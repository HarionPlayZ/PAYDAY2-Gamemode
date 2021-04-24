AddCSLuaFile()

ENT.PrintName = "SB ANB PAYDAY 2"
ENT.Type = "anim"

properties.Add("sb_anb_pd2_spawner_enable",{
	MenuLabel = "Enable Spawner",
	Order = 2,
	MenuIcon = "icon16/user_add.png",
	Filter = function(self,ent,ply)
		if !IsValid(ent) then return false end
		if ent:GetClass()!="sb_advanced_nextbot_payday2_spawner" then return false end
		if !gamemode.Call("CanProperty",ply,"sb_anb_pd2_spawner_enable",ent) then return false end
		
		return !ent:GetEnabled()
	end,
	Action = function(self,ent)
		self:MsgStart()
			net.WriteEntity(ent)
		self:MsgEnd()
	end,
	Receive = function(self,len,ply)
		local ent = net.ReadEntity()
		if !self:Filter(ent,ply) then return end
		
		ent:Enable()
	end,
})

properties.Add("sb_anb_pd2_spawner_disable",{
	MenuLabel = "Disable Spawner",
	Order = 1,
	MenuIcon = "icon16/user_delete.png",
	Filter = function(self,ent,ply)
		if !IsValid(ent) then return false end
		if ent:GetClass()!="sb_advanced_nextbot_payday2_spawner" then return false end
		if !gamemode.Call("CanProperty",ply,"sb_anb_pd2_spawner_disable",ent) then return false end
		
		return ent:GetEnabled()
	end,
	Action = function(self,ent)
		self:MsgStart()
			net.WriteEntity(ent)
		self:MsgEnd()
	end,
	Receive = function(self,len,ply)
		local ent = net.ReadEntity()
		if !self:Filter(ent,ply) then return end
		
		ent:Disable()
	end,
})

function ENT:SetupDataTables()
	self:NetworkVar("Bool",0,"Enabled")
end

if CLIENT then return end

