AddCSLuaFile("shared.lua")
include("shared.lua")

local coolDown = {}

function ENT:Initialize()
    self:SetModel("models/props_lab/box01a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    local phys = self:GetPhysicsObject()
    phys:Wake()
end

function ENT:Use(entity)
	if IsValid(entity) and entity:IsPlayer() then
		if entity:Team() == 2 then return true end
		local wep = entity:GetActiveWeapon():GetPrimaryAmmoType()
		if wep and wep != -1 then
			local ammo = game.GetAmmoName(wep)
			local amount = entity:GetActiveWeapon():GetMaxClip1() / 2
			entity:GiveAmmo(amount, ammo)
			entity:EmitSound("pd2_ammo_pickup.mp3")
			self:Remove()
		end
	end
end

function ENT:Touch(entity)
	if IsValid(entity) and entity:IsPlayer() then
		if entity:Team() == 2 then return true end
		local wep = entity:GetActiveWeapon():GetPrimaryAmmoType()
		if wep and wep != -1 then
			local ammo = game.GetAmmoName(wep)
			local amount = entity:GetActiveWeapon():GetMaxClip1() / 2
			entity:GiveAmmo(amount, ammo)
			entity:EmitSound("pd2_ammo_pickup.mp3")
			self:Remove()
		end
	end
end