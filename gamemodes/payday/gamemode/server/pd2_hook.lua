hook.Add("CanPlayerSuicide", "DisableSuicide", function(ply)
	ply:ChatPrint("That command was disabled!")
	return false
end)

hook.Add( "EntityTakeDamage", "NextbotDamageBlockIfTeam", function( target, dmginfo )
	local attacker = dmginfo:GetAttacker()
	if target:GetClass()=='func_breakable' then
		if target:Health()-dmginfo:GetDamage()<=0 then hook.Call('alarm') end
	end
	if target:IsPlayer() then
		if attacker:IsNextBot() and target:Team() == 2 or attacker:IsPlayer() and target:Team() == attacker:Team() then return true end
	end
end )

local difs = {'Normal', 'Hard', 'Very Hard', 'Overkill', 'Mayhem', 'Death Wish', 'Death Sentence'}
local commandtable = {
	'List of all commands:',
	'/money or !money - show your money.',
	'/level or !level - show your level.',
	'/buy or /buy - this command buy any weapon from list.',
	'/weapon or !weapon - if you want help with buying weapon.',
	'/armor or !armor - if you want help with buying armor.',
	'/dif or !dif - Show voted difficulty in game.',
	'/giveup or !giveup - Kill player if him in team gang.',
	'If you write in console (bind g medkit_use_pd2) you will can use medkit on g button.'
}

util.AddNetworkString('padpd2')
hook.Add("PlayerSay", "VoteDifficultyPD2", function( ply, text )
	local txt = string.Split(text,' ')
	if text == '/dif' or text == '!dif' then
		ply:ChatPrint('Difficulty: '..difs[global_dif+1])
	end
	if text == '/level' or text == '!level' then
		ply:ChatPrint("You have a "..ply:GetNWInt("pd2_level_data").." level and "..ply:pd2_get_xp().." xp.")
	end
	if text == "/help" or text == "!help" then
		for i, c in pairs(commandtable) do
			ply:ChatPrint(c)
		end
	end
end)

hook.Add('PD2AlarmStealth', 'cam_alarm', function()
	for i,cam in pairs(ents.FindByClass("pd2_camera")) do cam.Active = false end
end)

hook.Add( "ShouldCollide", "FNAPC", function( ent1, ent2 )
    if ( ent1:IsNextBot() and ent2:IsPlayer() and ent2:Team() == 2 ) then return false end
end )

hook.Add('escape','escape',function(ply,money)
	ply:pd2_taskbar_remove()
	ply:stop_display_time()
	ply:SetNWBool('escape',true)
	ply:SetTeam(1001)
	ply:StripAmmo()
    ply:StripWeapons()
	ply:ConCommand('pd2_hud_enable 0')
	ply:pd2_add_money(money or 0)
	startending()
end)

hook.Add("SetupPlayerVisibility", "AddRTCamera", function(ply, ent)
	for i,p in pairs(player.GetAll()) do
		AddOriginToPVS(p:GetPos())
	end
end) 

hook.Add('pd2_map_spawned','notready',function()
	for i,p in pairs(player.GetAll()) do
		p:SetNWBool('ready',false)
	end
end)