fx_version 'cerulean'
game 'gta5'

description 'NADRP-Houses'
version '1.0.0'

ui_page 'html/index.html'

shared_scripts {
	'config.lua',
    '@NADRP-core/shared/locale.lua',
	'locales/en.lua'
}

client_scripts {
	'client/main.lua',
	'client/decorate.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua'
}

files {
	'html/index.html',
	'html/reset.css',
	'html/style.css',
	'html/script.js',
	'html/img/dynasty8-logo.png'
}

dependencies {
	'NADRP-core',
	'NADRP-interior',
	'NADRP-clothing',
	'NADRP-weathersync'
}

lua54 'yes'