local dif_table = {"NORMAL", "HARD", "VERY HARD", "OVERKILL", "MAYHEM", "DEATH WISH", "DEATH SENTENCE"}

util.AddNetworkString('f4_menu')
hook.Add("ShowSpare2",'f4_menu',function(self)
	net.Start('f4_menu')
	net.Send(self)
end)
local voted

local function vote_complited()
	local voted_table = {}
	for i=1,7 do
		voted_table[i] = 0
	end
	for i,p in pairs(global_gang_table) do
		local k = p:GetNWInt('votedif')
		voted_table[k] = voted_table[k]+1
	end
	local i,dif = 4
	while dif==nil do
		dif = table.KeyFromValue(voted_table,i)
		i=i-1
	end
	dif = dif-1
	global_dif = dif
	net.Start('padpd2')
	net.WriteInt(dif,4)
	net.Send(player.GetAll())
	for i,p in pairs(player.GetAll()) do
		p:ChatPrint('Player choosed difficulty: '..dif_table[dif+1])
		p:EmitSound('Friends/friend_online.wav')
	end
	voted = true
	game_start()
end

local function vote_ready(self)
	local all_ready = true
	self:SetNWBool('ready',!self:GetNWBool('ready'))
	for i,p in pairs(global_gang_table) do
		if not p:GetNWBool('ready') then all_ready = false end
	end
	if all_ready and not voted then vote_complited() end
end

hook.Add( "PlayerButtonDown", "f4_menu", function( self, key )
	if key==17 and self:Team()==1 and not voted then vote_ready(self) end
	if key==65 and self:GetNWBool('cutscene') then 
		self:SetNWBool("pd2brief", false)
		self:SetNWBool('cutscene',false)
		self:Freeze(false)
		self:ConCommand('pd2_hud_enable 1')
		self:StopSound('pd2_plan_music.ogg')
		local all_skip = true
		for i,p in pairs(global_gang_table) do
			if p:GetNWBool('cutscene') then all_skip = false end
		end
		if all_skip then 
			global_skip_cutscene = true
			hook.Call('game_start')
		end
	end
end)


util.AddNetworkString('select_team')
net.Receive('select_team',function(len,self)
local team = net.ReadString()
	if team == 'spectator' then
		self:Kill()
		self:PD2SetSpectator()
	end
	if team == 'gang' and self:Team() != 1 then
		if not global_can_changeteam then self:ChatPrint("You cant change team, when game started!") return end
		self:PD2SetGang()
		self:Spawn()
		net.Start('vote_dif')
		net.Send(self)
	end
	if team == 'police' and self:Team() != 2 then
		if GetConVar("policejoin"):GetInt() == 1 then self:ChatPrint("Host disabled police team!") end
		if self:Team() == 1 and not global_can_changeteam then self:ChatPrint("You cant change team on police, when game started and you gangster!")
		else
			if not self:Alive() then self:Spawn() end
		end
		self:PD2SetPolice()
	end
end)

util.AddNetworkString('vote_dif')
util.AddNetworkString('select_dif')
net.Receive('select_dif',function(len,self)
local dif = net.ReadString()
self:SetNWInt('votedif',table.KeyFromValue(dif_table,dif))
end)

hook.Add('pd2_map_spawned','f4_menu',function()
	voted = false
end)

