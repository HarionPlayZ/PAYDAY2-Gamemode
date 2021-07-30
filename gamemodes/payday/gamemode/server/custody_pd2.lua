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
	table.RemoveByValue(global_gang_table,victim)
	if victim:Team() == 2 then timer.Simple(3, function() victim:Spawn() end) return end
	for i,p in pairs (player.GetAll()) do
		p:ChatPrint(victim:Name() .. langs_pd2['pd2.arrest.player'])
	end
	if victim:Team() == 1 then
		-- local maps = {"pd2_warehouse_mission", "pd2_htbank_mission", "pd2_jewelry_store_mission"}
		local all_death = true
		for i,p in pairs(player:GetAll())do
			if p:Team() == 1 then
				if p:Alive() and p!=victim then all_death = false break end
			end
		end
		if all_death then
			timer_map(5, function() GetConVar( "pd2_assaultphases_server_assaultphase" ):SetInt( 0 ) game.CleanUpMap() end)
			for i,p in pairs (player.GetAll()) do
				if p:Team() == 2 then
					p:pd2_add_money(1000)
					p:pd2_add_xp(1000,true)
					p:ChatPrint('Good job! You earned 1000$ and 1000 xp.')
				end
			p:UnSpectate()
			end
			timer_map(1, function() 
				for i,p in pairs (player.GetAll()) do
					p:ChatPrint(langs_pd2['pd2.arrest.players.all']) 
					p:ScreenFade( SCREENFADE.OUT, Color( 0, 0, 0, 255 ), 4, 1 ) 
				end
			end)
		end
		if IsValid(victim) then
			if victim:Team() == 2 then timer_map(10, function() victim:Spawn() end) end
			if victim:Team() == 1001 then timer_map(0, function() victim:Spawn() end) end
			if victim:Team() == 1 then
				victim:SetNWBool("cant_respawn", true)
				victim:Spectate(5)
				victim:SetObserverMode(5)
				victim:SetNWBool("pd2prison", true)
				victim:EmitSound("custody.mp3")
				victim:SetTeam(1001)
			end
		end
	end
end)

hook.Add("PlayerDeathThink","no_respawn", function()
	-- if not ply:GetNWBool("cant_respawn") then ply:RemoveAllAmmo() end
return false end)

hook.Add( "KeyPress", "keypress_spectatepd2", function( ply, key )
	if ply:Alive() then return end
	if key == 1 then
		ply:SetNWInt( 'pd2_spectator_mod', ply:GetNWInt('pd2_spectator_mod')+1)
		local pd2_int1 = player.GetAll()[ply:GetNWInt('pd2_spectator_mod')]
		if not IsValid(pd2_int1) then
			ply:SetNWInt( 'pd2_spectator_mod', 1)
			pd2_int1 = player.GetAll()[ply:GetNWInt('pd2_spectator_mod')]
		end
		ply:SpectateEntity(pd2_int1)
	end
	if key == 2048 then
		ply:SetNWInt( 'pd2_spectator_mod', ply:GetNWInt('pd2_spectator_mod')-1)
		local pd2_int1 = player.GetAll()[ply:GetNWInt('pd2_spectator_mod')]
		if not IsValid(pd2_int1) then
			ply:SetNWInt( 'pd2_spectator_mod', player.GetCount())
			pd2_int1 = player.GetAll()[ply:GetNWInt('pd2_spectator_mod')]
		end
		ply:SpectateEntity(pd2_int1)
	end
end )

hook.Add("PlayerDisconnected", "TryFixDisconnect", function(ply) ply:Kill() end)
