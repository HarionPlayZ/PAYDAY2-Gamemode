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
	'/spectator - change team on spectator.',
	'/votedif 0-6 - You can set difficulty in game.',
	'/dif or !dif - Show voted difficulty in game.',
	'If you write in console (bind g medkit_use_pd2) you will can use medkit on g button.'
}

hook.Add("PlayerSay", "VoteDifficultyPD2", function( ply, text )
	if text == '/dif' or text == '!dif' then
		ply:ChatPrint('Difficulty: '..difs[GetConVar('padpd2'):GetInt()+1])
	end
	if text == '/level' or text == '!level' then
		ply:ChatPrint("You have a "..ply:GetNWInt("pd2_level_data").." level and "..ply:pd2_get_xp().." xp.")
	end
	if text == "/help" or text == "!help" then
		for i, c in pairs(commandtable) do
			ply:ChatPrint(c)
		end
	end
	if voted == true then return end
	if ctgang_pd2 == false then return end
	local txt = string.Split(text,' ')
	if txt[1] == '/votedif' or txt[1] == '!votedif' then
		local arg = tonumber(txt[2])
		if not isnumber(arg) then arg = 0 end
		if arg < 0 then arg = 0 end
		if arg > 6 then arg = 6 end
		if ply:GetNWInt("pd2_level_data") < arg*5 then ply:ChatPrint("You don't have "..tostring(arg*5).." level to play on this difficulty!")  return end
		GetConVar('padpd2'):SetInt(arg)
		voted = true
		for k, v in pairs(player.GetAll()) do
			v:ChatPrint('Player choosed difficulty: '..difs[arg+1])
			v:EmitSound('Friends/friend_online.wav', 75, 150)
		end
	end
end)

hook.Add('PD2AlarmStealth', 'cam_alarm', function()
	ents.FindByName("alarm_trigger")[1]:Fire("Trigger")
	for k, v in pairs(ents.FindByClass("pd2_camera")) do v.Active = false end
end)

hook.Add( "AcceptInput", "AcceptInputsPD2", function( ent, name, activator, caller, data )
    if ent:GetName() == "button_start" and name == "Use" then
    	for k, v in pairs(player.GetAll()) do
    		if v:Team() == 1 then
    			v:Freeze(true)
    			v:SetNWBool("pd2brief", true)
    			v:EmitSound('pd2_plan_music.ogg')
    			v:ConCommand('pd2_hud_enable 0')
    			v:SelectWeapon( "cw_extrema_ratio_official" )
    			timer_Map(60, function()
					if IsValid(v) then
						v:SetNWInt("PD2TextsOBJSize",290)
						v:SetNWBool("pd2brief", false)
						v:Freeze(false)
						v:ConCommand('pd2_hud_enable 1')
					end
				end)
    		end
    	end
	    timer_Map(59.9, function()
			pd2_start_allplayers("PLACE DRILL ON SAFE") 
		end)
	end
	if ent:GetName() == "alarm_trigger" then
		timer_Map(40, function() start_player_police = true end)
	end
	if ent:GetName() == "button_start" and name == "Use" then
		spawn = false
		timer_Map(60, function() start_display_time() set_start_time(CurTime()) end)
	end
	if ent:GetName() == "drill_button" then
		for i,p in pairs(player.GetAll()) do
			p:SetNWInt("PD2TextsOBJSize",270)
		end
		pd2_start_allplayers("STEAL CASH IN SAFE")
		playsound(player.GetAll(),'pd2_obj.mp3')
		ents.FindByName('drill_spark')[1]:Fire('StartSpark')
		dril_spawn(Vector(-3525, 1708, 75),Angle(0,130,0),'dril',300)
		ent:Remove()
	end
	if ent:GetName() == "gold" then
		for i,p in pairs(player.GetAll()) do
			p:SetNWInt("PD2TextsOBJSize",137)
		end
		pd2_start_allplayers("WAIT VAN")
		playsound(player.GetAll(),'pd2_obj.mp3')
		ents.FindByName('money')[1]:Fire('kill')
		timer_Map(30,function() playsound(player.GetAll(),'pd2_bain_van_30.mp3') end)
		timer_Map(60,function()
			playsound(player.GetAll(),'pd2_obj.mp3')
			playsound(player.GetAll(),'pd2_bain_van_0.mp3')
			ents.FindByName('van_escape')[1]:Fire('Enable')
			ents.FindByName('tele_trigger1')[1]:Fire('Enable')
			for i,p in pairs(player.GetAll()) do
				p:SetNWInt("PD2TextsOBJSize",228.5)
			end
			pd2_start_allplayers("YOU CAN ESCAPE")
			
		end)
		ent:Remove()
	end
	if activator:IsPlayer() then
		if ent:GetName() == "tele_trigger1" and activator:Team() == 2 then
			return false 
		end
	end
end )
