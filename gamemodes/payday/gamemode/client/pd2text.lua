/* Code by KeQwerty
Made for HarionPlayZ, PAYDAY2 Gamemode*/

-- pd2 = pd2 or {}

local vosklznak = Material("icon/info_objective.png")
local box = Material("icon/box.png")
local w,h = ScrW()/100,ScrH()/100
surface.CreateFont("PD2Text", {
    font = "Payday2",
    size = math.Round(h*4.629629629),
    extended = true,
})
hook.Add('OnScreenSizeChanged','PD2Text',function()
surface.CreateFont("PD2Text", {
    font = "Payday2",
    size = math.Round(h*4.629629629),
    extended = true,
})
w,h = ScrW()/100,ScrH()/100
end)

local text,size

local function pd2_all()
    local pl = LocalPlayer()
    surface.SetMaterial(vosklznak)
    surface.SetDrawColor(Color(255,255,255))
    surface.DrawTexturedRect(30,25,30,30)
    --icon
    surface.SetMaterial(box)
    surface.SetDrawColor(Color(255,255,255))
    surface.DrawTexturedRect(60,20,size!=0 and size or 275,60)
    --box
    draw.SimpleText(text!=nil and text or '',"PD2Text",70,27.5,Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
end

net.Receive("pd2_taskbar_display", function()
	text=net.ReadString()
	size=net.ReadInt(32)
    hook.Add("HUDPaint", "pd2_taskbar_display", pd2_all)
end)

net.Receive("pd2_taskbar_remove", function()
    hook.Remove("HUDPaint", "pd2_taskbar_display")
end)