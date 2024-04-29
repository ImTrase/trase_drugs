if GetResourceState('qb-core') ~= 'started' then return end
QBCore = exports['qb-core']:GetCoreObject()
Config.Framework = 1
if (Config.PayType == 'black_money') then Config.PayType = 'markedbills' end
if (Config.PayType == 'money') then Config.PayType = 'cash' end

function GetPlayer(target)
    local player = QBCore.Functions.GetPlayer(target)
    if (player) then
        return player
    end
end

function GetItemLabel(itemName)
    local item = QBCore.Shared.Items[itemName]
    if item then
        return item.label
    else
        return item
    end
end

function CountItem(target, item)
    local player = GetPlayer(target)
    if (not player) then return 0 end
    local ItemData = player.Functions.GetItemByName(item)
    return ItemData?.count or ItemData?.amount or 0
end

function AddMoney(target, account, amount)
    local player = QBCore.Functions.GetPlayer(target)
    if (not player) then return end
    if (account == 'markedbills') then
        local info = { worth  = amount }
        player.Functions.AddItem(account, 1, false, info)
    else
        player.Functions.AddMoney(account, amount)
    end
end

function AddItem(target, item, amount)
    local player = QBCore.Functions.GetPlayer(target)
    if (not player) then return end
    player.Functions.AddItem(item, amount)
end

function RemoveItem(target, item, amount)
    local player = QBCore.Functions.GetPlayer(target)
    if (not player) then return end
    player.Functions.RemoveItem(item, amount)
end

local CachedSells = {}

function CountDrugs(target)
    if (CachedSells[target]) then return CachedSells[target] end -- Cache the drug count to a table, helps performance so we don't need to query each time.

    local player = GetPlayer(target)
    if (not player) then return 0 end

    local result = MySQL.query.await('SELECT drugssold FROM players WHERE citizenid = ?', { player.PlayerData.citizenid })
    CachedSells[target] = result[1].drugssold
    return result[1].drugssold
end

function AddDrugCount(target)
    local player = GetPlayer(target)
    if (not player) then return end

    CachedSells[target] += 1

    for k, v in pairs(Config.Ranks) do
        if (CachedSells[target] == v.SellRequirement) then
            TriggerClientEvent('trase_dealer:client:notify', target, Config.Strings['RankUp']:gsub('{TOTAL_DRUGSALE}', CachedSells[target]):gsub('{RANK_LABEL}', v.RankLabel))
        end
    end

    MySQL.query.await('UPDATE players SET drugssold = drugssold + 1 WHERE citizenid = ?', { player.PlayerData.citizenid })
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
    local players = QBCore.Functions.GetPlayers()
    local PD = {}
    for k, v in pairs(players) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player.PlayerData.job.name == Config.Police.Job then
            PD[#PD +1] = v
        end
    end
    return PD
end

function GetPlayerJob(target)
    local player = GetPlayer(target)
    if (not player) then return end
    return player.PlayerData.job.name
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
            MySQL.query('UPDATE players SET inventory = "[]" WHERE citizenid = ?', { identifier })
            print('^2[Trase_Dealer]^0: ^1[WARNING]^0: '.. playerName.. ' inventory has been wiped from the database for trying to evade a raid.')
        end)
    end

    if Config.RaidCommand ~= 1 and Config.DiscordLogs then
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
    -- QBCore Connect Event
    AddEventHandler('QBCore:PlayerLoaded', function(source, player)
        CachedIdentifiers[source] = player.PlayerData.citizenid
    end)

    -- QBCore Disconnect Event
    AddEventHandler('QBCore:PlayerDropped', function(source)
        if not Raiding then return end
        local ped = GetPlayerPed(source)
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