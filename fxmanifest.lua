fx_version 'cerulean'
games { 'gta5' }

author 'Trase'
lua54 'yes'
description 'Complete FiveM Drug System'
version '1.0.0'

shared_script {
    '@ox_lib/init.lua'
}

client_scripts {
    'client/open.lua',
    'client/client.lua',
}

server_scripts {
    'config.lua',
}

escrow_ignore {
    -- Always ignore these:
    'config.lua',
    'client/open.lua',
}

--[[
    ToDo:
    - Collect all the drugs


    Features:
    - Server-Sided Configuration to prevent modders getting the locations


    Dependencies:
    - ox_lib
]]