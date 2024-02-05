-- Fully Server Sided

Config = {}

Config.Framework = 0 -- 0 = ESX, 1 = QBCore


Config.Options = {
    DrawDistance = 10.0, -- The distance to draw the markers (increasing can hurt performance)
    AutoRepeat = true, -- If enabled, the player will not need to press E to farm after each action.
}

Config.Ranks = {
    {
        RankLabel = 'Dealer',
        SellRequirement = 10
    },
    {
        RankLabel = 'Kingpin',
        SellRequirement = 25
    }
}

Config.Drugs = {
    ['coke'] = {
        Collection = {
            Label = 'Coke',

            Speeds = {
                Collection = 2, -- Time in seconds to collect the drug
                Process = 5 -- Time in seconds to process the drug
            },
            
            Locations = {
                vec3(0, 0, 0)
            },

            Rewards = {
                ['money'] = 2500,
                ['coke'] = 1
            },

            Requirements = false
        },

        Process = {
            Locations = {
                vec3(0, 0, 0)
            },

            Rewards = {
                ['coke'] = 1
            },

            Requirements = {
                ['coke'] = 1
            }
        },
    }
}