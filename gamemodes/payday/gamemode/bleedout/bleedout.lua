local bindingstabwaspressed = {}
if table.IsEmpty( file.Find("bleedout.txt", "DATA") )then
	bindingstab = {
		bleedout_suicide = KEY_G,
		bleedout_help = KEY_H
	}
	local filetxt = util.TableToJSON(bindingstab, true)
	file.Write("bleedout.txt", filetxt)
else
	local filetxt = file.Read("bleedout.txt", "DATA")
	bindingstab = util.JSONToTable(filetxt)
end
AddCSLuaFile() // Для того что бы передавалась клиенту (ну на всякий случай)
tabhalo = {} // Создание столбика для обводки + иконок над игроками.
convar = GetConVar( "bleedout_shouldtakedmg" )
convar0 = GetConVar( "sbox_playershurtplayers" )
convar2 = GetConVar( "bleedout_draw_outlines" )
convar3 = GetConVar( "bleedout_draw_icons" )
convar4 = GetConVar( "bleedout_enable" )
convar5 = GetConVar( "bleedout_death_time" )
convar6 = GetConVar( "bleedout_revive_time" )
convar7 = GetConVar( "bleedout_icon_drawmode" )
convar8 = GetConVar( "bleedout_outline_color_r" )
convar9 = GetConVar( "bleedout_outline_color_g" )
convar10 = GetConVar( "bleedout_outline_color_b" )
convar12 = GetConVar( "bleedout_shouldshoot" )
convar13 = GetConVar( "bleedout_icon_custom" )
convar14 = GetConVar( "bleedout_icon_size" )
convar15 = GetConVar( "bleedout_draw_blood" )
convar16 = GetConVar( "bleedout_draw_colorcorrection" )
convar17 = GetConVar( "bleedout_num_bleedouts" )
convar18 = GetConVar( "bleedout_draw_timer" )
convar19 = GetConVar( "bleedout_legacyui" )
convar20 = GetConVar( "bleedout_view_roll" )
convar21 = GetConVar( "bleedout_draw_revive_timer" )
convar22 = GetConVar( "bleedout_notarget" )
convar23 = GetConVar( "bleedout_reducedmg" ) --3
convar24 = GetConVar( "bleedout_moving_enable" )
convar25 = GetConVar( "bleedout_npc_can_revive" )
convar26 = GetConVar( "bleedout_view_draw_body" )
convar27 = GetConVar( "bleedout_enable_bleeding" )
convar28 = GetConVar( "bleedout_sound_enable" )
convar29 = GetConVar( "bleedout_reviveonkill" )
convar30 = GetConVar( "bleedout_killcount" )
convar31 = GetConVar( "bleedout_hp" )
convar32 = GetConVar( "bleedout_blacknwhite" )
convar33 = GetConVar( "bleedout_heartbeat" )
local delay = CurTime() + 3
local loweredview = Vector(0, 0, 38) // Используется в FireBullets, CalcView, CalcViewModelView
local normalhullbottom, normalhulltop, duckhullbottom, duckhulltop = Vector(-16, -16, 0), Vector(16, 16, 72), Vector(-16, -16, 0), Vector(16, 16, 36) // Хуллы для игрока, используется в self:SetHull()
local distancetotrace = 91
local PLAYER = FindMetaTable("Player") // Метатабл для игроков
local NPC = FindMetaTable("NPC")
local cyclex, cycley = 0.6,0.65 // Период анимации, своровал с nzombies
local loweredpos = Vector(0,0, -32) // Вычитаем из обычного вектора.
local rotate = Angle(0,0,-20) -- Вращение
function SearchForClassInTable(tab, class)
	for k, v in pairs(tab) do
		if v:GetClass() == class then return v end
	end
	return nil
end
function DrawColorCorrection(t, from, to)
	local tab = {
		["$pp_colour_addr"] = Lerp(t, from["$pp_colour_addr"], to["$pp_colour_addr"]),
		["$pp_colour_addg"] = Lerp(t, from["$pp_colour_addg"], to["$pp_colour_addg"]),
		["$pp_colour_addb"] = Lerp(t, from["$pp_colour_addb"], to["$pp_colour_addb"]),
		["$pp_colour_brightness"] = Lerp(t, from["$pp_colour_brightness"], to["$pp_colour_brightness"]),
		["$pp_colour_contrast"] = Lerp(t, from["$pp_colour_contrast"], to["$pp_colour_contrast"]),
		["$pp_colour_colour"] = Lerp(t, from["$pp_colour_colour"], to["$pp_colour_colour"]),
		["$pp_colour_mulr"] = Lerp(t, from["$pp_colour_mulr"], to["$pp_colour_mulr"]),
		["$pp_colour_mulg"] = Lerp(t, from["$pp_colour_mulg"], to["$pp_colour_mulg"]),
		["$pp_colour_mulb"] = Lerp(t, from["$pp_colour_mulb"], to["$pp_colour_mulb"])
	}
	DrawColorModify(tab)
end
function LerpColor(t, fromcol, tocol)
	local from1, from2, from3 = ColorToHSL(fromcol) // Как подсказывают на форумах и вики: лучше переводить в hsv, а потом уже лерпать.
	local to1, to2, to3 = ColorToHSL(tocol)
	local f1 = Lerp(t, from1, to1)
	local f2 = Lerp(t, from2, to2)
	local f3 = Lerp(t, from3, to3)
	return HSLToColor(f1, f2, f3)
end
function BuildCircle(xx, yy, radius)
	local triangle = {} // P.s На будущее - если мне лень пользоваться math.cos - могу представить это как угол, а потом forward()
		triangle[1] = { 
			{x = xx + radius * -0.382683, y = yy + radius * -0.923880},
			{x = xx, y = yy - radius},
			{x = xx, y = yy}
		}
		triangle[2] = { 
			{x = xx + radius * -0.707107, y = yy + radius * -0.707107},
			{x = xx + radius * -0.382683, y = yy + radius * -0.923880},
			{x = xx, y = yy}
		}
		triangle[3] = { 
			{x = xx + radius * -0.920505, y = yy + radius * -0.390731},
			{x = xx + radius * -0.707107, y = yy + radius * -0.707107},
			{x = xx, y = yy}
		}
		triangle[4] = { 
			{x = xx - radius, y = yy},
			{x = xx + radius * -0.920505, y = yy + radius * -0.390731},
			{x = xx, y = yy}
		}
		triangle[5] = { 
			{x = xx + radius * -0.920505, y = yy + radius * 0.390731},
			{x = xx - radius, y = yy},
			{x = xx, y = yy}
		}
		triangle[6] = { 
			{x = xx + radius * -0.707107, y = yy + radius * 0.707107},
			{x = xx + radius * -0.920505, y = yy + radius * 0.390731},
			{x = xx, y = yy}
		}
		triangle[7] = { 
			{x = xx + radius * -0.382683, y = yy + radius * 0.923880},
			{x = xx + radius * -0.707107, y = yy + radius * 0.707107},
			{x = xx, y = yy}
		}
		triangle[8] = { 
			{x = xx, y = yy + radius},
			{x = xx + radius * -0.382683, y = yy + radius * 0.923880},
			{x = xx, y = yy}
		}
		triangle[9] = { 
			{x = xx + radius * 0.382683, y = yy + radius * 0.923880},
			{x = xx, y = yy + radius},
			{x = xx, y = yy}
		}
		triangle[10] = { 
			{x = xx + radius * 0.707107, y = yy + radius * 0.707107},
			{x = xx + radius * 0.382683, y = yy + radius * 0.923880},
			{x = xx, y = yy}
		}
		triangle[11] = { 
			{x = xx + radius * 0.920505, y = yy + radius * 0.390731},
			{x = xx + radius * 0.707107, y = yy + radius * 0.707107},
			{x = xx, y = yy}
		}
		triangle[12] = { 
			{x = xx + radius, y = yy},
			{x = xx + radius * 0.920505, y = yy + radius * 0.390731},
			{x = xx, y = yy}
		}
		triangle[13] = { 
			{x = xx + radius * 0.920505, y = yy + radius * -0.390731},
			{x = xx + radius, y = yy},
			{x = xx, y = yy}
		}
		triangle[14] = { 
			{x = xx + radius * 0.707107, y = yy + radius * -0.707107},
			{x = xx + radius * 0.920505, y = yy + radius * -0.390731},
			{x = xx, y = yy}
		}
		triangle[15] = { 
			{x = xx + radius * 0.382683, y = yy + radius * -0.923880},
			{x = xx + radius * 0.707107, y = yy + radius * -0.707107},
			{x = xx, y = yy}
		}
		triangle[16] = { 
			{x = xx, y = yy - radius},
			{x = xx + radius * 0.382683, y = yy + radius * -0.923880},
			{x = xx, y = yy}
		}
	return triangle
