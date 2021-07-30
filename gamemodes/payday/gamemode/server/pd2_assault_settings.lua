local con1 = GetConVar( "pd2_assaultphases_serverphases" )
local con2 = GetConVar( "pd2_assaultphases_server_assaultphase" )
local con3 = GetConVar( "pd2_assaultphases_server_music" )
local con4 = GetConVar( "pd2_assaultphases_server_assaultbar_difficulty" )
local con5 = GetConVar( "pd2_assaultphases_server_assaultbar_captainenabled" )
local con7 = GetConVar( "pd2_assaultphases_server_controlduration" )

local timer_c = math.random( 60, 240 )

start_player_police = false

pd2_gamemode_police_spawners = {}
pd2_ammo = {}
pd2_random_music = {"razormind", "tick_tock", "searchlights", "utter_chaos", "le_castle_vania", "left_in_the_cold", "break_the_rules", "full_force_forward", "donacdum", "wanted_dead_or_alive", "iwgyma", "sirens_in_the_distance", "shadows_and_trickery", "shoutout", "the_mark", "ho_ho_ho", "dead_mans_hand", "armed_to_the_teeth", "black_yellow_moebius", "backstab", "breach_2015", "calling_all_units", "death_row", "death_wish", "gun_metal_grey_2015", "fuse_box", "locke_and_load", "wheres_the_van", "time_window", "pimped_out_getaway", "8_bits_are_scary", "code_silver_2018", "hot_pursuit", "ode_to_greed", "the_gauntlet"}

con3:SetString(pd2_random_music[math.random(1,35)])

function police_spawners()
	con5:SetInt( 0 )
	for i,vec in pairs(police_vectable) do
		local spawnpd = ents.Create("sb_advanced_nextbot_payday2_spawner")
		spawnpd:SetModel("models/props_junk/sawblade001a.mdl")
		spawnpd:SetPos( vec )
		spawnpd:PhysicsInit(SOLID_VPHYSICS)
		spawnpd:SetMoveType(MOVETYPE_VPHYSICS)
		spawnpd:SetSolid(SOLID_VPHYSICS)
		spawnpd:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		table.insert(pd2_gamemode_police_spawners,spawnpd)
		
		spawnpd:GetPhysicsObject():EnableMotion(false)
		
		spawnpd.NextSpawn = CurTime()+1
		spawnpd.BotsToRemove = {}
		spawnpd.GroupsToRemove = {}
		spawnpd.GCTime = 0
		spawnpd.m_difficulty = global_dif+1
		spawnpd.m_maxonmap = maxonmap or 0
		spawnpd.m_hpdiff = hpdiff or 0
		spawnpd.m_prof = prof or 0
		spawnpd.m_classes = classes or {}
		spawnpd.m_policechase = 1
		spawnpd.m_spawndelay = 1
		spawnpd:Spawn()
		spawnpd:SetRenderMode(10)
		spawnpd:Disable()
		
		if i == 3 then spawnpd.m_difficulty = 8 end
		if i == 4 then spawnpd.m_difficulty = 9 end
	end
end

function sniper_spawners()
for i,vec in pairs(sniper_vectable) do
	local spawnsniper = ents.Create("sb_advanced_nextbot_payday2_spawner")
	spawnsniper:SetModel("models/props_junk/sawblade001a.mdl")
	spawnsniper:SetPos( vec )
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
	timer_map(1.1, function() spawnsniper:Disable() end)
end
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
	RunConsoleCommand("hostname", "PAYDAY 2 BETA - DIFFICULTY: "..difs[global_dif+1] )
	con4:SetInt( global_dif )
	police_spawners()
	con2:SetInt( 2 )
	timer_map(40, function() 
		pd2_gamemode_police_spawners[3]:Enable() 
		start_player_police = true 
			for k, v in pairs(player.GetAll()) do
				if v:Team() == 2 then 
					v:Spawn()
					v:SetNWBool("pd2policestop", false) 
					v:SetRenderMode(1) 
				end 
			end 
		timer.Start("ReCreateAssaultPhase") 
	end)
	timer_map(110, function() 
		timer_map(10, function() con2:SetInt( 3 ) end)
		for k, v in pairs(player.GetAll()) do v:EmitSound("pd2_bain_armor.mp3") end
		pd2_gamemode_police_spawners[1]:Enable()
		pd2_gamemode_police_spawners[2]:Enable()
		if global_dif >= 3 then 
			timer_map(timer_c, function() 
				pd2_gamemode_police_spawners[4]:Enable()
				con5:SetInt( 1 )
				for k, v in pairs(player.GetAll()) do v:EmitSound("pd2_captain_spawned.mp3") end
				timer_map(2, function() pd2_gamemode_police_spawners[4]:Disable() end)
			end)
		end
	end)
