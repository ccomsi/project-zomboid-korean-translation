--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

ISFireplaceMenu = {}

local function predicatePetrol(item)
	return (item:hasTag("Petrol") or item:getType() == "PetrolCan")
end

function ISFireplaceMenu.OnFillWorldObjectContextMenu(player, context, worldobjects, test)

	if test and ISWorldObjectContextMenu.Test then return true end

	local fireplace = nil

	local objects = {}
	for _,object in ipairs(worldobjects) do
		local square = object:getSquare()
		if square then
			local index = square:getNextNonItemObjectIndex(0)
			while index >= 0 and index < square:getObjects():size() do
				local object2 = square:getObjects():get(index)
				index = square:getNextNonItemObjectIndex(index + 1)
				if instanceof(object2, "IsoFireplace") then
					fireplace = object2
				end
			end
		end
	end

	if not fireplace then return end

	local playerObj = getSpecificPlayer(player)
	local playerInv = playerObj:getInventory()
	local startFireList = {}
	local startFireTypes = {}
	local petrol = nil
	local percedWood = nil
	local branch = nil
	local stick = nil

	-- check the player inventory to add some fuel (logs, planks, books..)
	local fuelList = {}
	local lightWithList = {}
	local fuelAmtList = {}
	local itemCount = {}
	local containers = ISInventoryPaneContextMenu.getContainers(playerObj)
	for i=1,containers:size() do
		local container = containers:get(i-1)
		for j=1,container:getItems():size() do
			local vItem = container:getItems():get(j-1)
			local type = vItem:getType()
			if vItem:hasTag("StartFire") or type == "Lighter" or type == "Matches" then
				if not startFireTypes[type] then
					table.insert(startFireList, vItem)
					startFireTypes[types] = true
				end
			elseif predicatePetrol(vItem) then
				petrol = petrol or vItem
			elseif type == "PercedWood" then
				percedWood = percedWood or vItem
			elseif type == "TreeBranch" or type == "TreeBranch2" then
				branch = branch or vItem
			elseif type == "WoodenStick" or type == "WoodenStick2" then
				stick = stick or vItem
			end
			if ISCampingMenu.isValidFuel(vItem) or ISCampingMenu.isValidTinder(vItem) then
				if not itemCount[vItem:getName()] then

				    if ISCampingMenu.isValidFuel(vItem) then
                        table.insert(fuelList, vItem)
				    end
				    if ISCampingMenu.isValidTinder(vItem) then
                        table.insert(lightWithList, vItem)
                        table.insert(fuelAmtList, ISCampingMenu.getFuelDurationForItem(vItem)/60*32)
				    end


-- 					if campingFuelType[vItem:getType()] then
-- 						if campingFuelType[vItem:getType()] > 0 then
-- 							table.insert(fuelList, vItem)
-- 						end
-- 					elseif campingFuelCategory[vItem:getCategory()] then
-- 						table.insert(fuelList, vItem)
-- 					end
-- 					if campingLightFireType[vItem:getType()] then
-- 						if campingLightFireType[vItem:getType()] > 0 then
-- 							table.insert(lightWithList, vItem)
-- 							table.insert(fuelAmtList, campingLightFireType[vItem:getType()])
-- 						end
-- 					elseif campingLightFireCategory[vItem:getCategory()] then
-- 						table.insert(lightWithList, vItem)
-- 						table.insert(fuelAmtList, campingLightFireCategory[vItem:getCategory()])
-- 					end
					itemCount[vItem:getName()] = 0
				end
				itemCount[vItem:getName()] = itemCount[vItem:getName()] + ISCampingMenu.getFuelItemUses(vItem)
			end
		end
	end

	table.sort(startFireList, function(a,b) return not string.sort(a:getDisplayName(), b:getDisplayName()) end)

	if test then return ISWorldObjectContextMenu.setTest() end
	local option = context:addOption(fireplace:getTileName() or getText("ContextMenu_Fireplace") .. " " .. getText("ContextMenu_Info"), worldobjects, ISFireplaceMenu.onDisplayInfo, player, fireplace)
