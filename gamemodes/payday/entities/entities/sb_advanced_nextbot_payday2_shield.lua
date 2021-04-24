AddCSLuaFile()

ENT.Type = "anim"
ENT.Spawnable = false
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Initialize()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	
	self:SetCustomCollisionCheck(true)
end

function ENT:Parent(ent,bone,pos,ang)
	self:FollowBone(ent,bone)
	self:SetLocalPos(pos)
	self:SetLocalAngles(ang)
	
	self:CollisionRulesChanged()
end

function ENT:TransformToProp()
	local pos = self:GetPos()
	local ang = self:GetAngles()
	
	local ent = ents.Create("prop_physics")
	ent:SetPos(pos)
	ent:SetAngles(ang)
	ent:SetModel(self:GetModel())
	ent.Owner = self.Owner
	ent:Spawn()
	ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	
	SafeRemoveEntityDelayed(ent,10)

	self:Remove()
end

function ENT:Draw()
	local reset = false
	local parent = self:GetParent()
	
	if IsValid(parent) then
		local m = parent:GetBoneMatrix(self:GetParentAttachment())
		
		if m then
			local p,a = LocalToWorld(self:GetLocalPos(),self:GetLocalAngles(),m:GetTranslation(),m:GetAngles())
			
			self:SetRenderOrigin(p)
			self:SetRenderAngles(a)
			
			reset = true
		end
	end
	
	self:DrawModel()
	self:CreateShadow()
	
	if reset then
		self:SetRenderOrigin()
		self:SetRenderAngles()
	end
end

function ENT:ShouldCollide(ent)
	local parent = self:GetParent()
	local team = IsValid(parent) and parent.GetTeam and parent:GetClass()=="sb_advanced_nextbot_payday2" and parent:GetTeam()
	
	if team and ent.GetTeam and ent:GetClass()=="sb_advanced_nextbot_payday2" and ent:GetTeam()==team then return false end
	
	return true
end

hook.Add("ShouldCollide","sb_advanced_nextbot_payday2_shield",function(ent1,ent2)
	if ent1:GetClass()=="sb_advanced_nextbot_payday2_shield" or ent2:GetClass()=="sb_advanced_nextbot_payday2_shield" then
		local shield = ent1:GetClass()=="sb_advanced_nextbot_payday2_shield" and ent1 or ent2
		local ent = ent1==shield and ent2 or ent1
		
		if shield.ShouldCollide and !shield:ShouldCollide(ent) then return false end
	end
end)

hook.Add("PhysgunPickup","sb_advanced_nextbot_payday2_shield",function(ply,ent)
	if ent:GetClass()=="sb_advanced_nextbot_payday2_shield" and IsValid(ent:GetParent()) then
		return false
	end
end)

hook.Add("AllowPlayerPickup","sb_advanced_nextbot_payday2_shield",function(ply,ent)
	if ent:GetClass()=="sb_advanced_nextbot_payday2_shield" and IsValid(ent:GetParent()) then
		return false
	end
end)

hook.Add("GravGunPickupAllowed","sb_advanced_nextbot_payday2_shield",function(ply,ent)
	if ent:GetClass()=="sb_advanced_nextbot_payday2_shield" and IsValid(ent:GetParent()) then
		return false
	end
end)