if not isClient() then return end

local ServerCommands = {}
local Commands = {}

-- -- -- -- --

Commands.player = {}
Commands.player.setWeight = function(args)
    getPlayer():getNutrition():setWeight(args.weight)
    getPlayer():getNutrition():setCalories(1000)
end

Commands.player.syncWeight = function(args)
    getPlayer():getNutrition():syncWeight()
end

-- -- -- -- --

Commands.fishing = {}

Commands.fishing.attachLure = function(args)
    local rod = getPlayer():getInventory():getItemWithID(args.rodId)
    local lure = getPlayer():getInventory():getItemWithID(args.lureId)

    log(DebugType.Action, '[ServerCommands.fishing.attachLure] '..tostring(getPlayer())..' rod '..tostring(rod)..' lure '..tostring(lure))

    local defaultName = rod:getScriptItem():getName()
    rod:setName(getText(defaultName) .. " " .. getText("UI_AttachLure_With") .. " " .. getItemName(args.lureFullType))

    rod:getModData().fishing_Lure = args.lureFullType

    if Fishing.lure.All[args.lureFullType].amountOfFoodHunger ~= -1 then
        local lureItem = getPlayer():getInventory():getItemWithID(args.lureId)
        lureItem:setHungChange(lureItem:getHungChange() + Fishing.lure.All[args.lureFullType].amountOfFoodHunger / 100)
    end

    getPlayer():setPrimaryHandItem(rod);
    getPlayer():setSecondaryHandItem(nil);
end

Commands.fishing.removeLure = function(args)
    local rod = getPlayer():getInventory():getItemWithID(args.rodId)
    local lure = getPlayer():getInventory():getItemWithID(args.lureId)

    log(DebugType.Action, '[ServerCommands.fishing.removeLure] '..tostring(getPlayer())..' rod '..tostring(rod)..' lure '..tostring(lure))

    local defaultName = rod:getScriptItem():getName()
    rod:setName(getText(defaultName))

    if Fishing.IsArtificalLure(rod:getModData().fishing_Lure) then
        getPlayer():setSecondaryHandItem(lure);
    end
    rod:getModData().fishing_Lure = nil
end

Commands.fishing.addChumToWater = function(args)
    FishSchoolManager.getInstance():addChum(args.x, args.y, args.force)
end

Commands.fishing.changeBobberSquare = function(args)
    if getPlayer():getInventory():containsID(args.rodID) then
        return;
    end

    local z = 0;
    local oldSq = getCell():getGridSquare(args.oldSqX, args.oldSqY, z);
    if not oldSq then
        return;
    end

    local item;
    local wobs = oldSq:getWorldObjects()
    for i = 0, wobs:size()-1 do
        local o = wobs:get(i)
        item = o:getItem()
        if item and item:getID() == args.bobberID then
            oldSq:RemoveTileObject(item:getWorldItem())
            break;
        end
    end

    if not item then
        print("changeBobberSquare: can't find the item")
        return;
    end

    local newSq = getCell():getGridSquare(fastfloor(args.bobberX), fastfloor(args.bobberY), z);
    if not newSq then
        return;
    end

    newSq:AddWorldInventoryItem(item, args.bobberX, args.bobberY, z, false)
end

Commands.erosion = {};
Commands.erosion.disableForSquare = function(args)
    local sq = getCell():getGridSquare(args.x, args.y, args.z);
    if sq ~= nil then
        sq:disableErosion();
    end
end

-- -- -- -- --

Commands.character = {};
Commands.character.rested = function(args)
    getPlayer():setIsResting(false)
    getPlayer():setBed(nil)
end

Commands.literature = {};
Commands.literature.readLiterature = function(args)
    local book = getPlayer():getInventory():getItemWithID(args.itemId)
    getPlayer():ReadLiterature(book);
    log(DebugType.Action, '[ServerCommands.literature.readLiterature] '..tostring(getPlayer())..' book '..tostring(book));
end

-- -- -- -- --

Commands.square = {};
Commands.square.removeGrass = function(args)
    local sq = getCell():getGridSquare(args.x, args.y, args.z);
    if sq ~= nil then
        sq:removeGrass();
    end
end

-- -- -- -- --
Commands.animal = {}
Commands.animal.forceEgg = function(args)
    local animal = getAnimal(tonumber(args.id))
    animal:debugForceEgg()
end
Commands.animal.invincible = function(args)
    local animal = getAnimal(tonumber(args.id))
    animal:setIsInvincible(args.value)
