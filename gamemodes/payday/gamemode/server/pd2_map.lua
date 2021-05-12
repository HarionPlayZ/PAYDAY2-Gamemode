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