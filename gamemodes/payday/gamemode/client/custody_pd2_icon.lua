local ourMat = Material("custody.png")
local ourMat2 = Material("pr1.png")
local ourMat3 = nil
local dif1 = {'Normal', 'Hard', 'Very Hard', 'Overkill', 'Mayhem', 'Death Wish', 'Death Sentence'}
local dif2 = {'', 'Å', 'Å', 'Å', 'Ä', 'Ç', 'É'}

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
	surface.CreateFont("timer_font",{font="pd2",size=60,weight=800} )
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
end)

hook.Add( "HUDShouldDraw", "hide_hud_pd2", function( name )
	if ( name == "CHudHealth" or name == "CHudBattery" or name == "CHudAmmo" ) then
		return false
	end
end)

function GM:HUDDrawTargetID()
end