end
Commands.animal.kill = function(args)
    local animal = getAnimal(tonumber(args.id))
    if args.index then
        local hutch = getHutch(tonumber(args.x), tonumber(args.y), tonumber(args.z))
        animal:getData():setHutchPosition(tonumber(args.index))
        hutch:killAnimal(animal)
    else
        animal:setAttackedBy(getFakeAttacker())
        animal:setHealth(0)
    end
end
Commands.animal.setWool = function(args)
    local animal = getAnimal(tonumber(args.id))
    animal:getData():setWoolQuantity(tonumber(args.value), true)
end
Commands.animal.setMilk = function(args)
    local animal = getAnimal(tonumber(args.id))
    animal:getData():setMaxMilkActual(tonumber(args.value))
    animal:getData():setMilkQuantity(tonumber(args.value))
end
Commands.animal.setStress = function(args)
    local animal = getAnimal(tonumber(args.id))
    animal:setDebugStress(tonumber(args.value))
end
Commands.animal.setAge = function(args)
    local animal = getAnimal(tonumber(args.id))
    animal:setAgeDebug(tonumber(args.value))
end
Commands.animal.setHunger = function(args)
    local animal = getAnimal(tonumber(args.id))
    animal:getStats():setHunger(tonumber(args.value))
end
Commands.animal.setThirst = function(args)
    local animal = getAnimal(tonumber(args.id))
    animal:getStats():setThirst(tonumber(args.value))
end
Commands.animal.acceptance = function(args)
    local animal = getAnimal(tonumber(args.id))
    local player = getPlayerByOnlineID(tonumber(args.player))
    animal:setDebugAcceptance(player, tonumber(args.acceptance))
end
Commands.animal.updateStatsAway = function(args)
    print("id="..tostring(args.id))
    local animal = getAnimal(tonumber(args.id))
    animal:updateLastTimeSinceUpdate();
    animal:updateStatsAway(tonumber(args.value));
end
Commands.animal.fertilized = function(args)
    local animal = getAnimal(tonumber(args.id))
    animal:getData():setFertilized(args.value)
    local male = getAnimal(tonumber(args.male))
    if male and args.value then
        animal:getData():setMaleGenome(male:getFullGenome())
    end
end
Commands.animal.fertilizedTime = function(args)
    local animal = getAnimal(tonumber(args.id))
    animal:getData():setFertilizedTime(args.value)
end
Commands.animal.pregnant = function(args)
    local animal = getAnimal(tonumber(args.id))
    animal:getData():setPregnant(args.value)
end
Commands.animal.pregnancyTime = function(args)
    local animal = getAnimal(tonumber(args.id))
    animal:getData():setPregnancyTime(args.value)
end
Commands.animal.dung = function(args)
    local animal = getAnimal(tonumber(args.id))
    animal:getData():checkPoop(false);
end
Commands.animal.happy = function(args)
    local animal = getAnimal(tonumber(args.id))
    animal:debugRandomHappyAnim()
end
Commands.animal.attach = function(args)
    local animal = getAnimal(tonumber(args.id))
    local item = instanceItem(args.item)
    animal:setAttachedItem(args.location, item)
end
Commands.animal.forceWander = function(args)
    local animal = getAnimal(tonumber(args.id))
    animal:forceWanderNow()
end
Commands.animal.forceHutch = function(args)
    local animal = getAnimal(tonumber(args.id))
    animal:getBehavior():callToHutch(nil, true)
end
-- -- -- -- --
Commands.hutch = {}
Commands.hutch.dirt = function(args)
    local hutch = getHutch(tonumber(args.x), tonumber(args.y), tonumber(args.z))
    if hutch then
        hutch:setHutchDirt(args.dirt)
    end
end
Commands.hutch.nestBoxDirt = function(args)
    local hutch = getHutch(tonumber(args.x), tonumber(args.y), tonumber(args.z))
    if hutch then
        hutch:setNestBoxDirt(args.dirt)
    end
end
-- -- -- -- --
Commands.ui = {}
Commands.ui.DirtyUI = function(args)
    ISInventoryPage.dirtyUI();
end
-- -- -- -- --

ServerCommands.OnServerCommand = function(module, command, args)
    if Commands[module] and Commands[module][command] then
        local argStr = ''
        for k,v in pairs(args) do argStr = argStr..' '..k..'='..tostring(v) end
        print('received '..module..' '..command..' '..argStr)
        Commands[module][command](args)
    end
end
Events.OnServerCommand.Add(ServerCommands.OnServerCommand)