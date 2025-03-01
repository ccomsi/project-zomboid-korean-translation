--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

require "ISUI/ISPanelJoypad"

CoopCharacterCreation = ISPanelJoypad:derive("CoopCharacterCreation")

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local BUTTON_HGT = FONT_HGT_SMALL + 6
local UI_BORDER_SPACING = 10

function CoopCharacterCreation:initPlayer()
	MainScreen.instance.desc:setForename(self.charCreationMain.forenameEntry:getText());
	MainScreen.instance.desc:setSurname(self.charCreationMain.surnameEntry:getText());
	MainScreen.instance.desc:setVoicePrefix(self.charCreationMain.instance:getVoicePrefix());
	MainScreen.instance.desc:setVoiceType(self.charCreationMain.instance:getVoiceType());
	MainScreen.instance.desc:setVoicePitch(self.charCreationMain.instance:getVoicePitch());
end

function CoopCharacterCreation:accept1()
	if CoopMapSpawnSelect.instance.selectedRegion then
		local spawnRegion = CoopMapSpawnSelect.instance.selectedRegion
		print('using spawn region '..tostring(spawnRegion.name))
		local spawn = spawnRegion.points[MainScreen.instance.desc:getProfession()]
		if not spawn then
			spawn = spawnRegion.points["unemployed"]
		end
		if not spawn then
			print("ERROR: there is no spawn point table for the player's profession, don't know where to spawn the player")
			return false
		end
		print(#spawn..' possible spawn points')
		local randSpawnPoint = spawn[(ZombRand(#spawn) + 1)]

		if randSpawnPoint.position then
			if randSpawnPoint.position == "center" then
				local cellSizeInSquares = getCellSizeInSquares()
				local cellX = ((getCellMaxX() - getCellMinX()) / 2) + getCellMinX();
				local cellY = ((getCellMaxY() - getCellMinY()) / 2) + getCellMinY();
				randSpawnPoint.posX = cellX * cellSizeInSquares + cellSizeInSquares / 2;
				randSpawnPoint.posY = cellY * cellSizeInSquares + cellSizeInSquares / 2;
				randSpawnPoint.posZ = 0;
			else
				error "Position is not valid. No spawn point has been set, canceling load"
				return
			end
		end

		if randSpawnPoint.worldX ~= nil then
			-- This is the old format with 300x300 cell coordinates.
			getWorld():setLuaPosX(randSpawnPoint.worldX * 300 + randSpawnPoint.posX)
			getWorld():setLuaPosY(randSpawnPoint.worldY * 300 + randSpawnPoint.posY)
			getWorld():setLuaPosZ(randSpawnPoint.posZ or 0)
		else
		-- This is the new format with square coordinates and no cell coordinates.
			getWorld():setLuaPosX(randSpawnPoint.posX)
			getWorld():setLuaPosY(randSpawnPoint.posY)
			getWorld():setLuaPosZ(randSpawnPoint.posZ or 0)
		end
	elseif getCore():isChallenge() then
		-- This shouldn't happen. See LastStandData.getSpawnRegion()
		if globalChallenge.xcell ~= nil then
			getWorld():setLuaPosX(globalChallenge.xcell * 300 + globalChallenge.x);
			getWorld():setLuaPosY(globalChallenge.ycell * 300 + globalChallenge.y);
			getWorld():setLuaPosZ(globalChallenge.z);
		else
			getWorld():setLuaPosX(globalChallenge.x);
			getWorld():setLuaPosY(globalChallenge.y);
			getWorld():setLuaPosZ(globalChallenge.z);
		end
	end
	getWorld():setLuaPlayerDesc(MainScreen.instance.desc)
	getWorld():getLuaTraits():clear()
	for i,v in pairs(self.charCreationProfession.listboxTraitSelected.items) do
		getWorld():addLuaTrait(v.item:getType())
	end
	MainScreen.instance.avatar = nil
	return true
end

function CoopCharacterCreation:accept()
	if not self:accept1() then
		return
	end

	self:initPlayer();

--	self:setVisible(false)
	self:removeFromUIManager()

	if UIManager.getSpeedControls() and not IsoPlayer.allPlayersDead() then
		setShowPausedMessage(true)
		UIManager.getSpeedControls():SetCurrentGameSpeed(1)
		if self.joypadData then
			self.joypadData.activeWhilePaused = nil
		end
	end

	CoopCharacterCreation.setVisibleAllUI(true)
	CoopCharacterCreation.instance = nil

	if ISPostDeathUI.instance[self.playerIndex] then
		ISPostDeathUI.instance[self.playerIndex]:removeFromUIManager()
		ISPostDeathUI.instance[self.playerIndex] = nil
	end

	if not self.joypadData then
		setPlayerMouse(nil)
		return
	end

	local controller = self.joypadData.controller
	local joypadData = JoypadState.joypads[self.playerIndex+1]
	JoypadState.players[self.playerIndex+1] = joypadData
	joypadData.player = self.playerIndex
	joypadData:setController(controller)
	joypadData:setActive(true)
	local username = nil
	if isClient() and self.playerIndex > 0 then
		username = CoopUserName.instance:getUserName()
	end
	setPlayerJoypad(self.playerIndex, self.joypadIndex, nil, username)

	self.joypadData.focus = nil
	self.joypadData.lastfocus = nil
	self.joypadData.prevfocus = nil
	self.joypadData.prevprevfocus = nil
end

function CoopCharacterCreation:cancel()
	self:removeFromUIManager()
	CoopCharacterCreation.setVisibleAllUI(true)
	CoopCharacterCreation.instance = nil

	if UIManager.getSpeedControls() and not IsoPlayer.allPlayersDead() then
		setShowPausedMessage(true)
		UIManager.getSpeedControls():SetCurrentGameSpeed(1)
	end
	
	if self.joypadData then
		self.joypadData.activeWhilePaused = nil
		self.joypadData.focus = nil -- self.joypadData.listBox
		self.joypadData.lastfocus = nil
		self.joypadData.prevfocus = nil
		self.joypadData.prevprevfocus = nil
	end

	if ISPostDeathUI.instance[self.playerIndex] then
		ISPostDeathUI.instance[self.playerIndex]:setVisible(true)
		if self.joypadData then
			self.joypadData.focus = ISPostDeathUI.instance[self.playerIndex]
		end
	end
end

function CoopCharacterCreation:createChildren()
	self.coopUserName = CoopUserName:new((self.width - 400) / 2, (self.height - 200) / 2, 400, 200)
	self.coopUserName:initialise()
	self.coopUserName:setVisible(false)
	self.coopUserName:setAnchorRight(true)
	self.coopUserName:setAnchorLeft(true)
	self.coopUserName:setAnchorBottom(true)
	self.coopUserName:setAnchorTop(true)
	self.coopUserName.backgroundColor = {r=0, g=0, b=0, a=0.8}
	self.coopUserName.borderColor = {r=1, g=1, b=1, a=0.5}

	local w,h = self:getWidth(), self:getHeight()
	local w2, h2 = w*0.7, h*0.8 --try to keep these values the same as in MainScreen.lua
	local x, y = (w-w2)/2, (h-h2)/2

	self.mapSpawnSelect = CoopMapSpawnSelect:new(x, y, w2, h2)
	self.mapSpawnSelect:initialise()
	self.mapSpawnSelect:setVisible(false)
	self.mapSpawnSelect:setAnchorRight(true)
	self.mapSpawnSelect:setAnchorLeft(true)
	self.mapSpawnSelect:setAnchorBottom(true)
	self.mapSpawnSelect:setAnchorTop(true)
	self.mapSpawnSelect.backgroundColor = {r=0, g=0, b=0, a=0.8}
	self.mapSpawnSelect.borderColor = {r=1, g=1, b=1, a=0.5}
	
	self.charCreationMain = CoopCharacterCreationMain:new(x, y, w2, h2)
	self.charCreationMain:initialise()
	self.charCreationMain:setAnchorRight(true)
	self.charCreationMain:setAnchorLeft(true)
	self.charCreationMain:setAnchorBottom(true)
	self.charCreationMain:setAnchorTop(true)
	self.charCreationMain.backgroundColor = {r=0, g=0, b=0, a=0.8}
	self.charCreationMain.borderColor = {r=1, g=1, b=1, a=0.5}

	self.charCreationProfession = CoopCharacterCreationProfession:new(x, y, w2, h2)
	self.charCreationProfession:initialise()
	self.charCreationProfession:setAnchorRight(true)
	self.charCreationProfession:setAnchorLeft(true)
	self.charCreationProfession:setAnchorBottom(true)
	self.charCreationProfession:setAnchorTop(true)
	self.charCreationProfession.backgroundColor = {r=0, g=0, b=0, a=0.8}
	self.charCreationProfession.borderColor = {r=1, g=1, b=1, a=0.5}

	self:addChild(self.coopUserName)
	self:addChild(self.mapSpawnSelect)
	self:addChild(self.charCreationMain)
	self:addChild(self.charCreationProfession)

	MainScreen.instance.desc = SurvivorFactory.CreateSurvivor()
	MainScreen.instance.avatar = nil
	MainScreen.instance.charCreationProfession = self.charCreationProfession

	self.mapSpawnSelect:create()
	self.charCreationMain:create()
	self.charCreationProfession:create()

	self.mapSpawnSelect:setVisible(false)
	self.charCreationMain:setVisible(false)
	self.charCreationProfession:setVisible(false)
end

function CoopCharacterCreation.getJoypad()
	if CoopCharacterCreation.instance then
		return CoopCharacterCreation.instance.joypadData
	end
	return nil
end

function CoopCharacterCreation:new(joypadIndex, joypadData, playerIndex)
	local o = ISPanelJoypad:new(0, 0, getCore():getScreenWidth(), getCore():getScreenHeight())
	setmetatable(o, self)
	self.__index = self
	o.borderColor.a = 0
	o.joypadIndex = joypadIndex
	o.joypadData = joypadData
	o.playerIndex = playerIndex
	o:setUIName("CoopCharacterCreation")
	CoopCharacterCreation.instance = o
	return o
end

CoopCharacterCreation.visibleUI = {}

function CoopCharacterCreation.setVisibleAllUI(visible)
	local ui = UIManager.getUI()
	if not visible then
		for i=0,ui:size()-1 do
			if ui:get(i):isVisible() then
				table.insert(CoopCharacterCreation.visibleUI, ui:get(i):toString())
				ui:get(i):setVisible(false)
			end
		end
	else
		for i,v in ipairs(CoopCharacterCreation.visibleUI) do
			for i=0,ui:size()-1 do
				if v == ui:get(i):toString() then
					ui:get(i):setVisible(true)
					break
				end
			end
		end
		CoopCharacterCreation.visibleUI = {}
	end
	UIManager.setVisibleAllUI(visible)
end

function CoopCharacterCreation.newPlayer(joypadIndex, joypadData)
	if CoopCharacterCreation.instance then return end
	if UIManager.getSpeedControls() and not IsoPlayer.allPlayersDead() then
		setShowPausedMessage(false)
		UIManager.getSpeedControls():SetCurrentGameSpeed(0)
		joypadData.activeWhilePaused = true
	end
	CoopCharacterCreation.setVisibleAllUI(false)
	local playerIndex = joypadData.player
	if not playerIndex then -- true when not respawning
		for i=0,getMaxActivePlayers()-1 do
			local player = getSpecificPlayer(i)
			if not player or player:isDead() then
				playerIndex = i
				break
			end
		end
	end
	local w = CoopCharacterCreation:new(joypadIndex, joypadData, playerIndex)
	w:initialise()
	w:addToUIManager()
	if w.coopUserName:shouldShow() then
		w.coopUserName:beforeShow()
		w.coopUserName:setVisible(true, joypadData)
	elseif w.mapSpawnSelect:hasChoices() then
		w.mapSpawnSelect:fillList()
		w.mapSpawnSelect:setVisible(true, joypadData)
	else
		w.mapSpawnSelect:useDefaultSpawnRegion()
		w.charCreationProfession:setVisible(true, joypadData)
	end
end

function CoopCharacterCreation:newPlayerMouse()
    ProfessionFactory.Reset();
    BaseGameCharacterDetails.DoProfessions();
	if CoopCharacterCreation.instance then return end
	if UIManager.getSpeedControls() and not IsoPlayer.allPlayersDead() then
		setShowPausedMessage(false)
		UIManager.getSpeedControls():SetCurrentGameSpeed(0)
	end
	CoopCharacterCreation.setVisibleAllUI(false)
	local w = CoopCharacterCreation:new(nil, nil, 0)
	w:initialise()
	w:addToUIManager()
	if w.mapSpawnSelect:hasChoices() then
		w.mapSpawnSelect:fillList()
		w.mapSpawnSelect:setVisible(true)
	else
		w.mapSpawnSelect:useDefaultSpawnRegion()
		w.charCreationProfession:setVisible(true)
	end
end

function CoopCharacterCreation:OnJoypadBeforeDeactivate(index)
	if self.joypadData and (self.joypadData.id == index) then
		-- Controller disconnected, cancel creation.
		-- Other windows are children of this ui.
		self:cancel()
	end
end

