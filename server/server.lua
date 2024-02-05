lib.callback.register('trase_drugs:server:grabConfig', function()
    -- Load the only needed configuration values to the client.
    local cfg = {}
    cfg.DrawDistance = Config.DrawDistance
    cfg.Drugs = Config.Drugs
    return cfg
end)