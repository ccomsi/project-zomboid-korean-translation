--***********************************************************
--**                    THE INDIE STONE                    **
--**				  Author: turbotutone				   **
--***********************************************************

require "DebugUIs/DebugMenu/Base/ISDebugSubPanelBase";

ClimateColorsDebug = ISDebugSubPanelBase:derive("ClimateColorsDebug");
local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local UI_BORDER_SPACING = 10
local BUTTON_HGT = FONT_HGT_SMALL + 6
local SCROLL_BAR_WIDTH = 13

function ClimateColorsDebug:initialise()
    ISPanel.initialise(self);
end

function ClimateColorsDebug:createChildren()
    ISPanel.createChildren(self);

    local clim = getClimateManager();
    self.clim = clim;
    self.colorInfo = {};
    self.colors = {};

    local v, obj;

    local x,y,w = UI_BORDER_SPACING+1,UI_BORDER_SPACING+1,self.width-UI_BORDER_SPACING*2 - SCROLL_BAR_WIDTH - 1;

    self:initHorzBars(x,w);

    y, obj = ISDebugUtils.addLabel(self,"float_title",x+(w/2),y,getText("IGUI_ClimateColors_Title"), UIFont.Medium);
    obj.center = true;
    y = ISDebugUtils.addHorzBar(self,y+UI_BORDER_SPACING)+UI_BORDER_SPACING+1;

    local c = clim:getColNightNoMoon();
    y = self:addColorInfo(x, y, w, c, getText("IGUI_ClimateColors_night_no_moon"));
    c = clim:getColNightMoon();
    y = self:addColorInfo(x, y, w, c, getText("IGUI_ClimateColors_night_moon"));
    c = clim:getColFog();
    y = self:addColorInfo(x, y, w, c, getText("IGUI_ClimateColors_fog"));
    c = clim:getColFogLegacy();
    y = self:addColorInfo(x, y, w, c, getText("IGUI_ClimateColors_fog_legacy"));
    c = clim:getColFogNew();
    y = self:addColorInfo(x, y, w, c, getText("IGUI_ClimateColors_fog_new"));
    c = clim:getFogTintStorm();
    y = self:addColorInfo(x, y, w, c, getText("IGUI_ClimateColors_fog_tint_storm"));
    c = clim:getFogTintTropical();
    y = self:addColorInfo(x, y, w, c, getText("IGUI_ClimateColors_fog_tint_tropical"));

    local wp = clim:getWeatherPeriod();

    c = wp:getCloudColorReddish();
    y = self:addColorInfo(x, y, w, c, getText("IGUI_ClimateColors_weather_reddish"));
    c = wp:getCloudColorGreenish();
    y = self:addColorInfo(x, y, w, c, getText("IGUI_ClimateColors_weather_greenish"));
    c = wp:getCloudColorBlueish();
    y = self:addColorInfo(x, y, w, c, getText("IGUI_ClimateColors_weather_blueish"));
    c = wp:getCloudColorPurplish();
    y = self:addColorInfo(x, y, w, c, getText("IGUI_ClimateColors_weather_purplish"));
    c = wp:getCloudColorTropical();
    y = self:addColorInfo(x, y, w, c, getText("IGUI_ClimateColors_weather_tropical"));
    c = wp:getCloudColorBlizzard();
    y = self:addColorInfo(x, y, w, c, getText("IGUI_ClimateColors_weather_blizzard"));


    local segment_txt = {getText("IGUI_ClimateColors_segment_dawn"), getText("IGUI_ClimateColors_segment_day"), getText("IGUI_ClimateColors_segment_dusk")};
    local season_txt = {getText("IGUI_ClimateColors_season_summer"), getText("IGUI_ClimateColors_season_fall"), getText("IGUI_ClimateColors_season_winter"), getText("IGUI_ClimateColors_season_spring")};
    local temp_txt = {getText("IGUI_ClimateColors_temp_bright"), getText("IGUI_ClimateColors_temp_normal"), getText("IGUI_ClimateColors_temp_cloudy")};
    local name = "";
    for segment = 1,3 do
        local y2,obj2 = ISDebugUtils.addLabel(self,segment_txt[segment],x+(w/2),y,segment_txt[segment], UIFont.Medium, true);
        obj2.center = true;
        y = y2+3;
        for season = 1,4 do
            for temp = 1,3 do
                if temp==1 or temp==3 or (temp==2 and segment==3) then
                    name = segment_txt[segment]..", "..season_txt[season]..", "..temp_txt[temp];
                    c = clim:getSeasonColor(segment-1, temp-1, season-1);
                    y = self:addColorInfo(x, y, w, c, name, segment, temp, season);
                end
            end
        end
    end

    y,obj = ISDebugUtils.addLabel(self,{},x+(w/2),y,getText("IGUI_DebugMenu_Save"), UIFont.Medium, true);
    obj.center = true;

    y = y+UI_BORDER_SPACING;
    y,obj = ISDebugUtils.addButton(self, { id = "save" }, x, y, w, BUTTON_HGT, getText("IGUI_ClimateColors_save"), ClimateColorsDebug.onButtonWriteConfig);

    self:setScrollHeight(y+UI_BORDER_SPACING+1);
