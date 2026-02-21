fx_version 'adamant'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

game 'rdr3'
lua54 'yes'
version '1.0.0'
author 'huzurweriN'

ui_page 'html/index.html'

shared_scripts {
    'shared/config.lua',
    'locale.lua',
    'languages/*.lua',
}

client_scripts {
    'client/functions.lua',
    'client/props.lua',
    'client/main.lua',
    'client/menuSetup.lua',
}

server_scripts {
    'server/main.lua',
}

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'images/phone.png',
}

dependencies {
    'vorp_core',
}
