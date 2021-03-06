resource.AddFile('materials/custody.png')
resource.AddFile('sound/custody.mp3')

langs_pd2 = {}

local ru_lang = {}
local en_lang = {}


ru_lang['pd2.arrest.player'] = ' под стражей!'
en_lang['pd2.arrest.player'] = ' in custody!'

ru_lang['pd2.arrest.players.all'] = 'Вся банда взята под стражу! Перезагрузка...'
en_lang['pd2.arrest.players.all'] = 'Gang taken into custody! Restarting...'

langs_pd2 = GetConVar('cl_language'):GetString() == 'russian' and ru_lang or en_lang

hook.Add("PlayerSpawn", "falseifspawnedicon", function(ply)
	ply:SetNWBool("pd2prison", false)
end)

hook.Add("PlayerDeath","playerdeath", function(victim, inflictor, attacker)
	if not IsFirstTimePredicted() then return end
	if victim:Team() == 2 then timer.Simple(10, function() victim:Spawn() end) return true end
	if victim:Team() == 1001 then timer.Simple(1, function() victim:Spawn() end) return true end
	timer.Simple(0.1,function() if(CLIENT&&victim:IsValid()) then end end)
	victim:SetNWBool("cant_respawn", true)
	victim:Spectate(5)
	victim:SetObserverMode(5)
	victim:SetNWBool("pd2prison", true)
	victim:EmitSound("custody.mp3")
	victim:SetTeam(1001)
	for k, v in pairs (player.GetAll()) do
		v:ChatPrint(victim:Name() .. langs_pd2['pd2.arrest.player'])
	end
	local all_death = true
	local maps = {"pd2_warehouse_mission", "pd2_htbank_mission", "pd2_jewelry_store_mission"}
		for i,p in pairs(player:GetAll())do
			if p:Team() == 1 then
				if p:Alive() and p!=victim then all_death = false end
			end
		end
		if all_death then
			for k, v in pairs (player.GetAll()) do
				timer.Simple(1, function() v:ChatPrint(langs_pd2['pd2.arrest.players.all']) v:ScreenFade( SCREENFADE.OUT, Color( 0, 0, 0, 255 ), 4, 1 ) GetConVar( "pd2_assaultphases_server_assaultphase" ):SetInt( 0 ) end)
				timer.Simple(5, function() RunConsoleCommand( "map", table.Random(maps) ) end)
				if v:Team() == 2 then
					v:pd2_add_money(1000)
					v:pd2_add_xp(1000)
					v:ChatPrint('Good job! You earned 1000$ and 1000 xp.')
				end
			v:UnSpectate()
			end
		end
end)

hook.Add("PlayerDeathThink","no_respawn", function(ply)
	if not IsFirstTimePredicted() then return end
	if ply:Team() == 2 then return true end
	if (!ply:GetNWBool("cant_respawn")) then
		ply:RemoveAllAmmo()
	end
	return false
end)

concommand.Add("pd2_spawnplayers", function(ply)
	for k, v in pairs(player.GetAll()) do
		if not v:Alive() then
			v:SetNWBool("pd2prison", false)
			v:Spawn()
		end
	end
end)

hook.Add( "KeyPress", "keypress_spectatepd2", function( ply, key )
	if ply:Alive() then return end
	if ( key == 1 ) then
		ply:SetNWInt( 'pd2_spectator_mod', ply:GetNWInt('pd2_spectator_mod')+1)
		local pd2_int1 = player.GetAll()[ply:GetNWInt('pd2_spectator_mod')]
		if not IsValid(pd2_int1) then
			ply:SetNWInt( 'pd2_spectator_mod', 1)
			pd2_int1 = player.GetAll()[ply:GetNWInt('pd2_spectator_mod')]
		end
		ply:SpectateEntity(pd2_int1)
	end
end )

hook.Add("PlayerDisconnected", "TryFixDisconnect", function(ply)
    ply:Kill()
end)