end
function DrawCircle(tab, t, color)
	draw.NoTexture()
	surface.SetDrawColor(color.r, color.g, color.b, color.a)
	local tab1 = {{}, {}, {}}
	if t <= 0.0625 then // Тут, к сожалению царит луа, так что никаких switch statement. Даже вариант с таблицей с функцииями хуже справляется.
		local t = t / 0.0625
		tab1[1].x = Lerp(t, tab[1][2].x, tab[1][1].x) // Так что придется довольствоваться if'ами. Может в луа они лучше чем с C..
		tab1[1].y = Lerp(t, tab[1][2].y, tab[1][1].y)
		tab1[2].x = tab[1][2].x
		tab1[2].y = tab[1][2].y
		tab1[3].x = tab[1][3].x
		tab1[3].y = tab[1][3].y
		surface.DrawPoly(tab1)
	elseif t <= 0.125 then
		local t = ( t - 0.0625 ) / 0.0625
		tab1[1].x = Lerp(t, tab[2][2].x, tab[2][1].x)
		tab1[1].y = Lerp(t, tab[2][2].y, tab[2][1].y)
		tab1[2].x = tab[2][2].x
		tab1[2].y = tab[2][2].y
		tab1[3].x = tab[2][3].x
		tab1[3].y = tab[2][3].y
		surface.DrawPoly(tab[1])
		surface.DrawPoly(tab1)
	elseif t <= 0.1875 then
		local t = ( t - 0.125 ) / 0.0625
		tab1[1].x = Lerp(t, tab[3][2].x, tab[3][1].x)
		tab1[1].y = Lerp(t, tab[3][2].y, tab[3][1].y)
		tab1[2].x = tab[3][2].x
		tab1[2].y = tab[3][2].y
		tab1[3].x = tab[3][3].x
		tab1[3].y = tab[3][3].y
		surface.DrawPoly(tab[1])
		surface.DrawPoly(tab[2])
		surface.DrawPoly(tab1)
	elseif t <= 0.25 then
		local t = ( t - 0.1875 ) / 0.0625
		tab1[1].x = Lerp(t, tab[4][2].x, tab[4][1].x)
		tab1[1].y = Lerp(t, tab[4][2].y, tab[4][1].y)
		tab1[2].x = tab[4][2].x
		tab1[2].y = tab[4][2].y
		tab1[3].x = tab[4][3].x
		tab1[3].y = tab[4][3].y
		surface.DrawPoly(tab[1])
		surface.DrawPoly(tab[2])
		surface.DrawPoly(tab[3])
		surface.DrawPoly(tab1)
	elseif t <= 0.3125 then
		local t = ( t - 0.25 ) / 0.0625
		tab1[1].x = Lerp(t, tab[5][2].x, tab[5][1].x)
		tab1[1].y = Lerp(t, tab[5][2].y, tab[5][1].y)
		tab1[2].x = tab[5][2].x
		tab1[2].y = tab[5][2].y
		tab1[3].x = tab[5][3].x
		tab1[3].y = tab[5][3].y
		for i = 1, 4 do
			surface.DrawPoly(tab[i])
		end
		surface.DrawPoly(tab1)
	elseif t <= 0.375 then
		local t = ( t - 0.3125 ) / 0.0625
		tab1[1].x = Lerp(t, tab[6][2].x, tab[6][1].x)
		tab1[1].y = Lerp(t, tab[6][2].y, tab[6][1].y)
		tab1[2].x = tab[6][2].x
		tab1[2].y = tab[6][2].y
		tab1[3].x = tab[6][3].x
		tab1[3].y = tab[6][3].y
		for i = 1, 5 do
			surface.DrawPoly(tab[i])
		end
		surface.DrawPoly(tab1)
	elseif t <= 0.4375 then
		local t = ( t - 0.375 ) / 0.0625
		tab1[1].x = Lerp(t, tab[7][2].x, tab[7][1].x)
		tab1[1].y = Lerp(t, tab[7][2].y, tab[7][1].y)
		tab1[2].x = tab[7][2].x
		tab1[2].y = tab[7][2].y
		tab1[3].x = tab[7][3].x
		tab1[3].y = tab[7][3].y
		for i = 1, 6 do
			surface.DrawPoly(tab[i])
		end
		surface.DrawPoly(tab1)
	elseif t <= 0.5 then
		local t = ( t - 0.4375 ) / 0.0625
		tab1[1].x = Lerp(t, tab[8][2].x, tab[8][1].x)
		tab1[1].y = Lerp(t, tab[8][2].y, tab[8][1].y)
		tab1[2].x = tab[8][2].x
		tab1[2].y = tab[8][2].y
		tab1[3].x = tab[8][3].x
		tab1[3].y = tab[8][3].y
		for i = 1, 7 do
			surface.DrawPoly(tab[i])
		end
		surface.DrawPoly(tab1)
	elseif t <= 0.5625 then
		local t = ( t - 0.5 ) / 0.0625
		tab1[1].x = Lerp(t, tab[9][2].x, tab[9][1].x)
		tab1[1].y = Lerp(t, tab[9][2].y, tab[9][1].y)
		tab1[2].x = tab[9][2].x
		tab1[2].y = tab[9][2].y
		tab1[3].x = tab[9][3].x
		tab1[3].y = tab[9][3].y
		for i = 1, 8 do
			surface.DrawPoly(tab[i])
		end
		surface.DrawPoly(tab1)
	elseif t <= 0.625 then
		local t = ( t - 0.5625 ) / 0.0625
		tab1[1].x = Lerp(t, tab[10][2].x, tab[10][1].x)
		tab1[1].y = Lerp(t, tab[10][2].y, tab[10][1].y)
		tab1[2].x = tab[10][2].x
		tab1[2].y = tab[10][2].y
		tab1[3].x = tab[10][3].x
		tab1[3].y = tab[10][3].y
		for i = 1, 9 do
			surface.DrawPoly(tab[i])
		end
		surface.DrawPoly(tab1)
	elseif t <= 0.6875 then
		local t = ( t - 0.625 ) / 0.0625
		tab1[1].x = Lerp(t, tab[11][2].x, tab[11][1].x)
		tab1[1].y = Lerp(t, tab[11][2].y, tab[11][1].y)
		tab1[2].x = tab[11][2].x
		tab1[2].y = tab[11][2].y
		tab1[3].x = tab[11][3].x
		tab1[3].y = tab[11][3].y
		for i = 1, 10 do
			surface.DrawPoly(tab[i])
		end
		surface.DrawPoly(tab1)
	elseif t <= 0.75 then
		local t = ( t - 0.6875 ) / 0.0625
		tab1[1].x = Lerp(t, tab[12][2].x, tab[12][1].x)
		tab1[1].y = Lerp(t, tab[12][2].y, tab[12][1].y)
		tab1[2].x = tab[12][2].x
		tab1[2].y = tab[12][2].y
		tab1[3].x = tab[12][3].x
		tab1[3].y = tab[12][3].y
		for i = 1, 11 do
			surface.DrawPoly(tab[i])
		end
		surface.DrawPoly(tab1)
	elseif t <= 0.8125 then
		local t = ( t - 0.75 ) / 0.0625
		tab1[1].x = Lerp(t, tab[13][2].x, tab[13][1].x)
		tab1[1].y = Lerp(t, tab[13][2].y, tab[13][1].y)
		tab1[2].x = tab[13][2].x
		tab1[2].y = tab[13][2].y
		tab1[3].x = tab[13][3].x
		tab1[3].y = tab[13][3].y
		for i = 1, 12 do
			surface.DrawPoly(tab[i])
		end
		surface.DrawPoly(tab1)
	elseif t <= 0.875 then
		local t = ( t - 0.8125 ) / 0.0625
		tab1[1].x = Lerp(t, tab[14][2].x, tab[14][1].x)
		tab1[1].y = Lerp(t, tab[14][2].y, tab[14][1].y)
		tab1[2].x = tab[14][2].x
		tab1[2].y = tab[14][2].y
		tab1[3].x = tab[14][3].x
		tab1[3].y = tab[14][3].y
		for i = 1, 13 do
			surface.DrawPoly(tab[i])
		end
		surface.DrawPoly(tab1)
	elseif t <= 0.9375 then
		local t = ( t - 0.875 ) / 0.0625
		tab1[1].x = Lerp(t, tab[15][2].x, tab[15][1].x)
		tab1[1].y = Lerp(t, tab[15][2].y, tab[15][1].y)
		tab1[2].x = tab[15][2].x
		tab1[2].y = tab[15][2].y
		tab1[3].x = tab[15][3].x
		tab1[3].y = tab[15][3].y
		for i = 1, 14 do
			surface.DrawPoly(tab[i])
		end
		surface.DrawPoly(tab1)
	elseif t < 1 then
		local t = ( t - 0.9375 ) / 0.0625
		tab1[1].x = Lerp(t, tab[16][2].x, tab[16][1].x)
		tab1[1].y = Lerp(t, tab[16][2].y, tab[16][1].y)
		tab1[2].x = tab[16][2].x
		tab1[2].y = tab[16][2].y
		tab1[3].x = tab[16][3].x
		tab1[3].y = tab[16][3].y
		for i = 1, 15 do
			surface.DrawPoly(tab[i])
		end
		surface.DrawPoly(tab1)
	else
		for i = 1, 16 do
			surface.DrawPoly(tab[i])
		end
	end
