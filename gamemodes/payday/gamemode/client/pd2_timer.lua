surface.CreateFont("timer_font",{font="Payday2",size=35,weight=800} )
local timertime = 0

local function TimerDisplay()
    local timer_tab = string.FormattedTime( CurTime() - timertime)
    local timer_t = string.format("%02d:%02d", timer_tab.m, timer_tab.s)
    local offset = 0
    if LocalPlayer():GetNWBool("timer_text_offset") then offset = height(0.015) end
    draw.SimpleText( timer_t, "timer_font", ScrW() * 0.51, ScrH() * 0.025 -offset, Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
end

function start_display_time()
	hook.Add("HUDPaint","TimerPD2",TimerDisplay)
	for k, v in pairs(player.GetAll()) do
		timer.Simple(0, function() v:SetNWBool("pd2dif", true) v:ConCommand("pd2_hud_enable 0") end)
		timer.Simple(5, function() v:SetNWBool("pd2dif", false) v:ConCommand("pd2_hud_enable 1") end)
	end
end
net.Receive( 'start_display_time', start_display_time )

function stop_display_time()
	hook.Remove("HUDPaint","TimerPD2")
end
net.Receive( 'stop_display_time', stop_display_time )

net.Receive( 'set_start_time', function()
	local time = net.ReadInt(32)
	timertime = time
end )
