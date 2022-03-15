fx_version 'cerulean'
game 'gta5'

description 'denalifw-HotdogJob'
version '1.0.0'

ui_page 'html/ui.html'

shared_scripts {
    '@denalifw-core/shared/locale.lua',
    'locales/en.lua',
    'config.lua'
}

client_script 'client/main.lua'
server_script 'server/main.lua'

files {
    'html/ui.html',
    'html/ui.css',
    'html/ui.js',
    'html/icon.png',
}

lua54 'yes'