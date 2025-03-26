local primary_forest = {
    features = {
        TREE = {
            { f = worldgen.features.TREE.hemlock_jumbo, p = 0.6 },
            { f = worldgen.features.TREE.hemlock, p = 0.05 },
            { f = worldgen.features.TREE.hemlock_sapling, p = 0.05 },
            { f = worldgen.features.TREE.holly_jumbo, p = 0.1 },
            { f = worldgen.features.TREE.holly, p = 0.05 },
            { f = worldgen.features.TREE.holly_sapling, p = 0.05 },
            { f = worldgen.features.TREE.pine_jumbo, p = 0.05 },
            { f = worldgen.features.TREE.pine, p = 0.025 },
            { f = worldgen.features.TREE.pine_sapling, p = 0.025 },
        },
        BUSH = {
            { f = worldgen.features.BUSH.bush_fat, p = 1 },
        },
        PLANT = {
            { f = worldgen.features.PLANT.grass_high, p = 0.8 },
            { f = worldgen.features.PLANT.fern, p = 0.15 },
            { f = worldgen.features.PLANT.generic_plant, p = 0.05 },
        }
    },
    params = {
        landscape = { "FOREST" },
        temperature = { "MEDIUM" },
        hygrometry = { "DRY", "RAIN" },
        placement = {
            "blends_natural_01_*",

            "!blends_natural_01_0",
            "!blends_natural_01_5",
            "!blends_natural_01_6",
            "!blends_natural_01_7",

            "!blends_natural_01_64",
            "!blends_natural_01_69",
            "!blends_natural_01_70",
            "!blends_natural_01_71",
        },
    }
}

worldgen.biomes_map["primary_forest"] = primary_forest