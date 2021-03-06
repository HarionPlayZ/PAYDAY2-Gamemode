local con1 = GetConVar( "pd2_assaultphases_serverphases" )
local con2 = GetConVar( "pd2_assaultphases_server_assaultphase" )
local con3 = GetConVar( "pd2_assaultphases_server_music" )
local con4 = GetConVar( "pd2_assaultphases_server_assaultbar_difficulty" )
local con5 = GetConVar( "pd2_assaultphases_server_assaultbar_captainenabled" )
local con7 = GetConVar( "pd2_assaultphases_server_controlduration" )

local timer_c = math.random( 60, 240 )
local timer_s = math.random( 30, 120 )

start_player_police = false

timer.Create("singleplayererror", 0.5, 0, function()
	for k, v in pairs(player.GetAll()) do
		v:ChatPrint("Please launch gamemode in multiplayer!")
		v:EmitSound("buttons/combine_button_locked.wav")
	end
end)


hook.Add( "Initialize", "pd2_load_vec", function()
	if game.GetMap() == "pd2_jewelry_store_mission" then
		vec1 = Vector(-5835.604980, 810.292603, 68.031250)
		vec2 = Vector(-4622.043457, 3271.763184, 68.031250)
		vec3 = Vector(-5835.604980, 810.292603, 68.031250)
		vec4 = Vector(-4622.043457, 3271.763184, 68.031250)
		random_spawn_p = {Vector(-4158.414063, 3250.695801, 68.031250), Vector(-4641.425781, 468.396393, 68.031250), Vector(-5929.043457, 1284.832031, 68.031250)}
		vec_p2 = Vector(4876.448730, -1681.583130, 68.031250)
		vec_1_s = Vector()
		vec_2_s = Vector()
		money_dif_pd2 = {1000, 2500, 5000, 10000, 17500, 25000, 50000}
		xp_tables = {2000, 5000, 10000, 20000, 37500, 50000, 75000}
	end
	if game.GetMap() == "pd2_warehouse_mission" then
		vec1 = Vector(3457.714600, 898.945679, 64.031250)
		vec2 = Vector(5403.900391, 1574.928101, 64.031250)
		vec3 = Vector(3070.912598, 273.047791, 64.031250)
		vec4 = Vector(3070.912598, 273.047791, 64.031250)
		random_spawn_p = {Vector(3462.708984, 202.040253, 64.031250), Vector(5462.325195, 2032.598511, 64.031250), Vector(5099.486328, 493.386292, 64.031250)}
		vec_p2 = Vector(-250.250427, 178.540894, -121.968750)
		vec_1_s = Vector()
		vec_2_s = Vector()
		money_dif_pd2 = {2000, 5000, 10000, 18750, 30000, 45000, 80000}
		xp_tables = {4500, 10000, 17500, 35000, 65000, 87500, 150000}
	end
	if game.GetMap() == "pd2_htbank_mission" then
		vec1 = Vector(2993.843018, -903.920959, -1011.968750)
		vec2 = Vector(-2020.054932, -1256.504272, -1015.977905)
		vec3 = Vector(373.001007, 3383.392090, -1015.618347)
		vec4 = Vector(373.001007, 3383.392090, -1015.618347)
		random_spawn_p = {Vector(2253.890625, 3140.556641, -1011.968750), Vector(2096.237305, -796.061829, -1011.981628), Vector(-982.990540, -749.902649, -1011.968750)}
		vec_p2 = Vector(3849.046631, 2554.394531, -470.968750)
		vec_1_s = Vector(-481.048065, -439.249176, -559.968750)
		vec_2_s = Vector(-857.031250, 281.031250, -735.968750)
		money_dif_pd2 = {1500, 4000, 7500, 17500, 30000, 42500, 75000}
		xp_tables = {3000, 7500, 15000, 30000, 55000, 75500, 125000}
		----------------------------
		timer.Simple(1, function()
			local box = ents.Create('prop_dynamic')
			box:SetPos(Vector(261.842041, 671.552307, -678.417603))
			box:SetModel("models/props_wasteland/cargo_container01.mdl")
			box:SetSolid(SOLID_VPHYSICS)
			box:SetRenderMode(10)
			box:SetAngles(Angle(0, 0, 90))
			box:Spawn()
		end)
	end
	timer.Stop("singleplayererror")
	if game.SinglePlayer() then
		timer.Start("singleplayererror")
	end
end)

