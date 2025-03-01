--***********************************************************
--**                    THE INDIE STONE                    **
--**				  Author: Yuri				   **
--***********************************************************


require "ISUI/ISCollapsableWindow"

StatisticChart = ISCollapsableWindow:derive("StatisticChart");
StatisticChart.instance = nil;
StatisticChart.shiftDown = 0;
StatisticChart.eventsAdded = false;

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local UI_BORDER_SPACING = 10
local BUTTON_HGT = FONT_HGT_SMALL + 6


-- function StatisticChart.OnOpenPanel()
    -- if StatisticChart.instance==nil then
        -- StatisticChart.instance = StatisticChart:new (100, 100, 900, 400, getPlayer());
        -- StatisticChart.instance:initialise();
        -- StatisticChart.instance:instantiate();
    -- end

    -- StatisticChart.instance:addToUIManager();
    -- StatisticChart.instance:setVisible(true);

    -- return StatisticChart.instance;
-- end

function StatisticChart:initialise()
    ISCollapsableWindow.initialise(self);
end


function StatisticChart:createChildren()
    ISCollapsableWindow.createChildren(self);
	
	self.labels = {};

    self:initVariables();
    local th = self:titleBarHeight();

    local y = th+UI_BORDER_SPACING;
    local x = UI_BORDER_SPACING+1;

    self.historyM1 = ValuePlotter:new(x,y,600,300,600);
    self.historyM1:initialise();
    self.historyM1:instantiate();
    self:addChild(self.historyM1);
    self.historyM1:setVisible(true);

    local vinfo;
	for j=1, #self.varInfo do
		vinfo = self.varInfo[j];
		self.historyM1:defineVariable(vinfo.desc, vinfo.col, vinfo.min, vinfo.max);
	end


	self.historyM1:setHorzLine(9.0,{r=0.1, g=0.1, b=0.1, a=1});
	self.historyM1:setHorzLine(11.0,{r=0.1, g=0.1, b=0.1, a=1});
	self.historyM1:setHorzLine(7.0,{r=0.1, g=0.1, b=0.1, a=1});

    y = self.historyM1:getY() + self.historyM1:getHeight();

    y=y+10;
    local cacheY, cacheX = y, x;

    y = self.historyM1:getY();
    x = self.historyM1:getX() + self.historyM1:getWidth();
    local vars = self.historyM1:getVars();
    for i=1,#vars do
        local btn = ISButton:new(x+UI_BORDER_SPACING, y, UI_BORDER_SPACING*2+getTextManager():MeasureStringX(self.font, getText("IGUI_ClimatePlotter_Toggle")), BUTTON_HGT,getText("IGUI_ClimatePlotter_Toggle"),self, StatisticChart.onButtonToggle);
        btn:initialise();
        btn:enableCancelColor()
        btn.toggleVarID = i;
        btn.toggleVarName = vars[i].name;
        btn.toggleVal = vars[i].enabled;
        self:addChild(btn);

        local pnl = ISPanel:new(btn:getRight() + UI_BORDER_SPACING, y, BUTTON_HGT, BUTTON_HGT);
        pnl:initialise();
        pnl.backgroundColor = vars[i].color;
        self:addChild(pnl);

        local lbl = ISLabel:new(pnl:getRight() + UI_BORDER_SPACING, y, BUTTON_HGT, vars[i].name, 1, 1, 1, 1.0, UIFont.Small, true);
        lbl:initialise();
        lbl:instantiate();
        self:addChild(lbl);

        y = btn:getY() + btn:getHeight() + UI_BORDER_SPACING;
    end
	
end

function StatisticChart:addLabel(_curX, _curY, _labelID, _title)
    if not self.labels[_labelID] then
        local label = {};
        label.titleLabel = ISLabel:new(_curX, _curY, BUTTON_HGT, _title, 1, 1, 1, 1.0, UIFont.Small, true);
        label.titleLabel:initialise();
        label.titleLabel:instantiate();
        self:addChild(label.titleLabel);

        self.labels[_labelID] = label;

        _curY = label.titleLabel:getY() + label.titleLabel:getHeight();
    else
        print("Cannot add label: "..tostring(_labelID));
    end
    return _curY;
end

function StatisticChart:addLabelValue(_curX, _curY, _width, _type, _labelID, _title, _defaultVal)
    if not self.labels[_labelID] then
        local label = {};
        label.titleLabel = ISLabel:new(_curX, _curY, BUTTON_HGT, _title, 1, 1, 1, 1.0, UIFont.Small, true);
        label.titleLabel:initialise();
        label.titleLabel:instantiate();
        self:addChild(label.titleLabel);

        if _type=="value" then
            label.valueLabel = ISLabel:new(_curX + _width, _curY, BUTTON_HGT, tostring(_defaultVal), 1, 1, 1, 1.0, UIFont.Small, true);
            label.valueLabel:initialise();
            label.valueLabel:instantiate();
            self:addChild(label.valueLabel);
        end

        self.labels[_labelID] = label;

        _curY = label.titleLabel:getY() + label.titleLabel:getHeight();
    else
        print("Cannot add label: "..tostring(_labelID));
    end
    return _curY;
end

function StatisticChart:getTitleLabel(_labelID)
    if self.labels[_labelID] then
        return self.labels[_labelID].titleLabel;
    end
end

