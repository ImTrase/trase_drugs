-- Function to get the Config.Ranks correct rank label
--@param target number
--@return number, table
function GetRankData(target)
    local drugsSold = CountDrugs(target)

    -- Loop through Config.Ranks and get the highest rank the player has
    local rank = 0
    for i = 1, #Config.Ranks do
        if (drugsSold >= Config.Ranks[i].SellRequirement) then
            rank = i
        end
    end

    return rank, Config.Ranks[rank]
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

    local requierments = type == 'collect' and Config.Drugs[drug].Collection.Requirements or Config.Drugs[drug].Process.Requirements
    if not requierments or not next(requierments) then return true end

    for item, amount in pairs(requierments) do
        local count = CountItem(src, item)
        if count < amount then
            return false, GetItemLabel(item)
        end
    end

    return true
end)