end
function NPC:IsTryingToRevive() // Простенькая функция
	return self:GetNWBool("TryingToRevive")
end
function NPC:SetTryingToRevive(bool) // Простенькая функция
	 self:SetNWBool("TryingToRevive", bool)
end
function NPC:GetReviveEnt() // Простенькая функция
	return self:GetNWEntity("NpcReviveent")
end
function NPC:SetReviveEnt(ent) // Простенькая функция
	self:SetNWEntity("NpcReviveent", ent)
end
function NPC:IsReviving() // Простенькая функция
	return self:GetNWBool("NPCReviving")
end
function NPC:SetReviving(bool) // Простенькая функция
	self:SetNWBool("NPCReviving", bool)
end
function NPC:GetReviveTime() // Простенькая функция
	return self:GetNWFloat("NPCReviveTime")
end
function NPC:SetReviveTime(time) // Простенькая функция
	self:SetNWFloat("NPCReviveTime", time)
end
function PLAYER:IsReviving() // Простенькая функция
	return self:GetNWBool("Reviving")
end
function PLAYER:SetReviving(bool) // Простенькая функция
	self:SetNWBool("Reviving", bool)
end
function PLAYER:GetBloodDelay() // Простенькая функция
	return self:GetNWFloat("Delay")
end
function PLAYER:SetBloodDelay(time) // Простенькая функция
	self:SetNWFloat("Delay", time)
end
function PLAYER:IsNPCReviving() // Простенькая функция
	return self:GetNWBool("NPCReviving")
end
function PLAYER:SetNPCReviving(bool) // Простенькая функция
	self:SetNWBool("NPCReviving", bool)
end
function PLAYER:GetNPCRevivour() // Простенькая функция
	return self:GetNWEntity("NPCRevivingEnt")
end
function PLAYER:SetNPCRevivour(ent) // Простенькая функция
	self:SetNWEntity("NPCRevivingEnt", ent)
end
function PLAYER:GetAttacker() // Простенькая функция
	return self:GetNWEntity("Attacker")
end
function PLAYER:SetAttacker(ent) // Простенькая функция
	self:SetNWEntity("Attacker", ent)
end
function PLAYER:GetAttackerWeapon() // Простенькая функция
	return self:GetNWEntity("AttackerWeap")
end
function PLAYER:SetAttackerWeapon(ent) // Простенькая функция
	self:SetNWEntity("AttackerWeap", ent)
end
function PLAYER:IsBeingReviving() // Простенькая функция
	return self:GetNWBool("BeingReviving")
end
function PLAYER:SetBeingReviving(bool) // Простенькая функция
	self:SetNWBool("BeingReviving", bool)
end
function PLAYER:IsBeingNPCReviving() // Простенькая функция
	return self:GetNWBool("BeingNPCReviving")
end
function PLAYER:SetBeingNPCReviving(bool) // Простенькая функция
	self:SetNWBool("BeingNPCReviving", bool)
end
function PLAYER:GetNumBleedOuts() // Простенькая функция
	return self:GetNWInt("NumBleedOuts")
end
function PLAYER:SetNumBleedOuts(num) // Простенькая функция
	self:SetNWInt("NumBleedOuts", num)
end
function PLAYER:GetReviveTimeFromEntity() // entity - игрок, которого возрождают
	return self:GetNWFloat("ReviveTimeFromEnt")
end
function PLAYER:SetReviveTimeFromEntity(time) // Простенькая функция
	self:SetNWFloat("ReviveTimeFromEnt", time)
end
function PLAYER:GetReviveTime() // Простенькая функция
	return self:GetNWFloat("ReviveTime")
end
function PLAYER:SetReviveTime(time) // Простенькая функция
	self:SetNWFloat("ReviveTime", time)
end
function PLAYER:GetBleedOutTime() // Простенькая функция
	return self:GetNWFloat("BleedOutTime")
end
function PLAYER:SetBleedOutTime(timing)
	self:SetNWFloat("BleedOutTime", timing)
end
function PLAYER:IsBleedOut() // Простенькая функция, показывающая упал ли игрок или нет?
	return self:GetNWBool("BleedOut")
end
function PLAYER:SetBleedOut(bool) // bool - да или нет. Упал или встал? Вот в чем вопрос
	local curtime = CurTime()
	if curtime == nil then //11
		curtime = RealTime() //11
	end
	self:SetNWBool("BleedOut", bool)
	if bool == true then
		self:SetNWFloat("BleedOutTime", curtime)
	else
		self:SetNWFloat("BleedOutTime", 0)
	end
end
function PLAYER:GetRevivingEntity()
	return self:GetNWEntity("RevivingEntity")
end
function PLAYER:SetRevivingEntity(ent)
	self:SetNWEntity("RevivingEntity", ent)
end

--- ^ shared functions
if SERVER then // Добавляю нетворк вары. Все предназначено для клиента.
	util.AddNetworkString("bleedout_go") // Когда кто то упал
	util.AddNetworkString("bleedout_out") // Когда кто то всталл
	util.AddNetworkString("bleedout_settable") // Сам процесс воскрешения.
	util.AddNetworkString("bleedout_suicide") // Типо команда, позволяющая сдохнуть. Наподобии kill
	util.AddNetworkString("bleedout_help") // Типо команда, позволяющая позвать на помощь.
