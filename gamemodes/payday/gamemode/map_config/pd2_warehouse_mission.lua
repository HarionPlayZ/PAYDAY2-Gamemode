police_vectable = {Vector(3457.714600, 898.945679, 64.031250),Vector(5403.900391, 1574.928101, 64.031250),Vector(3070.912598, 273.047791, 64.031250),Vector(3070.912598, 273.047791, 64.031250)}
spawner_police = {Vector(3462.708984, 202.040253, 64.031250), Vector(5462.325195, 2032.598511, 64.031250), Vector(5099.486328, 493.386292, 64.031250)}
spawner_gang = Vector(-250.250427, 178.540894, -121.968750)
sniper_vectable = {Vector(),Vector()}
money_dif_pd2 = {2000, 5000, 10000, 18750, 30000, 45000, 80000}
xp_tables = {4500, 10000, 17500, 35000, 65000, 87500, 150000}

hook.Add('dril_comlited','pd2_warehouse_mission',function(id)
	ents.FindByName('door_vault')[1]:Fire('Open')
	pd2_taskbar_display_all('TAKE CASES',168)
end)

local case

timer.Create('escape_zone',0,0.1,function()
local ent_table = ents.FindInBox(Vector(3855,2565,-64),Vector(4050, 2280, -46))
	for i,p in pairs(ent_table) do
		if p:IsPlayer() then
			if p:Alive() and p:Team()==1 then
				p:SetNWInt('escape_time',p:GetNWInt('escape_time')+1)
				if p:GetNWInt('escape_time') >= 50 then
					hook.Call('escape',nil,p)
				end
				if p:GetNWBool('case') then
					p:SetNWBool('case',false)
				end
			end
		end
	end
	for i,p in pairs(player.GetAll()) do
		if not table.HasValue(ent_table,p) then p:SetNWInt('escape_time',0) end
	end
end)
timer.Stop('escape_zone')

hook.Add( "AcceptInput", "pd2_warehouse_mission", function( ent, name, activator, caller, data )
    if ent:GetName() == "button_start" then
		timer_Map(60, function() 
			gang_spawner()
			pd2_taskbar_display_all('HACK THE DOOR',212)
			start_display_time() 
			set_start_time(CurTime()) 
		end)
	end
	if ent:GetName() == "drill_button" then
		pd2_taskbar_display_all("WAIT AND DEFEND",240)
		dril_spawn(Vector(3540, -794, 104),Angle(0,0,0),'dril',300+global_dif*60)
		ent:Remove()
	end
	if ent:GetName() == "case_button" then
		if not activator:GetNWBool('case') then
			ents.FindByName('case')[1]:Fire('Kill')
			activator:SetNWBool('case',true)
			if case then ent:Remove() end
			case = true
			timer.Start('escape_zone')
			pd2_taskbar_display_all('YOU CAN ESCAPE',228)
		end
	end
	if ent:GetName() == "computer_button" then
		pd2_taskbar_display_all('HACKING IN PROGRESS',299)
		timer_Map(15*(global_dif+1),function()
			ents.FindByName('door_vault_start')[1]:Fire('Open')
			pd2_assault_starting()
			pd2_taskbar_display_all("PLACE DRILL ON VAULT",305)
			playsound(player.GetAll(),'pd2_bain_police_40.mp3')
			timer_Map(95,function() 
				for i,ent in pairs(ents.FindByName('door_breaking_ex')) do ent:Fire('Explode') end
				for i,ent in pairs(ents.FindByName('door_breaking')) do ent:Fire('Break') end 
			end)
			timer_Map(120, function() pd2_gamemode_police_spawners[7]:Disable() end)
		end)
		ent:Remove()
	end
	if ent:GetName() == "wall_trigger" and activator:Team()==1 then
		local wall
		for i,ent2 in pairs(ents.FindInSphere(ent:GetPos(),10)) do
			if ent2:GetClass()=='func_brush' then wall = ent2 end
		end
		if IsValid(wall) then
			if name=='FireUser1' then
				wall:Fire('Enable')
			else
				wall:Fire('Disable')
			end
		end
	end
end )


hook.Add('escape','pd2_warehouse_mission',function(ply)
	ply:SetPos(Vector(-330, 505, -122))
	ply:SetEyeAngles(Angle(0,0,0))
end)