-- 	local option = context:addOption(getText("ContextMenu_FireplaceInfo"), worldobjects, ISFireplaceMenu.onDisplayInfo, player, fireplace)
	if playerObj:DistToSquared(fireplace:getX() + 0.5, fireplace:getY() + 0.5) < 2 * 2 then
		local fireState;
		if fireplace:isLit() then
			fireState = getText("IGUI_Fireplace_Burning")
		elseif fireplace:isSmouldering() then
			fireState = getText("IGUI_Fireplace_Smouldering")
		else
			fireState = getText("IGUI_Fireplace_Unlit")
		end
		option.toolTip = ISWorldObjectContextMenu:addToolTip()
		option.toolTip:setName(fireplace:getTileName() or getText("IGUI_Fireplace_Fireplace"))
-- 		option.toolTip:setName(getText("IGUI_Fireplace_Fireplace"))
		option.toolTip.description = getText("IGUI_BBQ_FuelAmount", ISCampingMenu.timeString(luautils.round(fireplace:getFuelAmount()))) .. " (" .. fireState .. ")"
-- 		print("time " .. tostring(fireplace:getFuelAmount()))
	end
-- nerf for fire capacity
	if #fuelList > 0 then
		if test then return ISWorldObjectContextMenu.setTest() end
		local fuelOption = context:addOption(campingText.addFuel, worldobjects, nil)
		if fireplace:getFuelAmount() >= getCampingFuelMax() then
		    fuelOption.notAvailable = true;
            local tooltip = ISWorldObjectContextMenu.addToolTip();
            tooltip.description = getText("ContextMenu_Fuel_Full");
            fuelOption.toolTip = tooltip;
		else
            local subMenuFuel = ISContextMenu:getNew(context)
            context:addSubMenu(fuelOption, subMenuFuel)

            if #fuelList > 1 then
                local numItems = 0
                local duration = 0
                for _,item in ipairs(fuelList) do
                    local count = itemCount[item:getName()]
                    duration = duration + (ISCampingMenu.getFuelDurationForItem(item) or 0.0) * count
                    numItems = numItems + count
                end
                if numItems > 1 then
                    local allOption = subMenuFuel:addActionsOption(getText("ContextMenu_AllWithCount", numItems), ISFireplaceMenu.onAddAllFuel, fireplace)
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

                    local subOption1 = subMenu:addActionsOption(getText("ContextMenu_One"), ISFireplaceMenu.onAddFuel, fireplace, v:getFullType())
                    local tooltip = ISWorldObjectContextMenu.addToolTip()
                    tooltip.description = getText("IGUI_BBQ_FuelAmount", ISCampingMenu.timeString(ISCampingMenu.getFuelDurationForItem(v)))
                    subOption1.toolTip = tooltip

                    local subOption2 = subMenu:addActionsOption(getText("ContextMenu_AllWithCount", count), ISFireplaceMenu.onAddMultipleFuel, fireplace, v:getFullType())
                    local tooltip = ISWorldObjectContextMenu.addToolTip()
                    tooltip.description = getText("IGUI_BBQ_FuelAmount", ISCampingMenu.timeString(ISCampingMenu.getFuelDurationForItem(v) * count))
                    subOption2.toolTip = tooltip
                else
                    local subOption = subMenuFuel:addActionsOption(label, ISFireplaceMenu.onAddFuel, fireplace, v:getFullType())
                    local tooltip = ISWorldObjectContextMenu.addToolTip()
                    tooltip.description = getText("IGUI_BBQ_FuelAmount", ISCampingMenu.timeString(ISCampingMenu.getFuelDurationForItem(v)))
                    subOption.toolTip = tooltip
                end
            end
        end
	end

	-- Options for lighting a fire
	local lightFromItem = nil
	local lightFromPetrol = nil
	local lightFromKindle = nil
	if (#lightWithList > 0) and (#startFireList > 0) and not fireplace:isLit() then
		lightFromItem = fireplace
	end
	if (#startFireList > 0) and petrol and not fireplace:isLit() and fireplace:hasFuel() then
		lightFromPetrol = fireplace
	end
	if percedWood and not fireplace:isLit() and fireplace:hasFuel() and playerObj:getStats():getEndurance() > 0 then
		lightFromKindle = fireplace
	end
	if lightFromPetrol or lightFromKindle or lightFromItem then
		if test then return ISWorldObjectContextMenu.setTest() end
		local lightOption = context:addOption(campingText.lightCampfire, worldobjects, nil)
		local subMenuLight = ISContextMenu:getNew(context)
		context:addSubMenu(lightOption, subMenuLight)
		if lightFromPetrol then
			for _,startFire in ipairs(startFireList) do
				subMenuLight:addOption(petrol:getName()..' + '..startFire:getName(), worldobjects, ISFireplaceMenu.onLightFromPetrol, player, startFire, petrol, lightFromPetrol)
			end
		end
		table.sort(lightWithList, function(a,b) return not string.sort(a:getName(), b:getName()) end)
		for i,v in ipairs(lightWithList) do
			local label = v:getName()
			local count = itemCount[v:getName()]
			if count > 1 then
				label = label..' ('..count..')'
			end
			for _,startFire in ipairs(startFireList) do
				local subOption = subMenuLight:addActionsOption(label..' + '..startFire:getName(), ISFireplaceMenu.onLightFromLiterature, v:getFullType(), startFire, lightFromItem, fuelAmtList[i])
				local tooltip = ISWorldObjectContextMenu.addToolTip()
				tooltip.description = getText("IGUI_BBQ_FuelAmount", ISCampingMenu.timeString(ISCampingMenu.getFuelDurationForItem(v)))
				subOption.toolTip = tooltip
			end
		end
		if lightFromKindle then
			if stick then
				subMenuLight:addOption(percedWood:getName()..' + '..stick:getName(), worldobjects, ISFireplaceMenu.onLightFromKindle, player, percedWood, stick, lightFromKindle)
			elseif branch then
				subMenuLight:addOption(percedWood:getName()..' + '..branch:getName(), worldobjects, ISFireplaceMenu.onLightFromKindle, player, percedWood, branch, lightFromKindle)
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

	if fireplace:isLit() then
		if test then return ISWorldObjectContextMenu.setTest() end
		context:addOption(campingText.putOutCampfire, worldobjects, ISFireplaceMenu.onExtinguish, player, fireplace)
	end
end

function ISFireplaceMenu.onDisplayInfo(worldobjects, player, bbq)
	local playerObj = getSpecificPlayer(player)
	if not AdjacentFreeTileFinder.isTileOrAdjacent(playerObj:getCurrentSquare(), bbq:getSquare()) then
		local adjacent = AdjacentFreeTileFinder.Find(bbq:getSquare(), playerObj)
		if adjacent then
			ISTimedActionQueue.add(ISWalkToTimedAction:new(playerObj, adjacent))
			ISTimedActionQueue.add(ISFireplaceInfoAction:new(playerObj, bbq))
			return
		end
	else
		ISTimedActionQueue.add(ISFireplaceInfoAction:new(playerObj, bbq))
	end
end

function ISFireplaceMenu.toPlayerInventory(playerObj, item)
    ISInventoryPaneContextMenu.transferIfNeeded(playerObj, item)
end

function ISFireplaceMenu.onAddFuel(playerObj, fireplace, fuelType)
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
	ISFireplaceMenu.toPlayerInventory(playerObj, fuelItem)
	if luautils.walkAdj(playerObj, fireplace:getSquare(), true) then
		if playerObj:isEquipped(fuelItem) then
			ISTimedActionQueue.add(ISUnequipAction:new(playerObj, fuelItem, 50));
		end
        if (fireplace:getFuelAmount() + fuelAmt > getCampingFuelMax()) then return end
		ISTimedActionQueue.add(ISFireplaceAddFuel:new(playerObj, fireplace, fuelItem, fuelAmt))
	end
end

local function addFuel(playerObj, fireplace, fuelItems)
	if fuelItems:isEmpty() then return end
	ISFireplaceMenu.toPlayerInventory(playerObj, fuelItems)
	if not luautils.walkAdj(playerObj, fireplace:getSquare(), true) then return end
	for i=1,fuelItems:size() do
		local fuelItem = fuelItems:get(i-1)
		if playerObj:isEquipped(fuelItem) then
			ISTimedActionQueue.add(ISUnequipAction:new(playerObj, fuelItem, 50))
		end
		local fuelAmt = ISCampingMenu.getFuelDurationForItem(fuelItem)
		local uses = ISCampingMenu.getFuelItemUses(fuelItem)
		for j=1,uses do
		    if (fireplace:getFuelAmount() + fuelAmt > getCampingFuelMax()) then return end
			ISTimedActionQueue.add(ISFireplaceAddFuel:new(playerObj, fireplace, fuelItem, fuelAmt))
		end
	end
end

ISFireplaceMenu.onAddMultipleFuel = function(playerObj, fireplace, fuelType)
	local fuelItems = ArrayList.new()
	local containers = ISInventoryPaneContextMenu.getContainers(playerObj)
	for i=1,containers:size() do
		local container = containers:get(i-1)
		container:getAllTypeEval(fuelType, ISCampingMenu.isValidFuel, fuelItems)
	end
	addFuel(playerObj, fireplace, fuelItems)
end

ISFireplaceMenu.onAddAllFuel = function(playerObj, fireplace)
	local fuelItems = ArrayList.new()
	local containers = ISInventoryPaneContextMenu.getContainers(playerObj)
	for i=1,containers:size() do
		local container = containers:get(i-1)
		container:getAllEval(ISCampingMenu.isValidFuel, fuelItems)
	end
	addFuel(playerObj, fireplace, fuelItems)
end

function ISFireplaceMenu.onLightFromLiterature(playerObj, itemType, lighter, fireplace, fuelAmt)
	local fuelItem = nil
	local containers = ISInventoryPaneContextMenu.getContainers(playerObj)
	for i=1,containers:size() do
		local container = containers:get(i-1)
		fuelItem = container:getFirstTypeEvalRecurse(itemType, ISCampingMenu.isValidTinder)
		if fuelItem then break end
	end
	if not fuelItem then return end
	ISFireplaceMenu.toPlayerInventory(playerObj, fuelItem)
	ISFireplaceMenu.toPlayerInventory(playerObj, lighter)
	if luautils.walkAdj(playerObj, fireplace:getSquare(), true) then
		if playerObj:isEquipped(fuelItem) then
			ISTimedActionQueue.add(ISUnequipAction:new(playerObj, fuelItem, 50));
		end
		ISTimedActionQueue.add(ISFireplaceLightFromLiterature:new(playerObj, fuelItem, lighter, fireplace))
	end
end

function ISFireplaceMenu.onLightFromPetrol(worldobjects, player, lighter, petrol, fireplace)
	local playerObj = getSpecificPlayer(player)
	ISFireplaceMenu.toPlayerInventory(playerObj, lighter)
	ISFireplaceMenu.toPlayerInventory(playerObj, petrol)
	if luautils.walkAdj(playerObj, fireplace:getSquare(), true) then
		ISTimedActionQueue.add(ISFireplaceLightFromPetrol:new(playerObj, fireplace, lighter, petrol))
	end
end

function ISFireplaceMenu.onLightFromKindle(worldobjects, player, percedWood, stickOrBranch, fireplace)
	local playerObj = getSpecificPlayer(player)
	ISFireplaceMenu.toPlayerInventory(playerObj, percedWood)
	ISFireplaceMenu.toPlayerInventory(playerObj, stickOrBranch)
	if luautils.walkAdj(playerObj, fireplace:getSquare(), true) then
		ISTimedActionQueue.add(ISFireplaceLightFromKindle:new(playerObj, percedWood, stickOrBranch, fireplace))
	end
end

function ISFireplaceMenu.onExtinguish(worldobjects, player, fireplace)
	local playerObj = getSpecificPlayer(player)
	if luautils.walkAdj(playerObj, fireplace:getSquare()) then
		ISTimedActionQueue.add(ISFireplaceExtinguish:new(playerObj, fireplace))
	end
end

Events.OnFillWorldObjectContextMenu.Add(ISFireplaceMenu.OnFillWorldObjectContextMenu)

