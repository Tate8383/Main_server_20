fx_version 'cerulean'
game 'gta5'

description 'denalifw-Apartments'
version '1.0.0'

shared_scripts {
    'config.lua',
    '@denalifw-core/shared/locale.lua',
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
	'denalifw-core',
	'denalifw-interior',
	'denalifw-clothing',
	'denalifw-weathersync'
}

lua54 'yes'
