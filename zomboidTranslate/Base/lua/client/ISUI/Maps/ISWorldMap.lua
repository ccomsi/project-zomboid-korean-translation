--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

require "ISUI/ISPanelJoypad"
require "ISUI/Maps/ISMap"
require "ISUI/Maps/ISWorldMapSymbols"
require "ISUI/Maps/ISWorldMapKey"

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_LARGE = getTextManager():getFontHeight(UIFont.Large)
local FONT_HGT_HANDWRITTEN = getTextManager():getFontHeight(UIFont.Handwritten)
local UI_BORDER_SPACING = 10
local BUTTON_HGT = FONT_HGT_SMALL + 6

-----

WorldMapOptions = ISCollapsableWindowJoypad:derive("WorldMapOptions")

function WorldMapOptions:onTickBox(index, selected, option)
	if option:getName() == "ColorblindPatterns" then
		getCore():setOptionColorblindPatterns(selected)
		return
	end
	option:setValue(selected)
end

function WorldMapOptions:onCommandEntered(entry, option)
	option:parse(entry:getText())
end

function WorldMapOptions:createChildren()
	local entryHgt = BUTTON_HGT

	local x = 12
	local y = self:titleBarHeight() + 6
	local maxWidth = 0

	self.doubleBoxes = {}
	self.tickBoxes = {}

	self.showAllOptions = false
	if getDebug() or (isClient() and (getAccessLevel() == "admin")) then
		self.showAllOptions = true
	end

	local texViewIsometric = getTexture("media/textures/worldMap/ViewIsometric.png")
	local btnSize = texViewIsometric and texViewIsometric:getWidth() or 48
	local maxHeight = getCore():getScreenHeight() - 20 - btnSize

	self.joypadButtonsY = {}
	self.joypadIndex = 1
	self.joypadIndexY = 1

	local visibleOptions = self:getVisibleOptions()
	for i,option in ipairs(visibleOptions) do
		if option:getType() == "boolean" then
			local tickBox = ISTickBox:new(x, y, self.width, entryHgt, "", self, self.onTickBox, option)
			tickBox:initialise()
			local text = getTextOrNull("IGUI_MapOption_" .. option:getName()) or option:getName()
			tickBox:addOption(text, option)
			tickBox:setSelected(1, option:getValue())
			tickBox:setWidthToFit()
			self:addChild(tickBox)
			maxWidth = math.max(maxWidth, tickBox:getRight())
			table.insert(self.tickBoxes, i, tickBox)
			self:insertNewLineOfButtons(tickBox)
			y = y + entryHgt + 6
		end
		if option:getType() == "double" then
			local text = getTextOrNull("IGUI_MapOption_" .. option:getName()) or option:getName()
			local label = ISLabel:new(x, y, entryHgt, text, 1, 1, 1, 1, UIFont.Small, true)
			self:addChild(label)
			local entry = ISTextEntryBox:new("", label:getRight()+4, y, 100, entryHgt)
			entry.onCommandEntered = function(self) self.parent:onCommandEntered(entry, option) end
			self:addChild(entry)
			entry:setOnlyNumbers(true)
			maxWidth = math.max(maxWidth, entry:getRight())
			table.insert(self.doubleBoxes, i, entry)
			self:insertNewLineOfButtons(entry)
			y = y + entryHgt + 6
		end
		if y + entryHgt + 6 >= maxHeight then
			x = x + maxWidth
			y = self:titleBarHeight() + 6
			maxWidth = 0
		end
	end

	local width = 0
	local height = 0
	for _,child in pairs(self:getChildren()) do
		width = math.max(width, child:getRight())
		height = math.max(height, child:getBottom())
	end
	self:setWidth(width + 12)
	self:setHeight(height + self:resizeWidgetHeight())

	self.screenHeight = getCore():getScreenHeight()
end

function WorldMapOptions:getVisibleOptions()
	local result = {}
	if self.showAllOptions then
		for i=1,self.map.mapAPI:getOptionCount() do
			local option = self.map.mapAPI:getOptionByIndex(i-1)
			if isClient() or not self:isMultiplayerOption(option:getName()) then
				table.insert(result, option)
			end
		end
		return result;
	end
	local optionNames = {}
	table.insert(optionNames, "Players")
	if isClient() then
		table.insert(optionNames, "RemotePlayers")
		table.insert(optionNames, "PlayerNames")
	end
	table.insert(optionNames, "Symbols")
	for _,optionName in ipairs(optionNames) do
		for i=1,self.map.mapAPI:getOptionCount() do
			local option = self.map.mapAPI:getOptionByIndex(i-1)
			if optionName == option:getName() then
				table.insert(result, option)
				break
			end
		end
	end
	return result
end

function WorldMapOptions:isMultiplayerOption(optionName)
	return optionName == "RemotePlayers" or optionName == "PlayerNames"
end

function WorldMapOptions:synchUI()
	local showAllOptions = false
	if getDebug() or (isClient() and (getAccessLevel() == "admin")) then
		showAllOptions = true
	end
	if showAllOptions ~= self.showAllOptions or self.screenHeight ~= getCore():getScreenHeight() then
		local children = {}
		for k,v in pairs(self:getChildren()) do
			table.insert(children, v)
		end
		for _,child in ipairs(children) do
			self:removeChild(child)
		end
		self:createChildren()
	end

	local visibleOptions = self:getVisibleOptions()
	for i,option in ipairs(visibleOptions) do
		if option:getType() == "boolean" then
			self.tickBoxes[i]:setSelected(1, option:getValue())
		end
		if option:getType() == "double" then
			self.doubleBoxes[i]:setText(option:getValueAsString())
		end
	end
end

function WorldMapOptions:onMouseDownOutside(x, y)
	if self:isMouseOver() then
		return -- click in ISTextEntryBox
	end
	if self.parent.optionBtn:isMouseOver() then
		return
	end
	self:setVisible(false)
	if self.joyfocus then
		setJoypadFocus(joypadData.player, self.parent.buttonPanel)
	end
end

function WorldMapOptions:onGainJoypadFocus(joypadData)
	ISCollapsableWindowJoypad.onGainJoypadFocus(self, joypadData)
	self:restoreJoypadFocus()
