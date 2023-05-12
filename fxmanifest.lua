fx_version 'adamant'
game 'gta5'

ui_page 'web/script-armas.html'

client_scripts {
    '@vrp/lib/utils.lua',
    'client.lua'
}   
server_scripts {
    '@vrp/lib/utils.lua',
    'server.lua'
}   

files {
    'web/*.html',
    'web/*.js',
    'web/*.css',
    'web/**/*'
}