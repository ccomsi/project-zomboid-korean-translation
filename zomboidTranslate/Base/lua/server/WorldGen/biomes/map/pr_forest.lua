local pr_forest = {
    features = {
        TREE = {
            { f = worldgen.features.TREE.redbud_jumbo, p = 0.1 },
            { f = worldgen.features.TREE.redbud, p = 0.45 },
            { f = worldgen.features.TREE.hawthorn_jumbo, p = 0.08 },
            { f = worldgen.features.TREE.hawthorn, p = 0.32 },
            { f = worldgen.features.TREE.silverbell_jumbo, p = 0.025 },
            { f = worldgen.features.TREE.silverbell, p = 0.025 },
        },
        BUSH = {
            { f = worldgen.features.BUSH.bush_dry, p = 1 },
        },
        PLANT = {
            { f = worldgen.features.PLANT.grass_low, p = 0.667 },
            { f = worldgen.features.PLANT.grass_medium, p = 0.167 },

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

worldgen.biomes_map["pr_forest"] = pr_forest