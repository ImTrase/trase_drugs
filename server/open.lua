-- Function to get the Config.Ranks correct rank label
--@param target number
--@return number, table
function GetRankData(target)
    local drugsSold = exports.trase_dealer:CountDrugs(target)

    -- Loop through Config.Ranks and get the highest rank the player has
    local rank = 1
    for i = 1, #Config.Ranks do
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