local mat = Material( "color" )
local progress = 0

local function drawscreen()
	for i,prop in pairs(ents.FindByModel('models/pd2_drill/drill.mdl')) do
		local ang = prop:GetAngles()
		cam.Start3D2D( prop:GetPos()+ang:Right()*-9.9+ang:Up()*2+ang:Forward()*3.6, prop:GetAngles()+Angle(-60,0,0),0.1);
			surface.SetMaterial( mat )
			surface.SetDrawColor( 101, 129, 165 )
			surface.DrawTexturedRect( 0,0, 57,75 )
			surface.SetDrawColor( 127, 127, 127 )
			surface.DrawTexturedRect( 22.5,10,10,55 )
			surface.SetDrawColor( 200, 200, 0 )
			surface.DrawTexturedRect( 22.5,10,10,progress*55 )
		cam.End3D2D();
	end
end
hook.Add( "PostDrawOpaqueRenderables", "drawscreen", drawscreen );