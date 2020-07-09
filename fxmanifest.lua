fx_version 'adamant'
games { 'gta5' };


client_scripts {
    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",

    "src/components/*.lua",

    "src/menu/elements/*.lua",

    "src/menu/items/*.lua",

    "src/menu/panels/*.lua",

    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua",

}



client_scripts {
    'cl_side.lua',

    -- module
    'module/transport.lua',
    'module/voleVehicule.lua',
    'module/braquo.lua',
    'module/scooter.lua',
}


server_script {
    "srv_side.lua",
    "config.lua",
}