end
if SERVER then
	function serverthink()
		local time = CurTime()
		for k, v in pairs(player.GetRevivingPlayers()) do
			time1 = v:GetReviveTime()
			if time1 != 0 then
				time2 = time1 + convar6:GetInt()
				if v:GetRevivingEntity():IsBleedOut() == false then
					v:SetReviving(false)
					v:SetWalkSpeed(120)
					v:SetRunSpeed(180)
					v:GetRevivingEntity():StopReviving() // GetRevivingEntity - игрок, которого воскрешают. 
					v:GetRevivingEntity():Revive()
					v:SetRevivingEntity(Entity(0)) // Очищаем ненужные вещи.
				end
				if time >= time2 then
					v:SetReviving(false)
					v:SetWalkSpeed(120)
					v:SetRunSpeed(180)
					v:GetRevivingEntity():StopReviving() // GetRevivingEntity - игрок, которого воскрешают. 
					v:GetRevivingEntity():Revive()
					v:SetRevivingEntity(Entity(0)) // Очищаем ненужные вещи.
				end
			end
		end
		for k, v in pairs(player.GetBleedOuts()) do
			time1 = v:GetBleedOutTime()
			if convar27:GetBool() == true and time > v:GetBloodDelay() then
				util.Decal( "Blood", v:EyePos(), v:GetPos() - Vector(0, 0, 10), v )
				v:SetBloodDelay(CurTime() + 3)
			end
			if convar25:GetBool() == true then
				if v:IsNPCReviving() == false then // Снизу идет поиск нпс ревайвора.
					rebels = ents.FindByClass("npc_citizen")
					//table.sort(rebels, function(a, b) return a:GetPos():Distance(v:EyePos()) < b:GetPos():Distance(v:EyePos()) end)
					for k1, v1 in pairs(rebels) do
						if v1:Visible(v) and v1:IsTryingToRevive() == false and v1:IsUnreachable(v) == false and v:IsNPCReviving() == false and v1:GetPos():Distance(v:GetPos()) < 512 and v1:Disposition( v ) == D_LI and v:IsBeingReviving() == false then
							v1:SetTryingToRevive(true)
							v1:SetReviveEnt(v)
							vectors = v:GetPos() + Vector(0, 0, 31)
							v1:SetSaveValue("m_vecLastPosition", vectors)
							v1:SetSchedule(SCHED_FORCED_GO_RUN)
							v:SetNPCReviving(true)
							v:SetNPCRevivour(v1)
						end
					end
				else
					local revivour = v:GetNPCRevivour()
					if IsValid(revivour) == false or revivour:GetPos():Distance(v:GetPos() + Vector(0, 0, 36)) > 512 or v:IsBleedOut() == false or v:IsBeingReviving() == true and !IsValid(v:GetNPCRevivour()) then 
						v:SetNPCRevivour(Entity(0))
						if IsValid(revivour) then 
								revivour:SetReviving(false)
								revivour:SetReviveTime(0)
								revivour:SetTryingToRevive(false)
								revivour:SetReviveEnt(Entity(0)) end
						revivour = Entity(0)
						v:SetNPCReviving(false)
						if v:IsBeingNPCReviving() == true then
							v:SetBeingNPCReviving(false)
							v:StopReviving()
						end
					elseif v:GetPos():Distance(vectors) > 64 then
						vectors = v:GetPos() + Vector(0, 0, 31)
						revivour:SetSaveValue("m_vecLastPosition", vectors)
						revivour:SetSchedule(SCHED_FORCED_GO_RUN)
					end
					if revivour != Entity(0) then
						if revivour:GetPos():Distance(v:GetPos() + Vector(0, 0, 36)) <= 128 and revivour:IsReviving() == false and !revivour:IsMoving() and v:IsBleedOut() == true and v:IsBeingReviving() == false then
							revivour:SetSequence("Crouch_idleD")
							revivour:SetReviving(true)
							revivour:SetReviveTime(CurTime())
							v:SetBeingReviving(true)
							v:SetBeingNPCReviving(true)
							v:StartReviving()
						elseif revivour:IsReviving() == true then
							revivour:SetSequence("Crouch_idleD")
							local npctime1 = CurTime()
							local npctime2 = revivour:GetReviveTime() + convar6:GetInt()
							if npctime1 >= npctime2 then
								revivour:SetReviving(false)
								revivour:SetReviveTime(0)
								v:SetBeingNPCReviving(false)
								revivour:SetTryingToRevive(false)
								revivour:SetReviveEnt(Entity(0))
								v:SetNPCRevivour(Entity(0))
								v:SetNPCReviving(false)
								v:StopReviving()
								v:Revive()
								revivour = Entity(0)
							end
						end
					end
				end
			end
			if time1 != 0 and v:IsBeingReviving() == false then
				time2 = time1 + convar5:GetInt()
				if time >= time2 then
					if !IsValid(v:GetAttacker()) then
						v:Kill()
						v:GodDisable()
						v:Revive()
					end
				end
			end
		end
	end
	hook.Add("KeyPress", "ReviveUseChecker", function(ply, key) // Чек нажатия юз кнопки. На сервере потому что так будет легче
		if ply:Team() == 2 then return true end
		if key == 32 and ply:IsBleedOut() == false and ply:IsReviving() == false then
			ply:TryRevive()
		elseif key == 32 and ply:IsBleedOut() == false and ply:IsReviving() == true then
			ply:SetReviving(false)
			ply:GetRevivingEntity():StopReviving()
			ply:GetRevivingEntity():SetBleedOutTime(CurTime() - ply:GetReviveTimeFromEntity())
			ply:SetRevivingEntity(Entity(0))
		end
	end)
