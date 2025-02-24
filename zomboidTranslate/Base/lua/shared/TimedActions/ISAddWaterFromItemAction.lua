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
            self.objectTo:getWaterAmount() < self.objectTo:getWaterMax()
    end
end

function ISAddWaterFromItemAction:waitToStart()
	self.character:faceThisObject(self.objectTo)
	return self.character:shouldBeTurning()
end

function ISAddWaterFromItemAction:update()
	self.character:faceThisObject(self.objectTo)
	self.itemFrom:setJobDelta(self:getJobDelta())
	
	local waterUsed = self.addUnits * self:getJobDelta();
	local waterRemaining = self.itemFromStartAmount - waterUsed;
	self:setItemFromWaterAmount(waterRemaining);

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
	-- Possibly start() wasn't called yet (because isValid() returned false)
	if self.addUnits and self.addUnits > 0 then
		local waterUsed = self.addUnits * self:getJobDelta();
		local waterRemaining = self.itemFromStartAmount - waterUsed;
		self:setItemFromWaterAmount(waterRemaining);

		self.objectTo:setWaterAmount(self.objectTo:getWaterAmount() + waterUsed, self.itemFrom:isTaintedWater())
		self.objectTo:sync()
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
	self.addUnits = self.netAction:getProgress() * self.addUnits
	self.itemFromEndingAmount = self.itemFromStartAmount - self.addUnits
	self:complete()
end

function ISAddWaterFromItemAction:complete()
	self:setItemFromWaterAmount(self.itemFromEndingAmount);
	
	self.objectTo:setWaterAmount(self.objectTo:getWaterAmount() + self.addUnits, self.itemFromTainted)
	self.objectTo:sync()

	--if (self.itemFrom:getCurrentUsesFloat() / self.itemFrom:getUseDelta()) < 1.0 then
	--	self.itemFrom:UseAndSync()
	--end

	return true;
end

function ISAddWaterFromItemAction:setItemFromWaterAmount(_amount)
	local targetUsed = _amount;
	local actualUsed = self.itemFrom:getFluidContainer():getAmount();
	local overFillAmount = actualUsed - targetUsed;
	
	if self.itemFrom:isWaterSource() then
		self.itemFrom:getFluidContainer():removeFluid(overFillAmount)
	end
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

	o.itemFromTainted = not o.itemFrom:isPureWater(false)
	o.itemFromStartAmount = o.itemFrom:getFluidContainer():getAmount()
	local destCapacity = math.max(0, o.objectTo:getWaterMax() - o.objectTo:getWaterAmount());
	o.addUnits = math.min(destCapacity, o.itemFromStartAmount)
	o.itemFromEndingAmount = o.itemFromStartAmount - o.addUnits

	o.maxTime = o:getDuration()
	return o
end    	
