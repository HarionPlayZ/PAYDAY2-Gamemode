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

voted = false
local difs = {'Normal', 'Hard', 'Very Hard', 'Overkill', 'Mayhem', 'Death Wish', 'Death Sentence'}
local commandtable = {
	'List of all commands:',
	'/money or !money - show your money.',
	'/level or !level - show your level.',
	'/buy or /buy - this command buy any weapon from list.',
	'/weapon or !weapon - if you want help with buying weapon.',
	'/armor or !armor - if you want help with buying armor.',
	'/gang or !gang - change team on gang.',
	'/police or !police - change team on police.',
	'/spectator or !spectator - change team on spectator.',
	'/votedif 0-6 or !votedif 0-6 - You can set difficulty in game.',
	'/dif or !dif - Show voted difficulty in game.',
	'If you write in console (bind g medkit_use_pd2) you will can use medkit on g button.'
}

util.AddNetworkString('padpd2')
hook.Add("PlayerSay", "VoteDifficultyPD2", function( ply, text )
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
	if voted then ply:ChatPrint('voted complited') return end
	if not ctgang_pd2 then ply:ChatPrint('voted complited') return end
	local txt = string.Split(text,' ')
	if txt[1] == '/votedif' or txt[1] == '!votedif' then
		local arg = tonumber(txt[2])
		if not isnumber(arg) then arg = 0 end
		if arg < 0 then arg = 0 end
		if arg > 6 then arg = 6 end
		if ply:GetNWInt("pd2_level_data") < arg*5 then ply:ChatPrint("You don't have "..tostring(arg*5).." level to play on this difficulty!")  return end
		global_dif = arg
		net.Start('padpd2')
		net.WriteInt(arg,4)
		net.Send(player.GetAll())
		voted = true
		for k, v in pairs(player.GetAll()) do
			v:ChatPrint('Player choosed difficulty: '..difs[arg+1])
			v:EmitSound('Friends/friend_online.wav', 75, 150)
		end
	end
end)

hook.Add('PD2AlarmStealth', 'cam_alarm', function()
	for k, v in pairs(ents.FindByClass("pd2_camera")) do v.Active = false end
end)
