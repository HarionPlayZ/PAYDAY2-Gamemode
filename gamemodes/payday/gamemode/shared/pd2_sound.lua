if SERVER then
	util.AddNetworkString("playsound")
	util.AddNetworkString("stopsound")
	function playsound(tab,str)
		net.Start("playsound")
		net.WriteString(str)
		net.Send(tab)
	end
	function stopsound(tab,str)
		net.Start("stopsound")
		net.WriteString(str)
		net.Send(tab)
	end
else
	local function playsound(path)
		LocalPlayer():EmitSound(path)
	end

	local function stopsound(path)
		LocalPlayer():StopSound(path)
	end

	net.Receive( "playsound", function()
		local path = net.ReadString()
		playsound(path)
	end )
	net.Receive( "stopsound", function()
		local path = net.ReadString()
		stopsound(path)
	end )
end