end

function WorldMapOptions:onJoypadDown(button, joypadData)
	if button == Joypad.BButton then
		self:setVisible(false)
		setJoypadFocus(joypadData.player, self.parent.buttonPanel)
		return
	end
	ISCollapsableWindowJoypad.onJoypadDown(self, button, joypadData)
end

function WorldMapOptions:new(x, y, width, height, map)
	local o = ISCollapsableWindowJoypad.new(self, x, y, width, height)
	o.backgroundColor = {r=0, g=0, b=0, a=1.0}
	o.resizable = false
	o.map = map
	return o
end

-----

ISWorldMapButtonPanel = ISPanelJoypad:derive("ISWorldMapButtonPanel")

function ISWorldMapButtonPanel:render()
	ISPanelJoypad.render(self)
	if self.joyfocus then
		local children = self:getVisibleChildren(self.joypadIndexY)
		local child = children[self.joypadIndex]
		if child then
			self:drawRectBorder(child.x, child.y, child.width, child.height, 0.4, 0.2, 1.0, 1.0);
			self:drawRectBorder(child.x-1, child.y-1, child.width+2, child.height+2, 0.4, 0.2, 1.0, 1.0);
		end
	end
end

function ISWorldMapButtonPanel:onGainJoypadFocus(joypadData)
	ISPanelJoypad.onGainJoypadFocus(self, joypadData)
	self:restoreJoypadFocus()
end

function ISWorldMapButtonPanel:onLoseJoypadFocus(joypadData)
	ISPanelJoypad.onLoseJoypadFocus(self, joypadData)
	self:clearJoypadFocus()
end

function ISWorldMapButtonPanel:onJoypadDown(button, joypadData)
	if button == Joypad.BButton or button == Joypad.YButton then
		setJoypadFocus(joypadData.player, self.parent)
		return
	end
	ISPanelJoypad.onJoypadDown(self, button, joypadData)
end

function ISWorldMapButtonPanel:new(x, y, width, height)
	local o = ISPanelJoypad.new(self, x, y, width, height)
	o:noBackground()
	return o
end

-----

ISWorldMap = ISPanelJoypad:derive("ISWorldMap")

function ISWorldMap:instantiate()
	self.javaObject = UIWorldMap.new(self)
	self.mapAPI = self.javaObject:getAPIv1()
	self.mapAPI:setMapItem(MapItem.getSingleton())
	self.javaObject:setX(self.x)
	self.javaObject:setY(self.y)
	self.javaObject:setWidth(self.width)
	self.javaObject:setHeight(self.height)
	self.javaObject:setAnchorLeft(self.anchorLeft)
	self.javaObject:setAnchorRight(self.anchorRight)
	self.javaObject:setAnchorTop(self.anchorTop)
	self.javaObject:setAnchorBottom(self.anchorBottom)
	self.javaObject:setWantKeyEvents(true)
	self:createChildren()
end

