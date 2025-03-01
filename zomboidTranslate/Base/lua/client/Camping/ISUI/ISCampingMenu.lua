--***********************************************************
--**                    ROBERT JOHNSON                     **
--**   Contextual inventory menu for all the camping stuff **
--***********************************************************

require 'Camping/CCampfireSystem'
--require 'Camping/camping_fuel'
--require 'Camping/camping_tent'

ISCampingMenu = {};
ISCampingMenu.currentSquare = nil;
ISCampingMenu.campfire = nil;
-- ISCampingMenu.tent = nil;

local function predicatePetrol(item)
	return item:getFluidContainer() and item:getFluidContainer():contains(Fluid.Petrol) and (item:getFluidContainer():getAmount() >= ZomboidGlobals.LightFromPetrolAmount)
end

-- local function predicateBuildCampfire(item)
-- 	return item:hasTag("BuildCampfire")
-- end

function ISCampingMenu.timeString(timeInMinutes)
	-- getPlayer():Say(tostring(timeInMinutes))
	if not timeInMinutes then timeInMinutes = 5 end
	local hourStr = getText("IGUI_Gametime_hour")
	local minuteStr = getText("IGUI_Gametime_minute")
	local hours = math.floor(timeInMinutes / 60)
	hours = round(hours,2)
	local minutes = timeInMinutes % 60
	minutes = round(minutes,2)
	if hours ~= 1 then hourStr = getText("IGUI_Gametime_hours") end
	if minutes ~= 1 then minuteStr = getText("IGUI_Gametime_minutes") end
	local str = ""
	if hours ~= 0 then
		str = hours .. ' ' .. hourStr
	end
	if str == '' or minutes ~= 0 then
		if str ~= '' then str = str .. ', ' end
		str = str .. minutes .. ' ' .. minuteStr
	end
	return str
end

function ISCampingMenu.isValidCampfire(campfire)
	if not campfire then return false end
	campfire:updateFromIsoObject()
	return campfire:getIsoObject() ~= nil
end

function ISCampingMenu.shouldBurn(item, playersChoice)
	if not item then return false end
	-- it might not always be the case that the player may want the item to burn, but it might still burn regardless
	if playersChoice then
        if item:isFavorite() then return false end
        if item:IsClothing() and item:isEquipped() then return false end
    end
	-- This prevents jewelry, shoes, etc from being used.
	if item:IsClothing() and not item:getFabricType() then return false end
	if item:IsClothing() and item:getFabricType() == "Leather" then return false end
	if item:IsClothing() and item:getWetness() > 0 then return false end
	if instanceof(item, "InventoryContainer") and not item:getInventory():isEmpty() then return false end
    if item:getFluidContainer() and item:getFluidContainer():getAmount() > 0 then return false end
    --TODO: check for appropriate moveables
--     if instanceof(item, "Moveable") then
--
--     end
    return true
end

function ISCampingMenu.isValidFuel(item)
    if not ISCampingMenu.shouldBurn(item, true) then return end

	local category = item:getCategory()
	local type = item:getType()

	local valid = item:hasTag("IsFireFuel") or item:getFireFuelRatio() > 0
	if campingFuelType[type] or campingFuelCategory[category] then valid = true end
	if campingFuelType[type] and campingFuelType[type] == 0 then valid = false end
	if campingFuelCategory[category] and campingFuelCategory[category] == 0 then valid = false end
    --TODO: check for appropriate moveables
--     if instanceof(item, "Moveable") then
--
--     end

	if item:hasTag("NotFireFuel") then valid = false end

	return valid
end

function ISCampingMenu.isValidTinder(item)
    if not ISCampingMenu.shouldBurn(item, true) then return end

	local category = item:getCategory()
	local type = item:getType()

	local valid = item:hasTag("IsFireTinder")
	if campingLightFireType[type] or campingLightFireCategory[category] then valid = true end
	if campingLightFireType[type] and campingLightFireType[type] == 0 then valid = false end
	if campingLightFireCategory[category] and campingLightFireCategory[category] == 0 then valid = false end
	if item:hasTag("NotFireTinder") then valid = false end

	return valid
