local team_table = {'spectator','gang','police'}
local dif_table = {"NORMAL", "HARD", "VERY HARD", "OVERKILL", "MAYHEM", "DEATH WISH", "DEATH SENTENCE"}


net.Receive('f4_menu',function()
	local frame = vgui.Create( "DFrame" )
	frame:SetPos( ScrW()*0.1, ScrH()*0.1 )
	frame:SetSize( ScrW()*0.8, ScrH()*0.8 )
	frame:SetTitle( "f4 menu" )
	frame:MakePopup()
	
	local sheet = vgui.Create( "DPropertySheet", frame )
	sheet:Dock( FILL )
	
	local panel1 = vgui.Create( "DPanel", sheet )
	panel1.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, self:GetAlpha() ) ) end 
	sheet:AddSheet( "teams", panel1, "icon16/tick.png" )
	
	local button
	for i =0,2 do
		button = vgui.Create( "DButton", panel1 )
		button:SetFont( "PD2Text" )
		button:SetText( team_table[i+1] )
		button:SetPos( 0,ScrH()*0.8/3.25*i )
		button:SetSize( ScrW()*0.8, ScrH()*0.8/3.25 )
		button.DoClick = function()
			net.Start('select_team')
			net.WriteString(team_table[i+1])
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
	frame:SetPos( ScrW()*0.1, ScrH()*0.1 )
	frame:SetSize( ScrW()*0.8, ScrH()*0.8 )
	frame:SetTitle( "f4 menu" )
	frame:MakePopup()
	
	local button
	for i =0,6 do
		button = vgui.Create( "DButton", frame )
		button:SetFont( "PD2Text" )
		button:SetText( dif_table[i+1] )
		button:SetPos( 0,ScrH()*0.8/7.25*i )
		button:SetSize( ScrW()*0.8, ScrH()*0.8/7.25 )
		button.DoClick = function()
			net.Start('select_dif')
			net.WriteString(dif_table[i+1])
			net.SendToServer()
			frame:Remove()
		end
	end
end)

local pl = LocalPlayer()
local function f4_menu_text()
	if not IsValid(pl) then pl = LocalPlayer() return end
	if pl:Team()==1001 then
		draw.DrawText("press f4", "PD2Text", ScrW() * 0.49, ScrH() * 0.47, Color(255,255,255,255), TEXT_ALIGN_CENTER)
	end
	if pl:Team()==1 and not pl:GetNWBool('ready') then
		draw.DrawText("press g to get ready", "PD2Text", ScrW() * 0.51, ScrH() * 0.47, Color(255,255,255,255), TEXT_ALIGN_CENTER)
	end
	if pl:Team()==1 and pl:GetNWBool('cutscene') then
		draw.DrawText("press space to skip", "PD2Text", ScrW() * 0.49, ScrH() * 0.8, Color(255,255,255,255), TEXT_ALIGN_CENTER)
	end
end
hook.Add( "HUDPaint", "f4_menu_text", f4_menu_text)
