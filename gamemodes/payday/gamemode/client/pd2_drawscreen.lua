local mat = Material( "color" )

surface.CreateFont( "Dril_Primary", {font = "Arial",size = 45,weight = 800} )
surface.CreateFont( "Dril_Secondary", {font = "Arial",size = 35,weight = 800} )

local function drawscreen()
	local time,progress,bool
	for i,prop in pairs(ents.FindByClass('*prop_physics')) do
		if prop:GetModel() == 'models/pd2_drill/drill.mdl' then
			local ang = prop:GetAngles()
			time = prop:GetNWFloat('time')
			bool = prop:GetNWBool('break')
			if bool then
				progress = (prop:GetNWFloat('break_time')-prop:GetNWFloat('spawn_time'))
			else
				progress = (CurTime()-prop:GetNWFloat('spawn_time'))
			end
			progress = progress/prop:GetNWFloat('progress')
			cam.Start3D2D( prop:GetPos()+ang:Right()*-9.648+ang:Up()*3.05+ang:Forward()*4.207, prop:GetAngles()+Angle(0,270,60),0.01)
				surface.SetMaterial( mat )
				if bool then
					surface.SetDrawColor( 180,3,4 )
					surface.DrawTexturedRect( 0,-489, 713,43 )
					surface.SetDrawColor( 69,5,5 )
					surface.DrawTexturedRect( 0,-448, 713,530 )
					surface.SetDrawColor( 104,6,6,255 )
					surface.DrawTexturedRect( 35,-268,642,80 )
					surface.SetDrawColor( 165,5,4 )
					
					draw.DrawText("// DRILL JAMED //", "Dril_Primary", 185,-375, Color(122, 2, 2,255))
					draw.DrawText("ESTIMATED TIME REMAINING", "Dril_Primary", 105,-125, Color(124, 2, 2,255))
					draw.DrawText("// ERROR //", "Dril_Primary", 250,-50, Color(124, 2, 2,255))
				else
					surface.SetDrawColor( 169,169,169 )
					surface.DrawTexturedRect( 0,-489, 713,43 )
					surface.SetDrawColor( 56,98,141 )
					surface.DrawTexturedRect( 0,-448, 713,530 )
					surface.SetDrawColor( 43, 82,120,255 )
					surface.DrawTexturedRect( 35,-268,642,80 )
					surface.SetDrawColor( 198, 176, 34 )
					
					draw.DrawText("DRILLING IN PROGRESS", "Dril_Primary", 135,-375, Color(123, 135, 91,255))
					draw.DrawText("ESTIMATED TIME REMAINING", "Dril_Primary", 105,-125, Color(175,164,51,255))
					draw.DrawText(math.floor(time+0.9).." SECONDS", "Dril_Primary", 250,-50, Color(175,164,51,255))
				end
				surface.DrawTexturedRect( 45,-258,622*progress,60 )
				draw.DrawText("OVKL ToolSys 2.0", "Dril_Secondary", 15,-486, Color(0,0,0,255))
			cam.End3D2D()
		end
	end
end
hook.Add( "PostDrawOpaqueRenderables", "drawscreen", drawscreen )
