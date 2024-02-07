local function InitClientConfig()
    local cfg = {}
    cfg.Options = Config.Options
    cfg.Drugs = Config.Drugs
    cfg.Ranks = Config.Ranks
    return cfg
end

local loaded = false

CreateThread(function()
    while not Config or not next(Config) do Wait(0) end
    -- Check if export "CountDrugs" from resource trase_dealer exists

    local success, hasExport = pcall(function()
        return exports[Config.Dealer] and exports[Config.Dealer].CountDrugs ~= nil
    end)

    local found = success and hasExport

    if not found then
        -- create a loop print to console every 5 seconds
        while not found do
            print('^2[Trase_Drugs]^0: ^1[ERROR]^0: The "Trase_Dealer" resource is missing or not configured properly.')
            Wait(5000)
        end
    end

    if found then
        loaded = true
    end
end)

RegisterNetEvent('trase_drugs:server:playerConnected', function()
    local src = source
 
    if loaded then
        local rank = GetRankData(src)
        Player(src).state:set('drugRank', rank, false)
        local data = {
            config = InitClientConfig()
        }
        TriggerClientEvent('trase_drugs:client:syncData', src, data, 2)
    end
end)

RegisterNetEvent('trase_drugs:server:collect', function(drug)
    if not Config.Drugs[drug] then
        print(('^2[Trase_Drugs] ^1[ERROR] ^0The drug %s does not exist in the configuration.'):format(drug))
        return
    end

    local src = source
    if not CheckRequirements(src, drug, 'collect') then
        print(('^2[Trase_Drugs] ^1[ERROR] (Possible Cheater) ^0Player %s does not have the required items to collect %s.'):format(src, drug))
        return
    end

    local drugData = Config.Drugs[drug].Collection
    
    if drugData.Requirements and next(drugData.Requirements) then
        for item, amount in pairs(drugData.Requirements) do
            RemoveItem(src, item, amount)
        end
    end

    if drugData.Rewards and next(drugData.Rewards) then
        for item, amount in pairs(drugData.Rewards) do
            AddItem(src, item, amount)
        end
    end
end)

RegisterNetEvent('trase_drugs:server:process', function(drug)
    if not Config.Drugs[drug] then
        print(('^2[Trase_Drugs] ^1[ERROR] ^0The drug %s does not exist in the configuration.'):format(drug))
        return
    end

    local src = source
    if not CheckRequirements(src, drug, 'process') then
        print(('^2[Trase_Drugs] ^1[ERROR] (Possible Cheater) ^0Player %s does not have the required items to process %s.'):format(src, drug))
        return
    end

    local drugData = Config.Drugs[drug].Process
    
    if drugData.Requirements and next(drugData.Requirements) then
        for item, amount in pairs(drugData.Requirements) do
            RemoveItem(src, item, amount)
        end
    end

    if drugData.Rewards and next(drugData.Rewards) then
        for item, amount in pairs(drugData.Rewards) do
            AddItem(src, item, amount)
        end
    end
end)

-- Command to Config.RankCommand
if Config.RankCommand.Enabled then
    RegisterCommand(Config.RankCommand.Command, function(source)
        local src = source
        local rank, rankData = GetRankData(src)

        TriggerClientEvent('trase_dealer:client:notify', src, locale('rank_notify'):format(rankData.RankLabel))
    end, false)
end

lib.locale()