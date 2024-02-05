-- Fully Server Sided

Config = {}

Config.Framework = 0 -- 0 = ESX, 1 = QBCore

Config.DrawDistance = 10.0 -- How far you can see the markers (increasing this can cause performance issues)

Config.Drugs = {
    ['coke'] = {
        Collection = {
            HelpText = {
                Collect = '[E] - Collect Coke',
                Process = '[E] - Process Coke'
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