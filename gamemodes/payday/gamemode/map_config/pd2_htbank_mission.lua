police_vectable = {Vector(2993.843018, -903.920959, -1011.968750),Vector(-2020.054932, -1256.504272, -1015.977905),Vector(373.001007, 3383.392090, -1015.618347),Vector(373.001007, 3383.392090, -1015.618347)}
spawner_police = {Vector(2253.890625, 3140.556641, -1011.968750), Vector(2096.237305, -796.061829, -1011.981628), Vector(-982.990540, -749.902649, -1011.968750)}
spawner_gang = Vector(3849.046631, 2554.394531, -470.968750)
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

local dril,can_escape,game_win
local money_count = 6
local function start_escape(id)
	if id == 1 then
		timer.Start('escape_zone')
		pd2_taskbar_display_all('WAIT ESCAPE VAN',240)
		timer_Map(30,function() playsound(player.GetAll(),'pd2_bain_van_30.mp3') end)
		timer_Map(60,function()
			playsound(player.GetAll(),'pd2_bain_van_0.mp3')
			for i,ent in pairs(ents.FindByName('van_escape1')) do ent:Fire('Enable') end
		end)	
	end
	if id == 2 and not can_escape then 
		can_escape = true
		pd2_taskbar_display_all('YOU CAN ESCAPE')
	end
end

timer.Create('escape_zone',0,0.1,function()
local ent_table = ents.FindInBox(Vector(-2120, -794, -1015),Vector(-2140, -725, -1000))
	for i,p in pairs(ent_table) do
		if p:IsPlayer() then
			if p:Alive() then
				p:SetNWInt('escape_time',p:GetNWInt('escape_time')+1)
				if p:GetNWInt('escape_time') >= 50 and can_escape then
					p:SetPos(Vector(3740, 2893, -471))
					p:SetEyeAngles(Angle(0,0,0))
					if not game_win then
						startending()
						game_win = true
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

hook.Add( "AcceptInput", "pd2_htbank_mission", function( ent, name, activator, caller, data )
	if ent:GetName() == "button_start" then
		timer_Map(60,function()
			ents.FindByName('tele_start')[1]:Fire('Enable')
			pd2_taskbar_display_all("PLACE DRILL ON VAULT",300)  
			start_display_time() 
			set_start_time(CurTime()) 
			guard_spawners()
		end)
	end
	if ent:GetName() == "drill_button" then
		dril = ents.FindByName('thermadrill_model')[1]
		dril:EmitSound("pd2_td.wav")
		dril:Fire('Enable')
		pd2_taskbar_display_all('WAIT AND DEFEND',242)
		ents.FindByName('drill_spark')[1]:Fire('StartSpark')
		pd2_assault_starting()
		timer_Map(5,function() playsound(player.GetAll(),'pd2_bain_police_40.mp3') end)
		timer_Map(200,function() sniper_spawners() end)
		timer_Map(360,function() hook.Call('dril_comlited') end)
		-- timer_Map(5,function() hook.Call('dril_comlited') end)
		ent:Remove()
	end
	if ent:GetName() == "money_button" then
		if not activator:GetNWBool('money') then
			ents.FindByName('moneys')[1]:Fire('Kill')
			activator:SetNWBool('money',true)
			if money_count == 1 then ent:Remove() end
			if money_count == 6 then start_escape(1) end
			money_count =  money_count - 1
		end
	end
end)

hook.Add('dril_comlited','pd2_htbank_mission',function(id)
	pd2_taskbar_display_all('TAKE MONEY',175)
	ents.FindByName('drill_spark')[1]:Fire('StopSpark')
	ents.FindByName('door_safe1')[1]:Fire('Open')
	dril:StopSound('pd2_td.wav')
	dril:Remove()
end)
