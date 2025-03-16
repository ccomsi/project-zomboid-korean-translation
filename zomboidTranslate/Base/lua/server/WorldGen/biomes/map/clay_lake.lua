local clay_lake = {
    replacements = {
        blends_natural_01_64 = { { f = worldgen.features.GROUND.clay, p = "Sandbox.ClayLakeChance" } },
        blends_natural_01_69 = { { f = worldgen.features.GROUND.clay, p = "Sandbox.ClayLakeChance" } },
        blends_natural_01_70 = { { f = worldgen.features.GROUND.clay, p = "Sandbox.ClayLakeChance" } },
        blends_natural_01_71 = { { f = worldgen.features.GROUND.clay, p = "Sandbox.ClayLakeChance" } },
    },
    params = {
        landscape = { "FOREST" },
        temperature = { "MEDIUM" },
        hygrometry = { "DRY", "RAIN" },
        zombies = 0.001,
        placement = {
            "blends_natural_01_*",
        },
    }
}

worldgen.biomes_map["clay_lake"] = clay_lake