end

function ISCampingMenu.getFuelDurationForItemInHours(item)
	local category = item:getCategory()
	local type = item:getType()

	local value = nil
	if campingFuelType[type] then value = campingFuelType[type]
	elseif campingLightFireType[type] then value = campingLightFireType[type]
	elseif campingFuelCategory[category] then value = campingFuelCategory[category]
	elseif campingLightFireCategory[category] then value = campingLightFireCategory[category] end

	local weightValue = item:getActualWeight()
	local burnRatio = 2/3
	if item:IsClothing() or item:IsInventoryContainer() or item:IsLiterature() or item:IsMap() then burnRatio = 1/4 end
	if item:getFireFuelRatio() > 0 then burnRatio = item:getFireFuelRatio() end
	weightValue = weightValue * burnRatio

    if value then
	    value = math.min(value, weightValue)
	else
	    value = weightValue
	end

	return value
end

-- this should return minutes
function ISCampingMenu.getFuelDurationForItem(item)
    return ISCampingMenu.getFuelDurationForItemInHours(item) * 60
end

function ISCampingMenu.getFuelItemUses(item)
	if not item:IsDrainable() then return 1 end
	return item:getCurrentUses()
end

ISCampingMenu.doCampingMenu = function(player, context, worldobjects, test)

	if test and ISWorldObjectContextMenu.Test then return true end

	local playerObj = getSpecificPlayer(player)
	local playerInv = playerObj:getInventory();

	if playerObj:getVehicle() then return end

	local makeCampfire = false;
	local addFuel = nil
	local addPetrol = nil
	local lightFromPetrol = nil
	local litCampfire = nil
	local removeCampfire = nil
	local removeTent = nil
	local sleep = nil
	local lightFromKindle = nil
	local lightFromLiterature = nil
	local startFireList = {}
	local startFireTypes = {}
	local petrol = nil
	local percedWood = nil
    local branch = nil
	local stick = nil
	-- local campfireKit = nil
	local campfireKit
	local tentKit = nil
	local fuelList = {}
	local lightFireList = {}
	local fuelAmtList = {}
	local itemCount = {}
	local stoneCount = 0

	local containers = ISInventoryPaneContextMenu.getContainers(playerObj)
	for i=1,containers:size() do
		local container = containers:get(i-1)
		for j=1,container:getItems():size() do
			local item = container:getItems():get(j-1)
			local type = item:getType()
			if item:hasTag("StartFire") or type == "Lighter" or type == "Matches" then
				if not startFireTypes[type] then
					table.insert(startFireList, item)
					startFireTypes[types] = true
				end
			elseif predicatePetrol(item) then
				petrol = item
			elseif type == "PercedWood" then
				percedWood = item
			elseif type == "TreeBranch" then
				branch = item
			elseif type == "TreeBranch2" then
				branch = item
			elseif type == "WoodenStick" then
				stick = item
			elseif type == "WoodenStick2" then
				stick = item
-- 			elseif type == "CampfireKit" then
-- 				campfireKit = item
-- 			elseif type == "CampingTentKit" then
-- 				tentKit = item
			elseif type == "Stone2" then
				stoneCount = stoneCount + 1
			end

			-- check the player inventory to add some fuel (logs, planks, books..)
			local category = item:getCategory()
			if ISCampingMenu.isValidFuel(item) or ISCampingMenu.isValidTinder(item) then
				if not itemCount[item:getName()] then

				    if ISCampingMenu.isValidFuel(item) then
                        table.insert(fuelList, item)
				    end
				    if ISCampingMenu.isValidTinder(item) and type then
                        table.insert(lightFireList, item)
--                         table.insert(fuelAmtList, 66)
--                         table.insert(fuelAmtList, ISCampingMenu.getFuelDurationForItem(item)/60*32)
				    end

