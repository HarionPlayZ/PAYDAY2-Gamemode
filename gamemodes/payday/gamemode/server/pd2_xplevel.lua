local ply = FindMetaTable("Player")
local path = "pd2/xp_data"
local singlpath = path.."/singl.txt"
local fullpath = path.."/xp.txt"

if not file.IsDir( path, "DATA" ) then
	file.CreateDir(path)
	file.Write( fullpath, "76561198201651767 0" )
end

if not file.Exists( fullpath, "DATA" ) then
	file.Write( fullpath, "76561198201651767 0" )
end
local host_xp = 0

if game.SinglePlayer() then
	file.Write( singlpath,'0' )
else
	if file.Exists(singlpath,"DATA") then
		host_xp = tonumber(file.Read(singlpath))
		file.Delete(singlpath)
	end
end

local function getxptable()
	return string.Split(file.Read( fullpath, "DATA" ), "\n")
end

local function getxptable_id(ply)
	local tab = getxptable()
	for i, v in pairs(tab) do
		local txt = string.Split(v, " ")
		if txt[1] == ply:SteamID64() then
			return i
		end
	end
end

local function rewritexp(id, number)
	local tab = string.Split(file.Read( fullpath, "DATA" ), "\n")
	local replace = string.Split(tab[id], " ")[1].." "..tostring(number)
	tab[id] = replace
	local txt = ""
	for i, t in pairs(tab) do
		txt = txt..t.."\n"
	end
	txt = string.Left(txt,string.len(txt)-1)
	file.Write( fullpath, txt )
end

if game.SinglePlayer() then
	function ply:pd2_set_xp(xp)
		local x = xp+tonumber(file.Read(singlpath))
		file.Write(singlpath,tostring(x))
	end
	function ply:pd2_add_xp(xp)
		file.Write(singlpath,xp)
	end
else
	function ply:pd2_set_xp(xp)
		rewritexp(getxptable_id(self), xp)
		self:pd2_update_level()
	end
	function ply:pd2_add_xp(xp)
		rewritexp(getxptable_id(self), xp+self:pd2_get_xp())
		self:pd2_update_level()
	end
end

function ply:pd2_get_xp()
	local tab = getxptable()
	for k, v in pairs(tab) do
		local txt = string.Split(v, " ")
		if txt[1] == self:SteamID64() then
			return tonumber(txt[2])
		end
	end	
end

function ply:pd2_update_level()
	local level = self:GetNWInt("pd2_level_data")
	local xp = math.min(math.floor(self:pd2_get_xp()/1000), 5050)
	local i = 0
	while xp > 0 do
		i = i+1
		xp = xp-i
	end
	if xp < 0 then
		i = i-1
	end
	self:SetNWInt("pd2_level_data", i)
	if self:GetNWInt("pd2_level_data") != level then
		self:ChatPrint("You reached a "..tostring(i).." level.")
	end
end

hook.Add("PlayerInitialSpawn", "pd2_player_join_steamid_xp", function(ply)
	if not game.SinglePlayer() and not ply:IsBot() then
		local tab = getxptable()
		local exist = false
		for k, v in pairs(tab) do
			local txt = string.Split(v, " ")
			if txt[1] == ply:SteamID64() then
				exist = true
			end
		end
		if not exist then file.Append(fullpath, "\n"..ply:SteamID64().." 0") end
		ply:pd2_add_xp(0)
		if ply:IsListenServerHost() then ply:pd2_add_xp(host_xp) end
	end
end)