function ISWorldMap:createChildren()
    local symbolsWidth = ISWorldMapSymbols.RequiredWidth()
	self.symbolsUI = ISWorldMapSymbols:new(self.width - UI_BORDER_SPACING - symbolsWidth, UI_BORDER_SPACING, symbolsWidth, self.height - 40 * 2, self)
	self.symbolsUI:initialise()
	self.symbolsUI:setAnchorLeft(false)
	self.symbolsUI:setAnchorRight(true)
	self:addChild(self.symbolsUI)

	self.keyUI = ISWorldMapKey:new(UI_BORDER_SPACING, UI_BORDER_SPACING, 10, 200, self)
	self.keyUI:initialise()
	self.keyUI:setAnchorLeft(true)
	self.keyUI:setAnchorRight(false)
	self.keyUI:setIso(self.isometric)
	self:addChild(self.keyUI)

	local btnSize = self.texViewIsometric and self.texViewIsometric:getWidth() or 48

	self.buttonPanel = ISWorldMapButtonPanel:new(self.width - 200, self.height - UI_BORDER_SPACING - btnSize, 200, btnSize)
	self.buttonPanel.anchorLeft = false
	self.buttonPanel.anchorRight = true
	self.buttonPanel.anchorTop = false
	self.buttonPanel.anchorBottom = true
	self:addChild(self.buttonPanel)

	local buttons = {}

	self.optionBtn = ISButton:new(0, 0, btnSize, btnSize, getText("UI_mainscreen_option"), self, self.onChangeOptions)
	self.buttonPanel:addChild(self.optionBtn)
	table.insert(buttons, self.optionBtn)

	self.zoomInButton = ISButton:new(buttons[#buttons]:getRight() + UI_BORDER_SPACING, 0, btnSize, btnSize, "+", self, self.onZoomInButton)
	self.buttonPanel:addChild(self.zoomInButton)
	table.insert(buttons, self.zoomInButton)

	self.zoomOutButton = ISButton:new(buttons[#buttons]:getRight() + UI_BORDER_SPACING, 0, btnSize, btnSize, "-", self, self.onZoomOutButton)
	self.buttonPanel:addChild(self.zoomOutButton)
	table.insert(buttons, self.zoomOutButton)

	if getDebug() then
		self.pyramidBtn = ISButton:new(buttons[#buttons]:getRight() + UI_BORDER_SPACING, 0, btnSize, btnSize, "", self, self.onTogglePyramid)
		self.pyramidBtn:setImage(self.texViewPyramid)
		self.buttonPanel:addChild(self.pyramidBtn)
		table.insert(buttons, self.pyramidBtn)
	end

	self.perspectiveBtn = ISButton:new(buttons[#buttons]:getRight() + UI_BORDER_SPACING, 0, btnSize, btnSize, "", self, self.onChangePerspective)
	self.perspectiveBtn:setImage(self.isometric and self.texViewIsometric or self.texViewOrthographic)
	self.buttonPanel:addChild(self.perspectiveBtn)
	table.insert(buttons, self.perspectiveBtn)

	self.centerBtn = ISButton:new(buttons[#buttons]:getRight() + UI_BORDER_SPACING, 0, btnSize, btnSize, "C", self, self.onCenterOnPlayer)
	self.buttonPanel:addChild(self.centerBtn)
	table.insert(buttons, self.centerBtn)

	self.symbolsBtn = ISButton:new(buttons[#buttons]:getRight() + UI_BORDER_SPACING, 0, btnSize, btnSize, "S", self, self.onToggleSymbols)
	self.buttonPanel:addChild(self.symbolsBtn)
	table.insert(buttons, self.symbolsBtn)

	self.forgetBtn = ISButton:new(buttons[#buttons]:getRight() + UI_BORDER_SPACING, 0, btnSize, btnSize, "?", self, function(self, button) self:onForget(button) end)
	self.buttonPanel:addChild(self.forgetBtn)
	table.insert(buttons, self.forgetBtn)

	self.closeBtn = ISButton:new(buttons[#buttons]:getRight() + UI_BORDER_SPACING, 0, btnSize, btnSize, getText("UI_btn_close"), self, self.close)
	self.buttonPanel:addChild(self.closeBtn)
	table.insert(buttons, self.closeBtn)

	self.buttonPanel:shrinkWrap(0, 0, nil)
	self.buttonPanel:setX(self.width - UI_BORDER_SPACING - self.buttonPanel.width)

	self.buttonPanel:insertNewListOfButtons(buttons)
	self.buttonPanel.joypadIndex = 1
	self.buttonPanel.joypadIndexY = 1
end

function ISWorldMap:prerender()
	ISPanelJoypad.prerender(self)
	self.symbolsUI:prerenderMap()
	if self.mapAPI:getBoolean("ColorblindPatterns") ~= getCore():getOptionColorblindPatterns() then
		MapUtils.initDefaultStyleV1(self)
		MapUtils.overlayPaper(self)
	end
end

function ISWorldMap:render()
	getWorld():setDrawWorld(false)

	local INSET = 0
	local w = getCore():getScreenWidth() - INSET * 2
	local h = getCore():getScreenHeight() - INSET * 2
	if self.width ~= w or self.height ~= h then
		self:setWidth(w)
		self:setHeight(h)
	end

	self.isometric = self.mapAPI:getBoolean("Isometric")
	self.perspectiveBtn:setImage(self.isometric and self.texViewIsometric or self.texViewOrthographic)
	self.keyUI:setIso(self.isometric)

	self:updateJoypad()

	if self.playerNum and ((self.playerNum ~= 0) or (JoypadState.players[self.playerNum+1] ~= nil and not wasMouseActiveMoreRecentlyThanJoypad())) then
		self:drawTexture(self.cross, self.width/2-12, self.height/2-12, 1, 1,1,1);
	end

	if self.joyfocus then
		local joypadTexture = Joypad.Texture.YButton
		self:drawTexture(joypadTexture, self.buttonPanel.x - 16 - joypadTexture:getWidth(), self.buttonPanel.y + (self.buttonPanel.height - joypadTexture:getHeight()) / 2, 1, 1, 1, 1)

		self.joypadPromptHgt = math.max(32, FONT_HGT_LARGE)
		self:renderJoypadPrompt(Joypad.Texture.XButton, getText("IGUI_Map_EditMarkings"), 16, self.height - 16 - self.joypadPromptHgt)

		if self.symbolsUI.currentTool then
			self:renderJoypadPrompt(Joypad.Texture.BButton, getText("UI_Cancel"), self.buttonPanel.x - 16 - 32, self.buttonPanel.y - 10 - self.joypadPromptHgt - 10 - self.joypadPromptHgt)
			local text = self.symbolsUI:getJoypadAButtonText()
			if text then
				self:renderJoypadPrompt(Joypad.Texture.AButton, text, self.buttonPanel.x - 16 - 32, self.buttonPanel.y - 10 - self.joypadPromptHgt)
			end
		end

		self:renderJoypadPrompt(Joypad.Texture.LTrigger, getText("IGUI_Map_ZoomOut"), 16, self.height - 16 - self.joypadPromptHgt - 8 - self.joypadPromptHgt)
		self:renderJoypadPrompt(Joypad.Texture.RTrigger, getText("IGUI_Map_ZoomIn"), 16, self.height - 16 - self.joypadPromptHgt - 8 - self.joypadPromptHgt - 8 - self.joypadPromptHgt)
	end

    -- change to make the chat window visible when the map is open
    if isClient() then
        ISChat.chat:setVisible(true);
        ISChat.chat:bringToTop()
    end

	ISPanelJoypad.render(self)
end

function ISWorldMap:renderJoypadPrompt(texture, text, x, y)
	if not texture then return end
	local h = self.joypadPromptHgt
	self:drawTexture(texture, x, y + (h - texture:getHeight()) / 2, 1, 1, 1, 1)
	self:drawText(text, x + texture:getWidth() + 10, y + (h - FONT_HGT_LARGE) / 2, 0, 0, 0, 1, UIFont.Large)
end

function ISWorldMap:onMouseDown(x, y)
	if self.symbolsUI:onMouseDownMap(x, y) then
		return true
	end
	self.dragging = true
	self.dragMoved = false
	self.dragStartX = x
	self.dragStartY = y
	self.dragStartCX = self.mapAPI:getCenterWorldX()
	self.dragStartCY = self.mapAPI:getCenterWorldY()
	self.dragStartZoomF = self.mapAPI:getZoomF()
	self.dragStartWorldX = self.mapAPI:uiToWorldX(x, y)
	self.dragStartWorldY = self.mapAPI:uiToWorldY(x, y)
	return true
end

function ISWorldMap:onMouseMove(dx, dy)
	if self.symbolsUI:onMouseMoveMap(dx, dy) then
		return true
	end
	if self.dragging then
		local mouseX = self:getMouseX()
		local mouseY = self:getMouseY()
		if not self.dragMoved and math.abs(mouseX - self.dragStartX) <= 4 and math.abs(mouseY - self.dragStartY) <= 4 then
			return
		end
		self.dragMoved = true
		local worldX = self.mapAPI:uiToWorldX(mouseX, mouseY, self.dragStartZoomF, self.dragStartCX, self.dragStartCY)
		local worldY = self.mapAPI:uiToWorldY(mouseX, mouseY, self.dragStartZoomF, self.dragStartCX, self.dragStartCY)
		self.mapAPI:centerOn(self.dragStartCX + self.dragStartWorldX - worldX, self.dragStartCY + self.dragStartWorldY - worldY)
	end
	return true
end

function ISWorldMap:onMouseMoveOutside(dx, dy)
	return self:onMouseMove(dx, dy)
end

function ISWorldMap:onMouseUp(x, y)
	self.dragging = false
	if self.symbolsUI:onMouseUpMap(x, y) then
		return true
	end
	return true
end

function ISWorldMap:onMouseUpOutside(x, y)
	self.dragging = false
	if self.symbolsUI:onMouseUpMap(x, y) then
		return true
	end
	return true
end

function ISWorldMap:onMouseWheel(del)
	self.mapAPI:zoomAt(self:getMouseX(), self:getMouseY(), del)
	return true
end

function ISWorldMap:onRightMouseDown(x, y)
	if self.symbolsUI:onRightMouseDownMap(x, y) then
		return true
	end
	return false
end

function ISWorldMap:onRightMouseUp(x, y)
	if self.symbolsUI:onRightMouseUpMap(x, y) then
		return true
	end
	if not getDebug() and not (isClient() and (getAccessLevel() == "admin")) then
		return false
	end
	local playerNum = 0
	local playerObj = getSpecificPlayer(0)
	if not playerObj then return end -- Debug in main menu
	local context = ISContextMenu.get(playerNum, x + self:getAbsoluteX(), y + self:getAbsoluteY())

	local option = context:addOption("Show Cell Grid", self, function(self) self:setShowCellGrid(not self.showCellGrid) end)
	context:setOptionChecked(option, self.showCellGrid)

	option = context:addOption("Show Tile Grid", self, function(self) self:setShowTileGrid(not self.showTileGrid) end)
	context:setOptionChecked(option, self.showTileGrid)

	self.hideUnvisitedAreas = self.mapAPI:getBoolean("HideUnvisited")
	option = context:addOption("Hide Unvisited Areas", self, function(self) self:setHideUnvisitedAreas(not self.hideUnvisitedAreas) end)
	context:setOptionChecked(option, self.hideUnvisitedAreas)

	option = context:addOption("Isometric", self, function(self) self:setIsometric(not self.isometric) end)
	context:setOptionChecked(option, self.isometric)

	-- DEV: Apply the style again after reloading ISMapDefinitions.lua
	option = context:addOption("Reapply Style", self,
		function(self)
			MapUtils.initDefaultStyleV1(self)
			MapUtils.overlayPaper(self)
		end)

	local worldX = self.mapAPI:uiToWorldX(x, y)
	local worldY = self.mapAPI:uiToWorldY(x, y)
	if getWorld():getMetaGrid():isValidChunk(worldX / 10, worldY / 10) then
		option = context:addOption("Teleport Here", self, self.onTeleport, worldX, worldY)
	end

	local animalChunk = getAnimalChunk(worldX, worldY);
	if animalChunk then
		local added = false;
		local animalOption = context:addOption("Virtual Animals");
		local subMenuAnimals = ISContextMenu:getNew(context);
		context:addSubMenu(animalOption, subMenuAnimals);
		if not animalChunk:getVirtualAnimals():isEmpty() then
			local virtualAnimal = animalChunk:getVirtualAnimals():get(0); -- RJ: TODO need list of animals possibly here
			added = true;
			option = subMenuAnimals:addOption("Force animals to rest", self, function(self) virtualAnimal:forceRest() end)
			option = subMenuAnimals:addOption("Force animals to eat", self, function(self) virtualAnimal:forceEat() end)

			local tracksOption = context:addOption("Add Tracks");
			local subMenuTracks = ISContextMenu:getNew(context);
			context:addSubMenu(tracksOption, subMenuTracks);
			option = subMenuTracks:addOption("Footsteps", self, function(self) animalChunk:addTracksStr(virtualAnimal, "footstep") end)
			option = subMenuTracks:addOption("Poop", self, function(self) animalChunk:addTracksStr(virtualAnimal, "poop") end)
			option = subMenuTracks:addOption("Broken Twigs", self, function(self) animalChunk:addTracksStr(virtualAnimal, "brokentwigs") end)
			option = subMenuTracks:addOption("Fur", self, function(self) animalChunk:addTracksStr(virtualAnimal, "fur") end)
			option = subMenuTracks:addOption("Grazing Area", self, function(self) animalChunk:addTracksStr(virtualAnimal, "herbgraze") end)
			if virtualAnimal:isEating() then
				option = subMenuAnimals:addOption("Force animals to stop eating", self, function(self) virtualAnimal:forceStopEat() end)
			end
			if virtualAnimal:isSleeping() then
				option = subMenuAnimals:addOption("Force animals to wake up", self, function(self) virtualAnimal:forceWakeUp() end)
			end
		end
		if not animalChunk:getAnimalsTracks():isEmpty() then
			added = true;
			option = subMenuAnimals:addOption("Remove tracks", self, function(self) animalChunk:deleteTracks() end)
		end
		if not added then
			context:removeLastOption();
		end
	end

	return true
end

function ISWorldMap:onForget()
	if MainScreen.instance and not MainScreen.instance.inGame then
		return
	end
	if self.forgetUI then
		self.forgetUI:setVisible(false)
		self.forgetUI:removeFromUIManager()
		self.forgetUI = nil
		return
	end
	local modal = ISModalRichText:new(self.width - 40 - 380, self.buttonPanel.y - 40 - 120, 380, 120, getText("IGUI_WorldMap_ConfirmForget"), true, self, self.onConfirmForget, self.playerNum)
	modal:initialise()
	modal.prevFocus = self.buttonPanel
	modal:addToUIManager()
	modal:setAlwaysOnTop(true)
	if JoypadState.players[self.playerNum+1] then
		setJoypadFocus(self.playerNum, modal)
	end
	self.forgetUI = modal
end

function ISWorldMap:onConfirmForget(button)
	self.forgetUI = nil
	if button.internal ~= "YES" then return end
	self.mapAPI:getSymbolsAPI():clear()
	WorldMapVisited.getInstance():forget()
end

function ISWorldMap:onToggleSymbols()
	if self.symbolsUI:isVisible() then
		self.symbolsUI:undisplay()
		self.symbolsUI:setVisible(false)
	else
		self.symbolsUI:setVisible(true)
	end
	if self.symbolsUI:isVisible() ~= self.keyUI:isVisible() then
		self:onToggleLegend()
	end
end

function ISWorldMap:onToggleLegend()
	if self.keyUI:isVisible() then
		self.keyUI:undisplay()
		self.keyUI:setVisible(false)
	else
		self.keyUI:setVisible(true)
	end
end

function ISWorldMap:onChangePerspective()
	self:setIsometric(not self.isometric)
end

function ISWorldMap:onCenterOnPlayer()
	if not self.character then
		self.mapAPI:resetView()
		return
	end
	self.mapAPI:centerOn(self.character:getX(), self.character:getY())
end

function ISWorldMap:onTogglePyramid()
	if self.mapAPI:getBoolean("ImagePyramid") then
		self.mapAPI:setBoolean("ImagePyramid", false)
		self.mapAPI:setBoolean("Features", true)
	else
		self.mapAPI:setBoolean("ImagePyramid", true)
		self.mapAPI:setBoolean("Features", false)
	end
end

function ISWorldMap:onZoomInButton()
	self.mapAPI:zoomAt(self.width / 2, self.height / 2, -2)
end

function ISWorldMap:onZoomOutButton()
	self.mapAPI:zoomAt(self.width / 2, self.height / 2, 2)
end

function ISWorldMap:onChangeOptions(button)
	if self.optionsUI == nil then
		local ui = WorldMapOptions:new(self.width - 300, button.y - 300, 300, 300, self)
		self:addChild(ui)
		ui:setVisible(false)
		self.optionsUI = ui
	end
	if self.optionsUI:isVisible() then
		self.optionsUI:setVisible(false)
		return
	end
	self.optionsUI:synchUI()
	self.optionsUI:setX(math.min(self.width - 20 - self.optionsUI.width, button.parent.x + button.x))
	self.optionsUI:setY(button.parent.y + button.y - self.optionsUI.height)
	self.optionsUI:setVisible(true)
	if JoypadState.players[self.playerNum+1] then
		setJoypadFocus(self.playerNum, self.optionsUI)
	end
end

function ISWorldMap:onTeleport(worldX, worldY)
	local playerObj = getSpecificPlayer(0)
	if not playerObj then return end
	playerObj:teleportTo(worldX, worldY, 0.0)
-- 	playerObj:setX(worldX)
-- 	playerObj:setY(worldY)
-- 	playerObj:setZ(0.0)
-- 	playerObj:setLastX(worldX)
-- 	playerObj:setLastY(worldY)
end

function ISWorldMap:setHideUnvisitedAreas(hide)
	self.hideUnvisitedAreas = hide
	self.mapAPI:setBoolean("HideUnvisited", hide)
end

function ISWorldMap:setIsometric(iso)
	self.isometric = iso
	self.mapAPI:setBoolean("Isometric", iso)
end

function ISWorldMap:setShowCellGrid(show)
	self.showCellGrid = show
	self.mapAPI:setBoolean("CellGrid", show)
end

function ISWorldMap:setShowTileGrid(show)
	self.showTileGrid = show
	self.mapAPI:setBoolean("TileGrid", show)
end

function ISWorldMap:setShowPlayers(show)
	self.showPlayers = show
	self.mapAPI:setBoolean("Players", show)
end

function ISWorldMap:setShowRemotePlayers(show)
	self.showRemotePlayers = show
	self.mapAPI:setBoolean("RemotePlayers", show)
end

function ISWorldMap:setShowPlayerNames(show)
	self.showPlayerNames = show
	self.mapAPI:setBoolean("PlayerNames", show)
end

function ISWorldMap:close()
	self:saveSettings()
	self.symbolsUI:undisplay()
	if self.forgetUI then
		self.forgetUI.no:forceClick()
	end
	self:setVisible(false)
	self:removeFromUIManager()
	if getSpecificPlayer(0) then
		getWorld():setDrawWorld(true)
	end
	for i=1,getNumActivePlayers() do
		if getSpecificPlayer(i-1) then
			getSpecificPlayer(i-1):setBlockMovement(false)
		end
	end
	if JoypadState.players[self.playerNum+1] then
		setJoypadFocus(self.playerNum, nil)
	end
	if MainScreen.instance and not MainScreen.instance.inGame then
		-- Debug in main menu
		self:setHideUnvisitedAreas(true)
		ISWorldMap_instance = nil
		WorldMapVisited.Reset()
	end
	if self.character then
		self.character:playSoundLocal("MapClose")
	end
end

function ISWorldMap:isKeyConsumed(key)
	if key == Keyboard.KEY_ESCAPE or getCore():isKey("Toggle UI", key) then return true end
	if key == Keyboard.KEY_C then return true end
	if key == Keyboard.KEY_S then return true end
	return false
end

function ISWorldMap:onKeyPress(key)
	if self.symbolsUI:onKeyPress(key) then
		return
	end
end

function ISWorldMap:onKeyRelease(key)
	if self:isVisible() then
		if self.symbolsUI:onKeyRelease(key) then
			return
		end
		if key == Keyboard.KEY_ESCAPE or getCore():isKey("Toggle UI", key) then
			self:close()
		end
		if key == Keyboard.KEY_C then
			self:onCenterOnPlayer()
		end
		if key == Keyboard.KEY_S then
			self:onToggleSymbols()
		end
	end
--[[
	if key == Keyboard.KEY_X then
		self:close()
	end
--]]
end

function ISWorldMap:updateJoypad()
	if self.getJoypadFocus then
		self.getJoypadFocus = false;
		if JoypadState.players[self.playerNum+1] then
			setJoypadFocus(self.playerNum, self)
		end
	end

	local currentTimeMs = getTimestampMs()
	self.updateMS = self.updateMS or currentTimeMs
	local dt = currentTimeMs - self.updateMS
	self.updateMS = currentTimeMs

	if self.joyfocus == nil then return end

	local cx = self.mapAPI:getCenterWorldX()
	local cy = self.mapAPI:getCenterWorldY()

	if isJoypadLTPressed(self.joyfocus.id, Joypad.LBumper) then
		if not self.LBumperZoom then
			self.LBumperZoom = self.mapAPI:getZoomF()
		end
		if self.LBumperZoom >= self.mapAPI:getZoomF() then
			self.LBumperZoom = self.mapAPI:getZoomF() - 1.0
			self.mapAPI:zoomAt(self.width / 2, self.height / 2, 2)
		end
	else
		self.LBumperZoom = nil
	end
	if isJoypadRTPressed(self.joyfocus.id, Joypad.RBumper) then
		if not self.RBumperZoom then
			self.RBumperZoom = self.mapAPI:getZoomF()
		end
		if self.RBumperZoom <= self.mapAPI:getZoomF() then
			self.RBumperZoom = self.mapAPI:getZoomF() + 1.0
			self.mapAPI:zoomAt(self.width / 2, self.height / 2, -2)
		end
	else
		self.RBumperZoom = nil
	end

	local x = getControllerPovX(self.joyfocus.id);
	local y = getControllerPovY(self.joyfocus.id);
	if x == 0 then
		x = getJoypadMovementAxisX(self.joyfocus.id)
		if (x > -0.5 and x < 0.5) then x = 0 end
	end
	if y == 0 then
		y = getJoypadMovementAxisY(self.joyfocus.id)
		if (y > -0.5 and y < 0.5) then y = 0 end
	end
	if x ~= 0 then
		if not self.povXms then
			self.povXms = currentTimeMs
		else
			if currentTimeMs - self.povXms <= 150 then
				x = 0
			end
		end
	else
		self.povXms = nil
	end
	if y ~= 0 then
		if not self.povYms then
			self.povYms = currentTimeMs
		else
			if currentTimeMs - self.povYms <= 150 then
				y = 0
			end
		end
	else
		self.povYms = nil
	end
	if self.mapAPI:getBoolean("Isometric") then
		if x ~= 0 and y ~= 0 then
			if x > 0 and y > 0 then
				y = 0
			elseif x < 0 and y < 0 then
				y = 0
			else
				x = 0
			end
		elseif x ~= 0 then
			y = -x
		elseif y ~= 0 then
			x = y
		end
	end
	if x~=0 or y ~= 0 then
		local scale = self.mapAPI:getWorldScale()
		local scrollDelta = (dt / 1000) * (500 / scale)
		local snap = 1
		if x < 0 then
			cx = math.floor((cx + scrollDelta * x) / snap) * snap
		elseif x > 0 then
			cx = math.ceil((cx + scrollDelta * x) / snap) * snap
		end
		if y < 0 then
			cy = math.floor((cy + scrollDelta * y) / snap) * snap
		elseif y > 0 then
			cy = math.ceil((cy + scrollDelta * y) / snap) * snap
		end
		self.mapAPI:centerOn(cx, cy)
	end
end

function ISWorldMap:onJoypadDown(button, joypadData)
	if button == Joypad.AButton then
		self.symbolsUI:onJoypadDownInMap(button, joypadData)
	end
	if button == Joypad.BButton then
		if self.symbolsUI:onKeyRelease(Keyboard.KEY_ESCAPE) then
			return
		end
		self:close()
	end
	if button == Joypad.XButton then
		self.symbolsUI:onKeyRelease(Keyboard.KEY_ESCAPE)
		if self.symbolsUI:isVisible() then
			setJoypadFocus(joypadData.player, self.symbolsUI)
		else
			self.symbolsUI:setVisible(true)
			setJoypadFocus(joypadData.player, self.symbolsUI)
		end
	end
	if button == Joypad.YButton then
		setJoypadFocus(joypadData.player, self.buttonPanel)
	end
end

function ISWorldMap:saveSettings()
	if not MainScreen.instance or not MainScreen.instance.inGame then return end
	local settings = WorldMapSettings.getInstance()
	settings:setDouble("WorldMap.CenterX", self.mapAPI:getCenterWorldX())
	settings:setDouble("WorldMap.CenterY", self.mapAPI:getCenterWorldY())
	settings:setDouble("WorldMap.Zoom", self.mapAPI:getZoomF())
	settings:setBoolean("WorldMap.Isometric", self.mapAPI:getBoolean("Isometric"))
	settings:setBoolean("WorldMap.ShowSymbolsUI", self.symbolsUI:isVisible())
	settings:save()
end

function ISWorldMap:restoreSettings()
	if not MainScreen.instance or not MainScreen.instance.inGame then return end
	local settings = WorldMapSettings.getInstance()
	if settings:getFileVersion() ~= 1 then return end
	local centerX = settings:getDouble("WorldMap.CenterX", 0.0)
	local centerY = settings:getDouble("WorldMap.CenterY", 0.0)
	local zoom = settings:getDouble("WorldMap.Zoom", 0.0)
	if zoom == 0.0 then return end -- ISMiniMap loaded settings for the first time
	local isometric = settings:getBoolean("WorldMap.Isometric")
	local showSymbolsUI = settings:getBoolean("WorldMap.ShowSymbolsUI")
	self.mapAPI:centerOn(centerX, centerY)
	self.mapAPI:setZoom(zoom)
	self.mapAPI:setBoolean("Isometric", isometric)
	if self.mapAPI:getDataCount() == 0 and self.mapAPI:getImagesCount() > 0 then
		self.mapAPI:setBoolean("ImagePyramid", true)
		self.mapAPI:setBoolean("Features", false)
	end
	self.symbolsUI:setVisible(showSymbolsUI)
	self.keyUI:setVisible(showSymbolsUI)
end

function ISWorldMap:initDataAndStyle()
	local mapAPI = self.mapAPI
	if MainScreen.instance.inGame then
		MapUtils.initDefaultMapData(self)
		mapAPI:setBoundsFromWorld()
		self.hideUnvisitedAreas = true
	else
		-- TEST in main menu
		MapUtils.initDirectoryMapData(self, 'media/maps/Muldraugh, KY')
		mapAPI:setBoundsFromData()
		local markers = mapAPI:getMarkersAPI()
		markers:addGridSquareMarker(11342, 6779, 50, 1.0, 1.0, 0.0, 1.0)
		self.hideUnvisitedAreas = false
	end
	MapUtils.initDefaultStyleV1(self)
	MapUtils.overlayPaper(self)
end

function ISWorldMap:new(x, y, width, height)
	local o = ISPanelJoypad.new(self, x, y, width, height)
	o:noBackground()
	o.anchorRight = true
	o.anchorBottom = true
	o.showCellGrid = false
	o.showTileGrid = false
	o.showPlayers = true
	o.showRemotePlayers = true
	o.showPlayerNames = true
	o.hideUnvisitedAreas = false
	o.isometric = true
	o.character = nil
	o.playerNum = character and character:getPlayerNum() or 0
	o.cross = getTexture("media/ui/LootableMaps/mapCross.png")
	o.texViewIsometric = getTexture("media/textures/worldMap/ViewIsometric.png")
	o.texViewOrthographic = getTexture("media/textures/worldMap/ViewOrtho.png")
	o.texViewPyramid = getTexture("media/textures/worldMap/ViewPyramid.png")
	return o
end

-----

function ISWorldMap.IsAllowed()
	if getCore():getGameMode() == "Tutorial" then return false end
	return SandboxVars.Map and (SandboxVars.Map.AllowWorldMap == true) or false
end

function ISWorldMap.NeedsLight()
	return SandboxVars.Map and (SandboxVars.Map.MapNeedsLight == true) or false
end

function ISWorldMap.ShowWorldMap(playerNum, centerX, centerY, zoom)
	if not ISWorldMap.IsAllowed() then
		return
	end
	if not ISWorldMap_instance then
		local INSET = 0
		ISWorldMap_instance = ISWorldMap:new(INSET, INSET, getCore():getScreenWidth() - INSET * 2, getCore():getScreenHeight() - INSET * 2)
		ISWorldMap_instance:initialise()
		ISWorldMap_instance:instantiate()
--		ISWorldMap_instance:setAlwaysOnTop(true) -- Breaks context menu
		ISWorldMap_instance.character = getSpecificPlayer(playerNum)
		ISWorldMap_instance.playerNum = playerNum
		ISWorldMap_instance.symbolsUI.character = getSpecificPlayer(playerNum)
		ISWorldMap_instance.symbolsUI.playerNum = playerNum
		ISWorldMap_instance.symbolsUI:checkInventory()
		ISWorldMap_instance:initDataAndStyle()
		ISWorldMap_instance:setHideUnvisitedAreas(ISWorldMap_instance.hideUnvisitedAreas)
		ISWorldMap_instance:setShowPlayers(ISWorldMap_instance.showPlayers)
		ISWorldMap_instance:setShowRemotePlayers(ISWorldMap_instance.showRemotePlayers)
		ISWorldMap_instance:setShowPlayerNames(ISWorldMap_instance.showPlayerNames)
		ISWorldMap_instance:setShowCellGrid(ISWorldMap_instance.showCellGrid)
		ISWorldMap_instance:setShowTileGrid(ISWorldMap_instance.showTileGrid)
		ISWorldMap_instance:setIsometric(ISWorldMap_instance.isometric)
		ISWorldMap_instance.mapAPI:resetView()
		if ISWorldMap_instance.character then
			ISWorldMap_instance.mapAPI:centerOn(ISWorldMap_instance.character:getX(), ISWorldMap_instance.character:getY())
			ISWorldMap_instance.mapAPI:setZoom(zoom and zoom or 18.0)
		end
		ISWorldMap_instance:restoreSettings()

		if centerX and centerY then
			ISWorldMap_instance.mapAPI:centerOn(centerX, centerY)
			ISWorldMap_instance.mapAPI:setZoom(zoom and zoom or 18.0)
		end

		ISWorldMap_instance:addToUIManager()
		ISWorldMap_instance.getJoypadFocus = true
		for i=1,getNumActivePlayers() do
			if getSpecificPlayer(i-1) then
				getSpecificPlayer(i-1):setBlockMovement(true)
			end
		end
		return
	end

	ISWorldMap_instance.character = getSpecificPlayer(playerNum)
	ISWorldMap_instance.playerNum = playerNum
	ISWorldMap_instance.symbolsUI.character = getSpecificPlayer(playerNum)
	ISWorldMap_instance.symbolsUI.playerNum = playerNum
	ISWorldMap_instance.symbolsUI:checkInventory()
	if centerX and centerY then
		ISWorldMap_instance.mapAPI:centerOn(centerX, centerY)
		ISWorldMap_instance.mapAPI:setZoom(zoom and zoom or 18.0)
	end
	ISWorldMap_instance:setVisible(true)
	ISWorldMap_instance:addToUIManager()
	ISWorldMap_instance.getJoypadFocus = true

	if MainScreen.instance.inGame then
		for i=1,getNumActivePlayers() do
			if getSpecificPlayer(i-1) then
				getSpecificPlayer(i-1):setBlockMovement(true)
			end
		end
	else
		ISWorldMap_instance:setHideUnvisitedAreas(false)
	end
end

function ISWorldMap.HideWorldMap(playerNum)
	if not ISWorldMap.IsAllowed() then
		return
	end
	ISWorldMap_instance:close()
end

function ISWorldMap.ToggleWorldMap(playerNum)
	if not ISWorldMap.IsAllowed() then
		return
	end
	local playerObj = getSpecificPlayer(playerNum)
	-- an additional close map check is before the light level check so players can close maps when it's dark
	-- the map should just automatically close when it's sufficiently dark, but that would be reported as a bug and also be hated
    if ISWorldMap_instance and ISWorldMap_instance:isVisible() then
          ISWorldMap.HideWorldMap(playerNum)
          return
    end
    local tooDarkToRead = false
    if playerObj then
        tooDarkToRead = playerObj:tooDarkToRead()
        if playerObj:getVehicle() then
            if playerObj:getVehicle():hasLiveBattery() then tooDarkToRead = false end
            if playerObj:getTorchStrength() > 0 then tooDarkToRead = false end
        end
    end
    if getCore():getDebug() then tooDarkToRead = false end

    -- check for light if the map needing light sandbox setting is enabled
	if ISWorldMap and ISWorldMap.NeedsLight() and playerObj and tooDarkToRead and not isAdmin() then
		-- kludge to allow for vehicle interior lights
		if not (playerObj:getVehicle() and playerObj:getVehicle():getBatteryCharge() > 0) then 
			HaloTextHelper.addBadText(playerObj, getText("ContextMenu_TooDark"));
-- 			HaloTextHelper.addText(playerObj, getText("ContextMenu_TooDark"), getCore():getGoodHighlitedColor());
			return
		end
	end

	-- Forbid showing the map when a splitscreen player has died.
	if ISPostDeathUI and ISPostDeathUI.instance and #ISPostDeathUI.instance > 0 then
		return
	end
	
	if ISWorldMap_instance and ISWorldMap_instance:isVisible() then
		ISWorldMap.HideWorldMap(playerNum)
	else
		-- local playerObj = getSpecificPlayer(playerNum)
		if playerObj then
			ISTimedActionQueue.clear(playerObj)
			ISTimedActionQueue.add(ISReadWorldMap:new(playerObj))
		else
			-- Debug: In the main menu
			ISWorldMap.ShowWorldMap(playerNum)
		end
	end
end

local KEYSTATE = {}

function ISWorldMap.checkKey(key)
	if not getCore():isKey("Map", key) then
		return false
	end
	if not ISWorldMap.IsAllowed() then
		return false
	end
	if getCore():getGameMode() == "Tutorial" then
		return false
	end
	if MainScreen.instance and not MainScreen.instance.inGame then
		-- For debugging the map in the main menu without starting a game.
		return false -- getDebug()
	end
	if UIManager.getSpeedControls() and (UIManager.getSpeedControls():getCurrentGameSpeed() == 0) then
		return false
	end
	local playerObj = getSpecificPlayer(0)
	if not playerObj or playerObj:isDead() then
		return false
	end
	-- -- check for light if the map needing light sandbox setting is enabled	
	-- if ISWorldMap.NeedsLight() and playerObj:getSquare():getLightLevel(playerObj:getPlayerNum()) < 0.43 then
		-- -- kludge to allow for vehicle interior lights
		-- if not (playerObj:getVehicle() and playerObj:getVehicle():getBatteryCharge() > 0) then 
			-- return false
		-- end
	-- end
--[[
	local queue = ISTimedActionQueue.queues[playerObj]
	if queue and #queue.queue > 0 then
		return false
	end
	if getCell():getDrag(0) then
		return false
	end
--]]
	return true
end

function ISWorldMap.onKeyStartPressed(key)
	if not ISWorldMap.checkKey(key) then return end
	if MainScreen.instance and not MainScreen.instance.inGame then
		-- For debugging the map in the main menu without starting a game.
		return
	end
	local radialMenu = getPlayerRadialMenu(0)
	if getCore():getOptionRadialMenuKeyToggle() and radialMenu:isReallyVisible() then
		KEYSTATE.radialWasVisible = true
		radialMenu:removeFromUIManager()
		return
	end
	KEYSTATE.keyPressedMS = getTimestampMs()
	KEYSTATE.radialWasVisible = false
end

function ISWorldMap.onKeyKeepPressed(key)
	if not ISWorldMap.checkKey(key) then return end
	if MainScreen.instance and not MainScreen.instance.inGame then
		-- For debugging the map in the main menu without starting a game.
		return
	end
	if KEYSTATE.radialWasVisible then
		return
	end
	if not KEYSTATE.keyPressedMS then
		return
	end
	local playerNum = 0
	local radialMenu = getPlayerRadialMenu(playerNum)
	local delay = 500
	if (getTimestampMs() - KEYSTATE.keyPressedMS >= delay) and not radialMenu:isReallyVisible() then
		radialMenu:clear()
		radialMenu:addSlice(getText("IGUI_WorldMap_Toggle"), getTexture("media/textures/worldMap/Map_On.png"), ISWorldMap.ToggleWorldMap, playerNum)
		if getPlayerMiniMap(playerNum) then
			radialMenu:addSlice(getText("IGUI_MiniMap_Toggle"), getTexture("media/textures/worldMap/Map_On.png"), ISMiniMap.ToggleMiniMap, playerNum)
		end
		radialMenu:center()
		radialMenu:addToUIManager()
		if JoypadState.players[playerNum+1] then
--			menu:setHideWhenButtonReleased(Joypad.RBumper)
			setJoypadFocus(playerNum, radialMenu)
			getSpecificPlayer(playerNum):setJoypadIgnoreAimUntilCentered(true)
		end
	end
end

function ISWorldMap.onKeyReleased(key)
	if not ISWorldMap.checkKey(key) then return end
--[[
	if not KEYSTATE.keyPressedMS then
		return
	end
--]]
	if MainScreen.instance and not MainScreen.instance.inGame then
		-- For debugging the map in the main menu without starting a game.
		ISWorldMap.ToggleWorldMap(0)
		return
	end
	local playerNum = 0
	local radialMenu = getPlayerRadialMenu(playerNum)
	if radialMenu:isReallyVisible() or KEYSTATE.radialWasVisible then
		if not getCore():getOptionRadialMenuKeyToggle() then
			radialMenu:removeFromUIManager()
		end
		return
	end
	ISWorldMap.ToggleWorldMap(playerNum)
end

function ISWorldMap.OnPlayerDeath(playerObj)
	if ISWorldMap_instance and ISWorldMap_instance:isVisible() then
		ISWorldMap.HideWorldMap(0)
	end
end

Events.OnKeyStartPressed.Add(ISWorldMap.onKeyStartPressed)
Events.OnKeyKeepPressed.Add(ISWorldMap.onKeyKeepPressed)
Events.OnKeyPressed.Add(ISWorldMap.onKeyReleased)
Events.OnPlayerDeath.Add(ISWorldMap.OnPlayerDeath)