-- 					if campingFuelType[type] then
-- 						if campingFuelType[type] > 0 then
-- 							table.insert(fuelList, item)
-- 						end
-- 					elseif campingFuelCategory[category] then
-- 						table.insert(fuelList, item)
-- 					end
-- 					if campingLightFireType[type] then
-- 						if campingLightFireType[type] > 0 then
-- 							table.insert(lightFireList, item)
-- 							table.insert(fuelAmtList, campingLightFireType[type])
-- 						end
-- 					elseif campingLightFireCategory[category] then
-- 						table.insert(lightFireList, item)
-- 						table.insert(fuelAmtList, campingLightFireCategory[category])
-- 					end
					itemCount[item:getName()] = 0
				end
				itemCount[item:getName()] = itemCount[item:getName()] + ISCampingMenu.getFuelItemUses(item)
			end
		end
	end

	table.sort(startFireList, function(a,b) return not string.sort(a:getDisplayName(), b:getDisplayName()) end)

	for i,v in ipairs(worldobjects) do
		ISCampingMenu.campfire = CCampfireSystem.instance:getLuaObjectOnSquare(v:getSquare())
		local campfire = ISCampingMenu.campfire
		-- we have to be outside
--~ 		if (v:getSquare():getProperties():Is(IsoFlagType.exterior)) then
			ISCampingMenu.currentSquare = v:getSquare();
			if stoneCount >= 3 and ISCampingMenu.campfire == nil then
				makeCampfire = true;
			end
			if ISCampingMenu.campfire ~= nil then
				if campfire.isLit then
					litCampfire = campfire
				end
				addFuel = campfire
				removeCampfire = campfire
			end
			if (#startFireList > 0) and petrol and campfire and
					not campfire.isLit and
					campfire.fuelAmt > 0 then
				lightFromPetrol = campfire
			end
			if percedWood and campfire and not campfire.isLit and campfire.fuelAmt > 0 and getSpecificPlayer(player):getStats():getEndurance() > 0 then
				lightFromKindle = campfire
			end
			if (#startFireList > 0) and campfire ~= nil and not campfire.isLit then
				lightFromLiterature = campfire
			end
	end

	if removeCampfire ~= nil then
		if test then return ISWorldObjectContextMenu.setTest() end
		local campfire = removeCampfire
		local isoCampfireObject = campfire:getIsoObject()
		local option = context:addOption(getText("ContextMenu_CampfireInfo"), worldobjects, ISCampingMenu.onDisplayInfo, player, isoCampfireObject, campfire)
		if playerObj:DistToSquared(isoCampfireObject:getX() + 0.5, isoCampfireObject:getY() + 0.5) < 2 * 2 then
			local fireState;
			if campfire.isLit == true then
				fireState = getText("IGUI_Fireplace_Burning")
			else
				fireState = getText("IGUI_Fireplace_Unlit")
			end
			option.toolTip = ISToolTip:new()
			option.toolTip:initialise()
			option.toolTip:setVisible(false)
			option.toolTip:setName(getText("IGUI_Campfire_Campfire"))
			option.toolTip.description = getText("IGUI_BBQ_FuelAmount", ISCampingMenu.timeString(luautils.round(campfire.fuelAmt))) .. " (" .. fireState .. ")"
		end
	end

	-- Add corpse to fire
	if removeCampfire ~= nil and playerObj:isGrappling() then
		if test then return ISWorldObjectContextMenu.setTest() end
		local campfire = removeCampfire
		local isoCampfireObject = campfire:getIsoObject()

		local option = context:addOption(getText("ContextMenu_CampfireCorpse"), worldobjects, ISCampingMenu.onDropCorpse, player, isoCampfireObject, campfire)
		if campfire.isLit then
			option.notAvailable = true
			option.toolTip = ISToolTip:new()
			option.toolTip:initialise()
			option.toolTip:setVisible(false)
			option.toolTip:setName(getText("ContextMenu_CampfireCorpse"))
			option.toolTip.description = getText("Tooltip_campfire_addcorpse")
		elseif playerObj:DistToSquared(isoCampfireObject:getX() + 0.5, isoCampfireObject:getY() + 0.5) > 1.5 then
			option.notAvailable = true
			option.toolTip = ISToolTip:new()
			option.toolTip:initialise()
			option.toolTip:setVisible(false)
			option.toolTip:setName(getText("ContextMenu_CampfireCorpse"))
			option.toolTip.description = getText("Tooltip_campfire_addcorpse_far")
		end
	end

-- nerf for fire capacity
	if #fuelList > 0 and addFuel then
		if test then return ISWorldObjectContextMenu.setTest() end
		local fuelOption = context:addOption(campingText.addFuel, worldobjects, nil);
		if addFuel and addFuel.fuelAmt and addFuel.fuelAmt >= getCampingFuelMax() then
		    fuelOption.notAvailable = true;
            local tooltip = ISWorldObjectContextMenu.addToolTip();
            tooltip.description = getText("ContextMenu_Fuel_Full");
            fuelOption.toolTip = tooltip;
		else
            local subMenuFuel = ISContextMenu:getNew(context);
            context:addSubMenu(fuelOption, subMenuFuel);

            if #fuelList > 1 then
                local numItems = 0
                local duration = 0
                for _,item in ipairs(fuelList) do
                    local count = itemCount[item:getName()]
                    duration = duration + (ISCampingMenu.getFuelDurationForItem(item) or 0.0) * count
                    numItems = numItems + count
                end
                if numItems > 1 then
                    local allOption = subMenuFuel:addActionsOption(getText("ContextMenu_AllWithCount", numItems), ISCampingMenu.onAddAllFuel, addFuel)
                    local tooltip = ISWorldObjectContextMenu.addToolTip()
                    tooltip.description = getText("IGUI_BBQ_FuelAmount", ISCampingMenu.timeString(duration))
                    allOption.toolTip = tooltip
                end
            end

            table.sort(fuelList, function(a,b) return not string.sort(a:getName(), b:getName()) end)
            for i,v in ipairs(fuelList) do
                local label = v:getName()
                local count = itemCount[v:getName()]
                if count > 1 then
                    label = label..' ('..count..')'
                    local subMenu = context:getNew(subMenuFuel)
                    local subOption = subMenuFuel:addOption(label)
                    subMenuFuel:addSubMenu(subOption, subMenu)

                    local subOption1 = subMenu:addActionsOption(getText("ContextMenu_One"), ISCampingMenu.onAddFuel, addFuel, v:getFullType())
                    local tooltip = ISWorldObjectContextMenu.addToolTip()
                    tooltip.description = getText("IGUI_BBQ_FuelAmount", ISCampingMenu.timeString(ISCampingMenu.getFuelDurationForItem(v)))
                    subOption1.toolTip = tooltip

                    local subOption2 = subMenu:addActionsOption(getText("ContextMenu_AllWithCount", count), ISCampingMenu.onAddMultipleFuel, addFuel, v:getFullType())
                    local tooltip = ISWorldObjectContextMenu.addToolTip()
                    tooltip.description = getText("IGUI_BBQ_FuelAmount", ISCampingMenu.timeString(ISCampingMenu.getFuelDurationForItem(v) * count))
                    subOption2.toolTip = tooltip
                else
                    local subOption = subMenuFuel:addActionsOption(label, ISCampingMenu.onAddFuel, addFuel, v:getFullType())
                    local tooltip = ISWorldObjectContextMenu.addToolTip()
                    tooltip.description = getText("IGUI_BBQ_FuelAmount", ISCampingMenu.timeString(ISCampingMenu.getFuelDurationForItem(v)))
                    subOption.toolTip = tooltip
                end
            end
        end
	end

-- 	if makeCampfire then
-- 		if test then return ISWorldObjectContextMenu.setTest() end
-- 		context:addOption(campingText.placeCampfire, worldobjects, ISCampingMenu.onPlaceCampfire, player) --, campfireKit);
-- 	end

	-- the following section is to be removed in build 43.
	if true then
		local disabledOption = context:addOption(getText("ContextMenu_CampfireKit"), worldobjects, ISCampingMenu.onPlaceCampfire, player) --, campfireKit);
		local tooltip = ISWorldObjectContextMenu.addToolTip()
		tooltip.description = getText("ContextMenu_CampfireKit_tooltip")
		disabledOption.toolTip = tooltip
		disabledOption.isDisabled = true;
	end
	-- the preceeding section is to be removed in build 43.
