fx_version 'adamant'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

game 'rdr3'
lua54 'yes'
version '1.0'
author 'Bazante'

client_scripts { 
    'client/client.lua',
    'client/menu.lua'
}

server_scripts { 
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua'
}

shared_scripts {
    'config.lua'
}

files {
    'images/galinha.png',
    'images/beijo.png',
    'images/coinflip.png',
    'images/dancaselvagem.png',
    'images/gorila.png'
}
