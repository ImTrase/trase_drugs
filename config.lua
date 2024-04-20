-- Fully Server Sided

Config = {}

Config.Framework = 'auto' -- 0 = ESX, 1 = QBCore
Config.Dealer = 'trase_dealer' -- The resource name of the dealer system (REQUIRED)

Config.DiscordLogs = true -- If enabled, set webhook in server/open.lua

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

Config.RaidCommand = {
    Enabled = true, -- If enabled, players can use /raid to start a raid.
    CountDown = 30, -- The time in seconds it will count down from.
    AnnounceType = 2, -- 1 = Chat, 2 = TXAdmin Message (can be changed in server/open.lua)
    Command = 'raid', -- The command to use to start a raid.
    Jobs = { ['police'] = true, ['sheriff'] = true }, -- The jobs that can start a raid.
    Radius = 100,
    Duration = 2, -- The time in minutes the raid will last.
    Punishment = 3 -- 1 = Wipe, 2 = Log, 3 = Wipe + Log
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
        RankLabel = 'Dealer', -- Label of the drug
        SellRequirement = 10, -- The minimum amount of drugs needing to be sold to reach this rank.
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
                ['coke_bag'] = 1
            },

            Requirements = false
        },

        Process = {
            Locations = {
                vec3(879.9382, -1132.7386, 26.0384)
            },

            Options = {
                Prop = { model = 'hei_prop_hei_drug_pack_01b', pos = vector3(0.13, 0.03, 0.02), rot = vector3(0.0, 0.0, 0.0) },
                Anim = { dict = 'mini@repair', clip = 'fixing_a_ped' }
            },

            Rewards = {
                ['coke_brick'] = 1
            },

            Requirements = {
                ['coke_bag'] = 10
            }
        },
    }
}