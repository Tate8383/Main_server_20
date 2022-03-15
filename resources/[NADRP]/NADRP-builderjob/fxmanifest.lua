fx_version 'cerulean'
game 'gta5'

description 'denalifw-BuilderJob'
version '1.0.0'

shared_scripts {
	'@denalifw-core/shared/locale.lua',
	'locales/en.lua',
	'config.lua'
}

client_script 'client/main.lua'

server_script 'server/main.lua'

lua54 'yes'