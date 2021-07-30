local team_table = {name={'spectator','gang','police'},color={Color(127,127,127),Color(255,255,127),Color(0,0,127)}}
local dif_table = {"NORMAL", "HARD", "VERY HARD", "OVERKILL", "MAYHEM", "DEATH WISH", "DEATH SENTENCE"}

local pl = LocalPlayer()
local w,h = ScrW(),ScrH()
hook.Add( "OnScreenSizeChanged", "newsize", function()
	w,h = ScrW(),ScrH()
end )


net.Receive('f4_menu',function()
	local frame = vgui.Create( "DFrame" )
	frame:SetPos( w*0.1, h*0.1 )
	frame:SetSize( w*0.8, h*0.8 )
	frame:SetTitle( "f4 menu" )
	frame:MakePopup()
	frame.Paint = function() draw.RoundedBox( 0, 0, 0, frame:GetWide(), frame:GetTall(), Color(15,15,15, 255) ) end
	
	local sheet = vgui.Create( "DPropertySheet", frame )
	sheet:Dock( FILL )
	sheet.Paint = function()
		surface.SetDrawColor(255,255,255,255)
		surface.DrawOutlinedRect( 0, 0, sheet:GetWide(), sheet:GetTall(), 4 ) 
	end
	
	
	local panel1 = vgui.Create( "DPanel", sheet )
	panel1.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, self:GetAlpha() ) ) end 
	sheet:AddSheet( "teams", panel1, "icon16/tick.png" )
	
	local button
	for i =0,2 do
		button = vgui.Create( "DButton", panel1 )
		button.Paint = function() 
			surface.SetDrawColor(Color(31,31,31, 255))
			surface.DrawRect(0,0, button:GetWide(),button:GetTall() )
			surface.SetDrawColor(Color(0,0,0,255))
			surface.DrawOutlinedRect(0,0, button:GetWide(),button:GetTall())
		end
		button:SetFont( "PD2Text" )
		button:SetTextColor(team_table.color[i+1])
		button:SetText( team_table.name[i+1] )
		button:SetPos( 0,h*0.8/3.25*i )
		button:SetSize( w*0.8, h*0.8/3.25 )
		button.DoClick = function()
			net.Start('select_team')
			net.WriteString(team_table.name[i+1])
			net.SendToServer()
			frame:Remove()
		end
	end

	local panel2 = vgui.Create( "DPanel", sheet )
	panel2.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, self:GetAlpha() ) ) end 
	sheet:AddSheet( "shop", panel2, "icon16/cross.png" )

	local panel3 = vgui.Create( "DPanel", sheet )
	panel3.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, self:GetAlpha() ) ) end 
	sheet:AddSheet( "info", panel3, "icon16/cross.png" )
	
	
end)

net.Receive('vote_dif',function()
	local frame = vgui.Create( "DFrame" )
	frame:SetPos( w*0.1, h*0.1 )
	frame:SetSize( w*0.8, h*0.8 )
	frame:SetTitle( "f4 menu" )
	frame:MakePopup()
	
	local button
	for i =0,6 do
		button = vgui.Create( "DButton", frame )
		button.Paint = function() 
			surface.SetDrawColor(Color(31,31,31, 255))
			surface.DrawRect(0,0, button:GetWide(),button:GetTall() )
			surface.SetDrawColor(Color(0,0,0,255))
			surface.DrawOutlinedRect(0,0, button:GetWide(),button:GetTall())
		end
		button:SetFont( "PD2Text" )
		button:SetText( dif_table[i+1] )
		button:SetPos( 0,h*0.8/7.25*i )
		button:SetSize( w*0.8, h*0.8/7.25 )
		button.DoClick = function()
			net.Start('select_dif')
			net.WriteString(dif_table[i+1])
			net.SendToServer()
			frame:Remove()
		end
	end
end)

local function f4_menu_text()
	if not IsValid(pl) then pl = LocalPlayer() else
		if pl:Team()==1001 then
			draw.DrawText("press "..input.LookupBinding( "gm_showspare2" ), "PD2Text", w*0.49, h*0.47, Color(255,255,255,255), TEXT_ALIGN_CENTER)
		end
		if pl:Team()==1 and not pl:GetNWBool('ready') then
			draw.DrawText("press g to get ready", "PD2Text", w*0.51, h*0.52, Color(255,255,255,255), TEXT_ALIGN_CENTER)
		end
		if pl:Team()==1 and pl:GetNWBool('cutscene') then
			draw.DrawText("press space to skip", "PD2Text", w*0.49, h*0.8, Color(255,255,255,255), TEXT_ALIGN_CENTER)
		end
	end
end
hook.Add( "HUDPaint", "f4_menu_text", f4_menu_text)
