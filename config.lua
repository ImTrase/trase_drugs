-- Fully Server Sided

Config = {}

Config.Framework = 0 -- 0 = ESX, 1 = QBCore
Config.Dealer = 'trase_dealer' -- The resource name of the dealer system (REQUIRED)

Config.RoleBenifits = {
    Enabled = true, -- If enabled, players will get benifits from their discord role. (pulls from the top role in the list, so make sure the most important role is at the top.)
    StackMultipliers = true, -- If enabled, the player will stack the multipliers from the discordRole + rank.
    Roles = {
        {
            RoleId = 960632501775257671,
            Benifits = {
                CollectionSpeed = 25, -- 25% faster collection speed
                ProcessSpeed = 25, -- 25% faster process speed
                Multiplier = 2, -- 2x the rewards
            }
        }
    }
}

Config.Options = {
    DrawDistance = 10.0, -- The distance to draw the markers (increasing can hurt performance)
    AutoRepeat = true, -- If enabled, the player will not need to press E to farm after each action.
}

Config.RankCommand = {
    Enabled = true, -- If enabled, players can use /rank to view their rank.
    Command = 'drugRank' -- The command to use to view the rank.
}

Config.Ranks = {
    {
        RankLabel = 'Dealer',
        SellRequirement = 10,
        Benifits = {
            CollectionSpeed = 5, -- 5% faster collection speed
            ProcessSpeed = 5, -- 5% faster process speed
        }
    },
    {
        RankLabel = 'Kingpin',
        SellRequirement = 25,
        Benifits = {
            CollectionSpeed = 25, -- 25% faster collection speed
            ProcessSpeed = 25, -- 25% faster process speed
            Multiplier = 2, -- 2x the rewards
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
                vec3(0, 0, 0),
            },

            Rewards = {
                ['money'] = 2500,
                ['water'] = 1
            },

            Requirements = false
        },

        Process = {
            Locations = {
                vec3(48.6413, 46.8333, 72.6150)
            },

            Rewards = {
                ['bread'] = 1
            },

            Requirements = {
                ['water'] = 1
            }
        },
    }
}