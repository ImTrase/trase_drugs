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
    'frameworks/**/client.lua',
    'client/open.lua',
    'client/client.lua',
}

server_scripts {
    'config.lua',
    'frameworks/**/server.lua',
    'server/open.lua',
    'server/server.lua',
}

files {
    'locales/*.json'
}

escrow_ignore {
    -- Always ignore these:
    'config.lua',
    'client/open.lua',
}

--[[
    ToDo:

    Features:
    - Server-Sided Configuration to prevent modders getting the locations
    - Rank System with benefits (Speed, Multiplier, etc)
    - Collection and Processing of Drugs
    - Extensive Configuration for Collection and Processing (Rewards, Times, Requirements, etc)
    - Discord Role Benefits (Multiplier, etc) [Good for donators, VIP, etc]
    - Fully Customizable
    - Framework Support (ESX, QBCore, etc)
    - Localization Support
    - Easy to use and understand
    - Synchronized Props (configurable)
    - Synchronized Animations (configurable)


    Dependencies:
    - ox_lib
]]