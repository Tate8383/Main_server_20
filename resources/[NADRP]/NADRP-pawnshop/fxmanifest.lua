fx_version 'cerulean'
game 'gta5'

description 'NADRP-Pawnshop'
version '1.0.0'

shared_scripts {
	'@NADRP-core/shared/locale.lua',
	'config.lua',
	'locales/en.lua',
}

server_script 'server/main.lua'

client_script 'client/main.lua'

lua54 'yes'