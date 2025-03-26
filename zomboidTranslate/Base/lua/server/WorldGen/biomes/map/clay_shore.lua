local clay_shore = {
    replacements = {
        blends_natural_01_64 = { { f = worldgen.features.GROUND.clay, p = "Sandbox.ClayRiverChance" } },
        blends_natural_01_69 = { { f = worldgen.features.GROUND.clay, p = "Sandbox.ClayRiverChance" } },
        blends_natural_01_70 = { { f = worldgen.features.GROUND.clay, p = "Sandbox.ClayRiverChance" } },
        blends_natural_01_71 = { { f = worldgen.features.GROUND.clay, p = "Sandbox.ClayRiverChance" } },
    },
    params = {
        landscape = { "FOREST" },
        temperature = { "MEDIUM" },
        hygrometry = { "DRY", "RAIN" },
        placement = {
            "blends_natural_01_*",
        },
    }
}

worldgen.biomes_map["clay_shore"] = clay_shore