end
if CLIENT then
	function PLAYER:Revive()
	end
	local mator = Material("bleedout/REVIVESKULL.png") // Иконка revive над игроками
	local mator0 = Material("bleedout/REVIVEICON.png") // COD версия иконки
	local mator1 = Material("bleedout/BLOODONSCR.png") // Кровь
	local itext1 = Material("bleedout/BLOODONSCR.png"):GetTexture("$basetexture") // Кешированая текстура
	local mator2 = Material("bleedout/BLEEDINGOUT.png") // Таймер
	local skullmat = Material("bleedout/SKULL.png") // Черепок
	local syrmat = Material("bleedout/SYRINGE.png") // Шприц
	local itext2 = Material("bleedout/BLEEDINGOUT.png"):GetTexture("$basetexture") // Кешированая текстура
	local centre = ScrW() / 2
	local centrey = ScrH() - 96
	local circle = BuildCircle(centre, centrey, 64)
	local circle2 = BuildCircle(centre, centrey, 42)
	hook.Add("HUDPaint", "BleedOutHudPrint", function()
		if LocalPlayer():IsBleedOut() == true and convar15:GetBool() == true then
			surface.SetMaterial(mator1)
			local time = CurTime()
			local time1 = LocalPlayer():GetBleedOutTime() + convar5:GetInt()
			local time2 = time1 - time
			local percenttime = time2 / convar5:GetInt() // Делает это в виде процента десятичной системы
			if percenttime < 0 then percenttime = 1 end
			surface.SetDrawColor(255, 255, 255, Lerp(percenttime, 255, 0) / 6 )
			surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
		end
		if LocalPlayer():IsBleedOut() == true and LocalPlayer():GetBleedOutTime() == 0 then
			draw.DrawText("You are being lifted up.", "Trebuchet24", ScrW() * 0.5, ScrH() * 0.8, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER)
		end
		if LocalPlayer():IsReviving() == true and convar21:GetBool() == true and convar19:GetInt() == 0 then
			local time = CurTime()
			local time1 = LocalPlayer():GetReviveTime() + convar6:GetFloat()
			local time2 = time1 - time
			local time3 = ( time2 - convar6:GetFloat() ) * -1
			local percenttime = time3 / convar6:GetInt()
			DrawCircle(circle, percenttime, LerpColor(percenttime, Color(255,0,0), Color(0,255,0)))
			DrawCircle(circle2, 1, Color(0,0,0) )
			surface.SetMaterial(syrmat)
			surface.SetDrawColor(255, 255, 255)
			surface.DrawTexturedRect(centre - 32, centrey - 32, 64, 64)
		elseif LocalPlayer():IsReviving() == true and convar21:GetBool() == true and convar19:GetInt() == 1 then
			local time = CurTime()
			local time1 = LocalPlayer():GetReviveTime() + convar6:GetFloat()
			local time2 = time1 - time
			local time3 = ( time2 - convar6:GetFloat() ) * -1
			local percenttime = time3 / convar6:GetInt()
			widthdif = ScrW() * 0.6 - ScrW() * 0.4
			local greenboxmetr = widthdif * percenttime
			local greenred = LerpColor(percenttime, Color(255,0,0), Color(0,255,0))
			draw.DrawText("Reviving.", "Trebuchet24", ScrW() * 0.5, ScrH() * 0.8, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER)
			surface.SetDrawColor(50, 50, 50, 255)
			surface.DrawRect(ScrW() * 0.4, ScrH() * 0.7, ScrW() * 0.6 - ScrW() * 0.4, ScrH() * 0.75 - ScrH() * 0.7)
			surface.SetDrawColor(greenred.r, greenred.g, greenred.b)
			surface.DrawRect(ScrW() * 0.4, ScrH() * 0.7, greenboxmetr, ScrH() * 0.75 - ScrH() * 0.7)
		elseif LocalPlayer():IsReviving() == true and convar21:GetBool() == true and convar19:GetInt() == 2 then
			local time = CurTime()
			local time1 = LocalPlayer():GetReviveTime() + convar6:GetFloat()
			local time2 = math.ceil(time1 - time)
			draw.DrawText("Reviving.", "Trebuchet24", ScrW() * 0.5, ScrH() * 0.8, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER)
		elseif LocalPlayer():IsReviving() == true and convar21:GetBool() == true and convar19:GetInt() == 3 then
			local time = CurTime()
			local time1 = LocalPlayer():GetReviveTime() + convar6:GetFloat()
			local time2 = time1 - time
			local time3 = ( time2 - convar6:GetFloat() ) * -1
			local percenttime = time3 / convar6:GetInt()
			DrawCircle(circle, percenttime, LerpColor(percenttime, Color(255,0,0), Color(0,255,0)))
			DrawCircle(circle2, 1, Color(0,0,0) )
			surface.SetMaterial(syrmat)
			surface.SetDrawColor(255, 255, 255)
			surface.DrawTexturedRect(centre - 32, centrey - 32, 64, 64)
			surface.DrawCircle(centre, centrey, 63, 0, 0, 0)
			surface.DrawCircle(centre, centrey, 63.5, 0, 0, 0)
			surface.DrawCircle(centre, centrey, 64, 0, 0, 0)
		end
		time = CurTime()
		if LocalPlayer():GetBleedOutTime() != 0 and convar18:GetBool() == true and convar19:GetInt() == 0 then
			local time = CurTime()
			local time1 = LocalPlayer():GetBleedOutTime() + convar5:GetInt()
			local time2 = time1 - time
			local percenttime = time2 / convar5:GetInt() // Делает это в виде процента десятичной системы
			DrawCircle(circle, percenttime, LerpColor(percenttime, Color(255,0,0), Color(0,255,0)))
			DrawCircle(circle2, 1, Color(0,0,0))
			surface.SetMaterial(skullmat)
			surface.SetDrawColor(255, 255, 255)
			surface.DrawTexturedRect(centre - 32, centrey - 32, 64, 64)
		elseif LocalPlayer():GetBleedOutTime() != 0 and convar18:GetBool() == true and convar19:GetInt() == 1 then
			local time = CurTime()
			local time1 = LocalPlayer():GetBleedOutTime() + convar5:GetInt()
			local time2 = time1 - time
			widthdif = ScrW() * 0.85 - ScrW() * 0.7 // Так как я делаю это без знаний сколько у игрока разрешение - использую scrw и тому подобное. Сейчас это отнимание большей части и меньшей и получение их разницы. В итоге получаем ширину
			local percenttime1 = time2 / convar5:GetInt() // Делает это в виде процента десятичной системы
			local greenboxmetr1 = widthdif * percenttime1
			surface.SetDrawColor(255, 255, 255, 230)
			surface.SetMaterial(mator2)
			local greenred = LerpColor(percenttime1, Color(255,0,0), Color(0,255,0))
			surface.DrawTexturedRect(ScrW() * 0.6, ScrH() * 0.6, ScrW() - ScrW() * 0.6, ScrH() - ScrH() * 0.6)
			surface.SetDrawColor(100, 100, 100, 255)
			surface.DrawRect(ScrW() * 0.7, ScrH() * 0.8, ScrW() * 0.85 - ScrW() * 0.7, ScrH() * 0.825 - ScrH() * 0.8)
			surface.SetDrawColor(greenred.r, greenred.g, greenred.b)
			surface.DrawRect(ScrW() * 0.7, ScrH() * 0.8, greenboxmetr1, ScrH() * 0.825 - ScrH() * 0.8)
		elseif LocalPlayer():GetBleedOutTime() != 0 and convar18:GetBool() == true and convar19:GetInt() == 2 then // Legacy UI
			local time = CurTime()
			local time1 = LocalPlayer():GetBleedOutTime() + convar5:GetInt()
			local time2 = math.ceil(time1 - time)
			draw.DrawText("Arrest after:", "Trebuchet24", ScrW() - 200, ScrH() - 300, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER)
			draw.DrawText(tostring(time2), "Trebuchet24", ScrW() - 200, ScrH() - 265, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER)
		elseif LocalPlayer():GetBleedOutTime() != 0 and convar18:GetBool() == true and convar19:GetInt() == 3 then
			local time = CurTime()
			local time1 = LocalPlayer():GetBleedOutTime() + convar5:GetInt()
			local time2 = time1 - time
			local percenttime = time2 / convar5:GetInt() // Делает это в виде процента десятичной системы
			DrawCircle(circle, percenttime, LerpColor(percenttime, Color(255,0,0), Color(0,255,0)))
			DrawCircle(circle2, 1, Color(0,0,0))
			surface.SetMaterial(skullmat)
			surface.SetDrawColor(255, 255, 255)
			surface.DrawTexturedRect(centre - 32, centrey - 32, 64, 64)
			surface.DrawCircle(centre, centrey, 63, 0, 0, 0)
			surface.DrawCircle(centre, centrey, 63.5, 0, 0, 0)
			surface.DrawCircle(centre, centrey, 64, 0, 0, 0)
		end
	end)
	hook.Add("PostPlayerDraw", "BleedoutIconDraw", function(ply)
		if ply:IsBleedOut() == true and convar3:GetBool() == true then
			if convar7:GetBool() == false then
				if convar13:GetString() != "bleedout/REVIVEICON.png" and convar13:GetString() != "bleedout/REVIVESKULL.png" then
					cam.Start2D()
					surface.SetDrawColor(255, 255, 255)
					local mat1 = Material(convar13:GetString(), alphatest) // Кастомный материал
					surface.SetMaterial(mat1)
					vpos = ply:GetPos() + Vector(0, 0, 72)
					local pos = vpos:ToScreen() // Для оптимизации, если не видно - значит хер с ним.
					surface.SetDrawColor( 255,255,255 )
					if pos.visible == true then
						surface.DrawTexturedRect( pos.x - convar14:GetInt() * 0.5 , pos.y - convar14:GetInt() * 0.5, convar14:GetInt() * 2, convar14:GetInt() * 2 )
					end
					cam.End2D()
				elseif convar13:GetString() == "bleedout/REVIVEICON.png" then
					cam.Start2D()
					surface.SetMaterial(mator0)
					local time1 = ply:GetBleedOutTime() + convar5:GetInt()
					local time2 = time1 - time
					vpos = ply:GetPos() + Vector(0, 0, 72)
					local pos = vpos:ToScreen() // Для оптимизации, если не видно - значит хер с ним.
					local percenttime = time2 / convar5:GetInt()
					if percenttime > 0 then
						surface.SetDrawColor(LerpColor(percenttime, Color(255,0,0), Color(0,255,0)).r, LerpColor(percenttime, Color(255,0,0), Color(0,255,0)).g, LerpColor(percenttime, Color(255,0,0), Color(0,255,0)).b)
					else
						surface.SetDrawColor(255, 255, 255)
					end
					if pos.visible == true then
						surface.DrawTexturedRect( pos.x - convar14:GetInt() , pos.y - convar14:GetInt(), convar14:GetInt() * 2, convar14:GetInt() * 2 )
					end
					cam.End2D()
				elseif convar13:GetString() == "bleedout/REVIVESKULL.png" then
					cam.Start2D()
					surface.SetMaterial(mator)
					local time1 = ply:GetBleedOutTime() + convar5:GetInt()
					local time2 = time1 - time
					vpos = ply:GetPos() + Vector(0, 0, 72)
					local pos = vpos:ToScreen() // Для оптимизации, если не видно - значит хер с ним.
					local percenttime = time2 / convar5:GetInt()
					if percenttime > 0 then
						surface.SetDrawColor(LerpColor(percenttime, Color(255,0,0), Color(0,255,0)).r, LerpColor(percenttime, Color(255,0,0), Color(0,255,0)).g, LerpColor(percenttime, Color(255,0,0), Color(0,255,0)).b)
					else
						surface.SetDrawColor(255, 255, 255)
					end	
					if pos.visible == true then
						surface.DrawTexturedRect( pos.x - convar14:GetInt() , pos.y - convar14:GetInt(), convar14:GetInt() * 2, convar14:GetInt() * 2 )
					end
					cam.End2D()
				end
			elseif convar13:GetString() != "bleedout/REVIVESKULL.png" and convar13:GetString() != "bleedout/REVIVEICON.png" then // Функция, которая позволяет менять текстурки иконок с помощью конс. Команд.
				render.DepthRange(0, 0)
				local mat1 = Material(convar13:GetString(), alphatest) // Кастомный материал
				render.SetMaterial(mat1) // Ставит кастомный материал.
				vpos = ply:GetPos() + Vector(0, 0, 72)
				render.DrawSprite(vpos, convar14:GetInt(), convar14:GetInt(), Color(255,255,255) )
				render.DepthRange(0, 1)
			elseif convar13:GetString() == "bleedout/REVIVEICON.png" then
				render.DepthRange(0, 0)
				render.SetMaterial(mator0) // Ставит кастомный материал.
				vpos = ply:GetPos() + Vector(0, 0, 72)
				local time = CurTime()
				local time1 = ply:GetBleedOutTime() + convar5:GetInt()
				local time2 = time1 - time
				local percenttime = time2 / convar5:GetInt()
				if percenttime > 0 then
					render.DrawSprite(vpos, convar14:GetInt(), convar14:GetInt(), LerpColor(percenttime, Color(255,0,0), Color(0,255,0)))
				else
					render.DrawSprite(vpos, convar14:GetInt(), convar14:GetInt(), Color(255,255,255))
				end
				render.DepthRange(0, 1)
			elseif convar13:GetString() == "bleedout/REVIVESKULL.png" then
				render.DepthRange(0, 0)
				render.SetMaterial(mator) // Ставит кастомный материал.
				vpos = ply:GetPos() + Vector(0, 0, 72)
				local time = CurTime()
				local time1 = ply:GetBleedOutTime() + convar5:GetInt()
				local time2 = time1 - time
				local percenttime = time2 / convar5:GetInt()
				if percenttime > 0 then
					render.DrawSprite(vpos, convar14:GetInt(), convar14:GetInt(), LerpColor(percenttime, Color(255,0,0), Color(0,255,0)))
				else
					render.DrawSprite(vpos, convar14:GetInt(), convar14:GetInt(), Color(255,255,255))
				end
				render.DepthRange(0, 1)
			end
		end
	end)
	hook.Add("PlayerBindPress", "DisableJumpingAndCrouching", function(ply, bind, bool) // Если игрок упал, то он не сможет нажать прыжок и присед
		if bind == "+jump" and ply:IsBleedOut() == true or bind == "+duck" and ply:IsBleedOut() == true then
			return true
		end
	end)
	local totab = 
	{
		[ "$pp_colour_addr" ] = 0,
		[ "$pp_colour_addg" ] = 0,
		[ "$pp_colour_addb" ] = 0,
		[ "$pp_colour_brightness" ] = -1,
		[ "$pp_colour_contrast" ] = 0,
		[ "$pp_colour_colour" ] = 0,
		[ "$pp_colour_mulr" ] = 0,
		[ "$pp_colour_mulg" ] = 0,
		[ "$pp_colour_mulb" ] = 0
	}
	local fromtab = 
	{
		[ "$pp_colour_addr" ] = 0,
		[ "$pp_colour_addg" ] = 0,
		[ "$pp_colour_addb" ] = 0,
		[ "$pp_colour_brightness" ] = 0,
		[ "$pp_colour_contrast" ] = 1,
		[ "$pp_colour_colour" ] = 0,
		[ "$pp_colour_mulr" ] = 1,
		[ "$pp_colour_mulg" ] = 1,
		[ "$pp_colour_mulb" ] = 1,
	}
	local blacknwhitetab = 
	{
		[ "$pp_colour_addr" ] = 0,
		[ "$pp_colour_addg" ] = 0,
		[ "$pp_colour_addb" ] = 0,
		[ "$pp_colour_brightness" ] = 0,
		[ "$pp_colour_contrast" ] = 1,
		[ "$pp_colour_colour" ] = 0,
		[ "$pp_colour_mulr" ] = 0,
		[ "$pp_colour_mulg" ] = 0,
		[ "$pp_colour_mulb" ] = 0,
	}
