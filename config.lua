-- Fully Server Sided

Config = {}

Config.Framework = 0 -- 0 = ESX, 1 = QBCore
Config.Dealer = 'trase_dealer' -- The resource name of the dealer system (REQUIRED)

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
        SellRequirement = 25,
        Benifits = {
            CollectionSpeed = 25, -- 25% faster collection speed
            ProcessSpeed = 25, -- 25% faster process speed
        }
    }
}

Config.Drugs = {
    ['coke'] = {
        Label = 'Coke',
        Speeds = {
            Collection = 10, -- Time in seconds to collect the drug
            Process = 5 -- Time in seconds to process the drug
        },

        Collection = {
            Locations = {
                vec3(48.6413, 46.8333, 72.6150)
            },

            Rewards = {
                ['money'] = 2500,
                ['water'] = 1
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