global_game_id = 0

hook.Add('pd2_map_spawned','pd2_map_spawned',function()
	global_game_id = global_game_id+1
end)

function timer_Map(delay,f)
local g_id = global_game_id
timer.Simple(delay,function() if g_id == global_game_id then f() end end)
end