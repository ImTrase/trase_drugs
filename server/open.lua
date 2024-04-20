RAIDWEBHOOK = '' -- Config.Webhook but be enabed
-- Function to get the Config.Ranks correct rank label
--@param target number
--@return number, table
function GetRankData(target)
    local drugsSold = exports.trase_dealer:CountDrugs(target)

    -- Loop through Config.Ranks and get the highest rank the player has
    local rank = 1
    for i = 1, #Config.Ranks do
        print(drugsSold)
        if (drugsSold >= Config.Ranks[i].SellRequirement) then
            rank = i
        end
    end

    return rank, Config.Ranks[rank]
end

-- Function to see if they have a discord role (uses trase_discord resource by default)
--@param src number
--@param roleId string | number
--@return boolean
function HasRole(src, roleId)
    if GetResourceState('trase_discord') ~= 'started' then
        print('^2[Trase_Drugs]^0: ^1[ERROR]^0: The "Trase_Discord" resource is missing or not configured properly.')
        return false
    end
    return exports.trase_discord:hasRole(src, roleId, false)
end

-- Function to check the requirements for the player to collect or process drugs
--@param src number
--@param drug string
--@param type string
--@return boolean
function CheckRequirements(src, drug, type)
    if not Config.Drugs[drug] then
        print(('^2[Trase_Drugs] ^1[ERROR] ^0The drug %s does not exist in the configuration.'):format(drug))
        return false
    end

    local requierments
    if type == 'collect' then
        requierments = Config.Drugs[drug].Collection.Requirements
    else
        requierments = Config.Drugs[drug].Process.Requirements
    end
    
    if not requierments or not next(requierments) then return true end

    for item, amount in pairs(requierments) do
        local count = CountItem(src, item)
        if count < amount then
            return false, GetItemLabel(item)
        end
    end

    return true
end

-- Function to log to discord via an HTTP request (discord embed)
--@param args table
--@return void
function SendLog(args)
    local title = args.title or "Drug System"
    local info = args.description or "No information provided"
    local webhook = args.webhook or ""
    local label = args.label or "Drug System"
    local fields = args.fields or {}

    local discordInfo = {
        ["color"] = "000001",
        ["type"] = "rich",
        ["title"] = title,
        ["description"] = info,
        ["fields"] = fields,
        ["author"] = {
            ["name"] = label
        }
    }

    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
        username = 'Drug System',
        avatar_url = "https://cdn.discordapp.com/attachments/1119540289196003410/1231280996851257435/logo.png?ex=663662c9&is=6623edc9&hm=338e8edb036c807111f6bf7aec8458c14c14d22d03f2af91bdb017d90605ac09&",
        embeds = { discordInfo } }),
        { ['Content-Type'] = 'application/json'
    })
end

if Config.RaidCommand.Enabled then
    Raiding = false
end

-- Function called when raiding a drug location
-- @param location string
--@return void
function RaidLocation(location)
    if Raiding then return end

    Raiding = true
    -- 10 Second raid time
    local message = locale('raid_message'):format(location, Config.RaidCommand.CountDown)

    if Config.RaidCommand.AnnounceType == 1 then
        TriggerClientEvent('chat:addMessage', -1, {
            args = { message }
        })
    else
        message = locale('raid_announce'):format(location, Config.RaidCommand.CountDown)
        TriggerClientEvent('txcl:showAnnouncement', -1, message, 'LSPD')
    end
    
    -- Wait half the Config.RaidCommand.CountDown
    Wait(Config.RaidCommand.CountDown * 500)

    -- Announce the raid is about to happen
    message = locale('raid_message'):format(location, 5)

    if Config.RaidCommand.AnnounceType == 1 then
        TriggerClientEvent('chat:addMessage', -1, {
            args = { message }
        })
    else
        message = locale('raid_announce'):format(location, 5)
        TriggerClientEvent('txcl:showAnnouncement', -1, message, 'LSPD')
    end

    -- Wait 5 seconds
    Wait(5000)

    -- Chat message to show the raid has ended
    message = locale('raid_end'):format(location)

    if Config.RaidCommand.AnnounceType == 1 then
        TriggerClientEvent('chat:addMessage', -1, {
            args = { message }
        })
    else
        message = locale('raid_end_announce'):format(location)
        TriggerClientEvent('txcl:showAnnouncement', -1, message, 'LSPD')
    end

    SetTimeout(Config.RaidCommand.Duration * 60000, function()
        Raiding = false
    end)
end

-- Callback to check if the player has the required items to collect or process drugs
--@param src number
--@param drug string
--@param type string
--@return boolean
lib.callback.register('trase_drugs:server:check_requirements', function(src, drug, type)
    if not Config.Drugs[drug] then
        print(('^2[Trase_Drugs] ^1[ERROR] ^0The drug %s does not exist in the configuration.'):format(drug))
        return false
    end

    return CheckRequirements(src, drug, type)
end)