pd2_gamemode_police_spawners = {}
pd2_ammo = {}
pd2_random_music = {"razormind", "tick_tock", "searchlights", "utter_chaos", "full_force_forward", "donacdum", "wanted_dead_or_alive", "iwgyma", "sirens_in_the_distance", "shadows_and_trickery", "shoutout", "the_mark", "ho_ho_ho", "dead_mans_hand", "armed_to_the_teeth", "black_yellow_moebius", "backstab", "breach_2015", "calling_all_units", "death_row", "death_wish", "gun_metal_grey_2015", "fuse_box", "locke_and_load", "wheres_the_van", "time_window", "pimped_out_getaway", "8_bits_are_scary", "code_silver_2018", "hot_pursuit", "ode_to_greed", "the_gauntlet"}

con3:SetString(pd2_random_music[math.random(1,32)])

function police_spawners()
	con5:SetInt( 0 )
	local spawnpd2 = ents.Create("sb_advanced_nextbot_payday2_spawner")
	spawnpd2:SetModel("models/props_junk/sawblade001a.mdl")
	spawnpd2:SetPos( vec1 )
	spawnpd2:PhysicsInit(SOLID_VPHYSICS)
	spawnpd2:SetMoveType(MOVETYPE_VPHYSICS)
	spawnpd2:SetSolid(SOLID_VPHYSICS)
	spawnpd2:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	pd2_gamemode_police_spawners[2] = spawnpd2
	
	spawnpd2:GetPhysicsObject():EnableMotion(false)
	
	spawnpd2.NextSpawn = CurTime()+1
	spawnpd2.BotsToRemove = {}
	spawnpd2.GroupsToRemove = {}
	spawnpd2.GCTime = 0
	spawnpd2.m_difficulty = GetConVar( "padpd2" ):GetInt()+1
	spawnpd2.m_maxonmap = maxonmap or 0
	spawnpd2.m_hpdiff = hpdiff or 0
	spawnpd2.m_prof = prof or 0
	spawnpd2.m_classes = classes or {}
	spawnpd2.m_policechase = 1
	spawnpd2.m_spawndelay = 1
	spawnpd2:Spawn()
	spawnpd2:SetRenderMode(10)
	spawnpd2:Disable()


	local spawnpd3 = ents.Create("sb_advanced_nextbot_payday2_spawner")
	spawnpd3:SetModel("models/props_junk/sawblade001a.mdl")
	spawnpd3:SetPos( vec2 )
	spawnpd3:PhysicsInit(SOLID_VPHYSICS)
	spawnpd3:SetMoveType(MOVETYPE_VPHYSICS)
	spawnpd3:SetSolid(SOLID_VPHYSICS)
	spawnpd3:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	pd2_gamemode_police_spawners[3] = spawnpd3
	
	spawnpd3:GetPhysicsObject():EnableMotion(false)
	
	spawnpd3.NextSpawn = CurTime()+1
	spawnpd3.BotsToRemove = {}
	spawnpd3.GroupsToRemove = {}
	spawnpd3.GCTime = 0
	spawnpd3.m_difficulty = GetConVar( "padpd2" ):GetInt()+1
	spawnpd3.m_maxonmap = maxonmap or 0
	spawnpd3.m_hpdiff = hpdiff or 0
	spawnpd3.m_prof = prof or 0
	spawnpd3.m_classes = classes or {}
	spawnpd3.m_policechase = 1
	spawnpd3.m_spawndelay = 1
	spawnpd3:Spawn()
	spawnpd3:SetRenderMode(10)
	spawnpd3:Disable()



	local spawnpd5 = ents.Create("sb_advanced_nextbot_payday2_spawner")
	spawnpd5:SetModel("models/props_junk/sawblade001a.mdl")
	spawnpd5:SetPos( vec3 )
	spawnpd5:PhysicsInit(SOLID_VPHYSICS)
	spawnpd5:SetMoveType(MOVETYPE_VPHYSICS)
	spawnpd5:SetSolid(SOLID_VPHYSICS)
	spawnpd5:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	pd2_gamemode_police_spawners[1] = spawnpd5
	
	spawnpd5:GetPhysicsObject():EnableMotion(false)
	
	spawnpd5.NextSpawn = CurTime()+1
	spawnpd5.BotsToRemove = {}
	spawnpd5.GroupsToRemove = {}
	spawnpd5.GCTime = 0
	spawnpd5.m_difficulty = 8
	spawnpd5.m_maxonmap = maxonmap or 0
	spawnpd5.m_hpdiff = hpdiff or 0
	spawnpd5.m_prof = prof or 0
	spawnpd5.m_classes = classes or {}
	spawnpd5.m_policechase = 1
	spawnpd5.m_spawndelay = 1
	spawnpd5:Spawn()
	spawnpd5:SetRenderMode(10)
	spawnpd5:Disable()


	local spawnpd4 = ents.Create("sb_advanced_nextbot_payday2_spawner")
	spawnpd4:SetModel("models/props_junk/sawblade001a.mdl")
	spawnpd4:SetPos( vec4 )
	spawnpd4:PhysicsInit(SOLID_VPHYSICS)
	spawnpd4:SetMoveType(MOVETYPE_VPHYSICS)
	spawnpd4:SetSolid(SOLID_VPHYSICS)
	spawnpd4:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	pd2_gamemode_police_spawners[4] = spawnpd4
	
	spawnpd4:GetPhysicsObject():EnableMotion(false)
	
	spawnpd4.NextSpawn = CurTime()+1
	spawnpd4.BotsToRemove = {}
	spawnpd4.GroupsToRemove = {}
	spawnpd4.GCTime = 0
	spawnpd4.m_difficulty = 9
	spawnpd4.m_maxonmap = maxonmap or 0
	spawnpd4.m_hpdiff = hpdiff or 0
	spawnpd4.m_prof = prof or 0
	spawnpd4.m_classes = classes or {}
	spawnpd4.m_policechase = 1
	spawnpd4.m_spawndelay = 1
	spawnpd4:Spawn()
	spawnpd4:SetRenderMode(10)
	spawnpd4:Disable()


