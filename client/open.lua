-- Open source functions you can edit.
-- If you need support or have a question, join the discord: https://discord.gg/trase

local busy = false -- Used to prevent spamming.
local lib = lib -- Localize the lib table.
lib.locale()
local locale = locale -- Localize the locale function.


-- Draws the marker on the floors.
-- @param coords table
-- @return void
function CreateMarker(coords)
    DrawMarker(2, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 1.0, 200, 20, 20, 50, false, true, 2, false, nil, nil, false)
end

-- Utilizes the text UI to prompt the user to press a key.
-- @param text string | boolean
-- @return void
function TextUI(text)
    if text then
        lib.showTextUI(text)
    else
        lib.hideTextUI()
    end
end

-- Sends a notification to the player.
-- @param text string
-- @return void
function SendNotification(text)
    lib.notify(text)
end

-- Attempts to collect the drugs from the collection point.
-- @param drug string
-- @param data table
-- @return void
function AttemptCollect(drug, data)
    if (busy) then return end
    busy = true

    local canCollect = lib.callback.await('trase_drugs:server:check_requirements', false, drug, 'collect')
    if not canCollect then
        SendNotification(locale('missing_items'):format(canCollect))
        busy = false
        return
    end

    local time = data.Speeds.Collection * 1000

    local rank = LocalPlayer.state.drugRank
    if rank and tonumber(rank) and Config.Ranks[rank] then
        local rankData = Config.Ranks[rank]
        if rankData.Benifits and rankData.Benifits.CollectionSpeed then
            local finalSpeed = data.Speeds.Collection - (data.Speeds.Collection * (rankData.Benifits.CollectionSpeed / 100))
            time = finalSpeed * 1000
        end
    end

    local progressBar = {
        label = locale('progress_collect'):format(data.Label),
        duration = time,
        useWhileDead = false,
        canCancel = true,
        disable = { car = true, move = true, combat = true },
    }

    if data.anim then progressBar.anim = data.anim end
    if data.prop then progressBar.prop = data.prop end

    if lib.progressBar(progressBar) then
        TriggerServerEvent('trase_drugs:server:collect', drug)
        busy = false
        if Config.Options.AutoRepeat then
            Wait(100)
            AttemptCollect(drug, data)
        end
    end
end

-- Attempts to process the drugs from the processing point.
-- @param drug string
-- @param data table
-- @return void
function AttemptProcess(drug, data)
    if (busy) then return end
    busy = true

    local canProcess = lib.callback.await('trase_drugs:server:check_requirements', false, drug, 'process')
    if not canProcess then
        SendNotification(locale('missing_items'):format(canProcess))
        busy = false
        return
    end

    local time = data.Speeds.Process * 1000

    local rank = LocalPlayer.state.drugRank

    if rank and tonumber(rank) and Config.Ranks[rank] then
        local rankData = Config.Ranks[rank]
        if rankData.Benifits and rankData.Benifits.ProcessSpeed then
            local finalSpeed = data.Speeds.Process - (data.Speeds.Process * (rankData.Benifits.ProcessSpeed / 100))
            time = finalSpeed * 1000
        end
    end

    local progressBar = {
        label = locale('progress_process'):format(data.Label),
        duration = time,
        useWhileDead = false,
        canCancel = true,
        disable = { car = true, move = true, combat = true },
    }

    if data.anim then progressBar.anim = data.anim end
    if data.prop then progressBar.prop = data.prop end

    if lib.progressBar(progressBar) then
        TriggerServerEvent('trase_drugs:server:process', drug)
        busy = false
        if Config.Options.AutoRepeat then
            Wait(100)
            AttemptProcess(drug, data)
        end
    end
end