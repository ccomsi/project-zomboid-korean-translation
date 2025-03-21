local birch_forest = {
    features = {
        TREE = {
            { f = worldgen.features.TREE.birch_jumbo, p = 0.85 },
            { f = worldgen.features.TREE.birch, p = 0.05 },
            { f = worldgen.features.TREE.hawthorn_jumbo, p = 0.025 },
            { f = worldgen.features.TREE.hawthorn, p = 0.025 },
            { f = worldgen.features.TREE.yellowwood_jumbo, p = 0.025 },
            { f = worldgen.features.TREE.yellowwood, p = 0.025 },

        },
        BUSH = {
            { f = worldgen.features.BUSH.bush_regular, p = 1 },
        },
        PLANT = {
            { f = worldgen.features.PLANT.grass_medium, p = 0.284 },
            { f = worldgen.features.PLANT.grass_low, p = 0.55 },

            { f = worldgen.features.PLANT.fern, p = 0.083 },
            { f = worldgen.features.PLANT.generic_plant, p = 0.083 },
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

worldgen.biomes_map["birch_forest"] = birch_forest