fx_version 'cerulean'
game 'gta5'

description 'denalifw-Drugs'
version '1.0.0'

shared_scripts {
    'config.lua',
    '@denalifw-core/shared/locale.lua',
    'locales/en.lua' -- Change this to your preferred language
}

client_scripts {
    'client/main.lua',
    'client/deliveries.lua',
    'client/cornerselling.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/deliveries.lua',
    'server/cornerselling.lua'
}

lua54 'yes'