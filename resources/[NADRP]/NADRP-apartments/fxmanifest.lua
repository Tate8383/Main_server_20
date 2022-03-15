fx_version 'cerulean'
game 'gta5'

description 'NADRP-Apartments'
version '1.0.0'

shared_scripts {
    'config.lua',
    '@NADRP-core/shared/locale.lua',
    'locales/en.lua', -- Change to the language you want
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

client_scripts {
	'client/main.lua',
	'client/gui.lua'
}

dependencies {
	'NADRP-core',
	'NADRP-interior',
	'NADRP-clothing',
	'NADRP-weathersync'
}

lua54 'yes'
