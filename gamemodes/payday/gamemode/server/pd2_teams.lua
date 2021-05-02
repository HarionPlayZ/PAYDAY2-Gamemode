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

function pl:PD2SetPolice()
    self:StripWeapons()
    self:StripAmmo()
    self:SetTeam(2)
	self:SetModel(models_p[global_dif+1])
	self:SetHealth(health_police[global_dif+1])
	self:SetMaxHealth( self:Health() )
	self:SetArmor(0)
	local weapon = self:Give(table.Random(weapon_random_swat))
	self:GiveAmmo(weapon:Clip1() * 500, weapon:GetPrimaryAmmoType(), true)
    self:SetWalkSpeed(150)
    self:SetRunSpeed(230)
    self:SetNoCollideWithTeammates( true )
    self:SetNoTarget(true)
    self:SetPos(table.Random(spawner_police))
    self:AllowFlashlight(true)
    if not start_player_police then 
        self:Freeze(true)
        self:SetRenderMode(10)
        self:GodEnable()
        self:DrawWorldModel( false )
        self:SetNWBool("pd2policestop", true)
    end
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
    local prim_weapon = self:GetNWString('weapon_main')
		if prim_weapon == '' then 
			prim_weapon = self:Give(table.Random(weapon_random_main))
		else
			prim_weapon = self:Give(prim_weapon)
		end
	if IsValid(prim_weapon) then self:GiveAmmo(prim_weapon:Clip1() * 5, prim_weapon:GetPrimaryAmmoType(), true) end
    local sec_weapon = self:GetNWString('weapon_sec')
		if sec_weapon == '' then
			sec_weapon = self:Give(table.Random(weapon_random_second))
		else
			sec_weapon = self:Give(sec_weapon)
		end
	if IsValid(sec_weapon) then self:GiveAmmo(sec_weapon:Clip1() * 5, sec_weapon:GetPrimaryAmmoType(), true) end
    self:GiveAmmo(2, 55, true)
    self:Give("cw_extrema_ratio_official")
    self:Give("cw_pd2_frag_grenade")
    self:SetHealth(health_pd2[global_dif+1])
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
    self:SetPos(spawner_gang)
    self:SetNoCollideWithTeammates( true )
    self:SetNWInt("havemedkit", 1)
    self:AllowFlashlight(true)
end
function pl:PD2SetSpectator()
	self:SetTeam(1001)
	self:StripAmmo()
	self:StripWeapons()
	self:Spawn()
end

hook.Add("PlayerSay", "JoinTeams", function( ply, text )
	if text == "/police" or text == "!police" then
		if GetConVar("policejoin"):GetInt() == 1 then ply:ChatPrint("Host disabled police team!") return end
		if ply:Team() == 1 and not changeteam then ply:ChatPrint("You cant change team on police, when game started and you gangster!") return true end
		timer.Simple(0, function() ply:Spawn() end)
		ply:PD2SetPolice()
		ply:EmitSound("pd2_player_join.ogg")
	end
	if text == "/gang" or text == "!gang" then
		if voted == false then ply:ChatPrint('Difficulty not choosed!') return end
		if ply:Team() == 1 then return true end
		if not changeteam then ply:ChatPrint("You cant change team, when game started!") return true end
		timer.Simple(0, function() ply:Spawn() end)
		ply:PD2SetGang()
		ply:EmitSound("pd2_player_join.ogg")
	end
	if text == "/spectator" or text == "!spectator" then
		if changeteam or ctgang then
			ply:PD2SetSpectator()
		end
	end
end)

hook.Add("PlayerSpawn", "PD2PoliceGiver", function(ply)
	ply:SetModel("models/player/gman_high.mdl")
	ply:SetNWBool("pd2policestop", false)
    ply:SetNWBool("pd2prison", false)
    ply:UnSpectate()
    ply:SetNoTarget(true)
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
	net.Start('padpd2')
	net.WriteInt(global_dif,4)
	net.Send(ply)
    return false
end)

hook.Add( "game_start", "teams", function()
	ctgang_pd2 = false
	timer_Map(60, function() changeteam = false end)
end )

hook.Add('pd2_map_spawned','team',function()
	changeteam = true
end)