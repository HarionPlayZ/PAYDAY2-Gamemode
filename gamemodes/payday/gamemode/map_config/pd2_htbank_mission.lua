police_vectable = {Vector(2993.843018, -903.920959, -1011.968750),Vector(-2020.054932, -1256.504272, -1015.977905),Vector(373.001007, 3383.392090, -1015.618347),Vector(373.001007, 3383.392090, -1015.618347)}
spawner_police = {Vector(2253.890625, 3140.556641, -1011.968750), Vector(2096.237305, -796.061829, -1011.981628), Vector(-982.990540, -749.902649, -1011.968750)}
sniper_vectable = {Vector(-481.048065, -439.249176, -559.968750),Vector(-857.031250, 281.031250, -735.968750)}
money_dif_pd2 = {1500, 4000, 7500, 17500, 30000, 42500, 75000}
xp_tables = {3000, 7500, 15000, 30000, 55000, 75500, 125000}
timer.Simple(0, function()
	local box = ents.Create('prop_dynamic')
	box:SetPos(Vector(261.842041, 671.552307, -678.417603))
	box:SetModel("models/props_wasteland/cargo_container01.mdl")
	box:SetSolid(SOLID_VPHYSICS)
	box:SetRenderMode(10)
	box:SetAngles(Angle(0, 0, 90))
	box:Spawn()
end)

local dril,can_escape,money_count,door_safe2
hook.Add('pd2_map_spawned','pd2_htbank_mission',function()
	door_safe2 = false
	can_escape = false
	money_count = 6
	timer.Stop('escape_zone')
end)

local function start_escape(id)
	if id == 1 then
		timer.Start('escape_zone')
		pd2_taskbar_display_all('WAIT ESCAPE VAN',240)
		timer_map(30,function() playsound(player.GetAll(),'pd2_bain_van_30.mp3') end)
		timer_map(60,function()
			playsound(player.GetAll(),'pd2_bain_van_0.mp3')
			pd2_taskbar_display_all('ESCAPE WITH MONEY',277)
			for i,ent in pairs(ents.FindByName('van_escape1')) do ent:Fire('Enable') end
		end)	
	end
	if id == 2 and not can_escape then 
		can_escape = true
		pd2_taskbar_display_all('YOU CAN ESCAPE',200)
	end
end

timer.Create('escape_zone',0,0.1,function()
local ent_table = ents.FindInBox(Vector(-2120, -794, -1015),Vector(-2140, -725, -1000))
	for i,p in pairs(ent_table) do
		if p:IsPlayer() then
			if p:Alive() and p:Team()==1 then
				p:SetNWInt('escape_time',p:GetNWInt('escape_time')+1)
				if p:GetNWInt('escape_time') >= 50 then
					if can_escape then
						hook.Call('escape',nil,p,(global_dif+1)*100*(4-money_count))
					else
						p:ChatPrint('you need more money bags: '..tostring(money_count-4))
					end
				end
				if p:GetNWBool('money') then
					p:SetNWBool('money',false)
					if money_count <= math.min(4) then 
						start_escape(2)
					end
				end
			end
		end
	end
	for i,p in pairs(player.GetAll()) do
		if not table.HasValue(ent_table,p) then p:SetNWInt('escape_time',0) end
	end
end)
timer.Stop('escape_zone')

hook.Add('dril_comlited','pd2_htbank_mission',function(id)
	if id == 'dril' then
		door_safe2 = true
		ents.FindByName('drill_spark')[1]:Fire('StopSpark')
		ents.FindByName('door_safe1')[1]:Fire('Open')
		dril:StopSound('pd2_td.wav')
		dril:Remove()
		ents.FindByName('drill_spark')[1]:Remove()	
	else
		pd2_taskbar_display_all('TAKE MONEY',175)
		local door = ents.FindByName('door_safe2')[1]
		door:Fire('Unlock')
	end
end)

hook.Add( "AcceptInput", "pd2_htbank_mission", function( ent, name, activator )
	if not activator:IsPlayer() then return end
	if activator:Team()!=1 then return end
	if ent:GetName() == "drill_button" then
		dril = ents.Create( "prop_dynamic" )
		dril:SetModel( "models/payday2/equipments/thermadrill.mdl" )
		dril:SetPos( Vector( 664, 1221, -979 ) )
		dril:SetAngles( Angle( 0, 0, 0 ) )
		dril:Spawn()
		dril:EmitSound("pd2_td.wav")
		ents.FindByName('drill_spark')[1]:Fire('StartSpark')
		pd2_taskbar_display_all('WAIT AND DEFEND',242)
		pd2_assault_starting()
		timer_map(5,function() playsound(player.GetAll(),'pd2_bain_police_40.mp3') end)
		timer_map(200,function() sniper_spawners() end)
		timer_map(360,function() hook.Call('dril_comlited',nil,'dril') end)
		ent:Remove()
	return end
	if ent:GetName() == "money_button" then
		if not activator:GetNWBool('money') then
			ents.FindByName('moneys')[1]:Fire('Kill')
			activator:SetNWBool('money',true)
			if money_count == 1 then ent:Remove() end
			if money_count == 6 then start_escape(1) end
			money_count = money_count - 1
		end
	return end
	if ent:GetName() == "door_safe2" and door_safe2 then
		dril_spawn(Vector(565, 1195, -970),Angle(0,180,0),'dril2',180)
		door_safe2 = false
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
	return end
end)				

hook.Add('game_start','pd2_htbank_mission',function()
	for i,p in pairs(global_gang_table) do	
		p:SetPos(Vector(-2055, -590, -1014) + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 100)
		p:SetEyeAngles(Angle(0,0,0))
	end
	pd2_taskbar_display_all("PLACE DRILL ON VAULT",304)  
	start_display_time() 
	guard_spawners()
end)

hook.Add('escape','pd2_htbank_mission',function(ply)
	ply:SetPos(Vector(3740, 2893, -471))
	ply:SetEyeAngles(Angle(0,0,0))
end)