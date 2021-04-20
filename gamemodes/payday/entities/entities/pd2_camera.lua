AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Spawnable = true
ENT.Type = "point"

local delay = 0.04

if CLIENT then

local function camera_alarm()
	local lp = LocalPlayer()
	local cas = lp:GetNWFloat('camalarm_start')
	local ca = lp:GetNWFloat('camalarm')
	if cas == 0 and ca == 0 then return end
	if cas == 0 then 
		cas = math.min(ca,1)
	else
		cas = math.min((CurTime()-cas)*lp:GetNWFloat('stealth')*2,1)
	end
	
	surface.SetDrawColor(127,127,127,255)
	surface.DrawRect(ScrW()*0.35,ScrH()*0.8,ScrW()*0.3,ScrH()*0.03)
	surface.SetDrawColor(0,0,0,255)
	surface.DrawRect(ScrW()*0.36,ScrH()*0.81,ScrW()*0.28,ScrH()*0.01)
	surface.SetDrawColor(255,0,0,255)
	surface.DrawRect(ScrW()*0.36,ScrH()*0.81,ScrW()*0.28*cas,ScrH()*0.01)
end
hook.Add('HUDPaint','camera_alarm',camera_alarm)

return end

local bone_table = {2,6,10,11,15,16,19,20,23,24}
function ENT:TraceBone(ent)
local vec
for i,v in pairs(bone_table) do
    vec = ent:GetBonePosition(v)
    local tr = util.TraceLine( {
        start = self:GetPos()+self:GetAngles():Forward()*5,
        endpos = vec,
        filter = {self,ent,self.Model},
        mask = MASK_ALL
    } )
	if not tr.Hit then return true end
end
return false end

local tab = {}
timer.Create('camera_think',delay,0,function()
for i,ent in pairs( tab ) do if IsValid(ent) then ent:think() end end
local ca
for i,p in pairs( player.GetAll() ) do
	ca = p:GetNWFloat('camalarm')
	if ca>0 then p:SetNWFloat('camalarm',math.max(ca-delay/p:GetNWFloat('stealth')/10,0)) end
	if ca>1 then p:SetNWFloat('camalarm',1) end
end
end )

function ENT:Initialize()
	tab = ents.FindByClass('pd2_camera')

	self.Active = true
	self.inconetableent = {}

	local model = ents.Create('prop_physics')
	model:SetModel('models/props/cs_assault/camera.mdl')
	model:SetPos(self:GetPos())
	model:SetAngles(self:GetAngles())
	model:Spawn()
	model:GetPhysicsObject():EnableMotion(false)
	self.Model = model
end

function ENT:OnRemove()
	if IsValid(self.Model) then self.Model:Remove() end
end

function ENT:think()
if not self.Active then return end
	local cone = ents.FindInCone(self:GetPos(), self:GetAngles():Forward(), 500, math.cos(math.rad(45)))
	for i, ent in pairs(cone) do
		if ent:IsPlayer() then
			if ent:Alive() and self:TraceBone(ent) then
				if not table.HasValue(self.inconetableent,ent) then 
					table.insert(self.inconetableent,ent)
					ent:SetNWFloat('camalarm_start',CurTime()-ent:GetNWFloat('camalarm'))
					ent:SetNWFloat('camalarm',0)
					ent:EmitSound("warning_camera.mp3")
				end
			end
		end
	end
	for i,p in pairs(self.inconetableent) do
		if not table.HasValue(cone,p) then
			table.remove(self.inconetableent,i)
			p:SetNWFloat('camalarm',(CurTime()-p:GetNWFloat('camalarm_start'))*p:GetNWFloat('stealth')*2)
			p:SetNWFloat('camalarm_start',0)
		end
		local t = p:GetNWFloat('camalarm_start')
		if t!=0 then
			if (CurTime()-t)*p:GetNWFloat('stealth')*2>1 then
				hook.Run('PD2AlarmStealth')
				p:EmitSound("detection_camera_or_citizen.mp3")
				p:SetNWFloat('camalarm', 0)
				p:SetNWFloat('camalarm_start',0)
				self.Active = false				
			end
		end
	end
end