ENT.DifficultyPresets = {
	[1] = {
		MaxOnMap = 15,
		HPDiff = 0,
		Prof = 1,
		Classes = {
			{"SWAT",1,0,50},
			{"HeavySWAT",1,0,30},
			{"SWATShieldGroup",1,2,10},
			{"SWATShield",0,2,10},
		},
	},
	[2] = {
		MaxOnMap = 25,
		HPDiff = 0,
		Prof = 2,
		Classes = {
			{"HeavySWAT2",1,0,50},
			{"HeavySWAT",1,0,30},
			{"SWATShieldGroup",1,2,10},
			{"TaserGroup",1,2,10},
			{"FBIShield",0,2,10},
		},
	},
	[3] = {
		MaxOnMap = 25,
		HPDiff = 1,
		Prof = 2,
		Classes = {
			{"FBIGroup",1,0,35.7},
			{"HeavyFBIGroup",1,0,21.4},
			{"FBIShieldGroup",1,2,14.3},
			{"TaserGroup",1,2,14.3},
			{"Bulldozer",0,2,7.1,{1}},
			{"Cloaker",0,2,7.1},
		},
	},
	[4] = {
		MaxOnMap = 30,
		HPDiff = 2,
		Prof = 3,
		Classes = {
			{"HeavyFBIGroup2",1,0,35.7},
			{"HeavyFBIArmorGroup",1,0,21.4},
			{"ArmorFBIShieldGroup",1,2,14.3},
			{"TaserGroup",1,2,7.1},
			{"MedicGroup",1,2,7.1},
			{"BulldozerGroup",1,2,7.1,{1,2}},
			{"Cloaker",0,2,7.1},
		},
	},
	[5] = {
		MaxOnMap = 35,
		HPDiff = 3,
		Prof = 3,
		Classes = {
			{"GensecGroup",1,0,35.7},
			{"HeavyGensecGroup",1,0,21.4},
			{"GensecShieldGroup",1,3,14.3},
			{"TaserGroup",1,3,7.1},
			{"MedicGroup",1,3,7.1},
			{"BulldozerGroup",1,2,7.1,{2}},
			{"Cloaker",0,2,7.1},
			{"Minigundozer",0,1,1},
		},
	},
	[6] = {
		MaxOnMap = 40,
		HPDiff = 4,
		Prof = 4,
		Classes = {
			{"HeavyGensecGroup2",1,0,35.7},
			{"HeavyGensecArmorGroup",1,0,21.4},
			{"ArmorGensecShieldGroup",1,3,14.3},
			{"TaserGroup",1,3,7.1},
			{"MedicGroup",1,3,7.1},
			{"BulldozerGroup",1,2,6.1,{2,3}},
			{"Cloaker",0,2,7.1},
			{"Minigundozer",0,1,1},
		},
	},
	[7] = {
		MaxOnMap = 40,
		HPDiff = 4,
		Prof = 5,
		Classes = {
			{"HeavyZealGroup",1,0,35.7},
			{"ZealGroup",1,0,21.4},
			{"ZealShieldGroup",1,3,14.3},
			{"ZealTaserGroup",1,3,7.1},
			{"ZealMedicGroup",1,3,7.1},
			{"ZealBulldozerGroup",1,2,6.1},
			{"ZealCloaker",0,2,7.1},
			{"MinigunBulldozerGroup",0,1,1},
		},
	},
	[8] = {
		MaxOnMap = 1,
		HPDiff = 1,
		Prof = 2,
		Classes = {
			{"CopsGroup",1,2,35.7},
		},
	},
	[9] = {
		MaxOnMap = 100,
		HPDiff = 2,
		Prof = 2,
		Classes = {
			{"Winters",1,1,100},
		},
	},
	[10] = {
		MaxOnMap = 95,
		HPDiff = 1,
		Prof = 4,
		Classes = {
			{"Sniper",0,2,100},
		},
	},
	[11] = {
		MaxOnMap = 10,
		HPDiff = 1,
		Prof = 3,
		Classes = {
			{"Gangster",10,8,100},
		},
	},
	[12] = {
		MaxOnMap = 6,
		HPDiff = 1,
		Prof = 1,
		Classes = {
			{"Guard",6,6,100},
		},
	},
}

