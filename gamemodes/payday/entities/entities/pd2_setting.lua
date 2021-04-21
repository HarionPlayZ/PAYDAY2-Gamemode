ENT.Base = "base_gmodentity"
ENT.Type = "point"

if SERVER then
util.AddNetworkString('pd2_map_spawned')
function ENT:Initialize()
	hook.Call('pd2_map_spawned')
	net.Start('pd2_map_spawned')
	net.Send(player.GetAll())
end
return end

net.Receive('pd2_map_spawned',function()
	hook.Call('pd2_map_spawned')
end)