local map_tag = game.GetMap():Left(4)
timer.Simple(0,function()
	if gmod.GetGamemode().Name!="PAYDAY 2" and map_tag=="pd2_" then
		RunConsoleCommand("gamemode", "payday")
		RunConsoleCommand("map", game.GetMap())
	end
	if gmod.GetGamemode().Name=="PAYDAY 2" and map_tag!="pd2_" then
		RunConsoleCommand("gamemode", "sandbox")
		RunConsoleCommand("map", game.GetMap()) 
	end
end)