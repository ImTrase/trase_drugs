local function InitClientConfig()
    local cfg = {}
    cfg.Options = Config.Options
    cfg.Drugs = Config.Drugs
    cfg.Ranks = Config.Ranks
    return cfg
end

local loaded = false
local DiscordBenifits = {}

CreateThread(function()
    while not Config or not next(Config) do Wait(0) end
    -- Check if export "CountDrugs" from resource trase_dealer exists
    
    if Config.EnableRanks then
        local success, hasExport = pcall(function()
            return exports[Config.Dealer] and exports[Config.Dealer].CountDrugs ~= nil
        end)

        local found = success and hasExport

        if not found then
            -- Loop print to console every 5 seconds if the dealer resource is missing
            while not found do
                print('^2[Trase_Drugs]^0: ^1[ERROR]^0: The "Trase_Dealer" resource is missing or not configured properly.')
                Wait(5000)
            end
        end

        if found then
            loaded = true
        end
    else
        -- If ranks are disabled, skip the dealer check and mark as loaded.
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
        if Config.RoleBenifits.Enabled then
            for i = 1, #Config.RoleBenifits.Roles do
                local role = Config.RoleBenifits.Roles[i]
                if HasRole(src, role.RoleId) then
                    data.role = role.Benifits
                    DiscordBenifits[tonumber(src)] = role.Benifits
                    break
                end
            end
        end
        TriggerClientEvent('trase_drugs:client:syncData', src, data, rank)
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
    local rank, rankData = GetRankData(src)
    
    if drugData.Requirements and next(drugData.Requirements) then
        for item, amount in pairs(drugData.Requirements) do
            RemoveItem(src, item, amount)
        end
    end

    if drugData.Rewards and next(drugData.Rewards) then
        for item, amount in pairs(drugData.Rewards) do
            local multiplier = 1
            local Discord = DiscordBenifits[tonumber(src)]
            if rankData.Benifits and rankData.Benifits.Multiplier then
                multiplier = rankData.Benifits.Multiplier
            end
            if Discord and Discord.Multiplier then
                if Config.RoleBenifits.StackMultipliers then
                    multiplier = multiplier * Discord.Multiplier
                else
                    multiplier = Discord.Multiplier
                end
            end
            AddItem(src, item, amount * multiplier)
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
    local rank, rankData = GetRankData(src)
    
    if drugData.Requirements and next(drugData.Requirements) then
        for item, amount in pairs(drugData.Requirements) do
            RemoveItem(src, item, amount)
        end
    end

    if drugData.Rewards and next(drugData.Rewards) then
        for item, amount in pairs(drugData.Rewards) do
            local multiplier = 1
            local Discord = DiscordBenifits[tonumber(src)]
            if rankData.Benifits and rankData.Benifits.Multiplier then
                multiplier = rankData.Benifits.Multiplier
            end
            -- Same logic as rank but with DiscordBenifits instead.
            if Discord and Discord.Multiplier then
                if Config.RoleBenifits.StackMultipliers then
                    multiplier = multiplier * Discord.Multiplier
                else
                    multiplier = Discord.Multiplier
                end
            end
            AddItem(src, item, amount * multiplier)
        end
    end
end)

-- Command to Config.RankCommand
if Config.RankCommand.Enabled and Config.EnableRanks then
    if GetResourceState(Config.EnableRanks) == 'started' then
        RegisterCommand(Config.RankCommand.Command, function(source)
            local src = source
            local rank, rankData = GetRankData(src)

            TriggerClientEvent('trase_dealer:client:notify', src, locale('rank_notify'):format(rankData.RankLabel))
        end, false)
    end
end

if Config.RaidCommand.Enabled then
    RegisterCommand(Config.RaidCommand.Command, function(source, args)
        local src = source
        local job = GetPlayerJob(src)
        if not job or not Config.RaidCommand.Jobs[job] then
            return TriggerClientEvent('trase_dealer:client:notify', src, locale('invalid_job'))
        end

        local drug = args[1]
        if not Config.Drugs[drug] then
            return TriggerClientEvent('trase_dealer:client:notify', src, locale('invalid_drug'))
        end
        RaidLocation(drug)
    end, false)
end

lib.locale()