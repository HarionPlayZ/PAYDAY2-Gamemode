resource.AddFile('materials/pr1.png')

global_dif = 0

pd2_path = 'gamemodes/payday/'
map_config_path = pd2_path..'gamemode/map_config/'..game.GetMap()..'.lua'
if file.Exists(map_config_path,'GAME') then
	include('map_config/'..game.GetMap()..'.lua')
else
	timer.Simple(0,function() hook.Call('map_custom_config') end)
end

--* Global registration
--? For subsequent call on the client side
AddCSLuaFile('shared.lua')

-- Registering helpers
AddCSLuaFile('helpers/sh_player_helper.lua')

-- Registering a working code
AddCSLuaFile('bleedout/bleedout.lua')
AddCSLuaFile('client/pd2_timer.lua')
AddCSLuaFile('client/pd2text.lua')
AddCSLuaFile('client/pd2_show_items.lua')
AddCSLuaFile('client/custody_pd2_icon.lua')
AddCSLuaFile('client/bleedout_client.lua')
AddCSLuaFile('client/pd2_assautphases.lua')
AddCSLuaFile('client/pd2_hud.lua')
AddCSLuaFile('client/pd2_outline.lua')
AddCSLuaFile('client/bleedout_client.lua')
AddCSLuaFile('client/pd2_drawscreen.lua')
AddCSLuaFile('shared/pd2_class_triggers.lua')
AddCSLuaFile('shared/pd2_sound.lua')
AddCSLuaFile('shared/bleedout_init.lua')
AddCSLuaFile('cl_init.lua')


--* Server script initialization
--? shared.lua - is called simultaneously on both the client and the server.
--? Recommended only for generic elements
include('shared.lua')

-- Initializing helpers

-- Initializing working code
include('server/pd2_hud.lua')
include('server/pd2_assautphases.lua')
include('server/pd2_assault_settings.lua')
include('bleedout/bleedout.lua')
include('server/custody_pd2.lua')
include('server/pd2_armor.lua')
include('server/functions.lua')
include('server/pd2_hook.lua')
include('server/pd2_teams.lua')
include('server/pd2_moneyshop.lua')
include('server/pd2_xplevel.lua')
include('server/pd2_map.lua')
include('shared/pd2_class_triggers.lua')
include('server/pd2_dril.lua')


function GM:PlayerSetHandsModel(ply, ent)
	local simplemodel = player_manager.TranslateToPlayerModelName(ply:GetModel())
	local info = player_manager.TranslatePlayerHands(simplemodel)
	if info then
		ent:SetModel(info.model)
		ent:SetSkin(info.skin)
		ent:SetBodyGroups(info.body)
	end
end
