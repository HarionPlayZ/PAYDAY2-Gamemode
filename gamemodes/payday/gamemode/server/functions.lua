local ply = FindMetaTable("Player")
local ent = FindMetaTable('Entity')

local text1 = "PUT DRILL ON SAFE"

util.AddNetworkString("pd2_net_starters1")

function ply:pd2_text()
	net.Start("pd2_net_starters1")
	net.Send(self)
end

function pd2_start_allplayers(txt)
	for k, v in pairs(player.GetAll()) do
		v:pd2_text()
		v:pd2_texts(txt)
	end
	text1 = txt
end

function ply:pd2_texts(txt)
	self:SetNWString("PD2TextsOBJ", txt)
end

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
			timer_Map(25, function() v:ScreenFade( SCREENFADE.OUT, Color( 0, 0, 0, 255 ), 4, 2 ) end)
			timer_Map(30, function() RunConsoleCommand("map", table.Random(maps)) end)
			v:pd2_add_money(money_dif_pd2[dif])
			v:pd2_add_xp(xp_tables[dif])
			v:ChatPrint('You earned '..money_dif_pd2[dif]..'$ money.')
		end
	end
end

util.AddNetworkString( 'start_display_time'  )
util.AddNetworkString( 'stop_display_time'  )
util.AddNetworkString( 'set_start_time'  )

function start_display_time()
	net.Start('start_display_time')
	net.Send(player.GetAll())
	for k, v in pairs(player.GetAll()) do
		timer.Simple(0, function() v:SetNWBool("pd2dif", true) v:ConCommand("pd2_hud_enable 0") end)
		timer_Map(5, function() v:SetNWBool("pd2dif", false) v:ConCommand("pd2_hud_enable 1") end)
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
			timer_Map(2, function() v:Kill() end)
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


function ent:timer_Simple(delay,f)
	timer.Simple(delay,function() if IsValid(self) then f() end end)
end