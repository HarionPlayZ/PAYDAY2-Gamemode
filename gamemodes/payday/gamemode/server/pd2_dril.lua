function dril_spawn(vec,ang,id,time)
local dril = ents.Create( "prop_physics" )
dril:SetModel( "models/pd2_drill/drill.mdl" )
dril:SetPos( vec )
dril:SetAngles( ang )
dril:Spawn()
dril:GetPhysicsObject():EnableMotion(false)
dril.id = id
dril:SetNWFloat('time',time)
dril:SetNWFloat('progress',time)
dril:SetNWFloat('spawn_time',CurTime())
dril:timer_Simple(math.random(200,450)/10,function() dril:SetNWBool('break',true) dril:SetNWFloat('break_time',CurTime()) end)
end

timer.Create('Dril',1,0,function()
	local time
	for i,self in pairs(ents.FindByModel('models/pd2_drill/drill.mdl')) do
		if not self:GetNWBool('break') then
			time = self:GetNWFloat('time')-1
			self:SetNWFloat('time',time)
			if time <= 0 then hook.Call('dril_comlited',nil,self.id) self:Remove() end
		end
	end
end)

-- hook.Add('dril_comlited','dril_comlited',function(id)
	-- print(id)
-- end)

hook.Add( "PlayerUse", "some_unique_name2", function( ply, ent )
	if ent:GetModel()=='models/pd2_drill/drill.mdl' then
		if ent:GetNWBool('break') then
			ent:SetNWFloat('spawn_time',CurTime()-ent:GetNWFloat('break_time')+ent:GetNWFloat('spawn_time'))
			ent:SetNWBool('break',false)
		end
	end
end )
