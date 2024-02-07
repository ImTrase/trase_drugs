local lib = lib

local locale = locale
DiscordBenifits = {}

-- Create Thread that will loop with Wait(0) then break after connection
CreateThread(function()
    while true do
        Wait(0)
        if NetworkIsPlayerActive(PlayerId()) then
            TriggerServerEvent('trase_drugs:server:playerConnected')
            break
        end
    end
end)

local shownUI = {}

local function CreateDrugs()
    while not Config or not next(Config) do Wait(0) end

    for k, v in pairs(Config.Drugs) do
        if v.Collection and next(v.Collection.Locations) then
            for i = 1, #v.Collection.Locations do
                local point = lib.points.new({
                    coords = v.Collection.Locations[i],
                    distance = Config.Options.DrawDistance,
                })


                function point:nearby()
                    CreateMarker(self.coords.xyz)
                    local id = 'collect'.. i
                    if self.currentDistance <= 3 then
                        if not shownUI[id] then
                            shownUI[id] = true
                            TextUI(locale('prompt_collect'):format(v.Label))
                        end
                    elseif shownUI[id] then
                        shownUI[id] = nil
                        TextUI(false)
                    end
                 
                    if self.currentDistance <= 2 then
                        if IsControlJustReleased(0, 38) then
                            AttemptCollect(k, v)
                        end
                    end
                end
            end
        end

        if v.Process and next(v.Process.Locations) then
            for i = 1, #v.Process.Locations do
                local point = lib.points.new({
                    coords = v.Process.Locations[i],
                    distance = Config.Options.DrawDistance,
                })


                function point:nearby()
                    CreateMarker(self.coords.xyz)
                    local id = 'process'.. i
                    if self.currentDistance <= 2 then
                        if not shownUI[id] then
                            shownUI[id] = true
                            TextUI(locale('prompt_process'):format(v.Label))
                        end
                        if IsControlJustReleased(0, 38) then
                            AttemptProcess(k, v)
                        end
                    elseif shownUI[id] and self.currentDistance > 2 then
                        shownUI[id] = false
                        TextUI(false)
                    end
                end
            end
        end
    end
end

RegisterNetEvent('trase_drugs:client:syncData', function(data, drugRank)
    Config = data.config

    CreateDrugs()
    LocalPlayer.state.drugRank = drugRank
    if data.role then
        DiscordBenifits = data.role
    end
end)