end

function sniper_spawners()
	local spawnsniper = ents.Create("sb_advanced_nextbot_payday2_spawner")
	spawnsniper:SetModel("models/props_junk/sawblade001a.mdl")
	spawnsniper:SetPos( vec_1_s )
	spawnsniper:PhysicsInit(SOLID_VPHYSICS)
	spawnsniper:SetMoveType(MOVETYPE_VPHYSICS)
	spawnsniper:SetSolid(SOLID_VPHYSICS)
	spawnsniper:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	pd2_gamemode_police_spawners[5] = spawnsniper
	
	spawnsniper:GetPhysicsObject():EnableMotion(false)
	
	spawnsniper.NextSpawn = CurTime()+1
	spawnsniper.BotsToRemove = {}
	spawnsniper.GroupsToRemove = {}
	spawnsniper.GCTime = 0
	spawnsniper.m_difficulty = 10
	spawnsniper.m_maxonmap = maxonmap or 0
	spawnsniper.m_hpdiff = hpdiff or 0
	spawnsniper.m_prof = prof or 0
	spawnsniper.m_classes = classes or {}
	spawnsniper.m_policechase = 1
	spawnsniper.m_spawndelay = 1
	spawnsniper:Spawn()
	spawnsniper:SetRenderMode(10)
	spawnsniper:Enable()
	timer.Simple(1.1, function() spawnsniper:Disable() end)

    local spawnsniper2 = ents.Create("sb_advanced_nextbot_payday2_spawner")
	spawnsniper2:SetModel("models/props_junk/sawblade001a.mdl")
	spawnsniper2:SetPos( vec_2_s )
	spawnsniper2:PhysicsInit(SOLID_VPHYSICS)
	spawnsniper2:SetMoveType(MOVETYPE_VPHYSICS)
	spawnsniper2:SetSolid(SOLID_VPHYSICS)
	spawnsniper2:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	pd2_gamemode_police_spawners[6] = spawnsniper2
	
	spawnsniper2:GetPhysicsObject():EnableMotion(false)
	
	spawnsniper2.NextSpawn = CurTime()+1
	spawnsniper2.BotsToRemove = {}
	spawnsniper2.GroupsToRemove = {}
	spawnsniper2.GCTime = 0
	spawnsniper2.m_difficulty = 10
	spawnsniper2.m_maxonmap = maxonmap or 0
	spawnsniper2.m_hpdiff = hpdiff or 0
	spawnsniper2.m_prof = prof or 0
	spawnsniper2.m_classes = classes or {}
	spawnsniper2.m_policechase = 1
	spawnsniper2.m_spawndelay = 1
	spawnsniper2:Spawn()
	spawnsniper2:SetRenderMode(10)
	spawnsniper2:Enable()
	timer.Simple(1.1, function() spawnsniper2:Disable() end)

	for k, v in pairs(player.GetAll()) do
		v:EmitSound('pd2_bain_sniper.mp3')
	end

