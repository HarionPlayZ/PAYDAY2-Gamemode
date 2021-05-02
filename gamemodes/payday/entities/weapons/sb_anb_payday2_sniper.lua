AddCSLuaFile()

SWEP.Base = "sb_anb_payday2_wepbase"
SWEP.PrintName = "Gewehr 3 (Sniper) for SB ANB PAYDAY 2"
SWEP.WorldModel = "models/sb_anb_payday2/weapon_sniper.mdl"
SWEP.HoldType = "ar2"
SWEP.Weight = 4

SWEP.PrimaryAmmo = "SniperRound"
SWEP.PrimaryClip = 6
SWEP.PrimaryAuto = false

SWEP.BulletsPerShoot = 1
SWEP.FullShootDamage = 750

SWEP.InternalSpreadDegrees = 0
SWEP.MuzzleEffect = true

SWEP.ShotSound = Sound("sb_anb_payday2/weapons/shot_sniper.mp3")
SWEP.ShotSoundLevel = 95
SWEP.NextShootTime = 1

SWEP.NPCSpreadDegrees = 2
SWEP.NPCBurstMin = 1
SWEP.NPCBurstMax = 1
SWEP.NPCBurstDelay = 0
SWEP.NPCRestMin = 5
SWEP.NPCRestMax = 5

if SERVER then return end

hook.Add("PostDrawTranslucentRenderables","sb_anb_payday2_sniper",function()
	render.SetColorMaterial()

	for k,v in ipairs(ents.FindByClass("sb_anb_payday2_sniper")) do
		if v:IsDormant() then continue end
		
		local att = v:LookupAttachment("laser")
	
		if att then
			local data = v:GetAttachment(att)
			
			if data then
				local tr = util.TraceLine({start = data.Pos,endpos = data.Pos+data.Ang:Forward()*56756,mask = MASK_NPCWORLDSTATIC})
				
				render.DrawBeam(tr.StartPos,tr.HitPos,0.5,0,1,Color(255,0,0,150))
			end
		end
	end
end)