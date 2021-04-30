local spark
function dril_spawn(vec,ang,id,time)
local dril = ents.Create( "prop_physics" )
dril:SetModel( "models/pd2_drill/drill.mdl" )
dril:SetPos( vec )
dril:SetAngles( ang )
dril:Spawn()
dril:GetPhysicsObject():EnableMotion(false)
dril.id = id
dril.repair = 0
dril:SetNWFloat('time',time)
dril:SetNWFloat('progress',time)
dril:SetNWFloat('spawn_time',CurTime())
dril:timer_Simple(math.random(300,900)/10,function() dril_break(dril) end)
dril:EmitSound('pd2_drill.wav')
spark = ents.FindByName('drill_spark')[1]
if IsValid(spark) then spark:Fire('StartSpark') end
end

timer.Create('Dril',1,0,function()
	local time
	for i,self in pairs(ents.FindByModel('models/pd2_drill/drill.mdl')) do
		if not self:GetNWBool('break') then
			time = self:GetNWFloat('time')-1
			self:SetNWFloat('time',time)
			if time <= 0 then
				dril_complited(self)
			end
		end
	end
end)

function dril_break(dril)
dril:SetNWBool('break',true) 
dril:SetNWFloat('break_time',CurTime())
dril:StopSound('pd2_drill.wav')
if IsValid(spark) then spark:Fire('StopSpark') end
end

function dril_repair(dril)
dril.repair = 0
dril:SetNWFloat('spawn_time',CurTime()-dril:GetNWFloat('break_time')+dril:GetNWFloat('spawn_time'))
dril:SetNWBool('break',false)
dril:EmitSound('pd2_drill.wav')
dril:timer_Simple(math.random(300,900)/10,function() dril_break(dril) end)
if IsValid(spark) then spark:Fire('StartSpark') end
end

function dril_complited(dril)
dril:StopSound('pd2_drill.wav')
dril:Remove()
hook.Call('dril_comlited',nil,dril.id)
if IsValid(spark) then spark:Remove() end
end

hook.Add( "PlayerUse", "dril", function( ply, dril )
	if dril:GetModel()=='models/pd2_drill/drill.mdl' then
		if dril:GetNWBool('break') then	
			ply:ChatPrint(math.floor(dril.repair/300*100))
			dril.repair = dril.repair + 1
			if dril.repair > 300 then dril_repair(dril) end
		end
	end
end )
