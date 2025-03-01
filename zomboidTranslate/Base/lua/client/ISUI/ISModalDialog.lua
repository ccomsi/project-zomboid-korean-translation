--***********************************************************
--**              	  ROBERT JOHNSON                       **
--**            UI display with a question or text         **
--**          can display a yes/no button or ok btn        **
--***********************************************************

require "ISUI/ISPanelJoypad"

ISModalDialog = ISPanelJoypad:derive("ISModalDialog");

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local UI_BORDER_SPACING = 10
local BUTTON_HGT = FONT_HGT_SMALL + 6

--************************************************************************--
--** ISModalDialog:initialise
--**
--************************************************************************--

function ISModalDialog:initialise()
	ISPanel.initialise(self);
	local btnWid = 100
	if self.yesno then
		self.yes = ISButton:new((self:getWidth() - UI_BORDER_SPACING) / 2 - btnWid, self:getHeight() - UI_BORDER_SPACING - BUTTON_HGT - 1, btnWid, BUTTON_HGT, getText("UI_Yes"), self, ISModalDialog.onClick);
		self.yes.internal = "YES";
		self.yes.anchorTop = false;
		self.yes.anchorBottom = true;
		self.yes:initialise();
		self.yes:instantiate();
		self.yes:enableAcceptColor()
		self:addChild(self.yes);

		self.no = ISButton:new((self:getWidth() + UI_BORDER_SPACING) / 2, self:getHeight() - UI_BORDER_SPACING - BUTTON_HGT - 1, btnWid, BUTTON_HGT, getText("UI_No"), self, ISModalDialog.onClick);
		self.no.internal = "NO";
		self.no.anchorTop = false;
		self.no.anchorBottom = true;
		self.no:initialise();
		self.no:instantiate();
		self.no:enableCancelColor()
		self:addChild(self.no);
	else
		self.ok = ISButton:new((self:getWidth() / 2) - btnWid / 2, self:getHeight() - UI_BORDER_SPACING - BUTTON_HGT - 1, btnWid, BUTTON_HGT, getText("UI_Ok"), self, ISModalDialog.onClick);
		self.ok.internal = "OK";
		self.ok.anchorTop = false;
		self.ok.anchorBottom = true;
		self.ok:initialise();
		self.ok:instantiate();
		self.ok:enableAcceptColor()
		self:addChild(self.ok);
	end
--	if UIManager.getSpeedControls() then
--		UIManager.getSpeedControls():SetCurrentGameSpeed(0);
--		UIManager.setShowPausedMessage(false);
--	end
end

function ISModalDialog:destroy()
	local inGame = MainScreen.instance and MainScreen.instance.inGame and not MainScreen.instance:getIsVisible()
	UIManager.setShowPausedMessage(inGame);
	self:setVisible(false);
	self:removeFromUIManager();
	if UIManager.getSpeedControls() and inGame then
		UIManager.getSpeedControls():SetCurrentGameSpeed(1);
	end
	if self.player ~= nil then
		setJoypadFocus(self.player, self.prevFocus);
	elseif self.joyfocus and self.joyfocus.focus == self then
		self.joyfocus.focus = self.prevFocus
		updateJoypadFocus(self.joyfocus)
	end
end

function ISModalDialog:onClick(button)
	self:destroy();
	if self.onclick ~= nil then
		button.player = self.player;
		self.onclick(self.target, button, self.param1, self.param2);
	end
end

function ISModalDialog:prerender()
	self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b);
	self:drawRectBorder(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);
	self:drawTextCentre(self.text, self:getWidth() / 2, 20, 1, 1, 1, 1, UIFont.Small);
end

function ISModalDialog:onMouseUp(x, y)
    if not self.moveWithMouse then return; end
    if not self:getIsVisible() then
        return;
    end

    self.moving = false;
    if ISMouseDrag.tabPanel then
        ISMouseDrag.tabPanel:onMouseUp(x,y);
    end

    ISMouseDrag.dragView = nil;
end

function ISModalDialog:onMouseUpOutside(x, y)
    if not self.moveWithMouse then return; end
    if not self:getIsVisible() then
        return;
    end

    self.moving = false;
    ISMouseDrag.dragView = nil;
end

function ISModalDialog:onMouseDown(x, y)
    if not self.moveWithMouse then return; end
    if not self:getIsVisible() then
        return;
    end

    self.downX = x;
    self.downY = y;
    self.moving = true;
    self:bringToTop();
end

function ISModalDialog:onMouseMoveOutside(dx, dy)
    if not self.moveWithMouse then return; end
    self.mouseOver = false;

    if self.moving then
        self:setX(self.x + dx);
        self:setY(self.y + dy);
        self:bringToTop();
    end
end

