--
-- Created by IntelliJ IDEA.
-- User: RJ
-- Date: 07/02/2017
-- Time: 14:57
-- To change this template use File | Settings | File Templates.
--
--Black: 0.129,0.129,0.129
--Red: 0.65, 0.054, 0.054
--Blue: 0.156, 0.188, 0.49
--Green: 0.06, 0.39, 0.17
require "StashDescriptions/StashUtil";

-- guns
local stashMap = StashUtil.newStash("WpStashMap1", "Map", "Base.WestpointMap", "Stash_AnnotedMap");
--stashMap.spawnOnlyOnZed = true;
--stashMap.daysToSpawn = "0-30";
--stashMap.zombies = 5
--stashMap.traps = "1-5";
--stashMap.barricades = 50;
stashMap.buildingX = 10941
stashMap.buildingY = 6726
stashMap.spawnTable = "GunCache1";
stashMap:addContainer("GunBox","carpentry_01_16",nil,nil,nil,nil,nil);
stashMap:addStamp("X", nil, 10941, 6724, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_WpMap1_Text1", 10951, 6716, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_WpMap1_Text2", 10955, 6740, 0.65, 0.054, 0.054)

local stashMap = StashUtil.newStash("WpStashMap2", "Map", "Base.WestpointMap", "Stash_AnnotedMap");
stashMap.barricades = 30;
stashMap.buildingX = 11040
stashMap.buildingY = 6731
stashMap.spawnTable = "GunCache1";
stashMap:addStamp("X", nil, 11040, 6732, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_WpMap2_Text1", 11016, 6740, 0.129,0.129,0.129)
stashMap:addStamp("Circle", nil, 11935, 6804, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_WpMap2_Text2", 11942, 6795, 0.129,0.129,0.129)
stashMap:addStamp("Exclamation", nil, 11234, 6750, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_WpMap2_Text3", 11242, 6740, 0.129,0.129,0.129)

-- shotgun
local stashMap = StashUtil.newStash("WpStashMap3", "Map", "Base.WestpointMap", "Stash_AnnotedMap");
stashMap.spawnOnlyOnZed = true;
stashMap.zombies = 3;
stashMap.buildingX = 11318
stashMap.buildingY = 6727
stashMap.spawnTable = "ShotgunCache1";
stashMap:addStamp("Target", nil, 11317, 6726, 0.129,0.129,0.129)
stashMap:addContainer(nil,nil,"Base.Bag_DuffelBagTINT",nil,nil,nil,nil);

local stashMap = StashUtil.newStash("WpStashMap4", "Map", "Base.WestpointMap", "Stash_AnnotedMap");
stashMap.barricades = 20;
stashMap.buildingX = 11196
stashMap.buildingY = 6714
stashMap.spawnTable = "ShotgunCache1";
stashMap:addStamp("Target", nil, 11198, 6713, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_WpMap4_Text1", 11210, 6705, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_WpMap4_Text3", 11158, 6755, 0.65, 0.054, 0.054)
stashMap:addStamp(nil, "Stash_WpMap4_Text31", 11158, 6770, 0.65, 0.054, 0.054)
stashMap:addContainer(nil,nil,"Base.Bag_DuffelBagTINT",nil,nil,nil,nil);

local stashMap = StashUtil.newStash("WpStashMap11", "Map", "Base.WestpointMap", "Stash_AnnotedMap");
stashMap.barricades = 40;
stashMap.buildingX = 11980
stashMap.buildingY = 6813
stashMap.spawnTable = "ShotgunCache1";
stashMap:addStamp("Target", nil, 11979, 6813, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_WpMap11_Text1", 11932, 6824, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_WpMap11_Text11", 11934, 6842, 0.129,0.129,0.129)
stashMap:addStamp("Circle", nil, 11974, 6913, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_WpMap11_Text2", 11983, 6906, 0.129,0.129,0.129)
stashMap:addStamp("X", nil, 11872, 6757, 0.06, 0.39, 0.17)
stashMap:addStamp(nil, "Stash_WpMap11_Text3", 11882, 6745, 0.06, 0.39, 0.17)
stashMap:addContainer(nil,nil,"Base.Bag_DuffelBagTINT",nil,nil,nil,nil);

-- tools
local stashMap = StashUtil.newStash("WpStashMap5", "Map", "Base.WestpointMap", "Stash_AnnotedMap");
stashMap.barricades = 30;
stashMap.buildingX = 11439
stashMap.buildingY = 6732
stashMap.spawnTable = "ToolsCache1";
stashMap:addStamp("Circle", nil, 11438, 6731, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_WpMap5_Text1", 11452, 6725, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_WpMap5_Text11", 11452, 6741, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_WpMap5_Text2", 11653, 7076, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_WpMap5_Text3", 11420, 6781, 0.129,0.129,0.129)
stashMap:addContainer("ToolsBox","carpentry_01_16",nil,"bedroom",nil,nil,nil);

local stashMap = StashUtil.newStash("WpStashMap6", "Map", "Base.WestpointMap", "Stash_AnnotedMap");
stashMap.spawnOnlyOnZed = true;
stashMap.zombies = 7;
stashMap.buildingX = 11496
stashMap.buildingY = 6703
stashMap.spawnTable = "ToolsCache1";
stashMap:addStamp("Circle", nil, 11498, 6703, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_WpMap6_Text1", 11466, 6713, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_WpMap6_Text2", 12064, 6794, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_WpMap6_Text3", 11500, 6771, 0.65, 0.054, 0.054)
stashMap:addContainer("ToolsBox","carpentry_01_16",nil,nil,nil,nil,nil);

-- survivor houses
local stashMap = StashUtil.newStash("WpStashMap7", "Map", "Base.WestpointMap", "Stash_AnnotedMap");
stashMap.spawnOnlyOnZed = true;
stashMap.buildingX = 11609
stashMap.buildingY = 6778
stashMap.spawnTable = "SurvivorCache1";
stashMap:addStamp("House", nil, 11608, 6778, 0.129,0.129,0.129)

local stashMap = StashUtil.newStash("WpStashMap8", "Map", "Base.WestpointMap", "Stash_AnnotedMap");
stashMap.spawnOnlyOnZed = true;
stashMap.zombies = 3;
stashMap.barricades = 40;
stashMap.buildingX = 11507
stashMap.buildingY = 6800
stashMap.spawnTable = "SurvivorCache1";
stashMap:addStamp("House", nil, 11507, 6801, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_WpMap8_Text1", 11517, 6792, 0.129,0.129,0.129)
--stashMap:addStamp("Lightning", nil, 12070, 6762, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_WpMap8_Text2", 12078, 6751, 0.129,0.129,0.129)
stashMap:addStamp("Exclamation", nil, 11608, 6778, 0.65, 0.054, 0.054)
stashMap:addStamp(nil, "Stash_WpMap8_Text3", 11616, 6767, 0.65, 0.054, 0.054)

-- danger houses
local stashMap = StashUtil.newStash("WpStashMap9", "Map", "Base.WestpointMap", "Stash_AnnotedMap");
stashMap.spawnOnlyOnZed = true;
stashMap.zombies = 20;
stashMap.barricades = 40;
stashMap.buildingX = 11656
stashMap.buildingY = 6816
stashMap.spawnTable = "SurvivorCache2";
stashMap:addStamp("Skull", nil, 11655, 6816, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_WpMap9_Text1", 11665, 6805, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_WpMap9_Text2", 11976, 6875, 0.129,0.129,0.129)
stashMap:addStamp("Question", nil, 11784, 6842, 0.65, 0.054, 0.054)
stashMap:addStamp(nil, "Stash_WpMap9_Text3", 11795, 6832, 0.65, 0.054, 0.054)

local stashMap = StashUtil.newStash("WpStashMap10", "Map", "Base.WestpointMap", "Stash_AnnotedMap");
stashMap.spawnOnlyOnZed = true;
stashMap.barricades = 30;
stashMap.buildingX = 11645
stashMap.buildingY = 6694
stashMap.spawnTable = "SurvivorCache2";
stashMap:addStamp("Skull", nil, 11645, 6693, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_WpMap10_Text1", 11655, 6686, 0.129,0.129,0.129)
--stashMap:addStamp("X", nil, 11958, 6914, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_WpMap10_Text2", 11967, 6906, 0.129,0.129,0.129)
stashMap:addStamp("Exclamation", nil, 11707, 6768, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_WpMap10_Text3", 11720, 6758, 0.129,0.129,0.129)

local stashMap = StashUtil.newStash("WpStashMap12", "Map", "Base.WestpointMap", "Stash_AnnotedMap");
stashMap.barricades = 80;
stashMap.zombies = 10;
stashMap.buildingX = 11981
stashMap.buildingY = 6943
stashMap.spawnTable = "SurvivorCache2";
stashMap:addStamp("Skull", nil, 11981, 6942, 0.65, 0.054, 0.054)
stashMap:addStamp(nil, "Stash_WpMap12_Text1", 11992, 6932, 0.65, 0.054, 0.054)
stashMap:addStamp(nil, "Stash_WpMap12_Text11", 11992, 6951, 0.65, 0.054, 0.054)
stashMap:addStamp("X", nil, 12068, 6761, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_WpMap12_Text2", 12079, 6751, 0.129,0.129,0.129)
stashMap:addStamp("X", nil, 11919, 6835, 0.65, 0.054, 0.054)
stashMap:addStamp(nil, "Stash_WpMap12_Text3", 11930, 6827, 0.65, 0.054, 0.054)

-- gun/weapon cache
local stashMap = StashUtil.newStash("WpStashMap13", "Map", "Base.WestpointMap", "Stash_AnnotedMap")
stashMap.buildingX = 10890
stashMap.buildingY = 6743
stashMap:addStamp("Gun", nil, 10889, 6743, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_WpMap13_Text1", 10836, 6749, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_WpMap13_Text2", 10836, 6772, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_WpMap13_Text3", 10837, 6793, 0.129,0.129,0.129)
stashMap.spawnTable = "GunCache1"
stashMap:addContainer("GunBox", nil, "Base.Bag_DuffelBagTINT", nil, nil, nil, nil)

-- food cache
local stashMap = StashUtil.newStash("WpStashMap14", "Map", "Base.WestpointMap", "Stash_AnnotedMap")
stashMap.buildingX = 11288
stashMap.buildingY = 6583
stashMap:addStamp("Boat", nil, 11288, 6571, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_WpMap14_Text1", 11297, 6562, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_WpMap14_Text11", 11296, 6587, 0.129,0.129,0.129)
stashMap.spawnTable = "FoodCache1"
stashMap:addContainer("FoodBox", "carpentry_01_16", nil, nil, 11286, 6580, 0)

-- survivor house
local stashMap = StashUtil.newStash("WpStashMap15", "Map", "Base.WestpointMap", "Stash_AnnotedMap")
stashMap.buildingX = 12058
stashMap.buildingY = 7368
stashMap:addStamp("Star", nil, 12058, 7367, 0.156, 0.188, 0.49)
stashMap:addStamp(nil, "Stash_WpMap15_Text1", 12078, 7344, 0.156, 0.188, 0.49)
stashMap:addStamp(nil, "Stash_WpMap15_Text11", 12078, 7370, 0.156, 0.188, 0.49)
stashMap.barricades = 80
stashMap.spawnTable = "SurvivorCache1"

-- survivor house
local stashMap = StashUtil.newStash("WpStashMap16", "Map", "Base.WestpointMap", "Stash_AnnotedMap")
stashMap.buildingX = 11135
stashMap.buildingY = 6854
stashMap:addStamp("ArrowEast", nil, 11118, 6860, 0.129,0.129,0.129)
stashMap:addStamp("ArrowNorth", nil, 11131, 6871, 0.129,0.129,0.129)
stashMap:addStamp("ArrowEast", nil, 11149, 6852, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_WpMap16_Text1", 11032, 6866, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_WpMap16_Text2", 11164, 6843, 0.129,0.129,0.129)
stashMap:addStamp("ArrowSouth", nil, 11187, 6874, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_WpMap16_Text21", 11161, 6881, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_WpMap16_Text3", 11079, 6910, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_WpMap16_Text31", 11103, 6931, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_WpMap16_Text32", 11103, 6954, 0.129,0.129,0.129)
stashMap:addStamp(nil, "Stash_WpMap16_Text4", 11077, 6987, 0.129,0.129,0.129)
stashMap.barricades = 80
stashMap.spawnTable = "SurvivorCache1"


