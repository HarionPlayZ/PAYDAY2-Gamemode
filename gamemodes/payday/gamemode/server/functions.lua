local ply = FindMetaTable("Player")
local text1 = "PUT DRILL ON SAFE"

util.AddNetworkString("pd2_net_starters1")

function ply:pd2_allbox_text()
	net.Start("pd2_net_starters1")
	net.Send(self)
end

function pd2_start_allplayers(txt)
	for k, v in pairs(player.GetAll()) do
		v:pd2_allbox_text()
		v:pd2_texts(txt)
	end
	text1 = txt
end

function ply:pd2_texts(txt)
	self:SetNWString("PD2TextsOBJ", txt)
end

hook.Add( "AcceptInput", "AcceptInputsPD2", function( ent, name, activator, caller, data )
    if ent:GetName() == "button_start" and name == "Use" then
    	for k, v in pairs(player.GetAll()) do
    		if v:Team() == 1 then
    			v:Freeze(true)
    			v:SetNWBool("pd2brief", true)
    			v:EmitSound('pd2_plan_music.ogg')
    			v:ConCommand('pd2_hud_enable 0')
    			v:SelectWeapon( "cw_extrema_ratio_official" )
    			timer.Simple(60, function() v:SetNWBool("pd2brief", false) v:Freeze(false) v:ConCommand('pd2_hud_enable 1') end)
    		end
    	end
	    timer.Simple(59.9, function() pd2_start_allplayers("PLACE DRILL ON SAFE") end)
	end
	if ent:GetName() == "alarm_trigger" then
		timer.Simple(40, function() start_player_police = true end)
	end
	if name == "FireUser1" then
	    if ent:GetName() == "door_safe" then
	    	pd2_start_allplayers("STEAL CASH IN SAFE")
	    end
	    if ent:GetName() == "gold" then
	    	pd2_start_allplayers("WAIT ESCAPE VAN")
	    end
	    if ent:GetName() == "van_escape" then
	    	pd2_start_allplayers("YOU CAN ESCAPE")
	    end
	end
	if ent:GetName() == "button_start" and name == "Use" then
		spawn = false
		timer.Simple(60, function() start_display_time() set_start_time(CurTime()) end)
	end
	if activator:IsPlayer() then
		if ent:GetName() == "tele_trigger1" and activator:Team() == 2 then
			return false 
		end
	end
end )

hook.Add('PD2AlarmStealth', 'cam_alarm', function()
	ents.FindByName("alarm_trigger")[1]:Fire("Trigger")
	for k, v in pairs(ents.FindByClass("pd2_camera")) do
		v.Active = false
	end
end)

hook.Add( "EntityTakeDamage", "EntityDamageBlockIfTeam", function( target, dmginfo )
	local attacker = dmginfo:GetAttacker()
	if target:IsPlayer() and attacker:IsPlayer() then 
		if target:Team() == attacker:Team() then return true end
	end
end )

concommand.Add("medkit_use_pd2", function(ply)
	if ply:GetNWInt("havemedkit") == 0 then return true end
	if ply:Team() == 2 then return true end
	ply:EmitSound("items/medshot4.wav")
	ply:Remove()
	ply:SetHealth(ply:GetMaxHealth())
	ply:SetNumBleedOuts(0)
	ply:ScreenFade(SCREENFADE.IN, Color(0, 255, 0, 100), 0.3, 0)
	ply:SetNWInt("havemedkit", 0)
	for k, v in pairs(player.GetAll()) do
		v:ChatPrint(ply:Name() .. " used MedKit!")
	end
end )

local maps = {"pd2_warehouse_mission", "pd2_htbank_mission", "pd2_jewelry_store_mission"}

function startending()
	for k, v in pairs(player.GetAll()) do
		if v:Team() == 1 then
			local dif = GetConVar('padpd2'):GetInt()+1
			v:ChatPrint("Gang escaped! Restart after 30 sec...")
			timer.Simple(25, function() v:ScreenFade( SCREENFADE.OUT, Color( 0, 0, 0, 255 ), 4, 2 ) end)
			timer.Simple(30, function() RunConsoleCommand("map", table.Random(maps)) end)
			v:pd2_add_money(money_dif_pd2[dif])
			v:pd2_add_xp(xp_tables[dif])
			v:ChatPrint('You earned '..money_dif_pd2[dif]..'$ money.')
		end
	end
end

hook.Add( "EntityTakeDamage", "NextbotDamageBlockIfTeam", function( target, dmginfo )
	local attacker = dmginfo:GetAttacker()
	if target:IsPlayer() and target:Team() == 2 then
		if attacker:IsNextBot() then return true end
	end
end )

voted = false
local difs = {'Normal', 'Hard', 'Very Hard', 'Overkill', 'Mayhem', 'Death Wish', 'Death Sentence'}