--[[
	if addPetrol then
		if test then return ISWorldObjectContextMenu.setTest() end
		context:addOption(campingText.addPetrol, worldobjects, ISCampingMenu.onAddPetrol, player, petrol, addPetrol);
	end
--]]
	if lightFromPetrol or lightFromKindle or (lightFromLiterature and #lightFireList > 0) then
		if test then return ISWorldObjectContextMenu.setTest() end
		local lightOption = context:addOption(campingText.lightCampfire, worldobjects, nil);
		local subMenuLight = ISContextMenu:getNew(context);
		context:addSubMenu(lightOption, subMenuLight);
		if lightFromPetrol then
			for _,startFire in ipairs(startFireList) do
				subMenuLight:addOption(petrol:getName()..' + '..startFire:getName(), worldobjects, ISCampingMenu.onLightFromPetrol, player, startFire, petrol, lightFromPetrol)
			end
		end
		table.sort(lightFireList, function(a,b) return not string.sort(a:getName(), b:getName()) end)
		for i,v in ipairs(lightFireList) do
			local label = v:getName()
			local count = itemCount[v:getName()]

			local fuelAmt = ISCampingMenu.getFuelDurationForItem(v)
			if count > 1 then
				label = label..' ('..count..')'
			end
			for _,startFire in ipairs(startFireList) do
				local subOption = subMenuLight:addActionsOption(label..' + '..startFire:getName(), ISCampingMenu.onLightFromLiterature, v:getFullType(), startFire, lightFromLiterature)
				local tooltip = ISWorldObjectContextMenu.addToolTip()
				tooltip.description = getText("IGUI_BBQ_FuelAmount", round(fuelAmt,2) )
				subOption.toolTip = tooltip
			end
		end
		if lightFromKindle then
			if stick then
				subMenuLight:addOption(percedWood:getName()..' + '..stick:getName(), worldobjects, ISCampingMenu.onLightFromKindle, player, percedWood, stick, lightFromKindle);
			elseif branch then
				subMenuLight:addOption(percedWood:getName()..' + '..branch:getName(), worldobjects, ISCampingMenu.onLightFromKindle, player, percedWood, branch, lightFromKindle);
			else
				local option = subMenuLight:addOption(percedWood:getName(), worldobjects, nil);
				option.notAvailable = true;
				local tooltip = ISWorldObjectContextMenu.addToolTip()
				tooltip:setName(percedWood:getName())
				tooltip.description = getText("Tooltip_lightFireNoStick")
				option.toolTip = tooltip
			end
		end
	end
	if litCampfire then
		if test then return ISWorldObjectContextMenu.setTest() end
		context:addOption(campingText.putOutCampfire, worldobjects, ISCampingMenu.onPutOutCampfire, player, litCampfire)
	end
	if removeCampfire then
		if test then return ISWorldObjectContextMenu.setTest() end
		context:addOption(campingText.removeCampfire, worldobjects, ISCampingMenu.onRemoveCampfire, player, removeCampfire);
	end
end

function ISCampingMenu.toPlayerInventory(playerObj, item)
    ISInventoryPaneContextMenu.transferIfNeeded(playerObj, item)
end

function ISCampingMenu.onDisplayInfo(worldobjects, player, isoCampfireObject, campfire)
	local playerObj = getSpecificPlayer(player)
	if not AdjacentFreeTileFinder.isTileOrAdjacent(playerObj:getCurrentSquare(), isoCampfireObject:getSquare()) then
		local adjacent = AdjacentFreeTileFinder.Find(isoCampfireObject:getSquare(), playerObj)
		if adjacent then
			ISTimedActionQueue.add(ISWalkToTimedAction:new(playerObj, adjacent))
			ISTimedActionQueue.add(ISCampingInfoAction:new(playerObj, isoCampfireObject, campfire))
			return
		end
	else
		ISTimedActionQueue.add(ISCampingInfoAction:new(playerObj, isoCampfireObject, campfire))
	end
end

function ISCampingMenu.onDropCorpse(worldobjects, player, isoCampfireObject, campfire)
	local playerObj = getSpecificPlayer(player)
	playerObj:faceThisObject(isoCampfireObject)
	local func = nil
	func = function()
		playerObj:faceThisObject(isoCampfireObject)
		if not playerObj:shouldBeTurning() then
			playerObj:getGrapplingTarget():setCurrent(isoCampfireObject:getSquare())
			playerObj:setDoGrappleLetGo();
			Events.OnTick.Remove(func)
		end
	end
	Events.OnTick.Add(func)
end

function ISCampingMenu.walkToCampfire(playerObj, square)
	local adjacent = AdjacentFreeTileFinder.FindClosest(square, playerObj)
	if adjacent == nil then return false end
	local x = adjacent:getX()
	local y = adjacent:getY()
	local z = adjacent:getZ()
	if adjacent == square:getAdjacentSquare(IsoDirections.NW) then
		x = x + 0.8
		y = y + 0.8
	elseif adjacent == square:getAdjacentSquare(IsoDirections.NE) then
		x = x + 0.2
		y = y + 0.8
	elseif adjacent == square:getAdjacentSquare(IsoDirections.SE) then
		x = x + 0.2
		y = y + 0.2
	elseif adjacent == square:getAdjacentSquare(IsoDirections.SW) then
		x = x + 0.8
		y = y + 0.2
	else
		x = x + 0.5
		y = y + 0.5
	end
	if (square:getZ() == playerObj:getCurrentSquare():getZ()) and
			(playerObj:DistToSquared(x, y) < 0.2 * 0.2) then
		return true
	end
	ISTimedActionQueue.add(ISPathFindAction:pathToLocationF(playerObj, x, y, z))
	return true
end

ISCampingMenu.doSleepOption = function(context, bed, player, playerObj)
    local sleepOption = context:addOption(getText("ContextMenu_Sleep"), bed, ISWorldObjectContextMenu.onSleep, player);
    local tooltipText = nil
    local sleepNeeded = not isClient() or getServerOptions():getBoolean("SleepNeeded")
    -- Not tired enough
    if sleepNeeded and (playerObj:getStats():getFatigue() <= 0.3) then
        sleepOption.notAvailable = true;
        tooltipText = getText("IGUI_Sleep_NotTiredEnough");
    end
	
	local isZombies = playerObj:getStats():getNumVisibleZombies() > 0 or playerObj:getStats():getNumChasingZombies() > 0 or playerObj:getStats():getNumVeryCloseZombies() > 0
    if sleepNeeded and isZombies then
        sleepOption.notAvailable = true;
        tooltipText = getText("IGUI_Sleep_NotSafe");
    end	
	
	if sleepNeeded and ((playerObj:getHoursSurvived() - playerObj:getLastHourSleeped()) <= 1) then
		-- cant go right back to sleep even with pills (sleeping pill exploit)
		sleepOption.notAvailable = true;
		tooltipText = getText("ContextMenu_NoSleepTooEarly");
		-- Sleeping pills counter those sleeping problems
	elseif playerObj:getSleepingTabletEffect() < 2000 then
        -- In pain, can still sleep if really tired
        if playerObj:getMoodles():getMoodleLevel(MoodleType.Pain) >= 2 and playerObj:getStats():getFatigue() <= 0.85 then
            sleepOption.notAvailable = true;
            tooltipText = getText("ContextMenu_PainNoSleep");
            -- In panic
        elseif playerObj:getMoodles():getMoodleLevel(MoodleType.Panic) >= 1 then
            sleepOption.notAvailable = true;
            tooltipText = getText("ContextMenu_PanicNoSleep");
            -- tried to sleep not so long ago
        end
    end

    local bedType = ISWorldObjectContextMenu.getBedQuality(bed)
    local bedTypeXln = getTextOrNull("Tooltip_BedType_" .. bedType)
    if bedTypeXln then
        if tooltipText then
            tooltipText = tooltipText .. " <BR> " .. getText("Tooltip_BedType", bedTypeXln)
        else
            tooltipText = getText("Tooltip_BedType", bedTypeXln)
        end
    end

    if tooltipText then
        local sleepTooltip = ISWorldObjectContextMenu.addToolTip();
        sleepTooltip:setName(getText("ContextMenu_Sleeping"));
        sleepTooltip.description = tooltipText;
        sleepOption.toolTip = sleepTooltip;
    end
end

ISCampingMenu.onAddFuel = function(playerObj, campfire, fuelType)
	if not ISCampingMenu.isValidCampfire(campfire) then return end
	local fuelItem = nil
	local containers = ISInventoryPaneContextMenu.getContainers(playerObj)
	for i=1,containers:size() do
		local container = containers:get(i-1)
		fuelItem = container:getFirstTypeEvalRecurse(fuelType, ISCampingMenu.isValidFuel)
		if fuelItem then break end
	end
	if not fuelItem then return end
	local fuelAmt = ISCampingMenu.getFuelDurationForItem(fuelItem)
	if not fuelAmt or fuelAmt <= 0 then return end
	ISCampingMenu.toPlayerInventory(playerObj, fuelItem)
	if not ISCampingMenu.walkToCampfire(playerObj, campfire:getSquare()) then return end
	if playerObj:isEquipped(fuelItem) then
		ISTimedActionQueue.add(ISUnequipAction:new(playerObj, fuelItem, 50))
	end
	ISTimedActionQueue.add(ISAddFuelAction:new(playerObj, campfire, fuelItem, fuelAmt))
end

local function addFuel(playerObj, campfire, fuelItems)
	if fuelItems:isEmpty() then return end
	ISCampingMenu.toPlayerInventory(playerObj, fuelItems)
	if not ISCampingMenu.walkToCampfire(playerObj, campfire:getSquare()) then return end
	for i=1,fuelItems:size() do
		local fuelItem = fuelItems:get(i-1)
		if playerObj:isEquipped(fuelItem) then
			ISTimedActionQueue.add(ISUnequipAction:new(playerObj, fuelItem, 50))
		end
		local fuelAmt = ISCampingMenu.getFuelDurationForItem(fuelItem)
		local uses = ISCampingMenu.getFuelItemUses(fuelItem)
		local fuelIn = campfire.fuelAmt
		for j=1,uses do
		    if (fuelIn + fuelAmt > getCampingFuelMax()) then return end
		    fuelIn = fuelIn + fuelAmt
			ISTimedActionQueue.add(ISAddFuelAction:new(playerObj, campfire, fuelItem, fuelAmt))
		end
	end
end

ISCampingMenu.onAddAllFuel = function(playerObj, campfire)
	if not ISCampingMenu.isValidCampfire(campfire) then return end
	local fuelItems = ArrayList.new()
	local containers = ISInventoryPaneContextMenu.getContainers(playerObj)
	for i=1,containers:size() do
		local container = containers:get(i-1)
		container:getAllEval(ISCampingMenu.isValidFuel, fuelItems)
	end
	addFuel(playerObj, campfire, fuelItems)
end

ISCampingMenu.onAddMultipleFuel = function(playerObj, campfire, fuelType)
	if not ISCampingMenu.isValidCampfire(campfire) then return end
	local fuelItems = ArrayList.new()
	local containers = ISInventoryPaneContextMenu.getContainers(playerObj)
	for i=1,containers:size() do
		local container = containers:get(i-1)
		container:getAllTypeEval(fuelType, ISCampingMenu.isValidFuel, fuelItems)
	end
	addFuel(playerObj, campfire, fuelItems)
end

ISCampingMenu.onPlaceCampfire = function(worldobjects, player) --, campfireKit)
	local playerObj = getSpecificPlayer(player)


	local containers = ISInventoryPaneContextMenu.getContainers(playerObj)
	local newCount = 0
	for i=1,containers:size() do
		local container = containers:get(i-1)
		for j=1,container:getItems():size() do
			local item = container:getItems():get(j-1)
			if item:getType() == "Stone2" and newCount < 3 then
				ISCampingMenu.toPlayerInventory(playerObj, item)
				newCount = newCount + 1
				if newCount >=3 then break end
			end
		end
	end
	local bo = campingCampfire:new(getSpecificPlayer(player))
	bo.player = player
	getCell():setDrag(bo, player)
