fx_version 'cerulean'
games {'gta5'}

author 'CertifiedStag'
Description 'Taxi Job'
version '1.0.0'

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

lua54 'yes'