hook.Add("PlayerSay", "VoteDifficultyPD2", function( ply, text )
	if text == '/showdif' then
		ply:ChatPrint('Difficulty: '..difs[GetConVar('padpd2'):GetInt()+1])
	end
	if text == '/showlevel' then
		ply:ChatPrint("You have a "..ply:GetNWInt("pd2_level_data").." level and "..ply:pd2_get_xp().." xp.")
	end
	if voted == true then return end
	if ctgang_pd2 == false then return end
	if text == '/votedif 0' then
		GetConVar('padpd2'):SetInt(0)
		voted = true
		for k, v in pairs(player.GetAll()) do
			v:ChatPrint('Player choosed difficulty: Normal')
			v:EmitSound('Friends/friend_online.wav', 75, 150)
		end
	end
	if text == '/votedif 1' then
		if ply:GetNWInt("pd2_level_data") < 5 then ply:ChatPrint("You don't have 5 level to play on this difficulty!") return end
		GetConVar('padpd2'):SetInt(1)
		voted = true
		for k, v in pairs(player.GetAll()) do
			v:ChatPrint('Player choosed difficulty: Hard')
			v:EmitSound('Friends/friend_online.wav', 75, 125)
		end
	end
	if text == '/votedif 2' then
		if ply:GetNWInt("pd2_level_data") < 10 then ply:ChatPrint("You don't have 10 level to play on this difficulty!") return end
		GetConVar('padpd2'):SetInt(2)
		voted = true
		for k, v in pairs(player.GetAll()) do
			v:ChatPrint('Player choosed difficulty: Very Hard')
			v:EmitSound('Friends/friend_online.wav', 75, 100)
		end
	end
	if text == '/votedif 3' then
		if ply:GetNWInt("pd2_level_data") < 15 then ply:ChatPrint("You don't have 15 level to play on this difficulty!") return end
		GetConVar('padpd2'):SetInt(3)
		voted = true
		for k, v in pairs(player.GetAll()) do
			v:ChatPrint('Player choosed difficulty: Overkill')
			v:EmitSound('Friends/friend_online.wav', 75, 85)
		end
	end
	if text == '/votedif 4' then
		if ply:GetNWInt("pd2_level_data") < 20 then ply:ChatPrint("You don't have 20 level to play on this difficulty!") return end
		GetConVar('padpd2'):SetInt(4)
		voted = true
		for k, v in pairs(player.GetAll()) do
			v:ChatPrint('Player choosed difficulty: Mayhem')
			v:EmitSound('Friends/friend_online.wav', 75, 75)
		end
	end
	if text == '/votedif 5' then
		if ply:GetNWInt("pd2_level_data") < 25 then ply:ChatPrint("You don't have 25 level to play on this difficulty!") return end
		GetConVar('padpd2'):SetInt(5)
		voted = true
		for k, v in pairs(player.GetAll()) do
			v:ChatPrint('Player choosed difficulty: Death Wish')
			v:EmitSound('Friends/friend_online.wav', 75, 60)
		end
	end
	if text == '/votedif 6' then
		if ply:GetNWInt("pd2_level_data") < 30 then ply:ChatPrint("You don't have 30 level to play on this difficulty!") return end
		GetConVar('padpd2'):SetInt(6)
		voted = true
		for k, v in pairs(player.GetAll()) do
			v:ChatPrint('Player choosed difficulty: Death Sentence')
			v:EmitSound('Friends/friend_online.wav', 75, 50)
		end
	end
end)

util.AddNetworkString( 'start_display_time'  )
util.AddNetworkString( 'stop_display_time'  )
util.AddNetworkString( 'set_start_time'  )

function start_display_time()
	net.Start('start_display_time')
	net.Send(player.GetAll())
	for k, v in pairs(player.GetAll()) do
		timer.Simple(0, function() v:SetNWBool("pd2dif", true) v:ConCommand("pd2_hud_enable 0") end)
		timer.Simple(5, function() v:SetNWBool("pd2dif", false) v:ConCommand("pd2_hud_enable 1") end)
	end
end

function stop_display_time()
	net.Start('stop_display_time')
	net.Send(player.GetAll())
end

function set_start_time(time)
	net.Start('set_start_time')
	net.WriteInt(time, 32)
	net.Send(player.GetAll())
end

timer.Create("killteam1", 2, 1, function()
	for k, v in pairs(player.GetAll()) do
		if v:Team() == 1 then
			timer.Simple(2, function() v:Kill() end)
		end
	end
end)

hook.Add( "Think", "PD2KillIfAllBleedout", function()
   -- Парсим всех игроков и заносим в таблицу validate_players всех игроков с тимой 1
   local all_players = player.GetAll()
   local validate_players = {}
   for i = 1, #all_players do
      local ply = all_players[i]
      if ply:Team() == 1 then table.insert(validate_players, ply) end
   end

   -- Проверяем что таблица не пуста
   local validate_players_count = #validate_players
   if validate_players_count ~= 0 then
      -- Создаем переменную которая по умолчанию говорит что все игроки мертвы
      local all_players_is_dead = true

      -- Парсим валидных игроков на проверку смерти
      for i = 1, validate_players_count do
         local ply = validate_players[i]
         -- Если хотя-бы 1 игрок не мёртв, то отменяем цикл и указываем в
         -- переменную all_players_is_dead что не все игроки мертвы
         if not ply:IsBleedOut() then
            all_players_is_dead = false
            break
         end
      end

      -- Если все игроки мертвы и нету таймера смерти, создаем таймер
      if all_players_is_dead and not timer.Exists("pd2killteam1") then
         timer.Create("pd2killteam1", 2, 1, function()
            for i = 1, validate_players_count do
               local ply = validate_players[i]
               -- Учитывая что таймер вызывается позднее текущего кадра
               -- на всякий случай добавляем проверку на валидность сущности игрока
               if IsValid(ply) then ply:Kill() end
             end
         end)
      end
   end
end )

hook.Add("CanPlayerSuicide", "DisableSuicide", function(ply)
	ply:ChatPrint("That command was disabled!")
	return false
end)