end

ISCampingMenu.onPutOutCampfire = function(worldobjects, player, campfire)
	local playerObj = getSpecificPlayer(player)
	if ISCampingMenu.walkToCampfire(playerObj, campfire:getSquare()) then
		ISTimedActionQueue.add(ISPutOutCampfireAction:new(playerObj, campfire));
	end
end

ISCampingMenu.onRemoveCampfire = function(worldobjects, player, campfire)
	local playerObj = getSpecificPlayer(player)
	if ISCampingMenu.walkToCampfire(playerObj, campfire:getSquare()) then
		ISTimedActionQueue.add(ISRemoveCampfireAction:new(playerObj, campfire, 60));
	end
end

ISCampingMenu.onLightFromLiterature = function(playerObj, itemType, lighter, campfire)
	if not ISCampingMenu.isValidCampfire(campfire) then return end
	local fuelItem = nil
	local containers = ISInventoryPaneContextMenu.getContainers(playerObj)
	for i=1,containers:size() do
		local container = containers:get(i-1)
		fuelItem = container:getFirstTypeEvalRecurse(itemType, ISCampingMenu.isValidTinder)
		if fuelItem then break end
	end
	ISCampingMenu.toPlayerInventory(playerObj, fuelItem)
	ISCampingMenu.toPlayerInventory(playerObj, lighter)
	if ISCampingMenu.walkToCampfire(playerObj, campfire:getSquare()) then
		if playerObj:isEquipped(fuelItem) then
			ISTimedActionQueue.add(ISUnequipAction:new(playerObj, fuelItem, 50));
		end
