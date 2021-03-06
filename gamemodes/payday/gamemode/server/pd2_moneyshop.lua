money_dif_pd2_jewer = {1000, 2500, 5000, 10000, 17500, 25000, 50000}
money_dif_pd2_jewer2 = {1500, 4000, 7500, 15000, 22500, 37250, 55000}
local ply = FindMetaTable("Player")
local path = "pd2_shop_data/money.txt"

if not file.IsDir( "pd2_shop_data", "DATA" ) then
	file.CreateDir("pd2_shop_data")
	file.Write( path, "76561198201651767 0" )
end

if not file.Exists( path, "DATA" ) then
	file.Write( path, "76561198201651767 0" )
end

local function getmoneytable()
	return string.Split(file.Read( path, "DATA" ), "\n")
end

local function getmoneytable_id(ply)
	local tab = getmoneytable()
	for i, v in pairs(tab) do
		local txt = string.Split(v, " ")
		if txt[1] == ply:SteamID64() then
			return i
		end
	end	
end

local function rewritemoney(id, number)
	local tab = string.Split(file.Read( path, "DATA" ), "\n")
	local replace = string.Split(tab[id], " ")[1].." "..tostring(number)
	tab[id] = replace
	local txt = ""
	for i, t in pairs(tab) do
		txt = txt..t.."\n"
	end
	txt = string.Left(txt,string.len(txt)-1)
	file.Write( path, txt )
end

function ply:pd2_set_money(money)
	rewritemoney(getmoneytable_id(self), money)
end

function ply:pd2_add_money(money)
	rewritemoney(getmoneytable_id(self), money+self:pd2_get_money())
end

function ply:pd2_get_money()
	local tab = getmoneytable()
	for k, v in pairs(tab) do
		local txt = string.Split(v, " ")
		if txt[1] == self:SteamID64() then
			return tonumber(txt[2])
		end
	end	
end

hook.Add("PlayerInitialSpawn", "pd2_player_join_steamid_money", function(ply)
	if not game.SinglePlayer() and not ply:IsBot() then
		local tab = getmoneytable()
		local exist = false
		for k, v in pairs(tab) do
			local txt = string.Split(v, " ")
			if txt[1] == ply:SteamID64() then
				exist = true
			end
		end
		if not exist then file.Append(path, "\n"..ply:SteamID64().." 0") end
	end
	ply:ConCommand("cw_customhud 0")
	ply:ConCommand("pd2_hud_team_custom 0")
	ply:ConCommand("pd2_hud_enable 1")
	RunConsoleCommand("ai_serverragdolls", 0)
end)

local weapon_table_price = {{name = "cw_m249_official", price = 7500, id = "m249", level = 60},{name = "cw_ws_aa12", price = 5000, id = "aa12", level = 35},{name = "cw_viper_minigun", price = 35000 , id = "minigun", level = 85},{name = "cw_mac11", price = 1750, id = "mac11", level = 5},{name = "cw_vss", price = 2250, id = "vss", level = 10},{name = "cw_m3super90", price = 2500 , id = "shotgun_m3", level = 15},{name = "ins2_atow_rpg7", price = 15000 , id = "rpg", level = 70},{name = "cw_deagle", price = 1500 , id = "deagle", level = 5},{name = "cw_l115", price = 2500 , id = "l115", level = 25},{name = "cw_ak74", price = 3500 , id = "ak74", level = 30},{name = "cw_kk_hk416", price = 3250 , id = "hk416", level = 25},{name = "cw_ar15", price = 3000 , id = "ar15", level = 20},{name = "cw_ump45", price = 1500 , id = "ump45", level = 15},{name = "cw_g3a3", price = 3000 , id = "g3a3", level = 40},{name = "cw_scarh", price = 2500 , id = "scar", level = 15},{name = "cw_g36c", price = 3500 , id = "g36c", level = 40},{name = "cw_shorty", price = 1000 , id = "shorty_shotgun", level = 5},{name = "cw_fiveseven", price = 750 , id = "fiveseven", level = 0}}
local armor_table_price = {{name = "200", price = 2500, level = 5},{name = "350", price = 5000, level = 15},{name = "500", price = 7500, level = 25},{name = "650", price = 10000, level = 35},{name = "800", price = 15000, level = 50},{name = "1000", price = 25000, level = 100}}