end
hook.Add("CalcMainActivity", "BleedOutActivity", function(ply, vel)
	if ply:IsBleedOut() == true then
		if vel:Length2D() > 1 or ply:GetActiveWeapon() == NULL then
			ply.CalcIdeal = ACT_HL2MP_SWIM_PISTOL
		elseif ply:GetActiveWeapon():GetHoldType() == "pistol" or ply:GetActiveWeapon():GetHoldType() == "revolver" then
			ply.CalcIdeal = ACT_HL2MP_SWIM_REVOLVER
		elseif ply:GetActiveWeapon():GetHoldType() == "smg" then
			ply.CalcIdeal = ACT_HL2MP_SWIM_SMG1
		elseif ply:GetActiveWeapon():GetHoldType() == "shotgun" then
			ply.CalcIdeal = ACT_HL2MP_SWIM_SHOTGUN
		elseif ply:GetActiveWeapon():GetHoldType() == "grenade" then
			ply.CalcIdeal = ACT_HL2MP_SWIM_GRENADE
		elseif ply:GetActiveWeapon():GetHoldType() == "ar2" then
			ply.CalcIdeal = ACT_HL2MP_SWIM_AR2
		elseif ply:GetActiveWeapon():GetHoldType() == "rpg" then
			ply.CalcIdeal = ACT_HL2MP_SWIM_RPG
		elseif ply:GetActiveWeapon():GetHoldType() == "physgun" then
			ply.CalcIdeal = ACT_HL2MP_SWIM_PHYSGUN
		elseif ply:GetActiveWeapon():GetHoldType() == "crossbow" then
			ply.CalcIdeal = ACT_HL2MP_SWIM_CROSSBOW
		elseif ply:GetActiveWeapon():GetHoldType() == "melee" then
			ply.CalcIdeal = ACT_HL2MP_SWIM_MELEE
		elseif ply:GetActiveWeapon():GetHoldType() == "slam" then
			ply.CalcIdeal = ACT_HL2MP_SWIM_SLAM
		elseif ply:GetActiveWeapon():GetHoldType() == "normal" then
			ply.CalcIdeal = ACT_HL2MP_SWIM
		elseif ply:GetActiveWeapon():GetHoldType() == "fist" then
			ply.CalcIdeal = ACT_HL2MP_SWIM_FIST
		elseif ply:GetActiveWeapon():GetHoldType() == "melee2" then
			ply.CalcIdeal = ACT_HL2MP_SWIM_MELEE2
		elseif ply:GetActiveWeapon():GetHoldType() == "passive" then
			ply.CalcIdeal = ACT_HL2MP_SWIM_PASSIVE
		elseif ply:GetActiveWeapon():GetHoldType() == "knife" then
			ply.CalcIdeal = ACT_HL2MP_SWIM_KNIFE
		elseif ply:GetActiveWeapon():GetHoldType() == "duel" then
			ply.CalcIdeal = ACT_HL2MP_SWIM_DUEL
		elseif ply:GetActiveWeapon():GetHoldType() == "camera" then
			ply.CalcIdeal = ACT_HL2MP_SWIM_REVOLVER
		elseif ply:GetActiveWeapon():GetHoldType() == "magic" then
			ply.CalcIdeal = ACT_HL2MP_SWIM_MAGIC
		else
			ply.CalcIdeal = ACT_HL2MP_SWIM_REVOLVER
		end
		return ply.CalcIdeal, -1
	end
end)
hook.Add("UpdateAnimation", "BleedOutAnims", function(ply, vel, seqspeed)// Своровано с nzombies, обьяснить не смогу. Не бейте тапками пж
	if ply:IsBleedOut() == true then
		local movement = 0
		local len = vel:Length2D()
		ply:ManipulateBonePosition(0, loweredpos)
		ply:ManipulateBoneAngles(0, rotate)
		ply:SetPoseParameter("move_x", -1)
		ply:SetPlaybackRate(movement)
	else
		ply:ManipulateBonePosition(0, Vector(0,0,0))
		ply:ManipulateBoneAngles(0, Angle(0,0,0))
	end
end)
hook.Add("CreateMove", "BleedOutHotKeys", function()
	for k, v in pairs(bindingstab) do
		if input.WasKeyPressed(v) and bindingstabwaspressed[v] != true then
			ply:ConCommand(k)
			bindingstabwaspressed[v] = true
		elseif !input.WasKeyPressed(v) and bindingstabwaspressed[v] == true then
			bindingstabwaspressed[v] = false
		end
	end
end)
hook.Add("SetupMove", "BleedOutSetupMove", function(ply, move, cmd)
	if ply:IsBleedOut() == true and convar24:GetBool() == true and ply:IsReviving() == false and ply:IsBeingReviving() == false then
		move:SetMaxSpeed(50)
		move:SetMaxClientSpeed(50)
	elseif ply:IsBleedOut() == true and convar24:GetBool() == false or ply:IsReviving() == true or ply:IsBeingReviving() == true then
		move:SetMaxSpeed(1)
		move:SetMaxClientSpeed(1)
	end
	if SERVER then
		if ply:GetActiveWeapon() != NULL then ply.OldWeap = ply:GetActiveWeapon() end
		if ply:IsBleedOut() == true and convar12:GetBool() == false and ply:Alive() == true then
			if SearchForClassInTable(ply:GetWeapons(), "bleedout_pist") == nil then
				ply:SetActiveWeapon(NULL)
			else
				ply:SelectWeapon( "bleedout_pist" )
			end
			ply:DrawViewModel( SearchForClassInTable(ply:GetWeapons(), "bleedout_pist") and true or false)
		elseif ply:Alive() == true then
			ply:SetActiveWeapon(ply.OldWeap)
			ply:DrawViewModel(true)
		else
			ply:DrawViewModel(true)
		end
	end
end)
function bleedoutsetfunc(ply, bool) // Спавн функция игроков, выставляет их булины падений при спавне.
	ply:SetBleedOut(false)
	ply:SetReviveTime(0)
	ply:SetReviving(false)
	ply:SetRevivingEntity(Entity(0))
	ply:SetBleedOutTime(0)
	ply:SetNumBleedOuts(0)
	ply:SetBeingReviving(false)
	ply:SetNPCReviving(false)
	ply:SetNPCRevivour(Entity(0))
	ply:SetBeingNPCReviving(false)
