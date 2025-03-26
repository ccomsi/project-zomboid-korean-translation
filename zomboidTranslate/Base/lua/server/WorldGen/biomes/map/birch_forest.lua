local birch_forest = {
    features = {
        TREE = {
            { f = worldgen.features.TREE.birch_jumbo, p = 0.75 },
            { f = worldgen.features.TREE.birch, p = 0.05 },
            { f = worldgen.features.TREE.hawthorn_jumbo, p = 0.075 },
            { f = worldgen.features.TREE.hawthorn, p = 0.025 },
            { f = worldgen.features.TREE.yellowwood_jumbo, p = 0.075 },
            { f = worldgen.features.TREE.yellowwood, p = 0.025 },

        },
        BUSH = {
            { f = worldgen.features.BUSH.bush_regular, p = 1 },
        },
        PLANT = {
            { f = worldgen.features.PLANT.grass_medium, p = 0.6 },
            { f = worldgen.features.PLANT.grass_low, p = 0.3 },

            { f = worldgen.features.PLANT.fern, p = 0.05 },
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

worldgen.biomes_map["birch_forest"] = birch_forest