fx_version 'cerulean'
game 'gta5'

description 'denalifw-HouseRobbery'
version '1.0.0'

shared_scripts {
 'config.lua',
 '@denalifw-core/shared/locale.lua',
 'locales/en.lua'

}
client_script 'client/main.lua'
server_script 'server/main.lua'

lua54 'yes'