end

function ClimateColorsDebug:addColorInfo(_x, _y, _w, _col, _name, _daySegment, _temp, _season)
    local info = {
        colorInfo = _col,
        name = _name,
        isSeasonal = (_daySegment and _temp and _season);
        daySegment = _daySegment,
        temperature = _temp,
        season = _season,
    }
    table.insert(self.colorInfo, info);
    return self:addColorOption(info, _x, _y, _w);
end

function ClimateColorsDebug:addColorOption(_info,_x,_y,_w)
    local offset = (BUTTON_HGT - FONT_HGT_SMALL)/2
    local barMod = UI_BORDER_SPACING;

    local y2,obj2 = ISDebugUtils.addLabel(self,_info,_x,_y+offset,_info.name, UIFont.Small, true);
    --obj2.center = true;

    local boxH = BUTTON_HGT;
    local ce = _info.colorInfo:getExterior();
    local ci = _info.colorInfo:getInterior();
    _y = y2+offset;
    _y = ISDebugUtils.addHorzBar(self,_y+barMod)+barMod+1;

    local boxW = math.max(50, getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_ClimateColors_Edit")) + UI_BORDER_SPACING);
    local curX = _x;
    local colorbox = ISPanel:new(curX,_y,(boxW),boxH);
    colorbox:initialise();
    colorbox.backgroundColor = {r=ce:getRedFloat(),g=ce:getGreenFloat(),b=ce:getBlueFloat(),a=1.0};
    self:addChild(colorbox);
    _info.colorbox_ext = colorbox;

    curX = curX+(boxW)+UI_BORDER_SPACING;
    colorbox = ISPanel:new(curX,_y,(boxW),boxH);
    colorbox:initialise();
    colorbox.backgroundColor = {r=ce:getAlphaFloat(),g=ce:getAlphaFloat(),b=ce:getAlphaFloat(),a=1.0};
    self:addChild(colorbox);
    _info.colorboxAlpha_ext = colorbox;

    curX = curX+(boxW)+UI_BORDER_SPACING;
    local y3,obj3 = ISDebugUtils.addButton(self, _info, curX, _y, boxW, boxH*2+UI_BORDER_SPACING, getText("IGUI_ClimateColors_Edit"), ClimateColorsDebug.onButtonClick);
    _info.buttonEdit_ext = obj3;

    --curX = curX+boxW+5;
    --local y3,obj3 = ISDebugUtils.addButton(self, _info, curX, _y, boxW, 16, "APPLY", ClimateColorsDebug.onButtonClick);
    --_info.buttonApply_ext = obj3;

    curX = curX+boxW+UI_BORDER_SPACING;
    local y2,obj2 = ISDebugUtils.addLabel(self,_info,curX,_y,getText("IGUI_ClimateColors_Ex"), UIFont.Small, true);
    _info.text_ext = obj2;

    local r = tostring(ISDebugUtils.roundNum(ce:getRedFloat(),2));
    local g = tostring(ISDebugUtils.roundNum(ce:getGreenFloat(),2));
    local b = tostring(ISDebugUtils.roundNum(ce:getBlueFloat(),2));
    local a = tostring(ISDebugUtils.roundNum(ce:getAlphaFloat(),2));
    local str = "(R: "..r..", G: "..g..", B: "..b..", A: "..a..")";
    local y2,obj2 = ISDebugUtils.addLabel(self,_info,_x+_w,_y,str, UIFont.Small, false);
    _info.textColVal_ext = obj2;

    _y = math.max(colorbox:getBottom(), y2) + UI_BORDER_SPACING;
    -------------------------------------------------------------------------------------
    local curX = _x;
    local colorbox = ISPanel:new(curX,_y,(boxW),boxH);
    colorbox:initialise();
    colorbox.backgroundColor = {r=ci:getRedFloat(),g=ci:getGreenFloat(),b=ci:getBlueFloat(),a=1.0};
    self:addChild(colorbox);
    _info.colorbox_int = colorbox;

    curX = curX+(boxW)+UI_BORDER_SPACING;
    colorbox = ISPanel:new(curX,_y,(boxW),boxH);
    colorbox:initialise();
    colorbox.backgroundColor = {r=ci:getAlphaFloat(),g=ci:getAlphaFloat(),b=ci:getAlphaFloat(),a=1.0};
    self:addChild(colorbox);
    _info.colorboxAlpha_int = colorbox;

    curX = curX+boxW+UI_BORDER_SPACING;
    --local y3,obj3 = ISDebugUtils.addButton(self, _info, curX, _y, boxW, boxH, "EDIT", ClimateColorsDebug.onButtonClick);
    _info.buttonEdit_int = obj3;

    --curX = curX+boxW+5;
    --local y3,obj3 = ISDebugUtils.addButton(self, _info, curX, _y, boxW, 16, "APPLY", ClimateColorsDebug.onButtonClick);
    --_info.buttonApply_int = obj3;

    curX = curX+boxW+UI_BORDER_SPACING;
    local y2,obj2 = ISDebugUtils.addLabel(self,_info,curX,_y,getText("IGUI_ClimateColors_In"), UIFont.Small, true);
    _info.text_int = obj2;

    local r = tostring(ISDebugUtils.roundNum(ci:getRedFloat(),2));
    local g = tostring(ISDebugUtils.roundNum(ci:getGreenFloat(),2));
    local b = tostring(ISDebugUtils.roundNum(ci:getBlueFloat(),2));
    local a = tostring(ISDebugUtils.roundNum(ci:getAlphaFloat(),2));
    local str = "(R: "..r..", G: "..g..", B: "..b..", A: "..a..")";
    local y2,obj2 = ISDebugUtils.addLabel(self,_info,_x+_w,_y,str, UIFont.Small, false);
    _info.textColVal_int = obj2;

    _y = math.max(colorbox:getBottom(), y2);

    _y = ISDebugUtils.addHorzBar(self,_y+barMod)+barMod+1;
    return _y;
end


function ClimateColorsDebug:prerender()
    ISDebugSubPanelBase.prerender(self);

    for k,o in pairs(self.colorInfo) do
        local c = o.colorInfo:getExterior();
        o.colorbox_ext.backgroundColor.r = c:getRedFloat();
        o.colorbox_ext.backgroundColor.g = c:getGreenFloat();
        o.colorbox_ext.backgroundColor.b = c:getBlueFloat();
        o.colorboxAlpha_ext.backgroundColor.r = c:getAlphaFloat();
        o.colorboxAlpha_ext.backgroundColor.g = c:getAlphaFloat();
        o.colorboxAlpha_ext.backgroundColor.b = c:getAlphaFloat();

        c = o.colorInfo:getInterior();
        o.colorbox_int.backgroundColor.r = c:getRedFloat();
        o.colorbox_int.backgroundColor.g = c:getGreenFloat();
        o.colorbox_int.backgroundColor.b = c:getBlueFloat();
        o.colorboxAlpha_int.backgroundColor.r = c:getAlphaFloat();
        o.colorboxAlpha_int.backgroundColor.g = c:getAlphaFloat();
        o.colorboxAlpha_int.backgroundColor.b = c:getAlphaFloat();
    end
end

function ClimateColorsDebug:onApplyColorChange(_colorInfo)
    for k,o in pairs(self.colorInfo) do
        if o.colorInfo==_colorInfo then
            local c = o.colorInfo:getExterior();
            o.colorbox_ext.backgroundColor.r = c:getRedFloat();
            o.colorbox_ext.backgroundColor.g = c:getGreenFloat();
            o.colorbox_ext.backgroundColor.b = c:getBlueFloat();
            o.colorboxAlpha_ext.backgroundColor.r = c:getAlphaFloat();
            o.colorboxAlpha_ext.backgroundColor.g = c:getAlphaFloat();
            o.colorboxAlpha_ext.backgroundColor.b = c:getAlphaFloat();

            local r = tostring(ISDebugUtils.roundNum(c:getRedFloat(),2));
            local g = tostring(ISDebugUtils.roundNum(c:getGreenFloat(),2));
            local b = tostring(ISDebugUtils.roundNum(c:getBlueFloat(),2));
            local a = tostring(ISDebugUtils.roundNum(c:getAlphaFloat(),2));
            local str = "(R: "..r..", G: "..g..", B: "..b..", A: "..a..")";
            o.textColVal_ext:setName(str);

            c = o.colorInfo:getInterior();
            o.colorbox_int.backgroundColor.r = c:getRedFloat();
            o.colorbox_int.backgroundColor.g = c:getGreenFloat();
            o.colorbox_int.backgroundColor.b = c:getBlueFloat();
            o.colorboxAlpha_int.backgroundColor.r = c:getAlphaFloat();
            o.colorboxAlpha_int.backgroundColor.g = c:getAlphaFloat();
            o.colorboxAlpha_int.backgroundColor.b = c:getAlphaFloat();

            local r = tostring(ISDebugUtils.roundNum(c:getRedFloat(),2));
            local g = tostring(ISDebugUtils.roundNum(c:getGreenFloat(),2));
            local b = tostring(ISDebugUtils.roundNum(c:getBlueFloat(),2));
            local a = tostring(ISDebugUtils.roundNum(c:getAlphaFloat(),2));
            local str = "(R: "..r..", G: "..g..", B: "..b..", A: "..a..")";
            o.textColVal_int:setName(str);
        end
    end
end

function ClimateColorsDebug:onButtonWriteConfig(_button)
    ClimateColorInfo.writeColorInfoConfig()
end

function ClimateColorsDebug:onButtonClick(_button)
    if _button.customData and _button.customData.colorInfo then
        if _button.customData.isSeasonal then
            local ci = _button.customData;
            local amb = 0.85;
            local desat = 0.2;
            if ci.season==1 then --summmer
                desat = 0.0;
            elseif ci.season==3 then --winter
                desat = 0.40;
            end
            if ci.daySegment==1 or ci.daySegment==3 then --dawn or dusk
                amb = amb-0.05;
            end
            if ci.temperature==1 then --bright
                amb = amb+0.05;
            elseif ci.temperature==3 then --cloudy
                amb = amb-0.05;
            end
            PopupColorEdit.OnOpenPanel(_button.customData.colorInfo, self, amb, desat);
        else
            PopupColorEdit.OnOpenPanel(_button.customData.colorInfo, self);
        end
    end
end

--[[
function ClimateColorsDebug:onSliderChange(_newval, _slider)
end

function ClimateColorsDebug:onTicked(_index, _selected, _arg1, _arg2, _tickbox)
end

function ClimateColorsDebug:onTickedValue(_index, _selected, _arg1, _arg2, _tickbox)
end--]]

function ClimateColorsDebug:update()
    ISPanel.update(self);
end

function ClimateColorsDebug:new(x, y, width, height, doStencil)
    local o = {};
    o = ISDebugSubPanelBase:new(x, y, width, height, doStencil);
    setmetatable(o, self);
    self.__index = self;
    return o;
end


