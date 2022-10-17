fx_version 'cerulean'
game 'gta5'

client_script {
	'config.lua',
	'client/main.lua',
}

server_script {
	'@oxmysql/lib/MySQL.lua',
	"config.lua",
	"server/main.lua",
}

ui_page "nui/index.html"

files {
	'nui/index.html',
	'nui/script.js',
	'nui/style.css',
	'nui/img/*.png'
}

lua54 'yes'

escrow_ignore {
	"server/ownVehicle.lua",
	"config.lua"
}