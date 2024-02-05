local Config

CreateThread(function()
    Config = lib.callback.await('trase_drugs:server:grabConfig')

    for k, v in pairs(Config.Drugs) do
        if v.Collection and next(v.Collection.Locations) then
            for i = 1, #v.Collection.Locations do
                local point = lib.points.new({
                    coords = v.Collection.Locations[i],
                    distance = Config.Marker,
                })

                function point:onEnter()
                    TextUI(v.Collection.HelpText.Collect)
                end

                function point:onExit()
                    TextUI(false)
                end

                function point:nearby()
                    CreateMarker(self.coords.xyz)
                 
                    if self.currentDistance <= 2 and IsControlJustReleased(0, 38) then
                        print('inside marker', self.id, 'dunak is a '.. self.dunak)
                    end
                end
            end
        end

        if v.Process and next(v.Process.Locations) then
            for i = 1, #v.Process.Locations do
                local point = lib.points.new({
                    coords = v.Process.Locations[i],
                    distance = Config.Marker,
                })

                function point:onEnter()
                    TextUI(v.Collection.HelpText.Process)
                end

                function point:onExit()
                    TextUI(false)
                end

                function point:nearby()
                    CreateMarker(self.coords.xyz)
                end

                if self.currentDistance <= 2 and IsControlJustReleased(0, 38) then
                    print('inside marker', self.id, 'dunak is a '.. self.dunak)
                end
            end
        end
    end
end)