end
function bleedoutviewfunc(ply, pos, angles, fov) // view - столбик, оставляем все как есть, но с другим вектором
	local view = {}
	local head = ply:LookupAttachment("eyes")
	local headpos = ply:GetAttachment(head)
	view.origin = pos - loweredview
	if ply:Crouching() == true then // Если игрок приседает - убираем это в корне
		view.origin = pos - loweredview + Vector(0,0, 36)
	end
	if convar20:GetBool() == true then
		view.angles = angles + Angle(0, 0, 25)
	else
		view.angles = angles
	end
	if convar26:GetBool() == true then
		view.origin = headpos.Pos
	end
	view.fov = fov
	view.znear = 5
	view.drawviewer = convar26:GetBool()
	return view
end
function bleedoutviewmodelviewfunc(wep, vm, oldp, olda, pos, ang)
	local finalpos = pos - loweredview
	if LocalPlayer():Crouching() == true then
		 finalpos = pos - loweredview + Vector(0, 0, 36)
	end
	if convar20:GetBool() == true then
		return finalpos, ang + Angle(0, 0, 10)
	else
		return finalpos, ang
	end
end
hook.Add("EntityFireBullets", "BleedOutFireBullets", function(ply, tab)
	if ply:IsNPC() and ply.IsVJBaseSNPC != true then
		if ply:GetEnemy():IsPlayer() and ply:GetEnemy():IsBleedOut() == true then
			tab.Dir = ( ply:GetEnemy():EyePos() - Vector(0, 0, 35) ) - ply:EyePos() + Vector(math.Rand(-10, 10), math.Rand(-10, 10), math.Rand(-10, 10))
			return true 
		end
	end
	if ply:IsPlayer() then
		local head = ply:LookupAttachment("eyes")
		local headpos = ply:GetAttachment(head).Pos
		if not ply:IsValid() then ply = LocalPlayer() end
		if ply:IsBleedOut() then
			if convar26:GetBool() == false then
				tab.Src = ply:EyePos() - loweredview
			else
				tab.Src = headpos
			end
		end
		return true // для того, что бы изменить начальное положение пули.
	end
end)
hook.Add("PlayerSpawn", "BleedoutSpawn", function(ply)
	ply.fragsbeforedeath = 0
	ply:Revive()
	ply:SetNumBleedOuts(0)
	ply:SetMaxHealth(2500)
	ply:SetHealth(2500)
end)
// --- Hook functions are set! ^
if SERVER then
	function PLAYER:TryRevive()
		self:LagCompensation( true )
		local trace = util.QuickTrace(self:EyePos(), self:EyeAngles():Forward() * distancetotrace, self)
		self:LagCompensation(false)
		if self:IsBleedOut() == false and self:IsReviving() == false and trace.Hit == true and trace.Entity:IsPlayer() == true and trace.Entity:IsBleedOut() == true and trace.Entity:IsBeingReviving() == false then
			self:SetReviveTimeFromEntity(CurTime() - trace.Entity:GetBleedOutTime())
			trace.Entity:StartReviving() // Начатие процесса ревайвинга.
			self:SetReviving(true)
			self:EmitSound("pd2_voice/incap_helping.mp3")
			self:SetRevivingEntity(trace.Entity)
			self:SetVelocity(self:GetVelocity() * -1)
			self:SetReviveTime(CurTime())
		end
	end
	function PLAYER:StartReviving()
		if self:Team() == 2 then return true end
		self:SetBeingReviving(true)
		self:SetBleedOutTime(0)
	end
	function PLAYER:StopReviving()
		if self:Team() == 2 then return true end
		self:SetBeingReviving(false)
		self:SetBleedOutTime(CurTime())
	end
	function PLAYER:GoBleedOut()
		if self:Team() == 2 then self:Kill() return true end
		self:SetBleedOut(true)
		if convar22:GetBool() == true then // convar22 - как я помню является конварой с нотаргетом. Если включена - значит ок.
			self:SetNoTarget(true)
		end
		self:ExitVehicle()
		if convar33:GetBool() == true then
			self:SetDSP( 16, false ) 
		end
		self:SetBloodDelay(CurTime() + 1)
		self:SetBeingReviving(false)
		self:SetReviving(false)
		self:SetReviveTime(0)
		self:Give('bleedout_pist')
		if self:GetRevivingEntity():IsPlayer() == true then 
			self:GetRevivingEntity():StopReviving()
			self:SetRevivingEntity(Entity(0))
		end
		self:SetHealth(self:GetMaxHealth() * ( convar31:GetFloat() / 100) )
		self:SetHull(duckhullbottom, duckhulltop) // Делаем хулл такой же как у игрока в присяде
		net.Start("bleedout_go") // Скидываем на клиентскую часть, что бы клиенты помучались))
		net.WriteEntity(self)
		net.WriteTable(player.GetBleedOuts())
		net.Broadcast()
	end
	function PLAYER:Revive() // Воскрешение
		if self:Team() == 2 then return true end
		self:SetActiveWeapon(self.OldWeap)
		self:SetBleedOut(false)
		self:SetHealth(self:GetMaxHealth() * 0.5)
		self:SetHull(normalhullbottom, normalhulltop)
		self:SetNoTarget(false)
		self:DrawViewModel(true)
		self:SetDSP( 0, true ) 
		self:SetBeingReviving(false)
		self:SetBleedOutTime(0)
		self:StripWeapon('bleedout_pist')
		self:GodDisable()
		self:Freeze( false )
		self:SetNumBleedOuts(self:GetNumBleedOuts() + 1)
		self:EmitSound("pd2_voice/incap_thanks.mp3")
		net.Start("bleedout_out")
		net.WriteEntity(self)
		net.WriteTable(player.GetBleedOuts())
		net.Broadcast()
	end
end
// Server Player Functions are set ^
function player.GetRevivingPlayers() // Дает список всех воскрешающих игроков.
	local tab = {}
	for k, v in pairs(player.GetAll()) do
		if v:IsReviving() == true then
			table.insert(tab, v)
		end
	end
	return tab
