global_game_id = 0

function timer_Map(delay,f)
local g_id = global_game_id
timer.Simple(delay,function() if g_id == global_game_id then f() end end)
end

hook.Add('pd2_map_spawned','pd2_map_spawned',function()
	global_game_id = global_game_id+1
	stop_display_time()
	for i,p in pairs(player.GetAll()) do
		p:Spawn()
	end
	voted = false
	ctgang_pd2 = true
	pd2_taskbar_remove()
end)

hook.Add( "AcceptInput", "pd2_map", function( ent, name )
	if ent:GetName() == "button_start" and name == "Use" then
		for k, v in pairs(player.GetAll()) do
			if v:Team() == 1 then
				v:Freeze(true)
				v:SetNWBool("pd2brief", true)
				v:EmitSound('pd2_plan_music.ogg')
				v:ConCommand('pd2_hud_enable 0')
				v:SelectWeapon( "cw_extrema_ratio_official" )
				timer_Map(60, function() if IsValid(v) then
					v:SetNWBool("pd2brief", false)
					v:Freeze(false)
					v:ConCommand('pd2_hud_enable 1')
				end end)
			end
		end
		spawn = false
		ent:Remove()
		ents.FindByName('door_start')[1]:Fire('Toggle')
	end
end)