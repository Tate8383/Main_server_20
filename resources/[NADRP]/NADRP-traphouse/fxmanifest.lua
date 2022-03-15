fx_version 'cerulean'
game 'gta5'

description 'NADRP-Traphouse'
version '1.0.0'

ui_page 'html/index.html'

shared_scripts {
	'config.lua',
    '@NADRP-core/shared/locale.lua',
	'locales/*.lua'
}
client_script 'client/main.lua'
server_script 'server/main.lua'

server_exports {
    'AddHouseItem',
    'RemoveHouseItem',
    'GetInventoryData',
    'CanItemBeSaled'
}

files {
    'html/*'
}

lua54 'yes'