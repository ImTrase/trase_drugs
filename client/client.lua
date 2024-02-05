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
            end
        end
    end
end)