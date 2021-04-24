local ourMat = Material("custody.png")
local ourMat2 = Material("pr1.png")
local ourMat3 = nil
local dif1 = {'Normal', 'Hard', 'Very Hard', 'Overkill', 'Mayhem', 'Death Wish', 'Death Sentence'}
local dif2 = {'', 'Å', 'Å Å', 'Å Å Å', 'Å Å Å Ä', 'Å Å Å Ä Ç', 'Å Å Å Ä Ç É'}
local color1 = {Color( 255, 255, 255, 255 ), Color( 255, 215, 0, 255 ), Color( 255, 215, 0, 255 ), Color( 255, 215, 0, 255 ), Color( 255, 215, 0, 255 ), Color( 255, 70, 0, 255 ), Color( 255, 0, 0, 255 )}

surface.CreateFont("pd2",{font="Payday2",size=60,weight=800} )

hook.Add( "InitPostEntity", "pd2_load_brief", function()
	if game.GetMap() == "pd2_jewelry_store_mission" then
		ourMat3 = Material("brief/jewelry.png")
	end
	if game.GetMap() == "pd2_warehouse_mission" then
		ourMat3 = Material("brief/warehouse.png")
	end
	if game.GetMap() == "pd2_htbank_mission" then
		ourMat3 = Material("brief/bankht.png")
	end
end)

hook.Add("HUDPaint", "IconOfPrisonpd2", function()
	if LocalPlayer():GetNWBool("pd2prison") then
		surface.SetDrawColor( 255, 255, 255, 255 ) -- Set the drawing color
		surface.SetMaterial( ourMat ) -- Use our cached material
		surface.DrawTexturedRect( ScrH()/2+330, ScrW()/2, 64, 64 ) -- Actually draw the rectangle
	end
	if LocalPlayer():GetNWBool("pd2policestop") then
		surface.SetDrawColor( 255, 255, 255, 255 ) -- Set the drawing color
		surface.SetMaterial( ourMat2 ) -- Use our cached material
		surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() ) -- Actually draw the rectangle
	end
	if LocalPlayer():GetNWBool("pd2brief") then
		surface.SetDrawColor( 255, 255, 255, 255 ) -- Set the drawing color
		surface.SetMaterial( ourMat3 ) -- Use our cached material
		surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() ) -- Actually draw the rectangle
	end
	if LocalPlayer():GetNWBool("pd2dif") then
		surface.SetDrawColor( 0, 0, 0, 255 ) -- Set the drawing color
		surface.DrawRect( 0, 0, ScrW(), ScrH() ) -- Actually draw the rectangle
		
		draw.SimpleText( dif1[padpd+1], "pd2", ScrW() * 0.5, ScrH() * 0.45, color1[padpd+1], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( dif2[padpd+1], "pd2", ScrW() * 0.5, ScrH() * 0.45+50, Color( 255, 215, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
end)

hook.Add( "HUDShouldDraw", "hide_hud_pd2", function( name )
	if ( name == "CHudHealth" or name == "CHudBattery" or name == "CHudAmmo" ) then
		return false
	end
end)

function GM:HUDDrawTargetID()
end


