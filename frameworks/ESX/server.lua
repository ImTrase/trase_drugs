if GetResourceState('es_extended') ~= 'started' then return end
ESX = exports['es_extended']:getSharedObject()
Config.Framework = 0

function GetPlayer(target)
    local xPlayer = ESX.GetPlayerFromId(target)
    if (xPlayer) then
        return xPlayer
    end
end

function GetItemLabel(itemName)
    return ESX.GetItemLabel(itemName)
end

function CountItem(target, itemName)
    local xPlayer = GetPlayer(target)
    if (not xPlayer) then return 0 end
    local item = xPlayer.getInventoryItem(itemName)
    if not item then
        print('^4[Trase_Dealer]^0: ^1[ERROR]^0: The item you specified does not exist in the database.')
        return 0
    end

    return item.count or 0
end

function AddMoney(target, account, amount)
    local xPlayer = GetPlayer(target)
    if (not xPlayer) then return end
    xPlayer.addAccountMoney(account, amount)
end

function RemoveItem(target, item, amount)
    local xPlayer = GetPlayer(target)
    if (not xPlayer) then return end
    xPlayer.removeInventoryItem(item, amount)
end

function AddItem(target, item, amount)
    local xPlayer = GetPlayer(target)
    if (not xPlayer) then return end
    xPlayer.addInventoryItem(item, amount)
end

local CachedSells = {}

function CountDrugs(target)
    if (CachedSells[target]) then return CachedSells[target] end -- Cache the drug count to a table, helps performance so we don't need to query each time.

    local xPlayer = GetPlayer(target)
    if (not xPlayer) then return 0 end

    local result = MySQL.query.await('SELECT drugssold FROM users WHERE identifier = ?', { xPlayer.identifier })
    CachedSells[target] = result[1].drugssold
    return result[1].drugssold
end

function AddDrugCount(target)
    local xPlayer = GetPlayer(target)
    if (not xPlayer) then return end

    CachedSells[target] += 1

    for k, v in pairs(Config.Ranks) do
        if (CachedSells[target] == v.SellRequirement) then
            TriggerClientEvent('trase_dealer:client:notify', target, Config.Strings['RankUp']:gsub('{TOTAL_DRUGSALE}', CachedSells[target]):gsub('{RANK_LABEL}', v.RankLabel))
        end
    end

    MySQL.query.await('UPDATE users SET drugssold = drugssold + 1 WHERE identifier = ?', { xPlayer.identifier })
end

function GetRank(target)
    local Count = CountDrugs(target)
    local Rank = 0

    for k, v in pairs(Config.Ranks) do
        if (CachedSells[target] >= v.SellRequirement and k > Rank) then
            Rank = k
        end
    end

    return Rank
end

function GetActivePolice()
    if (not Config.Police.Enabled) then return end
    local PD = {}

    for i = 1, #Config.Police.Jobs do
        local job = Config.Police.Jobs[i]
        local xPlayers = ESX.GetExtendedPlayers('job', Config.Police.Job)
        for k, v in pairs(xPlayers) do PD[#PD +1] = v.source end
    end

    return PD
end

function GetPlayerJob(target)
    local xPlayer = GetPlayer(target)
    if (not xPlayer) then return end
    return xPlayer.job.name
end

local CachedIdentifiers = {}
local AlreadyFlagged = {}
function TriedToEvadeRaid(target)
    local playerName = GetPlayerName(target)
    local identifier = CachedIdentifiers[target]
    if (not identifier) then return end

    if AlreadyFlagged[identifier] then return end
    
    AlreadyFlagged[identifier] = true
    CachedIdentifiers[target] = nil

    if Config.RaidCommand.Punishment == 1 or Config.RaidCommand.Punishment == 3 then
        -- Update the database
        SetTimeout(5000, function()
            MySQL.query('UPDATE users SET inventory = "[]" WHERE identifier = ?', { identifier })
            print('^2[Trase_Dealer]^0: ^1[WARNING]^0: '.. playerName.. ' inventory has been wiped from the database for trying to evade a raid.')
        end)
    end

    if Config.RaidCommand ~= 1 and Config.Webhook then
        local fields = {}
        fields[#fields+1] = { name = 'Player', value = playerName, inline = true }
        fields[#fields+1] = { name = 'Identifier', value = identifier, inline = true }

        SendLog({
            title = 'Raid Evader',
            description = playerName.. ' tried to evade a raid.',
            fields = fields,
            webhook = RAIDWEBHOOK
        })
    end
end

if Config.RaidCommand.Enabled then
    --ESX Connect Event
    AddEventHandler('esx:playerLoaded', function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        if (not xPlayer) then return end
        CachedIdentifiers[source] = xPlayer.identifier
    end)

    -- ESX Disconnect Event
    AddEventHandler('esx:playerDropped', function(source)
        if not Raiding then return end
        local src = source
        local ped = GetPlayerPed(src)
        local coords = GetEntityCoords(ped)

        -- Check all the drug locations
        for drug, data in pairs(Config.Drugs) do
            if data.Collection and next(data.Collection.Locations) then
                for i = 1, #data.Collection.Locations do
                    local distance = #(coords - data.Collection.Locations[i])
                    if distance <= Config.RaidCommand.Radius then
                        TriedToEvadeRaid(source)
                    end
                end
            end
        end
    end)
end