--[[---------------------------------------------
-------------------------------------------------
--
-- generateClothingDefs
--
-- eris
--
-------------------------------------------------
--]]---------------------------------------------

require "Foraging/forageDefinitions";

local function generateClothingDefs()
	local clothing = {
		common = {
			chance = 5,
			xp = 5,
			items = {
				["Hat_Antlers"] = "Base.Hat_Antlers",
				["Hat_Army"] = "Base.Hat_Army",
				["Hat_BalaclavaFace"] = "Base.Hat_BalaclavaFace",
				["Hat_BalaclavaFull"] = "Base.Hat_BalaclavaFull",
				["Hat_Bandana"] = "Base.Hat_Bandana",
				["Hat_BandanaMask"] = "Base.Hat_BandanaMask",
				["Hat_BandanaMaskTINT"] = "Base.Hat_BandanaMaskTINT",
				["Hat_BandanaTINT"] = "Base.Hat_BandanaTINT",
				["Hat_BandanaTied"] = "Base.Hat_BandanaTied",
				["Hat_BandanaTiedTINT"] = "Base.Hat_BandanaTiedTINT",
				["Hat_BaseballCap"] = "Base.Hat_BaseballCap",
				["Hat_BaseballCapArmy"] = "Base.Hat_BaseballCapArmy",
				["Hat_BaseballCapArmy_Reverse"] = "Base.Hat_BaseballCapArmy_Reverse",
				["Hat_BaseballCapBlue"] = "Base.Hat_BaseballCapBlue",
				["Hat_BaseballCapBlue_Reverse"] = "Base.Hat_BaseballCapBlue_Reverse",
				["Hat_BaseballCapGreen"] = "Base.Hat_BaseballCapGreen",
				["Hat_BaseballCapGreen_Reverse"] = "Base.Hat_BaseballCapGreen_Reverse",
				["Hat_BaseballCapKY"] = "Base.Hat_BaseballCapKY",
				["Hat_BaseballCapKY_Red"] = "Base.Hat_BaseballCapKY_Red",
				["Hat_BaseballCapKY_Reverse"] = "Base.Hat_BaseballCapKY_Reverse",
				["Hat_BaseballCapRed"] = "Base.Hat_BaseballCapRed",
				["Hat_BaseballCapRed_Reverse"] = "Base.Hat_BaseballCapRed_Reverse",
				["Hat_BaseballCap_Reverse"] = "Base.Hat_BaseballCap_Reverse",
				["Hat_BaseballHelmet_KY"] = "Base.Hat_BaseballHelmet_KY",
				["Hat_BaseballHelmet_Rangers"] = "Base.Hat_BaseballHelmet_Rangers",
				["Hat_BaseballHelmet_Z"] = "Base.Hat_BaseballHelmet_Z",
				["Hat_Beany"] = "Base.Hat_Beany",
				["Hat_Beret"] = "Base.Hat_Beret",
				["Hat_BeretArmy"] = "Base.Hat_BeretArmy",
				["Hat_BicycleHelmet"] = "Base.Hat_BicycleHelmet",
				["Hat_BonnieHat"] = "Base.Hat_BonnieHat",
				["Hat_BonnieHat_CamoGreen"] = "Base.Hat_BonnieHat_CamoGreen",
				["Hat_BoxingBlue"] = "Base.Hat_BoxingBlue",
				["Hat_BoxingRed"] = "Base.Hat_BoxingRed",
				["Hat_BucketHat"] = "Base.Hat_BucketHat",
				["Hat_BunnyEarsBlack"] = "Base.Hat_BunnyEarsBlack",
				["Hat_BunnyEarsWhite"] = "Base.Hat_BunnyEarsWhite",
				["Hat_ChefHat"] = "Base.Hat_ChefHat",
				["Hat_Cowboy"] = "Base.Hat_Cowboy",
				["Hat_CrashHelmet"] = "Base.Hat_CrashHelmet",
				["Hat_CrashHelmetFULL"] = "Base.Hat_CrashHelmetFULL",
				["Hat_CrashHelmet_Police"] = "Base.Hat_CrashHelmet_Police",
				["Hat_CrashHelmet_Stars"] = "Base.Hat_CrashHelmet_Stars",
				["Hat_DustMask"] = "Base.Hat_DustMask",
				["Hat_EarMuff_Protectors"] = "Base.Hat_EarMuff_Protectors",
				["Hat_EarMuffs"] = "Base.Hat_EarMuffs",
				["Hat_FastFood"] = "Base.Hat_FastFood",
				["Hat_FastFood_IceCream"] = "Base.Hat_FastFood_IceCream",
				["Hat_FastFood_Spiffo"] = "Base.Hat_FastFood_Spiffo",
				["Hat_Fedora"] = "Base.Hat_Fedora",
				["Hat_Fedora_Delmonte"] = "Base.Hat_Fedora_Delmonte",
				["Hat_Fireman"] = "Base.Hat_Fireman",
				["Hat_FootballHelmet"] = "Base.Hat_FootballHelmet",
				["Hat_FurryEars"] = "Base.Hat_FurryEars",
				["Hat_GasMask"] = "Base.Hat_GasMask",
				["Hat_GoldStar"] = "Base.Hat_GoldStar",
				["Hat_GolfHat"] = "Base.Hat_GolfHat",
				["Hat_GolfHatTINT"] = "Base.Hat_GolfHatTINT",
				["Hat_HardHat"] = "Base.Hat_HardHat",
				["Hat_HardHat_Miner"] = "Base.Hat_HardHat_Miner",
				["Hat_HockeyHelmet"] = "Base.Hat_HockeyHelmet",
				["Hat_HockeyMask"] = "Base.Hat_HockeyMask",
				["Hat_Jay"] = "Base.Hat_Jay",
				["Hat_JockeyHelmet01"] = "Base.Hat_JockeyHelmet01",
				["Hat_JockeyHelmet02"] = "Base.Hat_JockeyHelmet02",
				["Hat_JockeyHelmet03"] = "Base.Hat_JockeyHelmet03",
				["Hat_JockeyHelmet04"] = "Base.Hat_JockeyHelmet04",
				["Hat_JockeyHelmet05"] = "Base.Hat_JockeyHelmet05",
				["Hat_JockeyHelmet06"] = "Base.Hat_JockeyHelmet06",
				["Hat_JokeArrow"] = "Base.Hat_JokeArrow",
				["Hat_JokeKnife"] = "Base.Hat_JokeKnife",
				["Hat_NBCmask"] = "Base.Hat_NBCmask",
				["Hat_NewspaperHat"] = "Base.Hat_NewspaperHat",
				["Hat_PartyHat_Stars"] = "Base.Hat_PartyHat_Stars",
				["Hat_PartyHat_TINT"] = "Base.Hat_PartyHat_TINT",
				["Hat_PeakedCapArmy"] = "Base.Hat_PeakedCapArmy",
				["Hat_Police"] = "Base.Hat_Police",
				["Hat_Police_Grey"] = "Base.Hat_Police_Grey",
				["Hat_Raccoon"] = "Base.Hat_Raccoon",
				["Hat_Ranger"] = "Base.Hat_Ranger",
				["Hat_RidingHelmet"] = "Base.Hat_RidingHelmet",
				["Hat_RiotHelmet"] = "Base.Hat_RiotHelmet",
				["Hat_SPHhelmet"] = "Base.Hat_SPHhelmet",
				["Hat_SantaHat"] = "Base.Hat_SantaHat",
				["Hat_SantaHatGreen"] = "Base.Hat_SantaHatGreen",
				["Hat_ShowerCap"] = "Base.Hat_ShowerCap",
				["Hat_Spiffo"] = "Base.Hat_Spiffo",
				["Hat_SummerHat"] = "Base.Hat_SummerHat",
				["Hat_SurgicalCap"] = "Base.Hat_SurgicalCap",
-- 				["Hat_SurgicalCap_Blue"] = "Base.Hat_SurgicalCap_Blue", -- replaced by a single item with randomized color
-- 				["Hat_SurgicalCap_Green"] = "Base.Hat_SurgicalCap_Green",
				["Hat_SurgicalMask"] = "Base.Hat_SurgicalMask",
-- 				["Hat_SurgicalMask_Blue"] = "Base.Hat_SurgicalMask_Blue", -- replaced by a single item with randomized color
-- 				["Hat_SurgicalMask_Green"] = "Base.Hat_SurgicalMask_Green",
				["Hat_Sweatband"] = "Base.Hat_Sweatband",
				["Hat_TinFoilHat"] = "Base.Hat_TinFoilHat",
				["Hat_VisorBlack"] = "Base.Hat_VisorBlack",
				["Hat_VisorRed"] = "Base.Hat_VisorRed",
				["Hat_Visor_WhiteTINT"] = "Base.Hat_Visor_WhiteTINT",
				["Hat_WeddingVeil"] = "Base.Hat_WeddingVeil",
				["Hat_WinterHat"] = "Base.Hat_WinterHat",
				["Hat_WoolyHat"] = "Base.Hat_WoolyHat",
				["WeldingMask"] = "Base.WeldingMask",
			},
		},
		uncommon = {
			chance = 3,
			xp = 5,
			items = {
				["Apron_Black"] = "Base.Apron_Black",
				["Apron_IceCream"] = "Base.Apron_IceCream",
				["Apron_Jay"] = "Base.Apron_Jay",
				["Apron_PileOCrepe"] = "Base.Apron_PileOCrepe",
				["Apron_PizzaWhirled"] = "Base.Apron_PizzaWhirled",
				["Apron_Spiffos"] = "Base.Apron_Spiffos",
				["Apron_White"] = "Base.Apron_White",
				["Apron_WhiteTEXTURE"] = "Base.Apron_WhiteTEXTURE",
				["Bikini_Pattern01"] = "Base.Bikini_Pattern01",
				["Bikini_TINT"] = "Base.Bikini_TINT",
				["Boilersuit"] = "Base.Boilersuit",
				["Boilersuit_BlueRed"] = "Base.Boilersuit_BlueRed",
				["Boilersuit_Flying"] = "Base.Boilersuit_Flying",
				["Boilersuit_Prisoner"] = "Base.Boilersuit_Prisoner",
				["Boilersuit_PrisonerKhaki"] = "Base.Boilersuit_PrisonerKhaki",
				["Boilersuit_Yellow"] = "Base.Boilersuit_Yellow",
				["BoobTube"] = "Base.BoobTube",
				["BoobTubeSmall"] = "Base.BoobTubeSmall",
				["Boxers_Hearts"] = "Base.Boxers_Hearts",
				["Boxers_RedStripes"] = "Base.Boxers_RedStripes",
				["Boxers_Silk_Black"] = "Base.Boxers_Silk_Black",
				["Boxers_Silk_Red"] = "Base.Boxers_Silk_Red",
				["Boxers_White"] = "Base.Boxers_White",
				["Bra_Strapless_AnimalPrint"] = "Base.Bra_Strapless_AnimalPrint",
				["Bra_Strapless_Black"] = "Base.Bra_Strapless_Black",
				["Bra_Strapless_FrillyBlack"] = "Base.Bra_Strapless_FrillyBlack",
				["Bra_Strapless_FrillyPink"] = "Base.Bra_Strapless_FrillyPink",
				["Bra_Strapless_FrillyRed"] = "Base.Bra_Strapless_FrillyRed",
				["Bra_Strapless_RedSpots"] = "Base.Bra_Strapless_RedSpots",
				["Bra_Strapless_White"] = "Base.Bra_Strapless_White",
				["Bra_Straps_AnimalPrint"] = "Base.Bra_Straps_AnimalPrint",
				["Bra_Straps_Black"] = "Base.Bra_Straps_Black",
				["Bra_Straps_FrillyBlack"] = "Base.Bra_Straps_FrillyBlack",
				["Bra_Straps_FrillyPink"] = "Base.Bra_Straps_FrillyPink",
				["Bra_Straps_FrillyRed"] = "Base.Bra_Straps_FrillyRed",
				["Bra_Straps_White"] = "Base.Bra_Straps_White",
				["Briefs_AnimalPrints"] = "Base.Briefs_AnimalPrints",
				["Briefs_SmallTrunks_Black"] = "Base.Briefs_SmallTrunks_Black",
				["Briefs_SmallTrunks_Blue"] = "Base.Briefs_SmallTrunks_Blue",
				["Briefs_SmallTrunks_Red"] = "Base.Briefs_SmallTrunks_Red",
				["Briefs_SmallTrunks_WhiteTINT"] = "Base.Briefs_SmallTrunks_WhiteTINT",
				["Briefs_White"] = "Base.Briefs_White",
				["Corset"] = "Base.Corset",
				["Corset_Black"] = "Base.Corset_Black",
				["Corset_Medical"] = "Base.Corset_Medical",
				["Corset_Red"] = "Base.Corset_Red",
				["DressKnees_Straps"] = "Base.DressKnees_Straps",
				["Dress_Knees"] = "Base.Dress_Knees",
				["Dress_Long"] = "Base.Dress_Long",
				["Dress_Normal"] = "Base.Dress_Normal",
				["Dress_SatinNegligee"] = "Base.Dress_SatinNegligee",
				["Dress_Short"] = "Base.Dress_Short",
				["Dress_SmallBlackStrapless"] = "Base.Dress_SmallBlackStrapless",
				["Dress_SmallBlackStraps"] = "Base.Dress_SmallBlackStraps",
				["Dress_SmallStrapless"] = "Base.Dress_SmallStrapless",
				["Dress_SmallStraps"] = "Base.Dress_SmallStraps",
				["Dress_Straps"] = "Base.Dress_Straps",
				["Dress_long_Straps"] = "Base.Dress_long_Straps",
				["Dungarees"] = "Base.Dungarees",
				["FrillyUnderpants_Black"] = "Base.FrillyUnderpants_Black",
				["FrillyUnderpants_Pink"] = "Base.FrillyUnderpants_Pink",
				["FrillyUnderpants_Red"] = "Base.FrillyUnderpants_Red",
				["Garter"] = "Base.Garter",
				["Ghillie_Top"] = "Base.Ghillie_Top",
				["Ghillie_Trousers"] = "Base.Ghillie_Trousers",
				["Glasses"] = "Base.Glasses",
				["Glasses_Aviators"] = "Base.Glasses_Aviators",
				["Glasses_Eyepatch_Left"] = "Base.Glasses_Eyepatch_Left",
				["Glasses_Eyepatch_Right"] = "Base.Glasses_Eyepatch_Right",
				["Glasses_Normal"] = "Base.Glasses_Normal",
				["Glasses_Reading"] = "Base.Glasses_Reading",
				["Glasses_SafetyGoggles"] = "Base.Glasses_SafetyGoggles",
				["Glasses_Shooting"] = "Base.Glasses_Shooting",
				["Glasses_SkiGoggles"] = "Base.Glasses_SkiGoggles",
				["Glasses_Sun"] = "Base.Glasses_Sun",
				["Glasses_SwimmingGoggles"] = "Base.Glasses_SwimmingGoggles",
				["Gloves_BoxingBlue"] = "Base.Gloves_BoxingBlue",
				["Gloves_BoxingRed"] = "Base.Gloves_BoxingRed",
				["Gloves_FingerlessGloves"] = "Base.Gloves_FingerlessGloves",
				["Gloves_LeatherGloves"] = "Base.Gloves_LeatherGloves",
				["Gloves_LeatherGlovesBlack"] = "Base.Gloves_LeatherGlovesBlack",
				["Gloves_LongWomenGloves"] = "Base.Gloves_LongWomenGloves",
				["Gloves_Surgical"] = "Base.Gloves_Surgical",
				["Gloves_WhiteTINT"] = "Base.Gloves_WhiteTINT",
				["HazmatSuit"] = "Base.HazmatSuit",
				["HoodieDOWN_WhiteTINT"] = "Base.HoodieDOWN_WhiteTINT",
				["HoodieUP_WhiteTINT"] = "Base.HoodieUP_WhiteTINT",
				["HospitalGown"] = "Base.HospitalGown",
				["JacketLong_Doctor"] = "Base.JacketLong_Doctor",
				["JacketLong_Random"] = "Base.JacketLong_Random",
				["JacketLong_Santa"] = "Base.JacketLong_Santa",
				["JacketLong_SantaGreen"] = "Base.JacketLong_SantaGreen",
				["Jacket_ArmyCamoDesert"] = "Base.Jacket_ArmyCamoDesert",
				["Jacket_ArmyCamoGreen"] = "Base.Jacket_ArmyCamoGreen",
				["Jacket_Black"] = "Base.Jacket_Black",
				["Jacket_Chef"] = "Base.Jacket_Chef",
				["Jacket_CoatArmy"] = "Base.Jacket_CoatArmy",
				["Jacket_Fireman"] = "Base.Jacket_Fireman",
				["Jacket_LeatherBarrelDogs"] = "Base.Jacket_LeatherBarrelDogs",
				["Jacket_LeatherIronRodent"] = "Base.Jacket_LeatherIronRodent",
				["Jacket_LeatherWildRacoons"] = "Base.Jacket_LeatherWildRacoons",
				["Jacket_NavyBlue"] = "Base.Jacket_NavyBlue",
				["Jacket_Padded"] = "Base.Jacket_Padded",
				["Jacket_PaddedDOWN"] = "Base.Jacket_PaddedDOWN",
				["Jacket_Police"] = "Base.Jacket_Police",
				["Jacket_Ranger"] = "Base.Jacket_Ranger",
				["Jacket_Shellsuit_Black"] = "Base.Jacket_Shellsuit_Black",
				["Jacket_Shellsuit_Blue"] = "Base.Jacket_Shellsuit_Blue",
				["Jacket_Shellsuit_Green"] = "Base.Jacket_Shellsuit_Green",
				["Jacket_Shellsuit_Pink"] = "Base.Jacket_Shellsuit_Pink",
				["Jacket_Shellsuit_TINT"] = "Base.Jacket_Shellsuit_TINT",
				["Jacket_Shellsuit_Teal"] = "Base.Jacket_Shellsuit_Teal",
				["Jacket_Varsity"] = "Base.Jacket_Varsity",
				["Jacket_WhiteTINT"] = "Base.Jacket_WhiteTINT",
				["Jumper_DiamondPatternTINT"] = "Base.Jumper_DiamondPatternTINT",
				["Jumper_PoloNeck"] = "Base.Jumper_PoloNeck",
				["Jumper_RoundNeck"] = "Base.Jumper_RoundNeck",
				["Jumper_TankTopDiamondTINT"] = "Base.Jumper_TankTopDiamondTINT",
				["Jumper_TankTopTINT"] = "Base.Jumper_TankTopTINT",
				["Jumper_VNeck"] = "Base.Jumper_VNeck",
				["LongCoat_Bathrobe"] = "Base.LongCoat_Bathrobe",
				["LongJohns"] = "Base.LongJohns",
				["LongJohns_Bottoms"] = "Base.LongJohns_Bottoms",
				--["Male_Undies"] = "Base.Male_Undies",
				["PonchoGreen"] = "Base.PonchoGreen",
				["PonchoGreenDOWN"] = "Base.PonchoGreenDOWN",
				["PonchoYellow"] = "Base.PonchoYellow",
				["PonchoYellowDOWN"] = "Base.PonchoYellowDOWN",
				["Scarf_StripeBlackWhite"] = "Base.Scarf_StripeBlackWhite",
				["Scarf_StripeBlueWhite"] = "Base.Scarf_StripeBlueWhite",
				["Scarf_StripeRedWhite"] = "Base.Scarf_StripeRedWhite",
				["Scarf_White"] = "Base.Scarf_White",
				["Shirt_Baseball_KY"] = "Base.Shirt_Baseball_KY",
				["Shirt_Baseball_Rangers"] = "Base.Shirt_Baseball_Rangers",
				["Shirt_Baseball_Z"] = "Base.Shirt_Baseball_Z",
				["Shirt_Bowling_Blue"] = "Base.Shirt_Bowling_Blue",
				["Shirt_Bowling_Brown"] = "Base.Shirt_Bowling_Brown",
				["Shirt_Bowling_Green"] = "Base.Shirt_Bowling_Green",
				["Shirt_Bowling_LimeGreen"] = "Base.Shirt_Bowling_LimeGreen",
				["Shirt_Bowling_Pink"] = "Base.Shirt_Bowling_Pink",
				["Shirt_Bowling_White"] = "Base.Shirt_Bowling_White",
				["Shirt_CamoDesert"] = "Base.Shirt_CamoDesert",
				["Shirt_CamoGreen"] = "Base.Shirt_CamoGreen",
				["Shirt_CamoUrban"] = "Base.Shirt_CamoUrban",
				["Shirt_CropTopNoArmTINT"] = "Base.Shirt_CropTopNoArmTINT",
				["Shirt_CropTopTINT"] = "Base.Shirt_CropTopTINT",
				["Shirt_Denim"] = "Base.Shirt_Denim",
				["Shirt_FormalTINT"] = "Base.Shirt_FormalTINT",
				["Shirt_FormalWhite"] = "Base.Shirt_FormalWhite",
				["Shirt_FormalWhite_ShortSleeve"] = "Base.Shirt_FormalWhite_ShortSleeve",
				["Shirt_FormalWhite_ShortSleeveTINT"] = "Base.Shirt_FormalWhite_ShortSleeveTINT",
				["Shirt_HawaiianRed"] = "Base.Shirt_HawaiianRed",
				["Shirt_HawaiianTINT"] = "Base.Shirt_HawaiianTINT",
				["Shirt_Jockey01"] = "Base.Shirt_Jockey01",
				["Shirt_Jockey02"] = "Base.Shirt_Jockey02",
				["Shirt_Jockey03"] = "Base.Shirt_Jockey03",
				["Shirt_Jockey04"] = "Base.Shirt_Jockey04",
				["Shirt_Jockey05"] = "Base.Shirt_Jockey05",
				["Shirt_Jockey06"] = "Base.Shirt_Jockey06",
				["Shirt_Lumberjack"] = "Base.Shirt_Lumberjack",
				["Shirt_OfficerWhite"] = "Base.Shirt_OfficerWhite",
				["Shirt_PoliceBlue"] = "Base.Shirt_PoliceBlue",
				["Shirt_PoliceGrey"] = "Base.Shirt_PoliceGrey",
				["Shirt_Priest"] = "Base.Shirt_Priest",
				["Shirt_PrisonGuard"] = "Base.Shirt_PrisonGuard",
				["Shirt_Ranger"] = "Base.Shirt_Ranger",
				["Shirt_Scrubs"] = "Base.Shirt_Scrubs",
				["Shirt_Workman"] = "Base.Shirt_Workman",
				["Shoes_ArmyBoots"] = "Base.Shoes_ArmyBoots",
				["Shoes_ArmyBootsDesert"] = "Base.Shoes_ArmyBootsDesert",
				["Shoes_Black"] = "Base.Shoes_Black",
				["Shoes_BlackBoots"] = "Base.Shoes_BlackBoots",
				["Shoes_BlueTrainers"] = "Base.Shoes_BlueTrainers",
				["Shoes_Bowling"] = "Base.Shoes_Bowling",
				["Shoes_Brown"] = "Base.Shoes_Brown",
				["Shoes_Fancy"] = "Base.Shoes_Fancy",
				["Shoes_FlipFlop"] = "Base.Shoes_FlipFlop",
				["Shoes_Random"] = "Base.Shoes_Random",
				["Shoes_RedTrainers"] = "Base.Shoes_RedTrainers",
				["Shoes_RidingBoots"] = "Base.Shoes_RidingBoots",
				["Shoes_Sandals"] = "Base.Shoes_Sandals",
				["Shoes_Slippers"] = "Base.Shoes_Slippers",
				["Shoes_Strapped"] = "Base.Shoes_Strapped",
				["Shoes_TrainerTINT"] = "Base.Shoes_TrainerTINT",
				["Shoes_Wellies"] = "Base.Shoes_Wellies",
				["Shorts_BoxingBlue"] = "Base.Shorts_BoxingBlue",
				["Shorts_BoxingRed"] = "Base.Shorts_BoxingRed",
				["Shorts_CamoGreenLong"] = "Base.Shorts_CamoGreenLong",
				["Shorts_CamoUrbanLong"] = "Base.Shorts_CamoUrbanLong",
				["Shorts_LongDenim"] = "Base.Shorts_LongDenim",
				["Shorts_LongSport"] = "Base.Shorts_LongSport",
				["Shorts_LongSport_Red"] = "Base.Shorts_LongSport_Red",
				["Shorts_ShortDenim"] = "Base.Shorts_ShortDenim",
				["Shorts_ShortFormal"] = "Base.Shorts_ShortFormal",
				["Shorts_ShortSport"] = "Base.Shorts_ShortSport",
				["Skirt_Knees"] = "Base.Skirt_Knees",
				["Skirt_Long"] = "Base.Skirt_Long",
				["Skirt_Mini"] = "Base.Skirt_Mini",
				["Skirt_Normal"] = "Base.Skirt_Normal",
				["Skirt_Short"] = "Base.Skirt_Short",
				["Socks_Ankle"] = "Base.Socks_Ankle",
				["Socks_Long"] = "Base.Socks_Long",
				["StockingsBlack"] = "Base.StockingsBlack",
				["StockingsBlackSemiTrans"] = "Base.StockingsBlackSemiTrans",
				["StockingsBlackTrans"] = "Base.StockingsBlackTrans",
				["StockingsWhite"] = "Base.StockingsWhite",
				["Suit_Jacket"] = "Base.Suit_Jacket",
				["Suit_JacketTINT"] = "Base.Suit_JacketTINT",
				["SwimTrunks_Blue"] = "Base.SwimTrunks_Blue",
				["SwimTrunks_Green"] = "Base.SwimTrunks_Green",
				["SwimTrunks_Red"] = "Base.SwimTrunks_Red",
				["SwimTrunks_Yellow"] = "Base.SwimTrunks_Yellow",
				["Swimsuit_TINT"] = "Base.Swimsuit_TINT",
				["Tie_BowTieFull"] = "Base.Tie_BowTieFull",
				["Tie_BowTieWorn"] = "Base.Tie_BowTieWorn",
				["Tie_Full"] = "Base.Tie_Full",
				["Tie_Worn"] = "Base.Tie_Worn",
				["Tie_Worn_Spiffo"] = "Base.Tie_Worn_Spiffo",
				["TightsBlack"] = "Base.TightsBlack",
				["TightsBlackSemiTrans"] = "Base.TightsBlackSemiTrans",
				["TightsBlackTrans"] = "Base.TightsBlackTrans",
				["TightsFishnets"] = "Base.TightsFishnets",
				["Trousers"] = "Base.Trousers",
				["TrousersMesh_DenimLig"] = "Base.TrousersMesh_DenimLight",
				["TrousersMesh_Leather"] = "Base.TrousersMesh_Leather",
				["Trousers_ArmyService"] = "Base.Trousers_ArmyService",
				["Trousers_Black"] = "Base.Trousers_Black",
				["Trousers_CamoDesert"] = "Base.Trousers_CamoDesert",
				["Trousers_CamoGreen"] = "Base.Trousers_CamoGreen",
				["Trousers_CamoUrban"] = "Base.Trousers_CamoUrban",
				["Trousers_Chef"] = "Base.Trousers_Chef",
				["Trousers_DefaultTEXTURE"] = "Base.Trousers_DefaultTEXTURE",
				["Trousers_DefaultTEXTURE_HUE"] = "Base.Trousers_DefaultTEXTURE_HUE",
				["Trousers_DefaultTEXTURE_TINT"] = "Base.Trousers_DefaultTEXTURE_TINT",
				["Trousers_Denim"] = "Base.Trousers_Denim",
				["Trousers_Fireman"] = "Base.Trousers_Fireman",
				["Trousers_JeanBaggy"] = "Base.Trousers_JeanBaggy",
				["Trousers_LeatherBlack"] = "Base.Trousers_LeatherBlack",
				["Trousers_NavyBlue"] = "Base.Trousers_NavyBlue",
				["Trousers_Padded"] = "Base.Trousers_Padded",
				["Trousers_Police"] = "Base.Trousers_Police",
				["Trousers_PoliceGrey"] = "Base.Trousers_PoliceGrey",
				["Trousers_PrisonGuard"] = "Base.Trousers_PrisonGuard",
				["Trousers_Ranger"] = "Base.Trousers_Ranger",
				["Trousers_Santa"] = "Base.Trousers_Santa",
				["Trousers_SantaGreen"] = "Base.Trousers_SantaGreen",
				["Trousers_Scrubs"] = "Base.Trousers_Scrubs",
				["Trousers_Shellsuit_Black"] = "Base.Trousers_Shellsuit_Black",
				["Trousers_Shellsuit_Blue"] = "Base.Trousers_Shellsuit_Blue",
				["Trousers_Shellsuit_Green"] = "Base.Trousers_Shellsuit_Green",
				["Trousers_Shellsuit_Pink"] = "Base.Trousers_Shellsuit_Pink",
				["Trousers_Shellsuit_TINT"] = "Base.Trousers_Shellsuit_TINT",
				["Trousers_Shellsuit_Teal"] = "Base.Trousers_Shellsuit_Teal",
				["Trousers_Suit"] = "Base.Trousers_Suit",
				["Trousers_SuitTEXTURE"] = "Base.Trousers_SuitTEXTURE",
				["Trousers_SuitWhite"] = "Base.Trousers_SuitWhite",
				["Trousers_WhiteTEXTURE"] = "Base.Trousers_WhiteTEXTURE",
				["Trousers_WhiteTINT"] = "Base.Trousers_WhiteTINT",
				["Tshirt_ArmyGreen"] = "Base.Tshirt_ArmyGreen",
				["Tshirt_BusinessSpiffo"] = "Base.Tshirt_BusinessSpiffo",
				["Tshirt_CamoDesert"] = "Base.Tshirt_CamoDesert",
				["Tshirt_CamoGreen"] = "Base.Tshirt_CamoGreen",
				["Tshirt_CamoUrban"] = "Base.Tshirt_CamoUrban",
				["Tshirt_DefaultDECAL"] = "Base.Tshirt_DefaultDECAL",
				["Tshirt_DefaultDECAL_TINT"] = "Base.Tshirt_DefaultDECAL_TINT",
				["Tshirt_DefaultTEXTURE"] = "Base.Tshirt_DefaultTEXTURE",
				["Tshirt_DefaultTEXTURE_TINT"] = "Base.Tshirt_DefaultTEXTURE_TINT",
				["Tshirt_Fossoil"] = "Base.Tshirt_Fossoil",
				["Tshirt_Gas2Go"] = "Base.Tshirt_Gas2Go",
				["Tshirt_IndieStoneDECAL"] = "Base.Tshirt_IndieStoneDECAL",
				["Tshirt_McCoys"] = "Base.Tshirt_McCoys",
				["Tshirt_PileOCrepe"] = "Base.Tshirt_PileOCrepe",
				["Tshirt_PizzaWhirled"] = "Base.Tshirt_PizzaWhirled",
				["Tshirt_PoliceBlue"] = "Base.Tshirt_PoliceBlue",
				["Tshirt_PoliceGrey"] = "Base.Tshirt_PoliceGrey",
				["Tshirt_PoloStripedTINT"] = "Base.Tshirt_PoloStripedTINT",
				["Tshirt_PoloTINT"] = "Base.Tshirt_PoloTINT",
				["Tshirt_Profession_FiremanBlue"] = "Base.Tshirt_Profession_FiremanBlue",
				["Tshirt_Profession_FiremanRed"] = "Base.Tshirt_Profession_FiremanRed",
				["Tshirt_Profession_FiremanRed02"] = "Base.Tshirt_Profession_FiremanRed02",
				["Tshirt_Profession_FiremanWhite"] = "Base.Tshirt_Profession_FiremanWhite",
				["Tshirt_Profession_PoliceBlue"] = "Base.Tshirt_Profession_PoliceBlue",
				["Tshirt_Profession_PoliceWhite"] = "Base.Tshirt_Profession_PoliceWhite",
				["Tshirt_Profession_RangerBrown"] = "Base.Tshirt_Profession_RangerBrown",
				["Tshirt_Profession_RangerGreen"] = "Base.Tshirt_Profession_RangerGreen",
				["Tshirt_Profession_VeterenGreen"] = "Base.Tshirt_Profession_VeterenGreen",
				["Tshirt_Profession_VeterenRed"] = "Base.Tshirt_Profession_VeterenRed",
				["Tshirt_Ranger"] = "Base.Tshirt_Ranger",
				["Tshirt_Rock"] = "Base.Tshirt_Rock",
				["Tshirt_Scrubs"] = "Base.Tshirt_Scrubs",
				["Tshirt_SpiffoDECAL"] = "Base.Tshirt_SpiffoDECAL",
				["Tshirt_Sport"] = "Base.Tshirt_Sport",
				["Tshirt_SportDECAL"] = "Base.Tshirt_SportDECAL",
				["Tshirt_ThunderGas"] = "Base.Tshirt_ThunderGas",
				["Tshirt_ValleyStation"] = "Base.Tshirt_ValleyStation",
				["Tshirt_WhiteLongSleeve"] = "Base.Tshirt_WhiteLongSleeve",
				["Tshirt_WhiteLongSleeveTINT"] = "Base.Tshirt_WhiteLongSleeveTINT",
				["Tshirt_WhiteTINT"] = "Base.Tshirt_WhiteTINT",
				["Underpants_AnimalPrint"] = "Base.Underpants_AnimalPrint",
				["Underpants_Black"] = "Base.Underpants_Black",
				["Underpants_RedSpots"] = "Base.Underpants_RedSpots",
				["Underpants_White"] = "Base.Underpants_White",
				["Vest_BulletArmy"] = "Base.Vest_BulletArmy",
				["Vest_BulletCivilian"] = "Base.Vest_BulletCivilian",
				["Vest_BulletPolice"] = "Base.Vest_BulletPolice",
				["Vest_DefaultTEXTURE"] = "Base.Vest_DefaultTEXTURE",
				["Vest_DefaultTEXTURE_TINT"] = "Base.Vest_DefaultTEXTURE_TINT",
				["Vest_Foreman"] = "Base.Vest_Foreman",
				["Vest_HighViz"] = "Base.Vest_HighViz",
				["Vest_Hunting_Camo"] = "Base.Vest_Hunting_Camo",
				["Vest_Hunting_CamoGreen"] = "Base.Vest_Hunting_CamoGreen",
				["Vest_Hunting_Grey"] = "Base.Vest_Hunting_Grey",
				["Vest_Hunting_Orange"] = "Base.Vest_Hunting_Orange",
				["Vest_Waistcoat"] = "Base.Vest_Waistcoat",
				["Vest_WaistcoatTINT"] = "Base.Vest_WaistcoatTINT",
				["Vest_Waistcoat_GigaMart"] = "Base.Vest_Waistcoat_GigaMart",
				["WeddingJacket"] = "Base.WeddingJacket",
			},
		},
		rare = {
			chance = 1,
			xp = 5,
			items = {
				["AmmoStrap_Bullets"] = "Base.AmmoStrap_Bullets",
				["AmmoStrap_Shells"] = "Base.AmmoStrap_Shells",
				["Bag_ALICEpack"] = "Base.Bag_ALICEpack",
				["Bag_ALICEpack_Army"] = "Base.Bag_ALICEpack_Army",
				["BellyButton_DangleGold"] = "Base.BellyButton_DangleGold",
				["BellyButton_DangleGoldRuby"] = "Base.BellyButton_DangleGoldRuby",
				["BellyButton_DangleSilver"] = "Base.BellyButton_DangleSilver",
				["BellyButton_DangleSilverDiamond"] = "Base.BellyButton_DangleSilverDiamond",
				["BellyButton_RingGold"] = "Base.BellyButton_RingGold",
				["BellyButton_RingGoldDiamond"] = "Base.BellyButton_RingGoldDiamond",
				["BellyButton_RingGoldRuby"] = "Base.BellyButton_RingGoldRuby",
				["BellyButton_RingSilver"] = "Base.BellyButton_RingSilver",
				["BellyButton_RingSilverAmethyst"] = "Base.BellyButton_RingSilverAmethyst",
				["BellyButton_RingSilverDiamond"] = "Base.BellyButton_RingSilverDiamond",
				["BellyButton_RingSilverRuby"] = "Base.BellyButton_RingSilverRuby",
				["BellyButton_StudGold"] = "Base.BellyButton_StudGold",
				["BellyButton_StudGoldDiamond"] = "Base.BellyButton_StudGoldDiamond",
				["BellyButton_StudSilver"] = "Base.BellyButton_StudSilver",
				["BellyButton_StudSilverDiamond"] = "Base.BellyButton_StudSilverDiamond",
				["Belt2"] = "Base.Belt2",
				["Bracelet_BangleLeftGold"] = "Base.Bracelet_BangleLeftGold",
				["Bracelet_BangleLeftSilver"] = "Base.Bracelet_BangleLeftSilver",
				["Bracelet_BangleRightGold"] = "Base.Bracelet_BangleRightGold",
				["Bracelet_BangleRightSilver"] = "Base.Bracelet_BangleRightSilver",
				["Bracelet_ChainLeftGold"] = "Base.Bracelet_ChainLeftGold",
				["Bracelet_ChainLeftSilver"] = "Base.Bracelet_ChainLeftSilver",
				["Bracelet_ChainRightGold"] = "Base.Bracelet_ChainRightGold",
				["Bracelet_ChainRightSilver"] = "Base.Bracelet_ChainRightSilver",
				["Bracelet_LeftFriendshipTINT"] = "Base.Bracelet_LeftFriendshipTINT",
				["Bracelet_RightFriendshipTINT"] = "Base.Bracelet_RightFriendshipTINT",
				["BunnySuitBlack"] = "Base.BunnySuitBlack",
				["BunnySuitPink"] = "Base.BunnySuitPink",
				["BunnyTail"] = "Base.BunnyTail",
				["Earring_Dangly_Diamond"] = "Base.Earring_Dangly_Diamond",
				["Earring_Dangly_Emerald"] = "Base.Earring_Dangly_Emerald",
				["Earring_Dangly_Pearl"] = "Base.Earring_Dangly_Pearl",
				["Earring_Dangly_Ruby"] = "Base.Earring_Dangly_Ruby",
				["Earring_Dangly_Sapphire"] = "Base.Earring_Dangly_Sapphire",
				["Earring_LoopLrg_Gold"] = "Base.Earring_LoopLrg_Gold",
				["Earring_LoopLrg_Silver"] = "Base.Earring_LoopLrg_Silver",
				["Earring_LoopMed_Gold"] = "Base.Earring_LoopMed_Gold",
				["Earring_LoopMed_Silver"] = "Base.Earring_LoopMed_Silver",
				["Earring_LoopSmall_Gold_Both"] = "Base.Earring_LoopSmall_Gold_Both",
				["Earring_LoopSmall_Gold_Top"] = "Base.Earring_LoopSmall_Gold_Top",
				["Earring_LoopSmall_Silver_Both"] = "Base.Earring_LoopSmall_Silver_Both",
				["Earring_LoopSmall_Silver_Top"] = "Base.Earring_LoopSmall_Silver_Top",
				["Earring_Pearl"] = "Base.Earring_Pearl",
				["Earring_Stone_Emerald"] = "Base.Earring_Stone_Emerald",
				["Earring_Stone_Ruby"] = "Base.Earring_Stone_Ruby",
				["Earring_Stone_Sapphire"] = "Base.Earring_Stone_Sapphire",
				["Earring_Stud_Gold"] = "Base.Earring_Stud_Gold",
				["Earring_Stud_Silver"] = "Base.Earring_Stud_Silver",
				["HolsterDouble"] = "Base.HolsterDouble",
				["HolsterSimple"] = "Base.HolsterSimple",
				["NecklaceLong_Amber"] = "Base.NecklaceLong_Amber",
				["NecklaceLong_Gold"] = "Base.NecklaceLong_Gold",
				["NecklaceLong_GoldDiamond"] = "Base.NecklaceLong_GoldDiamond",
				["NecklaceLong_Silver"] = "Base.NecklaceLong_Silver",
				["NecklaceLong_SilverDiamond"] = "Base.NecklaceLong_SilverDiamond",
				["NecklaceLong_SilverEmerald"] = "Base.NecklaceLong_SilverEmerald",
				["NecklaceLong_SilverSapphire"] = "Base.NecklaceLong_SilverSapphire",
				["Necklace_Choker"] = "Base.Necklace_Choker",
				["Necklace_Choker_Amber"] = "Base.Necklace_Choker_Amber",
				["Necklace_Choker_Diamond"] = "Base.Necklace_Choker_Diamond",
				["Necklace_Choker_Sapphire"] = "Base.Necklace_Choker_Sapphire",
				["Necklace_Crucifix"] = "Base.Necklace_Crucifix",
				["Necklace_DogTag"] = "Base.Necklace_DogTag",
				["Necklace_Gold"] = "Base.Necklace_Gold",
				["Necklace_GoldDiamond"] = "Base.Necklace_GoldDiamond",
				["Necklace_GoldRuby"] = "Base.Necklace_GoldRuby",
				["Necklace_Pearl"] = "Base.Necklace_Pearl",
				["Necklace_Silver"] = "Base.Necklace_Silver",
				["Necklace_SilverCrucifix"] = "Base.Necklace_SilverCrucifix",
				["Necklace_SilverDiamond"] = "Base.Necklace_SilverDiamond",
				["Necklace_SilverSapphire"] = "Base.Necklace_SilverSapphire",
				["Necklace_YingYang"] = "Base.Necklace_YingYang",
				["NoseRing_Gold"] = "Base.NoseRing_Gold",
				["NoseRing_Silver"] = "Base.NoseRing_Silver",
				["NoseStud_Gold"] = "Base.NoseStud_Gold",
				["NoseStud_Silver"] = "Base.NoseStud_Silver",
				["Ring_Left_MiddleFinger_Gold"] = "Base.Ring_Left_MiddleFinger_Gold",
				["Ring_Left_MiddleFinger_GoldDiamond"] = "Base.Ring_Left_MiddleFinger_GoldDiamond",
				["Ring_Left_MiddleFinger_GoldRuby"] = "Base.Ring_Left_MiddleFinger_GoldRuby",
				["Ring_Left_MiddleFinger_Silver"] = "Base.Ring_Left_MiddleFinger_Silver",
				["Ring_Left_MiddleFinger_SilverDiamond"] = "Base.Ring_Left_MiddleFinger_SilverDiamond",
				["Ring_Left_RingFinger_Gold"] = "Base.Ring_Left_RingFinger_Gold",
				["Ring_Left_RingFinger_GoldDiamond"] = "Base.Ring_Left_RingFinger_GoldDiamond",
				["Ring_Left_RingFinger_GoldRuby"] = "Base.Ring_Left_RingFinger_GoldRuby",
				["Ring_Left_RingFinger_Silver"] = "Base.Ring_Left_RingFinger_Silver",
				["Ring_Left_RingFinger_SilverDiamond"] = "Base.Ring_Left_RingFinger_SilverDiamond",
				["Ring_Right_MiddleFinger_Gold"] = "Base.Ring_Right_MiddleFinger_Gold",
				["Ring_Right_MiddleFinger_GoldDiamond"] = "Base.Ring_Right_MiddleFinger_GoldDiamond",
				["Ring_Right_MiddleFinger_GoldRuby"] = "Base.Ring_Right_MiddleFinger_GoldRuby",
				["Ring_Right_MiddleFinger_Silver"] = "Base.Ring_Right_MiddleFinger_Silver",
				["Ring_Right_MiddleFinger_SilverDiamond"] = "Base.Ring_Right_MiddleFinger_SilverDiamond",
				["Ring_Right_RingFinger_Gold"] = "Base.Ring_Right_RingFinger_Gold",
				["Ring_Right_RingFinger_GoldDiamond"] = "Base.Ring_Right_RingFinger_GoldDiamond",
				["Ring_Right_RingFinger_GoldRuby"] = "Base.Ring_Right_RingFinger_GoldRuby",
				["Ring_Right_RingFinger_Silver"] = "Base.Ring_Right_RingFinger_Silver",
				["Ring_Right_RingFinger_SilverDiamond"] = "Base.Ring_Right_RingFinger_SilverDiamond",
				["WeddingDress"] = "Base.WeddingDress",
				["WristWatch_Left_ClassicBlack"] = "Base.WristWatch_Left_ClassicBlack",
				["WristWatch_Left_ClassicBrown"] = "Base.WristWatch_Left_ClassicBrown",
				["WristWatch_Left_ClassicGold"] = "Base.WristWatch_Left_ClassicGold",
				["WristWatch_Left_ClassicMilitary"] = "Base.WristWatch_Left_ClassicMilitary",
				["WristWatch_Left_DigitalBlack"] = "Base.WristWatch_Left_DigitalBlack",
				["WristWatch_Left_DigitalDress"] = "Base.WristWatch_Left_DigitalDress",
				["WristWatch_Left_DigitalRed"] = "Base.WristWatch_Left_DigitalRed",
				["WristWatch_Right_ClassicBlack"] = "Base.WristWatch_Right_ClassicBlack",
				["WristWatch_Right_ClassicBrown"] = "Base.WristWatch_Right_ClassicBrown",
				["WristWatch_Right_ClassicGold"] = "Base.WristWatch_Right_ClassicGold",
				["WristWatch_Right_ClassicMilitary"] = "Base.WristWatch_Right_ClassicMilitary",
				["WristWatch_Right_DigitalBlack"] = "Base.WristWatch_Right_DigitalBlack",
				["WristWatch_Right_DigitalDress"] = "Base.WristWatch_Right_DigitalDress",
				["WristWatch_Right_DigitalRed"] = "Base.WristWatch_Right_DigitalRed",
				["BlackRobe"] = "Base.BlackRobe",
				--["Bag_BaseballBag"] = "Base.Bag_BaseballBag",
				--["Bag_BurglarBag"] = "Base.Bag_BurglarBag",
				--["Bag_ConstructionBag"] = "Base.Bag_ConstructionBag",
				--["Bag_Dancer"] = "Base.Bag_Dancer",
				--["Bag_DoctorBag"] = "Base.Bag_DoctorBag",
				--["Bag_DuffelBag"] = "Base.Bag_DuffelBag",
				--["Bag_DuffelBagTINT"] = "Base.Bag_DuffelBagTINT",
				--["Bag_FannyPackBack"] = "Base.Bag_FannyPackBack",
				--["Bag_InmateEscapedBag"] = "Base.Bag_InmateEscapedBag",
				--["Bag_JanitorToolbox"] = "Base.Bag_JanitorToolbox",
				--["Bag_MedicalBag"] = "Base.Bag_MedicalBag",
				--["Bag_Military"] = "Base.Bag_Military",
				--["Bag_MoneyBag"] = "Base.Bag_MoneyBag",
				--["Bag_SatchelPhoto"] = "Base.Bag_SatchelPhoto",
				--["Bag_ShotgunBag"] = "Base.Bag_ShotgunBag",
				--["Bag_ShotgunDblBag"] = "Base.Bag_ShotgunDblBag",
				--["Bag_ShotgunDblSawnoffBag"] = "Base.Bag_ShotgunDblSawnoffBag",
				--["Bag_ShotgunSawnoffBag"] = "Base.Bag_ShotgunSawnoffBag",
				--["Bag_Stripper"] = "Base.Bag_Stripper",
				--["Bag_SurvivorBag"] = "Base.Bag_SurvivorBag",
				--["Bag_TennisBag"] = "Base.Bag_TennisBag",
				--["Bag_ToolBag"] = "Base.Bag_ToolBag",
				--["Bag_TrashBag"] = "Base.Bag_TrashBag",
			},
		},
	};
	for _, spawnTable in pairs(clothing) do
		for itemName, itemFullName in pairs(spawnTable.items) do
			forageDefs[itemName] = {
				type = itemFullName,
				skill = 0,
				xp = spawnTable.xp,
				categories = { "Clothing" },
				zones = {
					Vegitation  = spawnTable.chance,
					TrailerPark = spawnTable.chance,
					TownZone    = spawnTable.chance,
					ForagingNav = spawnTable.chance,
				},
				spawnFuncs = { forageSystem.doClothingItemSpawn },
				forceOutside = false,
				canBeAboveFloor = true,
				itemSizeModifier = 0.5,
				isItemOverrideSize = true,
			};
		end;
	end;
end

generateClothingDefs();