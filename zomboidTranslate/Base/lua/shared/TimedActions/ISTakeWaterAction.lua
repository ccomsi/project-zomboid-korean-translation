--***********************************************************
--**                    ROBERT JOHNSON                     **
--***********************************************************

require "TimedActions/ISBaseTimedAction"

ISTakeWaterAction = ISBaseTimedAction:derive("ISTakeWaterAction");

function ISTakeWaterAction:isValid()
	if self.item and not self.item:getContainer() then return false end
	return self.waterObject:hasWater()
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
    
    -- spurcival: TODO: live update fluid qtys here?
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
        if self.waterObject:getProperties() and (self.waterObject:getProperties():Val("CustomName") == "Toilet") then
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

    -- spurcival: TODO: set partial use here?
    
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
    local usedWaterTainted = self.waterObject:isTaintedWater();
    local usedWaterAmount = self.waterObject:useWater(self.waterUnit);
    self.waterObject:sync();
    
    local newPoisonLevel;
	if self.item then
		local fluid = Fluid.Water;
	    if usedWaterTainted then
            fluid = Fluid.TaintedWater;
        end
        self.item:getFluidContainer():addFluid(fluid, usedWaterAmount);
        self.item:syncItemFields();
        sendItemStats(self.item)
    else
        local thirst = self.character:getStats():getThirst() - usedWaterAmount
        self.character:getStats():setThirst(math.max(thirst, 0.0));
        --Stat_Thirst
        syncPlayerStats(self.character, 0x00004000);

        -- Trust client in case water is tainted, since we can't compute puddles on the server side
        local isTainted = (isServer() and self.waterTaintedCL) or usedWaterTainted
        if isTainted then
            --tainted water shouldn't kill the player but make them sick - dangerous when sick
            local bodyDamage	= self.character:getBodyDamage();
            local stats			= self.character:getStats();
            if bodyDamage:getPoisonLevel() < 20 and stats:getSickness() < 0.3 then
                newPoisonLevel = math.min(bodyDamage:getPoisonLevel() + 10 + math.floor(self.waterUnit * 10), 20);
                bodyDamage:setPoisonLevel(newPoisonLevel);
                sendDamage(self.character)
                --print("Player " .. tostring(self.character:getDisplayName()) .. " just drank tainted water with poison power " .. tostring(newPoisonLevel))
            end
        end
    end

    return true;
end

function ISTakeWaterAction:serverStop()
	if self.item ~= nil and self.item:getFluidContainer() then
		self.item:getFluidContainer():addFluid(Fluid.Water, self.netAction:getProgress()*(self.waterUnit));
        self.item:syncItemFields();
        sendItemStats(self.item)
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

    local waterAvailable = o.waterObject:getWaterAmount();
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
