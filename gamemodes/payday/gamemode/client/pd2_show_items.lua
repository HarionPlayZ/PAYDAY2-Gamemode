hook.Add("PreDrawOutlines", "PD2_AMMOS_outline", function()
    local tab = {}
	for i,ent in pairs(ents.FindByClass("pd2_ammo")) do
		if LocalPlayer():GetPos():Distance(ent:GetPos())<=500 then
			table.insert(tab,ent)
		end
	end
    outline.Add(tab, Color(255,255,255), 0)
end)

hook.Add("PreDrawOutlines", "PD2_PLAYERS_outline", function()
    local gang = {}
    local cops = {}
    for i,p in pairs(player.GetAll()) do
        if p:Alive() then
        	if p:Team() == 1 then
        		table.insert(gang,p)
        	end
        	if p:Team() == 2 then
        		table.insert(cops,p)
        	end
        end
    end
    if LocalPlayer():Team() == 2 then outline.Add(gang, Color(255, 0, 0), 1) outline.Add(cops, Color(0, 255, 255), 1) outline.Add(ents.FindByClass('sb_advanced_nextbot_payday2'), Color(0, 255, 255), 1) end
    if LocalPlayer():Team() == 1 then outline.Add(gang, Color(0, 255, 255), 1) end
end)

surface.CreateFont("nickfont",{font="Payday2",size=30,weight=800} )

local function text_3d()
    if LocalPlayer():Team() == 1 then
        for i,p in pairs(player.GetAll()) do
            if p:Alive() then
                if p:Team() == 1 and p != LocalPlayer() then
                    local point = p:GetPos() + p:OBBCenter() + Vector(0,0,40)
                    local data2D = point:ToScreen()
        
                    if not data2D.visible then return end
                    if p:IsBot() then
                        draw.SimpleText( p:Nick(), "nickfont", data2D.x, data2D.y, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                    else
                        draw.SimpleText( p:Nick()..'('..tostring(p:GetNWInt("pd2_level_data"))..')', "nickfont", data2D.x, data2D.y, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                    end
                end
            end
        end
    end
    if LocalPlayer():Team() == 2 then
        for i,p in pairs(ents.FindByClass("sb_advanced_nextbot_payday2")) do
            if p:IsNextBot() then
                local point = p:GetPos() + p:OBBCenter() + Vector(0,0,40)
                local data2D = point:ToScreen()
        
                if not data2D.visible then return end

                draw.SimpleText( "BOT", "nickfont", data2D.x, data2D.y, Color( 0, 0, 205 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            end
        end
    end
    if LocalPlayer():Team() == 2 then
        for i,p in pairs(player.GetAll()) do
            if p:Alive() then
                if p:Team() == 2 and p != LocalPlayer() then
                    local point = p:GetPos() + p:OBBCenter() + Vector(0,0,40)
                    local data2D = point:ToScreen()
        
                    if not data2D.visible then return end

                    draw.SimpleText( p:Nick(), "nickfont", data2D.x, data2D.y, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                end
            end
        end
    end
end
hook.Add( "HUDPaint", "text_3d",text_3d)