--* Client script initialization
--? shared.lua - is called simultaneously on both the client and the server.
--? Recommended only for generic elements
include('shared.lua')
include('client/pd2_hud.lua')
include('client/pd2_outline.lua')
include('client/pd2_show_items.lua')
include('client/pd2_assautphases.lua')
include('client/bleedout_client.lua')
include('client/custody_pd2_icon.lua')
include('client/pd2_timer.lua')
include('bleedout/bleedout.lua')
include('client/pd2text.lua')
include('client/pd2_drawscreen.lua')

net.Receive('padpd2',function()
	padpd = net.ReadInt(4)
end)