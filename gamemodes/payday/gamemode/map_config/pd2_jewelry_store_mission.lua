police_vectable = {Vector(-5835.604980, 810.292603, 68.031250),Vector(-4622.043457, 3271.763184, 68.031250),Vector(-5835.604980, 810.292603, 68.031250),Vector(-4622.043457, 3271.763184, 68.031250)}
spawner_police = {Vector(-4158.414063, 3250.695801, 68.031250), Vector(-4641.425781, 468.396393, 68.031250), Vector(-5929.043457, 1284.832031, 68.031250)}
spawner_gang = Vector(4876.448730, -1681.583130, 68.031250)
sniper_vectable = {Vector(),Vector()}
money_dif_pd2 = {1000, 2500, 5000, 10000, 17500, 25000, 50000}
xp_tables = {2000, 5000, 10000, 20000, 37500, 50000, 75000}

local can_pickup_gold,alarm = false
hook.Add('pd2_map_spawned','pd2_htbank_mission',function()
	alarm = false
	can_pickup_gold = false
	timer.Stop('escape_zone')
end)

hook.Add('alarm','alarm',function()
	if alarm then return end
	alarm = true
	for i,ent i pairs(ents.FindByName('van_escape')) do ent:Fire('Disable') end
	pd2_taskbar_display_all("STEAL CASH IN SAFE",271)
	pd2_assault_starting()
	sound.Play( "alarm1.mp3", Vector(-3850, 1920, 120) )
	playsound(player.GetAll(),'pd2_bain_alarm.mp3')
	timer_Map(5,function() playsound(player.GetAll(),'pd2_bain_police_40.mp3') end)
	timer_Map(40,function()
		local car = ents.FindByName('police_car')[1] 
		if IsValid(car) then car:Fire('Enable') end
		timer.Start('police_light')
	end)
end)

local pcb,pcr
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

timer.Create('escape_zone',0,0.1,function()
local ent_table = ents.FindInBox(Vector(-5185, 2368, 68),Vector(-5345, 2272, 75))
	for i,p in pairs(ent_table) do
		if p:IsPlayer() then
			if p:Alive() and p:Team()==1 then
				p:SetNWInt('escape_time',p:GetNWInt('escape_time')+1)
				if p:GetNWInt('escape_time') >= 50 then
					hook.Call('escape',nil,p)
				end
			end
		end
	end
	for i,p in pairs(player.GetAll()) do
		if not table.HasValue(ent_table,p) and p:Team()==1 then p:SetNWInt('escape_time',0) end
	end
end)
timer.Stop('escape_zone')

hook.Add('pd2_map_spawned','pd2_jewelry_store_mission',function()
	timer.Stop('police_light')
	pcb = ents.FindByName('police_car_blue')[1]
	pcr = ents.FindByName('police_car_red')[1]
end)

hook.Add('dril_comlited','pd2_jewelry_store_mission',function(id)
	ents.FindByModel('models/payday2/otherprops/safe.mdl')[1]:Fire('SetAnimationNoReset','opening')
	ents.FindByName('safe_coll')[1]:Fire('Toggle')
	can_pickup_gold = true
end)

hook.Add( "AcceptInput", "pd2_jewelry_store_mission", function( ent, name, activator, caller, data )
	if not activator:IsPlayer() then return end
	if activator:Team()!=1 then return end
	if ent:GetName() == "drill_button" then
		pd2_taskbar_display_all("WAIT AND DEFEND",240)
		dril_spawn(Vector(-3525, 1708, 75),Angle(0,130,0),'dril',300)
		ent:Remove()
	end
	if ent:GetName() == "gold" and can_pickup_gold then
		pd2_taskbar_display_all("WAIT VAN",137)
		ents.FindByName('money')[1]:Fire('kill')
		timer_Map(30,function() playsound(gang_table,'pd2_bain_van_30.mp3') end)
		timer_Map(60,function()
			playsound(gang_table,'pd2_bain_van_0.mp3')
			ents.FindByName('van_escape')[1]:Fire('Enable')
			pd2_taskbar_display_all("YOU CAN ESCAPE",228.5)
			timer.Start('escape_zone')
		end)
		ent:Remove()
	end
end )

hook.Add('game_start','pd2_jewelry_store_mission',function()
	timer_Map(60, function() 
		pd2_taskbar_display_all("PLACE DRILL ON SAFE",290)  
		start_display_time()
		for i,p in pairs(gang_table) do
			p:SetPos(Vector(-5290, 2315, 67))
			p:SetEyeAngles(Angle(0,0,0))
		end
	end)
end)

hook.Add('escape','pd2_jewelry_store_mission',function(ply)
	ply:SetPos(Vector(4855, -1345, 60))
	ply:SetEyeAngles(Angle(0,0,0))
end)