function ISModalDialog:onMouseMove(dx, dy)
    if not self.moveWithMouse then return; end
    self.mouseOver = true;

    if self.moving then
        self:setX(self.x + dx);
        self:setY(self.y + dy);
        self:bringToTop();
        --ISMouseDrag.dragView = self;
    end
end

function ISModalDialog:onGainJoypadFocus(joypadData)
--    print("gained modal focus");
    ISPanelJoypad.onGainJoypadFocus(self, joypadData);
	if self.yesno then
		self:setISButtonForA(self.yes)
		self:setISButtonForB(self.no)
	else
		self:setISButtonForA(self.ok)
	end
	self.joypadButtons = {}
end

function ISModalDialog:onLoseJoypadFocus(joypadData)
	ISPanelJoypad.onLoseJoypadFocus(self, joypadData)
	if self.yesno then
		self.yes:clearJoypadButton()
		self.no:clearJoypadButton()
	else
		self.ok:clearJoypadButton()
	end
end

function ISModalDialog:onJoypadBeforeDeactivate(joypadData)
	if self.removeIfJoypadDeactivated then -- ugh
		self:destroy()
	end
end

function ISModalDialog:onJoypadDown(button)
	ISPanelJoypad.onJoypadDown(self, button)
--[[
    if button == Joypad.AButton then
        if self.yesno then
            self.yes.player = self.player;
            self.yes.onclick(self.yes.target, self.yes);
        else
            self.ok.onclick(self.ok.target, self.ok);
        end
        if self.player ~= nil then
            setJoypadFocus(self.player, self.prevFocus);
        elseif self.joyfocus and self.joyfocus.focus == self then
            self.joyfocus.focus = self.prevFocus
            updateJoypadFocus(self.joyfocus)
        end
        self:destroy();
    end
    if button == Joypad.BButton then
        if self.yesno then
            self.no.player = self.player;
            self.no.onclick(self.no.target, self.no);
        else
            self.ok.onclick(self.ok.target, self.ok);
        end
       if self.player ~= nil then
            setJoypadFocus(self.player, self.prevFocus);
        elseif self.joyfocus and self.joyfocus.focus == self then
            self.joyfocus.focus = self.prevFocus
            updateJoypadFocus(self.joyfocus)
       end
        self:destroy();
    end
--]]
end

--************************************************************************--
--** ISModalDialog:render
--**
--************************************************************************--
function ISModalDialog:render()

end

function ISModalDialog.CalcSize(width, height, text)
	local fontHgt = getTextManager():getFontHeight(UIFont.Small)
	local textWid = 0
	local textHgt = 0
	local lines = text:split("\\n")
	for _,line in ipairs(lines) do
		textWid = math.max(textWid, getTextManager():MeasureStringX(UIFont.Small, line))
		textHgt = textHgt + fontHgt
	end
	local buttonWid = 100
	if width < math.max(textWid + UI_BORDER_SPACING, buttonWid * 2 + UI_BORDER_SPACING*3 + 2) then
		width = math.max(textWid + UI_BORDER_SPACING, buttonWid * 2 + UI_BORDER_SPACING*3 + 2)
	end
	local buttonHgt = 25
	local padBottom = 10
	if height < 20 + textHgt + 20 + buttonHgt + padBottom then
		height = 20 + textHgt + 20 + buttonHgt + padBottom
	end
	return width,height
end

--************************************************************************--
--** ISModalDialog:new
--**
--************************************************************************--
function ISModalDialog:new(x, y, width, height, text, yesno, target, onclick, player, param1, param2)
	text = text:gsub("\\n", "\n")
	width,height = ISModalDialog.CalcSize(width, height, text)
	local o = ISPanelJoypad.new(self, x, y, width, height);
	local playerObj = player and getSpecificPlayer(player) or nil
	if y == 0 then
		if playerObj and playerObj:getJoypadBind() ~= -1 then
			o.y = getPlayerScreenTop(player) + (getPlayerScreenHeight(player) - height) / 2
		else
			o.y = o:getMouseY() - (height / 2)
		end
		o:setY(o.y)
	end
	if x == 0 then
		if playerObj and playerObj:getJoypadBind() ~= -1 then
			o.x = getPlayerScreenLeft(player) + (getPlayerScreenWidth(player) - width) / 2
		else
			o.x = o:getMouseX() - (width / 2)
		end
		o:setX(o.x)
	end
	o.name = nil;
    o.backgroundColor = {r=0, g=0, b=0, a=0.8};
    o.borderColor = {r=0.4, g=0.4, b=0.4, a=1};
	o.anchorLeft = true;
	o.anchorRight = true;
	o.anchorTop = true;
	o.anchorBottom = true;
	o.text = text;
	o.yesno = yesno;
	o.target = target;
	o.onclick = onclick;
	o.yes = nil;
    o.player = player;
	o.no = nil;
	o.ok = nil;
	o.param1 = param1;
	o.param2 = param2;
    o.moveWithMouse = false;
    return o;
end

