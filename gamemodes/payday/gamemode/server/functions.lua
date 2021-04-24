local ply = FindMetaTable("Player")
local ent = FindMetaTable('Entity')

local text1 = "PUT DRILL ON SAFE"

util.AddNetworkString("pd2_taskbar_display")
util.AddNetworkString("pd2_taskbar_remove")

function ply:pd2_taskbar_display(txt,size)
	net.Start("pd2_taskbar_display")
	net.WriteString(txt)
	net.WriteInt(size,32)
	net.Send(self)
end

function pd2_taskbar_display_all(txt,size)
	for i,p in pairs(player.GetAll()) do
		if p:Team() == 1 then
			net.Start("pd2_taskbar_display")
			net.WriteString(txt)
			net.WriteInt(size,32)
			net.Send(p)
		end
	end
end

function pd2_taskbar_remove()
	net.Start("pd2_taskbar_remove")
	net.Send(player.GetAll())
end

function ply:pd2_taskbar_remove()
	net.Start("pd2_taskbar_remove")
	net.Send(self)
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
local all_escape = true
	for k, v in pairs(player.GetAll()) do
		if v:GetNWBool('escape') then v:escape() end
		if v:Team() == 1 then all_escape = false end
	end
	if all_escape then
		for i,p in pairs(player.GetAll()) do
			timer_Map(25, function() p:ScreenFade( SCREENFADE.OUT, Color( 0, 0, 0, 255 ), 4, 2 ) end)
		end
		timer_Map(30, function() RunConsoleCommand("map", table.Random(maps)) end)
	end
end

function ply:escape()
	local dif = global_dif+1
	self:ChatPrint("Gang escaped! Restart after 30 sec...")
	self:pd2_add_money(money_dif_pd2[dif])
	self:pd2_add_xp(xp_tables[dif],true)
	self:ChatPrint('You earned '..money_dif_pd2[dif]..'$ money.')
	self:SetTeam(1001)
	self:SetNWBool('escape',false)
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

function ply:stop_display_time()
	net.Start('stop_display_time')
	net.Send(self)
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

timer.Create("PD2KillIfAllBleedout", 0, 1, function()
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