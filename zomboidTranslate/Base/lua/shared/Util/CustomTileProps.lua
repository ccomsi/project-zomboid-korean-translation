CustomTileProps_SetPair = {}
CustomTileProps_RemovePair = {}
-- Building
CustomTileProps_SetPair["crafted_04_39"] = {
    CanScrap = "",
    Material = "Wood",
    Material2 = "Nails"
}
CustomTileProps_SetPair["crafted_02_51"] = {
    CanScrap = "",
    Material = "MetalPlates"
}
CustomTileProps_SetPair["crafted_02_50"] = {
    CanScrap = "",
    Material = "MetalPlates"
}
CustomTileProps_SetPair["crafted_02_49"] = {
    CanScrap = "",
    Material = "MetalPlates"
}
CustomTileProps_SetPair["crafted_02_48"] = {
    CanScrap = "",
    Material = "MetalPlates"
}
CustomTileProps_SetPair["crafted_04_70"] = {
    CanScrap = "",
    Material = "Wood",
    Material2 = "Nails"
}
CustomTileProps_SetPair["crafted_04_60"] = {
    CanScrap = "",
    Material = "Wood",
    Material2 = "Nails"
}
CustomTileProps_SetPair["crafted_01_67"] = {
    CanScrap = "",
    Material = "Wood",
    Material2 = "Nails"
}
CustomTileProps_SetPair["crafted_05_72"] = {
    CanScrap = "",
    Material = "Wood",
    Material2 = "Nails"
}
CustomTileProps_SetPair["crafted_04_34"] = {
    CanScrap = "",
    Material = "Stone"
}
CustomTileProps_SetPair["crafted_01_73"] = {
    CanScrap = "",
    Material = "Wood",
    Material2 = "Nails"
}
CustomTileProps_SetPair["crafted_01_123"] = {
    CanScrap = "",
    Material = "Wood",
    Material2 = "Nails"
}
CustomTileProps_SetPair["vegetation_drying_01_8"] = {
    CanScrap = "",
    Material = "Wood",
    Material2 = "Nails"
}
CustomTileProps_SetPair["vegetation_drying_01_9wddddwaw"] = {
    CanScrap = "",
    Material = "Wood",
    Material2 = "Nails"
}
CustomTileProps_SetPair["crafted_05_75"] = {
    CanScrap = "",
    Material = "Wood",
    Material2 = "Nails"
}
CustomTileProps_SetPair["crafted_05_111"] = {
    CanScrap = "",
    Material = "Wood",
    Material2 = "Nails",
    IsMoveAble = ""
}
CustomTileProps_SetPair["crafted_05_85"] = {
    CanScrap = "",
    Material = "Wood",
    Material2 = "Nails"
}
CustomTileProps_SetPair["crafted_05_81"] = {
    CanScrap = "",
    Material = "Wood",
    Material2 = "Nails"
}
CustomTileProps_SetPair["crafted_05_73"] = {
    CanScrap = "",
    Material = "Wood",
    Material2 = "Nails"
}
CustomTileProps_SetPair["crafted_02_40"] = {
    CanScrap = "",
    Material = "Stone"
}
CustomTileProps_SetPair["camping_01_6"] = {
    ContainerCapacity = "15"
}

CustomTileProps_RemovePair["crafted_04_114"] = {"BlocksPlacement"}
CustomTileProps_RemovePair["crafted_04_115"] = {"BlocksPlacement"}
CustomTileProps_RemovePair["crafted_04_116"] = {"BlocksPlacement"}
CustomTileProps_RemovePair["crafted_04_117"] = {"BlocksPlacement"}
CustomTileProps_RemovePair["crafted_04_118"] = {"BlocksPlacement"}
CustomTileProps_RemovePair["crafted_04_119"] = {"BlocksPlacement"}

CustomTileProps_RemovePair["crafted_04_122"] = {"BlocksPlacement"}
CustomTileProps_RemovePair["crafted_04_123"] = {"BlocksPlacement"}
CustomTileProps_RemovePair["crafted_04_124"] = {"BlocksPlacement"}
CustomTileProps_RemovePair["crafted_04_125"] = {"BlocksPlacement"}
CustomTileProps_RemovePair["crafted_04_126"] = {"BlocksPlacement"}
CustomTileProps_RemovePair["crafted_04_127"] = {"BlocksPlacement"}

-- UnSet



local function OnGameStart()
    for tileName, values in pairs(CustomTileProps_SetPair) do
        local tile = IsoSpriteManager.instance:getSprite(tileName)
        local props = tile:getProperties()
        for key, value in pairs(values) do
            props:Set(key, value)
        end
    end
    for tileName, values in pairs(CustomTileProps_RemovePair) do
        local tile = IsoSpriteManager.instance:getSprite(tileName)
        local props = tile:getProperties()
        for i, val in ipairs(values) do
            props:UnSet(val)
        end
    end
end
Events.OnGameStart.Add(OnGameStart)


local function OnKeyPressed(key)

end

Events.OnKeyPressed.Add(OnKeyPressed)