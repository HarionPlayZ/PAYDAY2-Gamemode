global_game_id = 0

function timer_Map(delay,f)
local g_id = global_game_id
timer.Simple(delay,function() if g_id == global_game_id then f() end end)
end

hook.Add('pd2_map_spawned','pd2_map_spawned',function()
	global_game_id = global_game_id+1
	stop_display_time()
	voted = false
	ctgang_pd2 = true
	changeteam = true
	timer.Stop("ReCreateAssaultPhase")
	pd2_taskbar_remove()
	for i,p in pairs(player.GetAll()) do
		p:PD2SetSpectator()
	end
end)

hook.Add( "AcceptInput", "pd2_map", function( ent, name,activator )
	if not activator:IsPlayer() then return end
	if activator:Team()!=1 then return end
	if ent:GetName() == "button_start" and name == "Use" then
		gang_table = {}
		for i,p in pairs(player.GetAll()) do
			if p:Team() == 1 then
				p:Freeze(true)
				p:SetNWBool("pd2brief", true)
				p:EmitSound('pd2_plan_music.ogg')
				p:ConCommand('pd2_hud_enable 0')
				p:SelectWeapon( "cw_extrema_ratio_official" )
				timer_Map(60, function() if IsValid(p) then
					p:SetNWBool("pd2brief", false)
					p:Freeze(false)
					p:ConCommand('pd2_hud_enable 1')
				end end)
				table.insert(gang_table,p)
			end
		end
		spawn = false
		ent:Remove()
		ents.FindByName('door_start')[1]:Fire('Toggle')
		hook.Call('game_start')
	end
end)