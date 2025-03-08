--***********************************************************
--**                    ROBERT JOHNSON                     **
--***********************************************************

require "TimedActions/ISBaseTimedAction"

ISTakeWaterAction = ISBaseTimedAction:derive("ISTakeWaterAction");

function ISTakeWaterAction:isValid()
	if self.item and not self.item:getContainer() then return false end
	return self.waterObject:hasFluid()
end

function ISTakeWaterAction:waitToStart()
    if self.waterObject then
        self.character:faceThisObject(self.waterObject)
    end
    return self.character:shouldBeTurning()
end

function ISTakeWaterAction:update()
    if self.item ~= nil then
        self.item:setJobDelta(self:getJobDelta());
    end
    if self.waterObject then
        self.character:faceThisObject(self.waterObject);
    end
end

function ISTakeWaterAction:start()
    local props = self.waterObject:getProperties()
    local hasWaterFlag = (props ~= nil) and props:Is(IsoFlagType.water)
    local isLakeOrRiver = not instanceof(self.waterObject, "IsoWorldInventoryObject") and (props ~= nil) and luautils.stringStarts(self.waterObject:getSprite():getName(), 'blends_natural_02')
    local isPuddle = not hasWaterFlag and not isLakeOrRiver and (props ~= nil) and props:Is(IsoFlagType.solidfloor)
    
    if self.item ~= nil then
		self.item:setBeingFilled(true)
	    self.item:setJobType(getText("ContextMenu_Fill") .. self.item:getName());
	    self.item:setJobDelta(0.0);
        if (props ~= nil) and (props:Val("CustomName") == "Dispenser") then
            self.sound = self.character:playSound(self.item:getFillFromDispenserSound() or "GetWaterFromDispenser");
        elseif (props ~= nil) and (props:Val("CustomName") == "Toilet") then
            self.sound = self.character:playSound(self.item:getFillFromToiletSound() or "GetWaterFromToilet");
        elseif instanceof(self.waterObject, "IsoThumpable") or hasWaterFlag or isLakeOrRiver or isPuddle then -- play the drink sound for rain barrel
            self.sound = self.character:playSound("GetWaterFromLake");
        elseif isLakeOrRiver then
            self.sound = self.character:playSound(self.item:getFillFromLakeSound() or "GetWaterFromLake");
        else
            self.sound = self.character:playSound(self.item:getFillFromTapSound() or "GetWaterFromTap");
        end
	
		self:setAnimVariable("PourType", self.item:getPourType());
		self:setActionAnim("fill_container_tap");
        if self.character:isSecondaryHandItem(nil) then
            self:setOverrideHandModels(nil, self.item:getStaticModel());
        else
            self:setOverrideHandModels(self.item:getStaticModel(), nil)
        end
    else
        if (props ~= nil) and (props:Val("CustomName") == "Dispenser") then
            self.sound = self.character:playSound("GetWaterFromDispenser");
        elseif (props ~= nil) and (props:Val("CustomName") == "Toilet") then
            self.sound = self.character:playSound("DrinkingFromToilet");
        elseif isLakeOrRiver or isPuddle then
            self.sound = self.character:playSound("DrinkingFromRiver");
        elseif instanceof(self.waterObject, "IsoThumpable") or hasWaterFlag or isLakeOrRiver then -- play the drink sound for rain barrel
            self.sound = self.character:playSound("DrinkingFromPool");
        else
            self.sound = self.character:playSound("DrinkingFromTap");
        end
	
		self:setActionAnim("drink_tap")
		self:setOverrideHandModels(nil, nil)
	end
	
	self.character:reportEvent("EventTakeWater");
end

function ISTakeWaterAction:stopSound()
	if self.sound and self.character:getEmitter():isPlaying(self.sound) then
		self.character:stopOrTriggerSound(self.sound);
	end
end

function ISTakeWaterAction:stop()
	self:stopSound();

    if not isClient() and not isServer() then
        self:serverStop();
    end
    
    if self.item ~= nil then
		self.item:setBeingFilled(false)
        self.item:setJobDelta(0.0);
    end
    
    ISBaseTimedAction.stop(self);
end

function ISTakeWaterAction:perform()
	self:stopSound();

    if self.item ~= nil then
        self.item:setBeingFilled(false)
        self.item:getContainer():setDrawDirty(true);
        self.item:setJobDelta(0.0);
    end
    
    -- needed to remove from queue / start next.
    ISBaseTimedAction.perform(self);
end

function ISTakeWaterAction:complete()
    self:transferFluid(self.waterUnit)
    return true;
end

function ISTakeWaterAction:transferFluid(_amount)
    if self.item then
        self.waterObject:transferFluidTo(self.item:getFluidContainer(), _amount);
        self.item:syncItemFields();
        sendItemStats(self.item)
    else
        local fluidContainer = self.waterObject:moveFluidToTemporaryContainer(_amount);
        self.character:DrinkFluid(fluidContainer, 1);
        FluidContainer.DisposeContainer(fluidContainer);
    end
end

function ISTakeWaterAction:serverStop()
    if self.waterUnit and self.waterUnit > 0 then
        local progress = self.netAction and self.netAction:getProgress() or self:getJobDelta();
        local waterUsed = self.waterUnit * progress;
        self:transferFluid(waterUsed);
    end
end

function ISTakeWaterAction:getDuration()
    if self.character:isTimedActionInstant() then
        return 1;
    end

    if self.item ~= nil then
        return (self.waterUnit * 100) + 30
    else
        return (self.waterUnit * 100) + 15
    end
end

function ISTakeWaterAction:new (character, item, waterObject, waterTaintedCL)
	local o = ISBaseTimedAction.new(self, character)
	o.item = item;
    o.waterObject = waterObject;
    o.waterTaintedCL = waterTaintedCL;

    local waterAvailable = o.waterObject:getFluidAmount();
    if o.item ~= nil then
		if o.item:getFluidContainer() then
			o.startUsedAmount = o.item:getFluidContainer():getAmount();
			o.endUsedAmount = o.item:getFluidContainer():getCapacity();
		    o.waterUnit = math.min(o.endUsedAmount - o.startUsedAmount, waterAvailable)
        end
    else
        local thirst = o.character:getStats():getThirst()
        local waterNeeded = math.min(thirst, 1)
        o.waterUnit = math.min(waterNeeded, waterAvailable)
        o.startUsedAmount = 0.0
        o.endUsedAmount = math.min(o.waterUnit, 1.0)
    end

	o.maxTime = o:getDuration()
	return o
end
