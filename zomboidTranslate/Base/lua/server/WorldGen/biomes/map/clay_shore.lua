local clay_shore = {
    replacements = {
        blends_natural_01_64 = { { f = worldgen.features.GROUND.clay, p = 0.01 } },
        blends_natural_01_69 = { { f = worldgen.features.GROUND.clay, p = 0.01 } },
        blends_natural_01_70 = { { f = worldgen.features.GROUND.clay, p = 0.01 } },
        blends_natural_01_71 = { { f = worldgen.features.GROUND.clay, p = 0.01 } },
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

worldgen.biomes_map["clay_shore"] = clay_shore