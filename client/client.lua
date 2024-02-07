local lib = lib

local locale = locale


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

local function CreateDrugs()
    while not Config or not next(Config) do Wait(0) end

    for k, v in pairs(Config.Drugs) do
        if v.Collection and next(v.Collection.Locations) then
            for i = 1, #v.Collection.Locations do
                local point = lib.points.new({
                    coords = v.Collection.Locations[i],
                    distance = Config.Options.DrawDistance,
                })

                function point:onEnter()
                    --@Todo: Add a localized string for this.
                    TextUI(locale('prompt_collect'):format(v.Label))
                end

                function point:onExit()
                    TextUI(false)
                end

                function point:nearby()
                    CreateMarker(self.coords.xyz)
                 
                    if self.currentDistance <= 2 and IsControlJustReleased(0, 38) then
                        AttemptCollect(k, v)
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

                function point:onEnter()
                    --@Todo: Add a localized string for this.
                    TextUI(locale('prompt_process'):format(v.Label))
                end

                function point:onExit()
                    TextUI(false)
                end

                function point:nearby()
                    CreateMarker(self.coords.xyz)

                    if self.currentDistance <= 2 and IsControlJustReleased(0, 38) then
                        AttemptProcess(k, v)
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
end)