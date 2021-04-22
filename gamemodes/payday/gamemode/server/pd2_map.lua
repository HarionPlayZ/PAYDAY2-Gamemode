local map = game.GetMap()
global_game_id = 0

function timer_Map(delay,f)
local g_id = global_game_id
timer.Simple(delay,function() if g_id == global_game_id then f() end end)
end

local alarm
hook.Add('alarm','alarm',function()
	if alarm then return end
	alarm = true
	pd2_assault_starting()
	if map == 'pd2_jewelry_store_mission' then
		sound.Play( "alarm1.mp3", Vector(-3850, 1920, 120) )
		playsound(player.GetAll(),'pd2_obj.mp3')
		playsound(player.GetAll(),'pd2_bain_alarm.mp3')
		timer_Map(5,function() playsound(player.GetAll(),'pd2_bain_police_40.mp3') end)
		timer_Map(40,function()
			local car = ents.FindByName('police_car')[1] 
			if IsValid(car) then car:Fire('Enable') end
			timer.Start('police_light')
		end)
	end
end)

local pcb,pcr
if map == 'pd2_jewelry_store_mission' then
	timer.Create('police_light',0.25,0,function()
		timer.Stop('police_light')
		pcb:Fire('TurnOn')
		pcr:Fire('TurnOff')
		timer_Map(0.25,function()
			pcb:Fire('TurnOff')
			pcr:Fire('TurnOn')
			timer.Start('police_light')
		end)
	end)
end

hook.Add('pd2_map_spawned','pd2_map_spawned',function()
	global_game_id = global_game_id+1
	if map == 'pd2_jewelry_store_mission' then
		timer.Stop('police_light')
		pcb = ents.FindByName('police_car_blue')[1]
		pcr = ents.FindByName('police_car_red')[1]
	end
end)

hook.Add('dril_comlited','dril_comlited',function(id)
	if map == 'pd2_jewelry_store_mission' then
		ents.FindByName('drill_spark')[1]:Fire('StopSpark')
		local safe = ents.FindByModel('models/payday2/otherprops/safe.mdl')[1]
		safe:Fire('SetAnimationNoReset','opening')
		local safe_door = ents.FindByName('safe_coll')[1]
		safe_door:Fire('Toggle')
	end
end)