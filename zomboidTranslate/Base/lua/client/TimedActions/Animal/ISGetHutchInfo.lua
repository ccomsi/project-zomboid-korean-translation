--***********************************************************
--**                    ROBERT JOHNSON                     **
--***********************************************************

require "TimedActions/ISBaseTimedAction"

ISGetHutchInfo = ISBaseTimedAction:derive("ISGetHutchInfo");

function ISGetHutchInfo:isValid()
	return true;
end

function ISGetHutchInfo:update()
	self.character:setIsAiming(false);
	self.character:faceThisObject(self.hutch)
end

function ISGetHutchInfo:start()
end

function ISGetHutchInfo:stop()
    ISBaseTimedAction.stop(self);
end

function ISGetHutchInfo:perform()
	local ui = ISHutchUI:new(getPlayerScreenLeft(self.playerNum)+100, getPlayerScreenTop(self.playerNum)+100, 200, 200, self.hutch, self.character)
	ui:initialise();
	ui:addToUIManager();
	if getJoypadData(self.playerNum) then
		setJoypadFocus(self.playerNum, ui)
	end
	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self);
end

function ISGetHutchInfo:new(character, hutch)
	local o = ISBaseTimedAction.new(self, character)
	o.playerNum = character:getPlayerNum()
	o.hutch = hutch;
	o.maxTime = 1
	o.stopOnAim = false;
	return o;
end
