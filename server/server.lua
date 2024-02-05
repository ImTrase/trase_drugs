local function InitClientConfig()
    local cfg = {}
    cfg.Options = Config.Options
    cfg.Drugs = Config.Drugs
    cfg.Ranks = Config.Ranks
    return cfg
end

RegisterNetEvent('trase_drugs:server:playerConnected', function()
    local src = source
    local rank = GetRankData(src)

    Player(src):state('drugRank', rank)

    local data = {
        config = InitClientConfig()
    }

    TriggerClientEvent('trase_drugs:client:syncData', src, data)
end)

lib.locale()