end
function player.GetBleedOuts() // Для рисовки обводки игроков. Работает онли на сервере, так что когда кто то падает/встает эта штука передается клиенту.
	local tab = {}
	for k, v in pairs(player.GetAll()) do
		if v:IsBleedOut() == true then
			table.insert(tab, v)
		end
	end
	return tab
end
function ents.GetShootingAtBleedOuts()
	local tab = {}
	for k, v in pairs(ents.FindByClass("npc_*")) do
		if v:GetEnemy():IsPlayer() then
			if v:GetEnemy():IsBleedOut() == true then
				table.insert(tab, v)
			end
		end
	end
end
function player.GetNoBleedOuts() // Для теста, дебаг функция, делает абсолютно обратную функцию player.GetBleedOuts(). Т.е - не упавшие игроки
	local tab = {}
	for k, v in pairs(player.GetAll()) do
		if v:IsBleedOut() == false then
			table.insert(tab, v)
		end
	end
	return tab
end
// Other functions are set ^
if SERVER then
	net.Receive("bleedout_suicide", function(len, ply)
		if IsValid(ply) and ply:IsBleedOut() == true then
			ply:Kill()
		end
	end)
	net.Receive("bleedout_help", function(len, ply)
		local rand = math.random(0,4)
		ply:StopSound( "vo/coast/bugbait/sandy_help.wav" )
		ply:StopSound( "vo/npc/male01/help01.wav" )
		ply:StopSound( "vo/streetwar/sniper/male01/c17_09_help01.wav" )
		ply:StopSound( "vo/streetwar/sniper/male01/c17_09_help02.wav" )
		ply:StopSound( "vo/streetwar/sniper/male01/c17_09_help03.wav" )
		if rand == 0 and IsValid(ply) and ply:IsBleedOut() == true and convar28:GetBool() == true then
			ply:EmitSound( "vo/coast/bugbait/sandy_help.wav", 75, 100, 1, CHAN_AUTO)
		elseif IsValid(ply) and rand == 1 and ply:IsBleedOut() == true and convar28:GetBool() == true then
			ply:EmitSound( "vo/npc/male01/help01.wav", 75, 100, 1, CHAN_AUTO)
		elseif IsValid(ply) and rand == 2 and ply:IsBleedOut() == true and convar28:GetBool() == true then
			ply:EmitSound( "vo/streetwar/sniper/male01/c17_09_help01.wav", 75, 100, 1, CHAN_AUTO)
		elseif IsValid(ply) and rand == 3 and ply:IsBleedOut() == true and convar28:GetBool() == true then
			ply:EmitSound( "vo/streetwar/sniper/male01/c17_09_help02.wav", 75, 100, 1, CHAN_AUTO)
		elseif IsValid(ply) and rand == 4 and ply:IsBleedOut() == true and convar28:GetBool() == true then
			ply:EmitSound( "vo/streetwar/sniper/male01/c17_09_help03.wav", 75, 100, 1, CHAN_AUTO)
		end
	end)
end
if CLIENT then
	net.Receive("bleedout_settable", function() // Предназначено для передачи тейбла с игроками, упавшими. Хорошая вещь однако
		tabhalo = net.ReadTable()
		table.RemoveByValue(tabhalo, LocalPlayer())
	end)
	net.Receive("bleedout_go", function()
		ply = net.ReadEntity()
		tabhalo = net.ReadTable() // Кидает клиенту столбик с падающими игроками
		table.RemoveByValue( tabhalo, LocalPlayer() ) // Если этого не сделать - будут сверху граф. артефакты.
		if ply == LocalPlayer() then
			hook.Add("CalcView", "BleedOutView", bleedoutviewfunc)
			hook.Add("CalcViewModelView", "BleedOutViewModelView", bleedoutviewmodelviewfunc)
		end
	end)
		net.Receive("bleedout_out", function() 
		ply = net.ReadEntity()
		tabhalo = net.ReadTable()
		table.RemoveByValue( tabhalo, LocalPlayer() )
		if ply == LocalPlayer() then
			hook.Remove("CalcView", "BleedOutView")
			hook.Remove("CalcViewModelView", "BleedOutViewModelView")
		end
	end)
end
hook.Add("PlayerSpawn", "BleedOutSet", bleedoutsetfunc)
if SERVER then
	hook.Add("EntityTakeDamage", "PlayerBleedOutWhen", function(ply, dmginfo)
		if (ply:IsPlayer() ) then // Если ply = игрок и получил дамаг от пули.
			if ply:IsBleedOut() == true then
				dmginfo:ScaleDamage( (ply:GetMaxHealth() - convar23:GetInt()) / 100) // Почему тут MaxHealth я уже не помню
			end
			if ply:Health() <= dmginfo:GetDamage() and ply:IsBleedOut() == false and convar4:GetBool() == true and ply:GetNumBleedOuts() < convar17:GetInt() then
				dmginfo:SetDamage(0)
				ply:GoBleedOut()
				ply:SetAttacker( dmginfo:GetAttacker() )
				if
					!IsValid(dmginfo:GetAttacker()) then ply:SetAttackerWeapon( NULL )
				else
					ply:SetAttackerWeapon( dmginfo:GetAttacker():GetActiveWeapon() )
				end
			end
		elseif ply:IsNPC() == true then
			if ply:Health() <= dmginfo:GetDamage() and dmginfo:GetInflictor():IsPlayer() == true and ply:Disposition( dmginfo:GetInflictor() ) != D_LI and dmginfo:GetInflictor():IsBleedOut() == true then
				dmginfo:GetInflictor().fragsbeforedeath = dmginfo:GetInflictor().fragsbeforedeath + 1
			end
			if ply:Health() <= dmginfo:GetDamage() and convar29:GetBool() == true and dmginfo:GetInflictor():IsPlayer() == true and ply:Disposition( dmginfo:GetInflictor() ) != D_LI and dmginfo:GetInflictor():IsBleedOut() == true and dmginfo:GetInflictor().fragsbeforedeath == convar30:GetFloat() then
				dmginfo:GetInflictor():Revive()
				dmginfo:GetInflictor().fragsbeforedeath = 0
			end
		end

	end)
	hook.Add("PlayerShouldTakeDamage", "BleedOutDamage", function(attacked, inflictor)
		local time = CurTime()
		local time2 = attacked:GetBleedOutTime() + convar5:GetFloat()
		if convar:GetBool() == false and attacked:IsBleedOut() == true and time < time2 or convar0:GetBool() == false and inflictor:IsPlayer() == true and attacked:IsBleedOut() == false or convar0:GetBool() == false and inflictor:IsPlayer() == true and attacked:IsBleedOut() == true and time < time2 then
			return false
		else
			return true
		end
	end)
	hook.Add("Think", "ServerThink", serverthink)
	hook.Add("PlayerDeath", "BleedOutDeath", function(victim, inflicto, attacker)
		if victim:IsBleedOut() == false and victim:IsReviving() == true then
			victim:SetReviving(false)
			victim:GetRevivingEntity():StopReviving()
			victim:GetRevivingEntity():SetBleedOutTime(CurTime() - victim:GetReviveTimeFromEntity())
			victim:SetRevivingEntity(Entity(0))
		end
		victim:SetBleedOut(false)
		victim:Revive()
		victim:SetNumBleedOuts(0)
	end)
	hook.Add("PlayerDisconnected", "BleedOutDisconnect", function(ply) // Убираем с столбика значение игрока с дисконектом
		if ply:IsBleedOut() == true then
			local tab = player.GetBleedOuts()
			table.RemoveByValue(tab, ply)
			net.Start("bleedout_settable")
			net.WriteTable(tab)
			net.Broadcast()
		end
	end)
	hook.Add("EntityRemoved", "BleedOutRemove", function(ent) // ТОже самое, но если игрок магически исчез.
		if ent:IsPlayer() == true then
			if ent:IsBleedOut() == true then
				local tab = player.GetBleedOuts()
				table.RemoveByValue(tab, ent)
				net.Start("bleedout_settable")
				net.WriteTable(tab)
				net.Broadcast()	
			end
		end
	end)
end
// Создано великим магистром под ником Jaff специально для HarionPlayZ.