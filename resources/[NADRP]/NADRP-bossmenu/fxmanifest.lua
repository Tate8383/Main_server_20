fx_version 'cerulean'
game 'gta5'

description 'NADRP-BossMenu'
version '1.0.0'

client_scripts {
    '@menuv/menuv.lua',
    'config.lua',
    'client.lua'
}

server_script 'server.lua'

server_export 'GetAccount'

lua54 'yes'