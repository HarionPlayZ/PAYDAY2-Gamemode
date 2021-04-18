if ( CLIENT ) then return end

local function Think()
	local enabled = 1
	local speed = 1 / 100
	local time = FrameTime()
	
	for _, ply in ipairs( player.GetAll() ) do
		if ( not ply:Alive() or ply:Team() == 2 ) then goto next_player end

		local armor = ply:Armor()
		if ( armor < ( ply.LastArmor or 0 ) ) then
			ply.ArmorRegenNext = CurTime() + 5
		end
		
		if ( CurTime() > ( ply.ArmorRegenNext or 0 ) && enabled ) then
			ply.ArmorRegen = ( ply.ArmorRegen or 0 ) + time
			if ( ply.ArmorRegen >= speed ) then
				local add = math.floor( ply.ArmorRegen / speed )
				ply.ArmorRegen = ply.ArmorRegen - ( add * speed )
				if ( armor < ply:GetMaxArmor() || speed < 0 ) then
					ply:SetArmor( math.min( armor + add, ply:GetMaxArmor() ) )
				end
			end
		end
		
		ply.LastArmor = ply:Armor()

		::next_player::
	end
end
hook.Add( "Think", "armorRegen.Think", Think )
