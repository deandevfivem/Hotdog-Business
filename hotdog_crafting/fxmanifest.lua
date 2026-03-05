fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'hotdog_business'
author 'Dean'
description 'Hotdog Business System'
version '2.0.0'

shared_scripts {
    '@ox_lib/init.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

dependencies {
    'ox_lib',
    'ox_inventory',
    'Renewed-Banking'
}