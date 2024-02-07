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
    DrawDistance = 5.0, -- The distance to draw the markers (increasing can hurt performance)
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
    -- Configured for: https://www.gta5-mods.com/maps/mlo-enhanced-coke-lab-sp-fivem-dvd6789
    ['coke'] = {
        Label = 'Coke',
        Speeds = {
            Collection = 10, -- Time in seconds to collect the drug
            Process = 5 -- Time in seconds to process the drug
        },

        Collection = {
            Locations = {
                vec3(882.4806, -1141.9399, 26.0383),
                vec3(880.1509, -1141.8541, 26.0383),
            },

            -- For options view https://overextended.dev/ox_lib/Modules/Interface/Client/progress for the options. (for only prop + anim)
            Options = {
                Prop = { model = 'prop_coke_block_half_b', pos = vector3(0.13, 0.03, 0.02), rot = vector3(0.0, 0.0, 0.0) },
                Anim = { dict = 'mini@repair', clip = 'fixing_a_ped' }
            },

            Rewards = {
                ['money'] = 2500,
                ['water'] = 1
            },

            Requirements = false
        },

        Process = {
            Locations = {
                vec3(879.9382, -1132.7386, 26.0384)
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