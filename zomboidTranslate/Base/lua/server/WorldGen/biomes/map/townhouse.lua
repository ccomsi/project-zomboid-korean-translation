local townhouse = {
    features = {
        TREE = {
            { f = worldgen.features.TREE.dogwood_jumbo, p = 0.25 },
            { f = worldgen.features.TREE.dogwood, p = 0.1 },
            { f = worldgen.features.TREE.redbud_jumbo, p = 0.2 },
            { f = worldgen.features.TREE.redbud, p = 0.1 },
            { f = worldgen.features.TREE.yellowwood_jumbo, p = 0.25 },
            { f = worldgen.features.TREE.yellowwood, p = 0.1 },
        },
        BUSH = {
            { f = worldgen.features.BUSH.bush_dry, p = 1 },
        },
        PLANT = {
            { f = worldgen.features.PLANT.grass_low, p = 0.75 },
            { f = worldgen.features.PLANT.grass_medium, p = 0.15 },

            { f = worldgen.features.PLANT.fern, p = 0.03 },
            { f = worldgen.features.PLANT.generic_plant, p = 0.07 },
        }
    },
    params = {
        landscape = { "FOREST" },
        temperature = { "MEDIUM" },
        hygrometry = { "DRY", "RAIN" },
        zombies = 0.001,
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

worldgen.biomes_map["townhouse"] = townhouse