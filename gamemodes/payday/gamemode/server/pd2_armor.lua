util.AddNetworkString("pd2_dmgsys")

local pd2_dmgsys_enabled = CreateConVar("pd2_dmgsys_enabled","1",FCVAR_ARCHIVE,"Enables/Disables PAYDAY 2 Damage System.",0,1)
local pd2_dmgsys_team = CreateConVar("pd2_dmgsys_team","-1",FCVAR_ARCHIVE,"If higher than -1, PAYDAY 2 Damage System will work only for team with this index.",-1)
local pd2_dmgsys_armorres = CreateConVar("pd2_dmgsys_armorres","5",FCVAR_ARCHIVE,"Sets armor restore time in PAYDAY 2 Damage System. Set to 0 to disable.",0)
local pd2_dmgsys_fallspd = CreateConVar("pd2_dmgsys_fallspd","350",FCVAR_ARCHIVE,"Sets falling speed to take damage in PAYDAY 2 Damage System. Set to 0 to disable.",0)
local pd2_dmgsys_fallspd_fatal = CreateConVar("pd2_dmgsys_fallspd_fatal","500",FCVAR_ARCHIVE,"Sets fatal falling speed to kill player in PAYDAY 2 Damage System. Set to 0 to disable.",0)

-- Ideal hook, called after EntityTakeDamage (so other addons already done their logic), but before PostEntityTakeDamage (addons that checks this hook will get actual info after system will do all logic), and before actual player death (but after health and armor default reduction logic, so this is only one problem).
gameevent.Listen("player_hurt")

local CurData

hook.Add("EntityTakeDamage","pd2_dmgsys",function(ent,dmg)
	if ent:IsPlayer() and pd2_dmgsys_enabled:GetBool() then
		local func = pd2_dmgsys_ShouldWorkOnPlayer
		local work = false
		
		if func then
			work = func(ent,dmg)
		else
			work = pd2_dmgsys_team:GetInt()==-1 or pd2_dmgsys_team:GetInt()==ent:Team()
		end
		
		if work then
			-- Custom logic of fall damage, suppressing default damage logic
			if dmg:IsFallDamage() and pd2_dmgsys_fallspd:GetInt()>0 and !ent.pd2_dmgsys_falldamage then
				return true
			end
		
			CurData = {
				Player = ent,
				DamageInfo = dmg,
				Health = ent:Health(),
				Armor = ent:Armor(),
			}
		end
	end
end)

hook.Add("player_hurt","pd2_dmgsys",function(data)
	if !CurData then return end
	
	local ply = Player(data.userid)
	if CurData.Player!=ply then return end
	
	local dmg = CurData.DamageInfo
	local hp = CurData.Health
	local armor = CurData.Armor
	
	CurData = nil
	
	local newhp = hp
	local newarmor = armor
	local damage = dmg:GetDamage()
	
	if armor>0 and bit.band(dmg:GetDamageType(),bit.bor(/*DMG_FALL,*/DMG_DROWN,DMG_PARALYZE,DMG_POISON,DMG_RADIATION,DMG_NERVEGAS,DMG_ACID))==0 then
		local armorsub = damage>armor and armor or damage
		newarmor = newarmor-armorsub
		
		if damage>armor then
			local hpsub = damage-armor
			newhp = newhp-hpsub
		end
	else
		newhp = newhp-damage
	end
	
	ply:SetHealth(newhp<0 and 0 or newhp)
	ply:SetArmor(newarmor<0 and 0 or newarmor)
	
	if ply:Armor()<ply:GetMaxArmor() then
		local func = pd2_dmgsys_GetArmorRestoreTime
		local armorres
		
		if func then
			armorres = pd2_dmgsys_GetArmorRestoreTime(ply,dmg)
		else
			armorres = pd2_dmgsys_armorres:GetFloat()
		end
		
		if armorres>0 then
			ply.pd2_dmgsys_armorres = CurTime()+armorres
		end
	end
end)

hook.Add("OnPlayerHitGround","pd2_dmgsys",function(ply,onwater,onfloater,speed)
	if !pd2_dmgsys_enabled:GetBool() then return end

	local fallspd = pd2_dmgsys_fallspd:GetInt()
	if fallspd<=0 then return end
	
	if speed>=fallspd then
		local fatal = pd2_dmgsys_fallspd_fatal:GetInt()
		local isfatal = fatal>0 and speed>=fatal
		
		local dmg = DamageInfo()
		dmg:SetAttacker(game.GetWorld())
		dmg:SetInflictor(game.GetWorld())
		dmg:SetDamage(isfatal and ply:Health()+ply:Armor() or ply:GetMaxHealth()/4)
		dmg:SetDamageType(DMG_FALL)
		
		ply.pd2_dmgsys_falldamage = true
		ply:TakeDamageInfo(dmg)
		ply.pd2_dmgsys_falldamage = nil
		
		ply:EmitSound("Player.FallDamage",75,math.random(90,110),0.75)
	end
end)

hook.Add("PlayerPostThink","pd2_dmgsys",function(ply)
	if ply.pd2_dmgsys_armorres then
		if !ply:Alive() or pd2_dmgsys_armorres:GetFloat()<=0 or !pd2_dmgsys_enabled:GetBool() then
			ply.pd2_dmgsys_armorres = nil
		elseif CurTime()>=ply.pd2_dmgsys_armorres then
			if ply:Team() == 1 then
				ply:SetArmor(ply:GetMaxArmor())
				
				if ply.pd2_dmgsys_armorres>0 then
					net.Start("pd2_dmgsys",true)
					net.Send(ply)
				end
				
				ply.pd2_dmgsys_armorres = nil
			end
		end
	end
end)

hook.Add("PlayerSpawn","pd2_dmgsys",function(ply)
	ply.pd2_dmgsys_armorres = 0
end)