end

function guard_spawners()

	local spawnguard = ents.Create("sb_advanced_nextbot_payday2_spawner")
	spawnguard:SetModel("models/props_junk/sawblade001a.mdl")
	spawnguard:SetPos( Vector(-37.370724, 1337.254272, -911.968750) )
	spawnguard:PhysicsInit(SOLID_VPHYSICS)
	spawnguard:SetMoveType(MOVETYPE_VPHYSICS)
	spawnguard:SetSolid(SOLID_VPHYSICS)
	spawnguard:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	pd2_gamemode_police_spawners[7] = spawnguard
	
	spawnguard:GetPhysicsObject():EnableMotion(false)
	
	spawnguard.NextSpawn = CurTime()+1
	spawnguard.BotsToRemove = {}
	spawnguard.GroupsToRemove = {}
	spawnguard.GCTime = 0
	spawnguard.m_difficulty = 12
	spawnguard.m_maxonmap = maxonmap or 0
	spawnguard.m_hpdiff = hpdiff or 0
	spawnguard.m_prof = prof or 0
	spawnguard.m_classes = classes or {}
	spawnguard.m_policechase = 1
	spawnguard.m_spawndelay = 1
	spawnguard:Spawn()
	spawnguard:SetRenderMode(10)
	spawnguard:Enable()

end


function gang_spawner()
	local spawngang = ents.Create("sb_advanced_nextbot_payday2_spawner")
	spawngang:SetModel("models/props_junk/sawblade001a.mdl")
	spawngang:SetPos( Vector(4991.096680, 2483.880127, 64.031250) )
	spawngang:PhysicsInit(SOLID_VPHYSICS)
	spawngang:SetMoveType(MOVETYPE_VPHYSICS)
	spawngang:SetSolid(SOLID_VPHYSICS)
	spawngang:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	pd2_gamemode_police_spawners[7] = spawngang
	
	spawngang:GetPhysicsObject():EnableMotion(false)
	
	spawngang.NextSpawn = CurTime()+5
	spawngang.BotsToRemove = {}
	spawngang.GroupsToRemove = {}
	spawngang.GCTime = 0
	spawngang.m_difficulty = 11
	spawngang.m_maxonmap = maxonmap or 10
	spawngang.m_hpdiff = hpdiff or 0
	spawngang.m_prof = prof or 0
	spawngang.m_classes = classes or {}
	spawngang.m_policechase = 1
	spawngang.m_spawndelay = 5
	spawngang:Spawn()
	spawngang:SetRenderMode(10)
	spawngang:Enable()
end

print("assault starting")
RunConsoleCommand("hud_deathnotice_time", 0)
con1:SetInt( 1 )
con2:SetInt( 0 )
con7:SetInt ( 120 )

local difs = {"NORMAL", "HARD", "VERY HARD", "OVERKILL", "MAYHEM", "DEATH WISH", "DEATH SENTENCE"}

function pd2_assault_starting()
	for k, v in pairs(player.GetAll()) do
		if v:Team() == 1 then
			v:SetBodyGroups( "00" )
		end
	end
	RunConsoleCommand("hostname", "PAYDAY 2 ALPHA - DIFFICULTY: "..difs[GetConVar( "padpd2" ):GetInt()+1] )
	con4:SetInt( GetConVar( "padpd2" ):GetInt() )
	police_spawners()
	con2:SetInt( 2 )
	timer.Simple(40, function() pd2_gamemode_police_spawners[1]:Enable() start_player_police = true for k, v in pairs(player.GetAll()) do if v:Team() == 2 then v:Spawn() v:SetNWBool("pd2policestop", false) v:SetRenderMode(1) end end timer.Start("ReCreateAssaultPhase") end)
	timer.Simple(110, function() 
		timer.Simple(10, function() con2:SetInt( 3 ) end)
		for k, v in pairs(player.GetAll()) do v:EmitSound("pd2_bain_armor.mp3") end
		pd2_gamemode_police_spawners[2]:Enable()
		pd2_gamemode_police_spawners[3]:Enable()
		if GetConVar( "padpd2" ):GetInt() >= 3 then 
			print("captain difficulty enabled")
			timer.Simple(timer_c, function() 
				pd2_gamemode_police_spawners[4]:Enable()
				con5:SetInt( 1 )
				for k, v in pairs(player.GetAll()) do v:EmitSound("pd2_captain_spawned.mp3") end
				timer.Simple(2, function() pd2_gamemode_police_spawners[4]:Disable() end)
			end)
		end
	end)
