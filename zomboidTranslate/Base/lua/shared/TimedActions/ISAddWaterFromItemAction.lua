--***********************************************************
--**                   THE INDIE STONE                     **
--***********************************************************

require "TimedActions/ISBaseTimedAction"

ISAddWaterFromItemAction = ISBaseTimedAction:derive("ISAddWaterFromItemAction")

function ISAddWaterFromItemAction:isValid()
    if isClient() and self.itemFrom then
        return true
    else
        return self.itemFrom:isWaterSource() and self.character:getInventory():contains(self.itemFrom) and
            self.objectTo:getObjectIndex() ~= -1 and
            self.objectTo:getFluidAmount() < self.objectTo:getFluidCapacity()
    end
end

function ISAddWaterFromItemAction:waitToStart()
	self.character:faceThisObject(self.objectTo)
	return self.character:shouldBeTurning()
end

function ISAddWaterFromItemAction:update()
	self.character:faceThisObject(self.objectTo)
	self.itemFrom:setJobDelta(self:getJobDelta())
	self.character:setMetabolicTarget(Metabolics.LightDomestic);
end

function ISAddWaterFromItemAction:start()
	self.itemFrom:setJobType(getText("IGUI_JobType_PourOut"))
	self.itemFrom:setJobDelta(0.0)

	self:setAnimVariable("PourType", self.itemFrom:getPourType());
	self:setActionAnim("fill_container_tap");
	self:setOverrideHandModels(self.itemFrom:getStaticModel(), nil)

	self.sound = self.character:playSound("PourWaterIntoObject")

	self.character:reportEvent("EventTakeWater");
end

function ISAddWaterFromItemAction:stop()
	self:stopSound()
	self.itemFrom:setJobDelta(0.0)

	if not isClient() and not isServer() then
		self:serverStop()
	end

	ISBaseTimedAction.stop(self)
end

function ISAddWaterFromItemAction:perform()
	self:stopSound()
	self.itemFrom:getContainer():setDrawDirty(true)
	self.itemFrom:setJobDelta(0.0)

	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self)
end

function ISAddWaterFromItemAction:serverStop()
	local progress = self.netAction and self.netAction:getProgress() or self:getJobDelta();
	self.addUnits = progress * self.addUnits
	self.itemFromEndingAmount = self.itemFromStartAmount - self.addUnits
	self:complete()
end

function ISAddWaterFromItemAction:complete()
	if self.addUnits and self.addUnits > 0 then
		self.objectTo:transferFluidFrom(self.itemFrom:getFluidContainer(), self.addUnits);
		self.itemFrom:syncItemFields();
	end

	return true;
end

function ISAddWaterFromItemAction:getDuration()
	if self.character:isTimedActionInstant() then
		return 1;
	end
	return math.max(6, self.addUnits) * 7;
end

function ISAddWaterFromItemAction:stopSound()
	if self.sound and self.character:getEmitter():isPlaying(self.sound) then
		self.character:stopOrTriggerSound(self.sound);
	end
end

function ISAddWaterFromItemAction:new(character, itemFrom, objectTo)
	local o = ISBaseTimedAction.new(self, character)
	o.itemFrom = itemFrom
	o.objectTo = objectTo

	o.itemFromStartAmount = o.itemFrom:getFluidContainer():getAmount()
	local destCapacity = math.max(0, o.objectTo:getFluidCapacity() - o.objectTo:getFluidAmount());
	o.addUnits = math.min(destCapacity, o.itemFromStartAmount)
	o.itemFromEndingAmount = o.itemFromStartAmount - o.addUnits

	o.maxTime = o:getDuration()
	return o
end    	
