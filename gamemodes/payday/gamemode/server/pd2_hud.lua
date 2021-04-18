local team_custom = CreateConVar("pd2_hud_team_custom","0",bit.bor(FCVAR_ARCHIVE,FCVAR_REPLICATED),"Enables teammates from pd2_hud_teammates menu. Disable this and overwrite pd2_hud_GetTeammates function to make custom behaviour.",0,1)
local allow_hitmarker = CreateConVar("pd2_hud_allow_hitmarker","1",bit.bor(FCVAR_ARCHIVE,FCVAR_REPLICATED),"Allows hit markers.",0,1)
local allow_damageind = CreateConVar("pd2_hud_allow_damageind","1",bit.bor(FCVAR_ARCHIVE,FCVAR_REPLICATED),"Allows damage indicators.",0,1)
local allow_team = CreateConVar("pd2_hud_allow_team","1",bit.bor(FCVAR_ARCHIVE,FCVAR_REPLICATED),"Allows teammates HUD.",0,1)

util.AddNetworkString("pd2_hud")

local curply

hook.Add("EntityTakeDamage","pd2_hud",function(ent,dmg)
	curply = ent:IsPlayer() and allow_damageind:GetBool() and {
		ply = ent,
		pos = (dmg:IsBulletDamage() and IsValid(dmg:GetInflictor()) and dmg:GetInflictor():GetPos() or IsValid(dmg:GetAttacker()) and dmg:GetAttacker():GetPos()) or dmg:GetDamagePosition(),
		armor = ent:Armor(),
	}
end)

hook.Add("PostEntityTakeDamage","pd2_hud",function(ent,dmg,took)
	if !took then return end
	
	if curply and curply.ply==ent then
		net.Start("pd2_hud",true)
			net.WriteBool(false)
			net.WriteVector(curply.pos)
			net.WriteUInt(ent:Armor()>0 and 0 or curply.armor>0 and 1 or 2,3)
			net.WriteFloat(dmg:GetDamage())
		net.Send(ent)
	end
	
	if allow_hitmarker:GetBool() and IsValid(dmg:GetAttacker()) and dmg:GetAttacker():IsPlayer() and (ent:IsPlayer() and ent!=dmg:GetAttacker() or ent:IsNPC() or ent:IsNextBot()) then
		net.Start("pd2_hud",true)
			net.WriteBool(true)
			net.WriteBool(ent:Health()<=0)
		net.Send(dmg:GetAttacker())
	end
	
	if ent:IsPlayer() and allow_damageind:GetBool() and allow_team:GetBool() then
		ent:SetNWFloat("pd2_hud_damage",CurTime())
	end
end)

timer.Create('pd2_hud',0.5,0,function()
	if !allow_team:GetBool() then return end
	for k,v in ipairs(player.GetAll()) do
		local wep = v:GetActiveWeapon()
		if IsValid(wep) then
			if wep:GetPrimaryAmmoType()!=-1 then
				v:SetNWInt("pd2_hud_clip1",wep:GetMaxClip1())
				v:SetNWInt("pd2_hud_pammo",v:GetAmmoCount(wep:GetPrimaryAmmoType())+math.max(0,wep:Clip1()))
			else
				v:SetNWInt("pd2_hud_clip1",-1)
				v:SetNWInt("pd2_hud_pammo",-1)
			end
			if wep:GetSecondaryAmmoType()!=-1 then
				v:SetNWInt("pd2_hud_clip2",wep:GetMaxClip2())
				v:SetNWInt("pd2_hud_sammo",v:GetAmmoCount(wep:GetSecondaryAmmoType())+math.max(0,wep:Clip2()))
			else
				v:SetNWInt("pd2_hud_clip2",-1)
				v:SetNWInt("pd2_hud_sammo",-1)
			end
		end
	end
end )