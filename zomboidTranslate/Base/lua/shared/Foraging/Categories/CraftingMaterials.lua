--[[---------------------------------------------
-------------------------------------------------
--
-- generateCraftingMaterialDefs
--
-- eris
--
-------------------------------------------------
--]]---------------------------------------------

require "Foraging/forageDefinitions";

local function generateCraftingMaterialDefs()
	-- "Bottleneck" and tool type items for crafting
	-- These are dual category items to allow for higher spawn rates
	local craftingTools = {
		--crafting tools which can be found anywhere, mostly in towns
		generic = {
			chance = 10,
			xp = 20,
			categories = { "Junk", "CraftingMaterials" },
			items = {
				--FleshingTool            = "Base.FleshingTool",
				--IronBandSmall           = "Base.IronBandSaw",
				Awl                     = "Base.Awl",
				CarpentryChisel         = "Base.CarpentryChisel",
				CrudeWhetstone          = "Base.CrudeWhetstone",
				File                    = "Base.File",
				HandDrill               = "Base.HandDrill",
				Handiknife              = "Base.Handiknife",
				HeadingTool             = "Base.HeadingTool",
				IronBand                = "Base.IronBand",
				KnappingTool            = "Base.KnappingTool",
				MasonsChisel            = "Base.MasonsChisel",
				MasonsTrowel            = "Base.MasonsTrowel",
				MetalworkingChisel      = "Base.MetalworkingChisel",
				MetalworkingPunch       = "Base.MetalworkingPunch",
				Multitool               = "Base.Multitool",
				OldDrill                = "Base.OldDrill",
				SheetMetalSnips         = "Base.SheetMetalSnips",
				SmallFileSet            = "Base.SmallFileSet",
				SmallPunchSet           = "Base.SmallPunchSet",
				StoneDrill              = "Base.StoneDrill",
				ViseGrips               = "Base.ViseGrips",
				Whetstone               = "Base.Whetstone",
			},
		},
	};
	for _, spawnTable in pairs(craftingTools) do
		for itemName, itemFullName in pairs(spawnTable.items) do
			forageDefs[itemName] = {
				type = itemFullName,
				skill = 0,
				xp = spawnTable.xp,
				categories = spawnTable.categories,
				zones = {
					Forest      	= spawnTable.chance,
					DeepForest  	= spawnTable.chance,
					PHForest  		= spawnTable.chance,
					PRForest  		= spawnTable.chance,
					BirchForest  	= spawnTable.chance,
					OrganicForest  	= spawnTable.chance,
					Vegitation  	= spawnTable.chance,
					FarmLand    	= spawnTable.chance,
					TrailerPark 	= spawnTable.chance,
					TownZone    	= spawnTable.chance,
					ForagingNav 	= spawnTable.chance,
				},
				spawnFuncs = { forageSystem.doGenericItemSpawn },
				forceOutside = false,
				canBeAboveFloor = true,
				itemSizeModifier = 0.5,
				isItemOverrideSize = true,
			};
		end;
	end;
end

generateCraftingMaterialDefs();