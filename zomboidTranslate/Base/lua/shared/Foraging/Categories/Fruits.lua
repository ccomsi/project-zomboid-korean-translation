--[[---------------------------------------------
-------------------------------------------------
--
-- generateFruitsDefs
--
-- eris
--
-------------------------------------------------
--]]---------------------------------------------

require "Foraging/forageDefinitions";

local function generateFruitsDefs()
	local itemDefs = {
		Cherry = {
			type = "Base.Cherry",
			minCount = 1,
			maxCount = 4,
			skill = 4,
			xp = 5,
			snowChance = -10,
			categories = { "Fruits" },
			zones = {
				Forest      	= 5,
				PHForest      	= 5,
				PRForest      	= 5,
				DeepForest  	= 5,
				FarmLand    	= 15,
			},
			months = { 5, 6, 7, 8, 9 },
			bonusMonths = { 6, 7, 8 },
			malusMonths = { 5, 9 },
			spawnFuncs = { forageSystem.doWildFoodSpawn, forageSystem.doRandomAgeSpawn },
			altWorldTexture = forageSystem.worldSprites.smallTrees,
			itemSizeModifier = 1.0,
			isItemOverrideSize = true,
		},
		Strewberrie = {
			type = "Base.Strewberrie",
			skill = 8,
			xp = 5,
			snowChance = -10,
			categories = { "Fruits" },
			zones = {
				Forest      	= 5,
				PHForest      	= 5,
				PRForest      	= 5,
				DeepForest  	= 5,
				FarmLand    	= 15,
			},
			months = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
			bonusMonths = { 4, 5, 6 },
			malusMonths = { 1, 2, 10, 11 },
			spawnFuncs = { forageSystem.doWildFoodSpawn, forageSystem.doRandomAgeSpawn, forageSystem.doWildCropSpawn },
			altWorldTexture = getTexture("media/textures/Foraging/worldSprites/wildstrawberry_worldSprite.png"),
			itemSizeModifier = 1.0,
			isItemOverrideSize = true,
		},
		Lemon = {
			type = "Base.Lemon",
			minCount = 1,
			maxCount = 3,
			skill = 6,
			xp = 5,
			snowChance = -10,
			categories = { "Fruits" },
			zones = {
				Forest      	= 10,
				PHForest      	= 5,
				PRForest      	= 5,
				FarmLand    	= 15,
			},
			bonusMonths = { 1, 2, 12 },
			malusMonths = { 3, 4, 10, 11 },
			spawnFuncs = { forageSystem.doWildFoodSpawn, forageSystem.doRandomAgeSpawn },
			altWorldTexture = forageSystem.worldSprites.smallTrees,
			itemSizeModifier = 1.0,
			isItemOverrideSize = true,
		},
		Lime = {
			type = "Base.Lime",
			minCount = 1,
			maxCount = 3,
			skill = 6,
			xp = 5,
			snowChance = -10,
			categories = { "Fruits" },
			zones = {
				Forest      	= 10,
				PHForest      	= 5,
				PRForest      	= 5,
				FarmLand    	= 15,
			},
			bonusMonths = { 1, 2, 12 },
			malusMonths = { 3, 4, 10, 11 },
			spawnFuncs = { forageSystem.doWildFoodSpawn, forageSystem.doRandomAgeSpawn },
			altWorldTexture = forageSystem.worldSprites.smallTrees,
			itemSizeModifier = 1.0,
			isItemOverrideSize = true,
		},
		Grapefruit = {
			type = "Base.Grapefruit",
			minCount = 1,
			maxCount = 1,
			skill = 8,
			xp = 5,
			snowChance = -10,
			categories = { "Fruits" },
			zones = {
				Forest      	= 10,
				PHForest      	= 5,
				PRForest      	= 5,
				FarmLand    	= 15,
			},
			bonusMonths = { 1, 2, 12 },
			malusMonths = { 3, 4, 10, 11 },
			spawnFuncs = { forageSystem.doWildFoodSpawn, forageSystem.doRandomAgeSpawn },
			altWorldTexture = forageSystem.worldSprites.smallTrees,
			itemSizeModifier = 1.0,
			isItemOverrideSize = true,
		},
		Peach = {
			type = "Base.Peach",
			minCount = 1,
			maxCount = 2,
			skill = 8,
			xp = 5,
			snowChance = -10,
			categories = { "Fruits" },
			zones = {
				Forest      	= 10,
				PHForest      	= 5,
				PRForest      	= 5,
				FarmLand    	= 15,
			},
			months = { 4, 5, 6, 7, 8, 9, 10 },
			bonusMonths = { 6, 7, 8 },
			malusMonths = { 4, 5, 9, 10 },
			spawnFuncs = { forageSystem.doWildFoodSpawn, forageSystem.doRandomAgeSpawn },
			altWorldTexture = forageSystem.worldSprites.smallTrees,
			itemSizeModifier = 1.0,
			isItemOverrideSize = true,
		},
		Pear = {
			type = "Base.Pear",
			minCount = 1,
			maxCount = 2,
			skill = 8,
			xp = 5,
			snowChance = -10,
			categories = { "Fruits" },
			zones = {
				Forest      	= 10,
				PHForest      	= 5,
				PRForest      	= 5,
				FarmLand    	= 15,
			},
			months = { 7, 8, 9, 10 },
			bonusMonths = { 8, 9 },
			malusMonths = { 7, 10 },
			spawnFuncs = { forageSystem.doWildFoodSpawn, forageSystem.doRandomAgeSpawn },
			altWorldTexture = forageSystem.worldSprites.smallTrees,
			itemSizeModifier = 1.0,
			isItemOverrideSize = true,
		},
		PepperHabanero = {
			type = "Base.PepperHabanero",
			minCount = 1,
			maxCount = 4,
			skill = 6,
			xp = 5,
			snowChance = -10,
			categories = { "Fruits" },
			zones = {
				Forest      	= 10,
				PHForest      	= 5,
				PRForest      	= 5,
				FarmLand    	= 15,
			},
			months = { 6, 7, 8, 9, 10 },
			bonusMonths = { 7, 8, 9 },
			malusMonths = { 6, 10 },
			spawnFuncs = { forageSystem.doWildFoodSpawn, forageSystem.doRandomAgeSpawn, forageSystem.doWildCropSpawn },
			altWorldTexture = forageSystem.worldSprites.smallTrees,
			itemSizeModifier = 1.0,
			isItemOverrideSize = true,
		},
		PepperJalapeno = {
			type = "Base.PepperJalapeno",
			minCount = 1,
			maxCount = 4,
			skill = 6,
			xp = 5,
			snowChance = -10,
			categories = { "Fruits" },
			zones = {
				Forest      	= 10,
				PHForest      	= 5,
				PRForest      	= 5,
				FarmLand    	= 15,
			},
			months = { 6, 7, 8, 9, 10 },
			bonusMonths = { 7, 8, 9 },
			malusMonths = { 6, 10 },
			spawnFuncs = { forageSystem.doWildFoodSpawn, forageSystem.doRandomAgeSpawn, forageSystem.doWildCropSpawn },
			altWorldTexture = forageSystem.worldSprites.smallTrees,
			itemSizeModifier = 1.0,
			isItemOverrideSize = true,
		},
		Pineapple = {
			type = "Base.Pineapple",
			skill = 10,
			xp = 15,
			snowChance = -10,
			categories = { "Fruits" },
			zones = {
				FarmLand    	= 3,
			},
			months = { 2, 3, 4, 5, 6, 7, 8 },
			bonusMonths = { 4, 5, 6 },
			malusMonths = { 2, 8 },
			spawnFuncs = { forageSystem.doWildFoodSpawn, forageSystem.doRandomAgeSpawn },
			altWorldTexture = forageSystem.worldSprites.vines,
		},
		Grapes = {
			type = "Base.Grapes",
			skill = 7,
			xp = 5,
			snowChance = -10,
			categories = { "Fruits" },
			zones = {
				Forest      	= 5,
				PHForest      	= 5,
				PRForest      	= 5,
				DeepForest  	= 5,
				FarmLand    	= 5,
			},
			months = { 6, 7, 8, 9, 10, 11, 12 },
			bonusMonths = { 8, 9, 10 },
			malusMonths = { 6, 12 },
			spawnFuncs = { forageSystem.doWildFoodSpawn, forageSystem.doRandomAgeSpawn },
			altWorldTexture = forageSystem.worldSprites.vines,
		},
		Orange = {
			type = "Base.Orange",
			minCount = 1,
			maxCount = 3,
			skill = 5,
			xp = 5,
			snowChance = -10,
			categories = { "Fruits" },
			zones = {
				Forest      	= 10,
				PHForest      	= 5,
				PRForest      	= 5,
				FarmLand    	= 15,
			},
			months = { 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
			bonusMonths = { 4, 5, 6, 7, 8, 9 },
			malusMonths = { 2, 11 },
			spawnFuncs = { forageSystem.doWildFoodSpawn, forageSystem.doRandomAgeSpawn },
			altWorldTexture = forageSystem.worldSprites.smallTrees,
			itemSizeModifier = 1.0,
			isItemOverrideSize = true,
		},
		Apple = {
			type = "Base.Apple",
			minCount = 1,
			maxCount = 3,
			skill = 7,
			xp = 5,
			snowChance = -10,
			categories = { "Fruits" },
			zones = {
				Forest      	= 10,
				PHForest      	= 5,
				PRForest      	= 5,
				FarmLand    	= 15,
			},
			months = { 5, 6, 7, 8, 9, 10, 11, 12 },
			bonusMonths = { 7, 8, 9, 10 },
			malusMonths = { 5, 12 },
			spawnFuncs = { forageSystem.doWildFoodSpawn, forageSystem.doRandomAgeSpawn },
			altWorldTexture = forageSystem.worldSprites.smallTrees,
			itemSizeModifier = 1.0,
			isItemOverrideSize = true,
		},
		Banana = {
			type = "Base.Banana",
			minCount = 1,
			maxCount = 1,
			skill = 9,
			xp = 15,
			snowChance = -100,
			categories = { "Fruits" },
			zones = {
				Forest      = 1,
				FarmLand    = 3,
			},
			bonusMonths = { 3, 4, 5, 6, 7, 8, 9, 10 },
			malusMonths = { 1, 2, 11, 12 },
			spawnFuncs = { forageSystem.doWildFoodSpawn, forageSystem.doRandomAgeSpawn },
			altWorldTexture = forageSystem.worldSprites.smallTrees,
			itemSizeModifier = 1.0,
			isItemOverrideSize = true,
		},
		Watermelon = {
			type = "Base.Watermelon",
			skill = 10,
			xp = 15,
			snowChance = -20,
			categories = { "Fruits" },
			zones = {
				Forest      	= 1,
				FarmLand    	= 3,
			},
			months = { 5, 6, 7, 8, 9, 10, 11, 12 },
			bonusMonths = { 7, 8, 9, 10 },
			malusMonths = { 5, 12 },
			spawnFuncs = { forageSystem.doWildFoodSpawn, forageSystem.doRandomAgeSpawn, forageSystem.doWildCropSpawn },
			altWorldTexture = forageSystem.worldSprites.vines,
		},
		Mango = {
			type = "Base.Mango",
			skill = 7,
			xp = 15,
			snowChance = -30,
			categories = { "Fruits" },
			zones = {
				Forest      	= 3,
				PHForest      	= 5,
				PRForest      	= 5,
				DeepForest  	= 3,
				Vegitation  	= 3,
				FarmLand    	= 3,
			},
			months = { 9, 10, 11 },
			bonusMonths = { 10 },
			malusMonths = { 11 },
			spawnFuncs = { forageSystem.doWildFoodSpawn, forageSystem.doRandomAgeSpawn },
			altWorldTexture = forageSystem.worldSprites.smallTrees,
		},
	};
	for itemName, itemDef in pairs(itemDefs) do
		forageDefs[itemName] = itemDef;
	end;
end

generateFruitsDefs();