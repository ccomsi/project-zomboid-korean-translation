local ph_forest = {
    features = {
        TREE = {
            { f = worldgen.features.TREE.pine_jumbo, p = 0.3 },
            { f = worldgen.features.TREE.pine, p = 0.5 },
            { f = worldgen.features.TREE.pine_sapling, p = 0.2 },
        },
        BUSH = {
            { f = worldgen.features.BUSH.bush_dry, p = 1 },
        },
        PLANT = {
            { f = worldgen.features.PLANT.grass_low, p = 0.5 },
            { f = worldgen.features.PLANT.grass_medium, p = 0.3 },

            { f = worldgen.features.PLANT.fern, p = 0 },
            { f = worldgen.features.PLANT.generic_plant, p = 0.2 },
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

worldgen.biomes_map["ph_forest"] = ph_forest