function StatisticChart:getValueLabel(_labelID)
    if self.labels[_labelID] then
        return self.labels[_labelID].valueLabel;
    end
end

function StatisticChart:initVariables()
    self.varInfo = {};
    self.colTable = {};
    local cc = {1.0,0.5,0.0};
    for ri=1,#cc do
        for gi=1,#cc do
            for bi=1,#cc do
                if (not (ri==1 and gi==1 and bi==1)) and (not (ri==3 and gi==3 and bi==3)) then
                    self:addColor(cc[ri],cc[gi],cc[bi]);
                end
            end
        end
    end



end

function StatisticChart:addColor(_r,_g,_b)
    table.insert(self.colTable,{r=_r,g=_g,b=_b,a=1.0})
end

function StatisticChart:addVarInfo(_name,_desc,_min,_max,_func)
    table.insert(self.varInfo,{
        name = _name,
        desc = _desc,
        min = _min,
        max = _max,
        func = _func,
        col = {1,1,1,1};
    });
    self.varInfo[#self.varInfo].col = self.colTable[#self.varInfo];
end

function StatisticChart:updateValues()
    
    if self.clearOnNextRun then
        --clear
        self.historyM1:clearHistory();
        self.currentStage = nil;
        self.clearOnNextRun = false;
    end

    local dataset = {};
    local vinfo;
	self.data = getServerStatistic();
	if self.data ~= nil then
		for i=1,#self.varInfo do
			vinfo = self.varInfo[i];
			if type(vinfo.func)=="string" and self.data[vinfo.func] then
				local value = tonumber(tostring(self.data[vinfo.func]))
				self:getValueLabel(vinfo.name).name = tostring(self.data[vinfo.func]);
				table.insert(dataset, value);
			end
		end
	end
    self.historyM1:addPlotPoint(dataset, false);
end

StatisticChart.OnServerStatisticReceived = function()
	if StatisticChart.instance==nil then
        StatisticChart.instance = StatisticChart:new (100, 100, 900, 400, getPlayer());
        StatisticChart.instance:initialise();
        StatisticChart.instance:instantiate();
    end
	StatisticChart.instance:updateValues()
end

Events.OnServerStatisticReceived.Add(StatisticChart.OnServerStatisticReceived);

function StatisticChart:onMouseWheel(del)
	self.historyM1.maxPlotPoints = self.historyM1.maxPlotPoints + del;
	if self.historyM1.maxPlotPoints < 10 then
		self.historyM1.maxPlotPoints = 10
		return false
	end
	return true
end


function StatisticChart:onButtonToggle(_btn)
    if _btn.toggleVarName then
        _btn.toggleVal = not _btn.toggleVal;
        self.historyM1:setVariableEnabled(_btn.toggleVarName,_btn.toggleVal);
        if _btn.toggleVal then
            _btn:enableAcceptColor()
        else
            _btn:enableCancelColor()
        end
    end
end


function StatisticChart:onResize()
    ISUIElement.onResize(self);
    local th = self:titleBarHeight();
end

function StatisticChart:update()
    ISCollapsableWindow.update(self);
	if StatisticChart.instance then
		--StatisticChart.instance:updateValues();
	end
    if StatisticChart.shiftDown>0 then
        StatisticChart.shiftDown = StatisticChart.shiftDown-1;
    end
end

function StatisticChart:prerender()
    self:stayOnSplitScreen();
    ISCollapsableWindow.prerender(self);
end

function StatisticChart:stayOnSplitScreen()
    ISUIElement.stayOnSplitScreen(self, self.playerNum)
end


function StatisticChart:render()
    ISCollapsableWindow.render(self);

    if StatisticChart.shiftDown>0 then
        StatisticChart.shiftDown = StatisticChart.shiftDown-1;
    end
end


function StatisticChart:close()
    ISCollapsableWindow.close(self);
    if JoypadState.players[self.playerNum+1] then
        setJoypadFocus(self.playerNum, nil)
    end
    StatisticChart.instance = nil;
    self:removeFromUIManager();
    self:clear();
end

function StatisticChart:clear()
    self.currentTile = nil;
end



function StatisticChart:new (x, y, width, height, player)
    local o = {}
    --o.data = {}
    o = ISCollapsableWindow:new(x, y, width, height);
    setmetatable(o, self)
    self.__index = self
    o.x = x;
    o.y = y;
    o.player = player;
    o.playerNum = player:getPlayerNum();
    o.borderColor = {r=0.4, g=0.4, b=0.4, a=1};
    o.backgroundColor = {r=0, g=0, b=0, a=0.8};
    o.greyCol = { r=0.4,g=0.4,b=0.4,a=1};
    o.width = width;
    o.height = height;
    o.anchorLeft = true;
    o.anchorRight = false;
    o.anchorTop = true;
    o.anchorBottom = false;
    o.pin = true;
    o.isCollapsed = false;
    o.collapseCounter = 0;
    o.title = getText("IGUI_StatisticChart_Title");
    --o.viewList = {}
    o.resizable = true;
    o.drawFrame = true;

    o.currentTile = nil;
    o.richtext = nil;
    o.overrideBPrompt = true;
    o.subFocus = nil;
    o.hotKeyPanels = {};
    o.isJoypadWindow = false;

    o.hourStamp = -1;
    o.dayStamp = -1;
    o.monthStamp = -1;
    o.year = -1;

    return o
end