--         local fuelAmt = ISCampingMenu.getFuelDurationForItem(fuelItem)/60
		ISTimedActionQueue.add(ISLightFromLiterature:new(playerObj, fuelItem, lighter, campfire));
	end
end

ISCampingMenu.onLightFromKindle = function(worldobjects, player, percedWood, stickOrBranch, campfire)
	local playerObj = getSpecificPlayer(player)
	ISCampingMenu.toPlayerInventory(playerObj, percedWood)
	ISCampingMenu.toPlayerInventory(playerObj, stickOrBranch)
	if ISCampingMenu.walkToCampfire(playerObj, campfire:getSquare()) then
		ISTimedActionQueue.add(ISLightFromKindle:new(playerObj, percedWood, stickOrBranch, campfire));
	end
end
--[[
ISCampingMenu.onAddPetrol = function(worldobjects, player, petrol, campfire)
	local playerObj = getSpecificPlayer(player)
	ISCampingMenu.toPlayerInventory(playerObj, petrol)
	if ISCampingMenu.walkToCampfire(playerObj, campfire:getSquare()) then
		ISTimedActionQueue.add(ISAddPetrolAction:new(playerObj, campfire, petrol, 10));
	end
end
--]]
ISCampingMenu.onLightFromPetrol = function(worldobjects, player, lighter, petrol, campfire)
	local playerObj = getSpecificPlayer(player)
	ISCampingMenu.toPlayerInventory(playerObj, lighter)
	ISCampingMenu.toPlayerInventory(playerObj, petrol)
	if ISCampingMenu.walkToCampfire(playerObj, campfire:getSquare()) then
		ISTimedActionQueue.add(ISLightFromPetrol:new(playerObj, campfire, lighter, petrol, 20));
	end
end

ISCampingMenu.onRest = function(worldobjects, player, tent)
	local playerObj = getSpecificPlayer(player)
	if luautils.walkAdj(playerObj, tent:getSquare()) then
		ISTimedActionQueue.add(ISRestAction:new(playerObj), tent, false);
	end
end

Events.OnFillWorldObjectContextMenu.Add(ISCampingMenu.doCampingMenu);
