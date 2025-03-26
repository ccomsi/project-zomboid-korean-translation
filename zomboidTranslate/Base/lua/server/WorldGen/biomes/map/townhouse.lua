local townhouse = {
    features = {
        TREE = {
            { f = worldgen.features.TREE.dogwood_jumbo, p = 0.2 },
            { f = worldgen.features.TREE.maple_jumbo, p = 0.2 },
            { f = worldgen.features.TREE.yellowwood_jumbo, p = 0.25 },
            { f = worldgen.features.TREE.linden_jumbo, p = 0.05 },
            { f = worldgen.features.TREE.silverbell_jumbo, p = 0.3 },
        },
        BUSH = {
            { f = worldgen.features.BUSH.bush_regular, p = 1 },
        },
        PLANT = {
            { f = worldgen.features.PLANT.grass_low, p = 0.55 },
            { f = worldgen.features.PLANT.grass_medium, p = 0.4 },

            { f = worldgen.features.PLANT.fern, p = 0.025 },
            { f = worldgen.features.PLANT.generic_plant, p = 0.025 },
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

worldgen.biomes_map["townhouse"] = townhouse