end

timer.Create("ReCreateAssaultPhase", 150, 2, function()
	print('started1323123')
	con2:SetInt(2)
	pd2_gamemode_police_spawners[2]:Disable()
	pd2_gamemode_police_spawners[3]:Disable()
	for k, v in pairs(player.GetAll()) do
		v:EmitSound('pd2_bain_stop_assault.wav')
		timer.Simple(25, function() v:EmitSound('pd2_bain_giveemhell.mp3') end)
		timer.Simple(10, function() v:EmitSound('pd2_bain_morepolice.wav') end)
		timer.Simple(30, function()
			con2:SetInt(3)
			pd2_gamemode_police_spawners[2]:Enable()
			pd2_gamemode_police_spawners[3]:Enable()
		end)
	end
end)

timer.Stop("ReCreateAssaultPhase")

function GM:OnNPCKilled(npc, attacker, inflictor)
	if attacker:IsPlayer() then
	if npc:GetModel() == "models/payday2/units/captain_player_pd2anim_shield.mdl" then
		con5:SetInt( 0 )
		attacker:pd2_add_xp(1000)
		attacker:ChatPrint("You earned 1000 xp for killing captain!")
		timer.Simple(1, function() attacker:EmitSound("pd2_voice/shield.mp3") end)
	end
	if npc:GetModel():match("models/sb_anb_payday2/bulldozer_") then
		if attacker:Team() == 2 then return true end
		attacker:pd2_add_xp(200)
		attacker:ChatPrint("You earned 200 xp for killing bulldozer!")
		timer.Simple(1, function() attacker:EmitSound("pd2_voice/bulldozer.mp3") end)
	end
	if npc:GetModel():match("models/sb_anb_payday2/cloaker_")then
		if attacker:Team() == 2 then return true end
		attacker:pd2_add_xp(250)
		attacker:ChatPrint("You earned 250 xp for killing cloaker!")
		timer.Simple(1, function() attacker:EmitSound("pd2_voice/clocker.mp3") end)
	end
	if npc:GetModel():match("taser_player_pd2anim.mdl") then
		if attacker:Team() == 2 then return true end
		attacker:pd2_add_xp(75)
		attacker:ChatPrint("You earned 75 xp for killing taser!")
		timer.Simple(1, function() attacker:EmitSound("pd2_voice/taser.mp3") end)
	end
	if npc:GetModel() == "models/payday2/units/medic_player_pd2anim.mdl" then
		if attacker:Team() == 2 then return true end
		attacker:pd2_add_xp(125)
		attacker:ChatPrint("You earned 125 xp for killing medic!")
		timer.Simple(1, function() attacker:EmitSound("pd2_voice/medic.mp3") end)
	end
	if npc:GetModel():match("_player_pd2anim_shield.mdl") then
		if attacker:Team() == 2 then return true end
		attacker:pd2_add_xp(25)
		attacker:ChatPrint("You earned 25 xp for killing shield!")
		timer.Simple(1, function() attacker:EmitSound("pd2_voice/shield.mp3") end)
	end
	if npc:GetModel() == "models/payday2/units/sniper_swat_player_pd2anim.mdl" then
		if attacker:Team() == 2 then return true end
		attacker:pd2_add_xp(500)
		attacker:ChatPrint("You earned 500 xp for killing sniper!")
		timer.Simple(1, function() attacker:EmitSound("pd2_voice/sniper.mp3") end)
	end	
	end
	local ammo_enemy = ents.Create("pd2_ammo")
	pd2_ammo[1] = ammo_enemy
	pd2_ammo[1]:SetPos(npc:GetPos())
	pd2_ammo[1]:Spawn()
end