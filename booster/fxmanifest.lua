fx_version 'cerulean'

game 'gta5'

lua54 'yes'

client_scripts{
    'client.lua'
}

server_script{
    'server.lua'
}

shared_scripts{
    'config.lua'
}

server_script '@oxmysql/lib/MySQL.lua'
shared_script '@ox_lib/init.lua'