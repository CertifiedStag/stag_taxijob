fx_version 'cerulean'
games {'gta5'}

author 'CertifiedStag'
Description 'Taxi Job'
version '1.0.0'

ui_page 'html/meter.html'

server_scripts {
    'config.lua',
    'sv_taxijob.lua'
}

client_scripts {
    'config.lua',
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    'cl_taxijob.lua'
    
}

files {
    'html/meter.css',
    'html/meter.html',
    'html/meter.js',
    'html/reset.css',
    'html/g5-meter.png'
}

lua54 'yes'