function ply:BuyWeapon(name, slot)
	local money = self:pd2_get_money()
	local level = self:GetNWInt("pd2_level_data")
	for i, a in pairs(armor_table_price) do
		if string.lower(name) == 'armor'..a.name then
			if money >= a.price then
				if level >= a.level then
					self:SetNWInt('armor_init', tonumber(a.name))
					self:SetArmor(tonumber(a.name))
					self:SetMaxArmor(tonumber(a.name))
					self:pd2_set_money(money-a.price)
					self:ChatPrint('You bought armor!')
				else
					self:ChatPrint("You can't buy "..a.name..".")
					self:ChatPrint("You need "..a.level.." level, you have "..tostring(level).." level.")
				end
			else
				self:ChatPrint("You can't buy "..a.name..".")
				self:ChatPrint("You need "..a.price.."$, you have "..tostring(money).." $.")
			end
		end
	end
	for i, w in pairs(weapon_table_price) do
		if string.lower(name) == w.id then
			if money >= w.price then
				if level >= w.level then
					if slot == 1 then
						self:SetNWString('weapon_main', w.name)
					end
					if slot == 2 then
						self:SetNWString('weapon_sec', w.name)
					end
					if slot == 0 then
						self:ChatPrint('Invalid!') return
					end
					self:pd2_set_money(money-w.price)
					self:ChatPrint('You bought weapon!')
				else
					self:ChatPrint("You can't buy "..w.name..".")
					self:ChatPrint("You need "..w.level.." level, you have "..tostring(level).." level.")
				end
			else
				self:ChatPrint("You can't buy "..w.name..".")
				self:ChatPrint("You need "..w.price.."$, you have "..tostring(money).." $.")
			end
		end
	end
end

local commandtable = {'List of all commands:', '/showmoney - show your money.', '/showlevel - show your level(not xp).', '/buy - this command buy any weapon from list.', '/helpweapon - if you want help with buying weapon.', '/helparmor - if you want help with buying armor.', '/gang - change team on gang.', '/police - change team on police.', '/spectator - change team on spectator.', '/votedif 0-6 - You can set difficulty in game.', '/showdif - Show voted difficulty in game.', 'If you write in console (bind g medkit_use_pd2) you will can use medkit on g button.'}
hook.Add("PlayerSay", "BuyWeaponsPD2", function( ply, text )
	if text == "/helpweapon" then
		ply:ChatPrint('List:')
		for i, w in pairs(weapon_table_price) do
			ply:ChatPrint(w.id..' - Price:'..w.price..'$, Level: '..w.level)
		end
		ply:ChatPrint('Example: /buy m249 1 - slot 1 or 2')
	end
	if text == "/showmoney" then
		ply:ChatPrint('You have: '..ply:pd2_get_money()..'$.')
	end
	if text == "/help" then
		for i, c in pairs(commandtable) do
			ply:ChatPrint(c)
		end
	end
	if text == "/helparmor" then
		ply:ChatPrint('List:')
		for i, w in pairs(armor_table_price) do
			ply:ChatPrint('armor'..w.name..' - Price:'..w.price..'$, Level: '..w.level)
		end
		ply:ChatPrint('Example: /buy armor200')
	end
	local txt = string.Split(string.lower(text), " ")
	if txt[1] == "/buy" and txt[2] then
		if ply:Team() == 1001 then
			ply:BuyWeapon(txt[2], tonumber(txt[3]) or 0)
		else ply:ChatPrint("Join to team spectator to buy weapon!") end
	end
end)

