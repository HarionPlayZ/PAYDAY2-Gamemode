local pl = FindMetaTable("Player")
local changeteam = true
ctgang_pd2 = true
start_player_police = false

local health_pd2 = {7500, 5000, 3000, 2000, 1500, 1000, 750}
local health_police = {100, 125 , 150, 175, 200, 225, 250}
local models_p = {"models/payday2/units/cop3_player_pd2anim.mdl", "models/payday2/units/blue_swat_player_pd2anim.mdl", "models/payday2/units/heavy_swat_player_pd2anim.mdl", "models/payday2/units/swat_fbi_player_pd2anim.mdl", "models/payday2/units/heavy_fbi_player_pd2anim.mdl", "models/payday2/units/zeal_swat_player_pd2anim.mdl", "models/payday2/units/zeal_heavy_swat_player_pd2anim.mdl"}
local con1 = GetConVar( "pd2_assaultphases_server_assaultphase" )
weapon_random_main = {"cw_mp5"}
weapon_random_second = {"cw_m1911", "cw_makarov", "cw_mr96"}
weapon_random_swat = {"cw_m3super90", "cw_ar15", "cw_mac11", "cw_g36c", "cw_mp5", "cw_l115"}
local pd2gang_skins = {{model = "models/player/pd2_chains_p.mdl", exist = false}, {model = "models/player/pd2_dallas_p.mdl", exist = false}, {model = "models/player/pd2_hoxton_p.mdl", exist = false}, {model = "models/player/pd2_wolf_p.mdl", exist = false}}
random_spawn_p = {}

function pl:PD2SetPolice()
    self:StripWeapons()
    self:StripAmmo()
    self:SetTeam(2)
	self:SetModel(models_p[GetConVar( "padpd2" ):GetInt()+1])
	self:SetHealth(health_police[GetConVar( "padpd2" ):GetInt()+1])
	self:SetMaxHealth( self:Health() )
	self:SetArmor(0)
	local swat = self:Give(table.Random(weapon_random_swat))
	self:GiveAmmo(swat:Clip1() * 500, swat:GetPrimaryAmmoType(), true)
    self:SetWalkSpeed(150)
    self:SetRunSpeed(230)
    self:SetNoCollideWithTeammates( true )
    self:SetNoTarget(true)
    self:SetPos(random_spawn_p[math.random(1,3)])
    if not start_player_police then 
        self:Freeze(true)
        self:SetRenderMode(10)
        self:GodEnable()
        self:DrawWorldModel( false )
        self:SetNWBool("pd2policestop", true)
    end
    self:AllowFlashlight(true)
end

function pl:PD2SetGang()
    self:StripWeapons()
    self:StripAmmo()
	for i,v in pairs(pd2gang_skins) do
	    v.exist = false
	end
	for i,p in pairs(player.GetAll()) do
	    if p:Team() == 1 then
	        for i,v in pairs(pd2gang_skins) do
	            if v.model == p:GetModel() then
	                v.exist = true
	            end
	        end
	    end
	end
	local c = 0
	for i, v in pairs(pd2gang_skins) do
		if not v.exist then
			v.exist = true
    		self:SetModel(v.model)
    	else
    		c = c+1
    	end
    end
    if c == 4 then self:ChatPrint("You can't join to team, reason: Full team.") return end
	self:SetTeam(1)
    self:SetNWBool("pd2policestop", false)
	self:GiveAmmo(500, 'pistol', true)
	self:GiveAmmo(50, 8, true)
    self:SetBodyGroups( "02" )
    local main = self:GetNWString('weapon_main')
    if main == '' then 
        main = self:Give(table.Random(weapon_random_main))
    else
        main = self:Give(main)
    end
    if main:IsValid() then
        self:GiveAmmo(main:Clip1() * 5, main:GetPrimaryAmmoType(), true)
    else
        main = self:Give(table.Random(weapon_random_main))
    end
    local sec = self:GetNWString('weapon_sec')
    if sec == '' then
        sec = self:Give(table.Random(weapon_random_second))
    else
        sec = self:Give(sec)
    end
    if sec:IsValid() then    
        self:GiveAmmo(sec:Clip1() * 5, sec:GetPrimaryAmmoType(), true)
    else
        sec = self:Give(table.Random(weapon_random_second))
        self:GiveAmmo(sec:Clip1() * 5, sec:GetPrimaryAmmoType(), true)
    end   
    self:GiveAmmo(2, 55, true)
    self:Give("cw_extrema_ratio_official")
    self:Give("cw_pd2_frag_grenade")
    self:SetHealth(health_pd2[GetConVar( "padpd2" ):GetInt()+1])
    self:SetMaxHealth( self:Health() )
    local armor = self:GetNWInt('armor_init')
    if armor == 0 then
        self:SetMaxArmor(100)
        self:SetArmor(100)
    else
        self:SetMaxArmor(armor)
        self:SetArmor(armor)
    end
    self:SetWalkSpeed(140)
    self:SetRunSpeed(200)
    self:Freeze(false)
    self:SetRenderMode(1)
    self:GodDisable()
    self:SetNoTarget(false)
    self:SetPos(vec_p2)
    self:SetNoCollideWithTeammates( true )
    self:SetNWInt("havemedkit", 1)
    self:AllowFlashlight(true)
end


hook.Add("PlayerSay", "JoinTeams", function( ply, text )
    if string.lower(text) == "/police" then
    	if GetConVar("policejoin"):GetInt() == 1 then ply:ChatPrint("Host disabled police team!") return end
    	if ply:Team() == 1 and changeteam == false then ply:ChatPrint("You cant change team on police, when game started and you gangster!") return true end
        timer.Simple(0, function() ply:Spawn() end)
        ply:PD2SetPolice()
        ply:EmitSound("pd2_player_join.ogg")
    end
    if string.lower(text) == "/gang" then
        if voted == false then ply:ChatPrint('Difficulty not choosed!') return end
        if ply:Team() == 1 then return true end
    	if changeteam == false then ply:ChatPrint("You cant change team, when game started!") return true end
        timer.Simple(0, function() ply:Spawn() end)
        ply:PD2SetGang()
        ply:EmitSound("pd2_player_join.ogg")
    end
    if string.lower(text) == "/spectator" then
    	if ply:Team() == 1 and changeteam == false or ctgang == false then return end
    	ply:SetTeam(1001)
        ply:StripAmmo()
        ply:StripWeapons()
    end
end)

hook.Add("PlayerSpawn", "PD2PoliceGiver", function(ply)
	ply:SetModel("models/player/gman_high.mdl")
	ply:SetNWBool("pd2policestop", false)
    ply:SetNWBool("pd2prison", false)
    ply:UnSpectate()
    ply:ConCommand("pd2_assaultphases_client_assaultbar_scale 0.670000")
    ply:ConCommand("pd2_assaultphases_client_assaultbar_offset -30 20")
    ply:ConCommand("bleedout_legacyui 2")
    ply:SetNWInt("xp", ply:pd2_get_xp())
	if ply:Team() == 2 then
		ply:PD2SetPolice()
    end
	if ply:Team() == 1 then
		ply:PD2SetGang()
    end
    return false
end)

hook.Add( "AcceptInput", "AcceptInput", function( ent, name, activator, caller, data )
	if ent:GetName() == "button_start" and name == "Use" then
		ctgang_pd2 = false
		timer.Simple(60, function() changeteam = false end)
	end
end )