--[[---------------------------------------------
-------------------------------------------------
--
-- generateArtifactDefs
--
-- eris
--
-------------------------------------------------
--]]---------------------------------------------

require "Foraging/forageDefinitions";

local function generateArtifactDefs()
	local artifacts = {
		stoneArtifacts = {
			chance = 1,
			xp = 20,
			categories = { "Artifacts" },
			items = {
				Awl_Stone              	= "Base.Awl_Stone",
				PrimitiveScythe        	= "Base.PrimitiveScythe",
				Saw_Flint        		= "Base.Saw_Flint",
				StoneAxeHead            = "Base.StoneAxeHead",
				StoneBlade             	= "Base.StoneBlade",
				StoneBladeLong        	= "Base.StoneBladeLong",
				StoneChisel             = "Base.StoneChisel",
				StoneDrill           	= "Base.StoneDrill",
				StoneMaulHead           = "Base.StoneMaulHead",
			},
		},
		boneArtifacts = {
			chance = 1,
			xp = 20,
			categories = { "Artifacts" },
			items = {
				SharpBoneFragment       = "Base.SharpBoneFragment",
				Awl_Bone        		= "Base.Awl_Bone",
				SharpBone_Long     		= "Base.SharpBone_Long",
				BoneBead_Large          = "Base.BoneBead_Large",
				HatchetHead_Bone       	= "Base.HatchetHead_Bone",
				Needle_Bone	        	= "Base.Needle_Bone",
				FishingHook_Bone        = "Base.FishingHook_Bone",
			},
		},
	};
	for _, spawnTable in pairs(artifacts) do
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

generateArtifactDefs();