end

timer.Create("ReCreateAssaultPhase", 150, 2, function()
	con2:SetInt(2)
	pd2_gamemode_police_spawners[1]:Disable()
	pd2_gamemode_police_spawners[2]:Disable()
	for k, v in pairs(player.GetAll()) do
		v:EmitSound('pd2_bain_stop_assault.wav')
		timer_map(25, function() v:EmitSound('pd2_bain_giveemhell.mp3') end)
		timer_map(10, function() v:EmitSound('pd2_bain_morepolice.wav') end)
		timer_map(30, function()
			con2:SetInt(3)
			pd2_gamemode_police_spawners[1]:Enable()
			pd2_gamemode_police_spawners[2]:Enable()
		end)
	end
end)

timer.Stop("ReCreateAssaultPhase")

function GM:OnNPCKilled(npc, attacker, inflictor)
	if attacker:IsPlayer() then
	if npc:GetModel() == "models/payday2/units/captain_player_pd2anim_shield.mdl" then
		con5:SetInt( 0 )
		attacker:pd2_add_xp(1000,true)
		attacker:ChatPrint("You earned 1000 xp for killing captain!")
		timer_map(1, function() attacker:EmitSound("pd2_voice/shield.mp3") end)
	end
	if npc:GetModel():match("models/sb_anb_payday2/bulldozer_") then
		if attacker:Team() == 2 then return true end
		attacker:pd2_add_xp(200,true)
		attacker:ChatPrint("You earned 200 xp for killing bulldozer!")
		timer_map(1, function() attacker:EmitSound("pd2_voice/bulldozer.mp3") end)
	end
	if npc:GetModel():match("models/sb_anb_payday2/cloaker_")then
		if attacker:Team() == 2 then return true end
		attacker:pd2_add_xp(250,true)
		attacker:ChatPrint("You earned 250 xp for killing cloaker!")
		timer_map(1, function() attacker:EmitSound("pd2_voice/clocker.mp3") end)
	end
	if npc:GetModel():match("taser_player_pd2anim.mdl") then
		if attacker:Team() == 2 then return true end
		attacker:pd2_add_xp(75,true)
		attacker:ChatPrint("You earned 75 xp for killing taser!")
		timer_map(1, function() attacker:EmitSound("pd2_voice/taser.mp3") end)
	end
	if npc:GetModel() == "models/payday2/units/medic_player_pd2anim.mdl" then
		if attacker:Team() == 2 then return true end
		attacker:pd2_add_xp(125,true)
		attacker:ChatPrint("You earned 125 xp for killing medic!")
		timer_map(1, function() attacker:EmitSound("pd2_voice/medic.mp3") end)
	end
	if npc:GetModel():match("_player_pd2anim_shield.mdl") then
		if attacker:Team() == 2 then return true end
		attacker:pd2_add_xp(25,true)
		attacker:ChatPrint("You earned 25 xp for killing shield!")
		timer_map(1, function() attacker:EmitSound("pd2_voice/shield.mp3") end)
	end
	if npc:GetModel() == "models/payday2/units/sniper_swat_player_pd2anim.mdl" then
		if attacker:Team() == 2 then return true end
		attacker:pd2_add_xp(500,true)
		attacker:ChatPrint("You earned 500 xp for killing sniper!")
		timer_map(1, function() attacker:EmitSound("pd2_voice/sniper.mp3") end)
	end	
	end
	local ammo_enemy = ents.Create("pd2_ammo")
	pd2_ammo[1] = ammo_enemy
	pd2_ammo[1]:SetPos(npc:GetPos()+Vector(0,0,10))
	pd2_ammo[1]:Spawn()
end

hook.Add('pd2_map_spawned','pd2_assault_settings',function()
	pd2_gamemode_police_spawners = {}
end)