function ENT:Initialize()
	self:SetModel("models/props_junk/sawblade001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	
	self:GetPhysicsObject():EnableMotion(false)
	
	self.NextSpawn = CurTime()+self.m_spawndelay
	self.BotsToRemove = {}
	self.GroupsToRemove = {}
	self.GCTime = 0
	
	if self.SpawnEnabled then
		self:Enable()
	else
		self:Disable()
	end
end

function ENT:Think()
	if !self:GetEnabled() then return end
	
	if CurTime()>=self.GCTime then
		self.GCTime = CurTime()+10
		
		for k,v in pairs(self.BotsToRemove) do
			if !IsValid(k) then self.BotsToRemove[k] = nil end
		end
		
		for k,v in pairs(self.GroupsToRemove) do
			if !IsValid(k.Leader) then self.GroupsToRemove[k] = nil end
		end
	end
	
	if CurTime()>=self.NextSpawn then
		self.NextSpawn = CurTime()+self.m_spawndelay
		
		local classgroup,isgroup,variants = self:SelectToSpawn()
		
		if !classgroup then
			self.NextSpawn = CurTime()+math.min(self.m_spawndelay,3)
		else
			self:SpawnClassGroup(classgroup,isgroup,variants)
		end
	end
end

function ENT:SelectToSpawn()
	local diff,max,hpdiff,prof,classes,chase = self:GetData()
	
	local copinfo = {
		count = 0,
		classescount = {},
		groupscount = {},
	}
	
	for k,v in ipairs(ents.FindByClass("sb_advanced_nextbot_payday2")) do
		if v.ClassData.Type=="Police" then
			copinfo.count = copinfo.count+1
			
			if copinfo.count>=max then return end
			
			local class = v:GetKeyValue("Class")
			if class then
				copinfo.classescount[class] = (copinfo.classescount[class] or 0)+1
			end
			
			local group = v:GetKeyValue("Group")
			if group and v.GroupData and v.GroupData.Leader==v then
				copinfo.groupscount[group] = (copinfo.groupscount[group] or 0)+1
			end
		end
	end
	
	local Classes = {}
	local ENT = scripted_ents.GetStored("sb_advanced_nextbot_payday2").t
	
	for k,v in ipairs(classes) do
		if v[3]>0 then
			if v[2]==1 then
				if (copinfo.groupscount[v[1]] or 0)>=v[3] then continue end
			else
				if (copinfo.classescount[v[1]] or 0)>=v[3] then continue end
			end
		end
	
		local data = ENT[v[2]==1 and "BotGroups" or "BotClasses"][v[1]]
		
		if data and data.AddonsMounted then
			Classes[#Classes+1] = v
		end
	end
	
	if #Classes==0 then return end
	
	local allperc = 0
	
	for k,v in ipairs(Classes) do
		allperc = allperc+v[4]
	end
	
	if allperc==0 then return end
	
	local perc = math.Rand(0,allperc)
	local fromperc = 0
	
	for k,v in ipairs(Classes) do
		local toperc = fromperc+v[4]
		
		if perc>=fromperc and perc<toperc then
			return v[1],v[2]==1,v[5]
		end
		
		fromperc = toperc
	end
end

function ENT:SpawnClassGroup(classgroup,isgroup,variants)
	local diff,max,hpdiff,prof,classes,chase = self:GetData()

	local spawndata = {
		team = "police",
		side = 0,
		pside = 0,
		hpdiff = hpdiff,
		variant = variants and table.Random(variants) or 0,
		ownerleader = false,
		proficiency = prof,
		policechase = chase,
	}
	
	local ent = ents.Create("sb_advanced_nextbot_payday2")
	ent:SetPos(self:GetPos())
	ent:SetAngles(Angle(0,self:GetAngles().y,0))
	ent.Owner = self.Owner
	ent.CustomSpawnData = spawndata
	ent:SetKeyValue(isgroup and "Group" or "Class",classgroup)
	ent:Spawn()
	
	if isgroup then
		self.GroupsToRemove[ent.GroupData] = true
	else
		self.BotsToRemove[ent] = true
	end
end

function ENT:Enable()
	self:SetEnabled(true)
	self.NextSpawn = CurTime()+self.m_spawndelay
	self:SetColor(Color(0,255,0))
end

function ENT:Disable()
	self:SetEnabled(false)
	self:SetColor(Color(255,0,0))
end

function ENT:SetData(difficulty,maxonmap,hpdiff,prof,classes,policechase,spawndelay)
	self.m_difficulty = difficulty
	self.m_maxonmap = maxonmap or 0
	self.m_hpdiff = hpdiff or 0
	self.m_prof = prof or 0
	self.m_classes = classes or {}
	self.m_policechase = policechase
	self.m_spawndelay = spawndelay
end

function ENT:GetData()
	if self.m_difficulty>0 then
		local preset = self.DifficultyPresets[self.m_difficulty]
	
		return self.m_difficulty,preset.MaxOnMap,preset.HPDiff,preset.Prof,preset.Classes,self.m_policechase,self.m_spawndelay
	else
		return self.m_difficulty,self.m_maxonmap,self.m_hpdiff,self.m_prof,self.m_classes,self.m_policechase,self.m_spawndelay
	end
end

function ENT:OnRemove()
	for k,v in pairs(self.BotsToRemove) do
		if IsValid(k) then k:Remove() end
	end

	for k,v in pairs(self.GroupsToRemove) do
		if IsValid(k.Leader) then k.Leader:Remove() end
	end
end