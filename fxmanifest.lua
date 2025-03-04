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
    -- sql
    '@mysql-async/lib/MySQL.lua',
    'config.lua',
    'frameworks/**/server.lua',
    'server/open.lua',
    'server/server.lua',
    'server/versions.lua'
}

files {
    'locales/*.json'
}

escrow_ignore {
    -- Always ignore these:
    'config.lua',
    'client/*.lua',
    'server/*.lua',
    'server/versions.lua',
    'framework/**/*.lua',
}

dependencies {
    'mysql-async',
    'ox_lib'
}
