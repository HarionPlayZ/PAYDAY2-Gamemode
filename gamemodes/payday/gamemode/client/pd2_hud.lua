local enable = CreateConVar("pd2_hud_enable","1",bit.bor(FCVAR_ARCHIVE,FCVAR_NEVER_AS_STRING),"Enables PAYDAY 2 HUD, replaces default.",0,1)
local position = CreateConVar("pd2_hud_position","3",bit.bor(FCVAR_ARCHIVE,FCVAR_NEVER_AS_STRING),"Position of HUD. 0 - left top, 1 - right top, 2 - left bottom, 3 - right bottom.",0,3)
local scale = CreateConVar("pd2_hud_scale","0.5",bit.bor(FCVAR_ARCHIVE,FCVAR_NEVER_AS_STRING),"Scale of HUD. This is multiplier, you can use 1 (default), 2 (2 times larger), 1.5, 0.5 and other.",0)
local offset = CreateConVar("pd2_hud_offset","-50 -50",FCVAR_ARCHIVE,"Offset of HUD position, format 'x y'. Unknown format will be treated as '0 0'.")
local plycolor = CreateConVar("pd2_hud_plycolor","0",FCVAR_ARCHIVE,"Player's circle color. 0 - 1st player, 1 - 2nd player, 2 - 3rd player, 3 - 4th player; or custom color in 'r g b' format like '255 255 255'. Unknown format will be treated as 0.")
local damageind = CreateConVar("pd2_hud_damage","1",bit.bor(FCVAR_ARCHIVE,FCVAR_NEVER_AS_STRING),"Enables PAYDAY 2 damage indicators.",0,1)
local hitmarkers = CreateConVar("pd2_hud_hits","1",bit.bor(FCVAR_ARCHIVE,FCVAR_NEVER_AS_STRING),"Enables PAYDAY 2 hit markers.",0,1)
local drawteam = CreateConVar("pd2_hud_team_enable","1",bit.bor(FCVAR_ARCHIVE,FCVAR_NEVER_AS_STRING),"Enables teammates drawing on PAYDAY 2 HUD.",0,1)
local team_pos = CreateConVar("pd2_hud_team_position","3",bit.bor(FCVAR_ARCHIVE,FCVAR_NEVER_AS_STRING),"Teammates HUD position. 0 - left top, 1 - right top, 2 - left bottom, 3 - right bottom.",0,3)
local team_width = CreateConVar("pd2_hud_team_width","-304",bit.bor(FCVAR_ARCHIVE,FCVAR_NEVER_AS_STRING),"Teammates HUD width. Controls empty space between few teammate HUDs. Negative number means substract from Screen Width.")
local team_max = CreateConVar("pd2_hud_team_max","3",bit.bor(FCVAR_ARCHIVE,FCVAR_NEVER_AS_STRING),"Max teammates HUDs.",0)
local team_offset = CreateConVar("pd2_hud_team_offset","50 -50",FCVAR_ARCHIVE,"Offset of teammates HUD. Format same as in pd2_hud_offset.")
local team_scale = CreateConVar("pd2_hud_team_scale","0.5",bit.bor(FCVAR_ARCHIVE,FCVAR_NEVER_AS_STRING),"Scale of teammates HUD.",0)

local pd2_dmgsys_armorres_sound = CreateConVar("pd2_dmgsys_armorres_sound","1",FCVAR_ARCHIVE,"Enables/Disables armor restore sound in PAYDAY 2 Damage System.",0,1)

local team_custom = CreateConVar("pd2_hud_team_custom","1",FCVAR_REPLICATED,"Enables teammates from pd2_hud_teammates menu. Disable this and overwrite pd2_hud_GetTeammates function to make custom behaviour.",0,1)
local allow_hitmarker = CreateConVar("pd2_hud_allow_hitmarker","1",FCVAR_REPLICATED,"Allows hit markers.",0,1)
local allow_damageind = CreateConVar("pd2_hud_allow_damageind","1",FCVAR_REPLICATED,"Allows damage indicators.",0,1)
local allow_team = CreateConVar("pd2_hud_allow_team","1",FCVAR_REPLICATED,"Allows teammates HUD.",0,1)

local nodraw = {
	CHudAmmo = true,
	CHudBattery = true,
	CHudDamageIndicator = true,
	CHudGeiger = true,
	CHudHealth = true,
	CHudPoisonDamageIndicator = true,
	CHudSecondaryAmmo = true,
}

local plycolors = {Color(200,255,150),Color(150,180,185),Color(180,100,110),Color(200,170,130)}

local background_color = Color(0,0,0,150)
local foreground_color = Color(255,255,255)
local yellow = Color(255,255,0)
local red = Color(255,0,0)

local armor_mat = Material("pd2_hud/hparmor_arm.png","smooth")
local hp_mat = Material("pd2_hud/hparmor_hp.png","smooth")
local bg_mat = Material("pd2_hud/hparmor_bg.png","smooth")
local dmg_mat = Material("pd2_hud/hparmor_dmg.png","smooth")
local circle = Material("pd2_hud/circle.png","smooth")
local firemode_auto = Material("pd2_hud/firemode_auto.png","smooth")
local firemode_single = Material("pd2_hud/firemode_single.png","smooth")
local hit = Material("pd2_hud/hit.png","smooth")
local hitkill = Material("pd2_hud/hitkill.png","smooth")
local dmgdir = Material("pd2_hud/dmgdir.png","smooth")

local w,h = 408,182
local w2,h2 = 514,104
local dmgdirw,dmgdirh = dmgdir:Width(),dmgdir:Height()

local hud_texture,hud_material

local TeammatesList = {}

local ReloadHUDTexture = function()
	local w,h = ScrW(),ScrH()
	
	hud_texture = GetRenderTargetEx("pd2_hud_"..w.."x"..h,w,h,RT_SIZE_NO_CHANGE,MATERIAL_RT_DEPTH_SEPARATE,bit.bor(2,256,8192),0,IMAGE_FORMAT_BGRA8888)
	hud_material = CreateMaterial("pd2_hud_"..w.."x"..h,"UnlitGeneric",{["$basetexture"] = hud_texture:GetName(),["$ignorez"] = "1",["$translucent"] = "1"})
end
ReloadHUDTexture()

local function TextureDraw_Start()
	render.PushRenderTarget(hud_texture,0,0,ScrW(),ScrH())
		render.OverrideAlphaWriteEnable(true,true)
		
		render.Clear(0,0,0,0,true,true)
end

local function TextureDraw_Finish(x,y,w,h)
		render.OverrideAlphaWriteEnable(false)
	render.PopRenderTarget()
	
	render.SetMaterial(hud_material)
	render.DrawScreenQuadEx(x,y,w,h)
end

-- For overwrite
pd2_hud_GetTeammates = pd2_hud_GetTeammates or function()
	return team.GetPlayers(LocalPlayer():Team())
end

local FractionCircle = function(x,y,r,mat,fr)
	if fr!=fr or fr<=0 then return end

	local c = surface.GetDrawColor()

	if fr<1 then
		render.ClearStencil()
		
		render.SetStencilEnable(true)
			
			render.SetStencilWriteMask(255)
			render.SetStencilTestMask(255)
			
			render.SetStencilCompareFunction(STENCIL_ALWAYS)
			render.SetStencilPassOperation(STENCIL_REPLACE)
			render.SetStencilFailOperation(STENCIL_KEEP)
			render.SetStencilZFailOperation(STENCIL_KEEP)
			
			render.SetStencilReferenceValue(1)
			
			surface.SetDrawColor(0,0,0,1)
			
			local len = r*2
			
			if fr>0.75 then
				local ang = math.rad((fr-0.75)*4*90)
			
				surface.DrawPoly({
					{x = x,y = y},
					{x = x+len*math.cos(ang),y = y-len*math.sin(ang)},
					{x = x+len,y = y},
				})
			end
			if fr>0.5 then
				local ang = math.rad((math.min(fr,0.75)-0.5)*4*90)
			
				surface.DrawPoly({
					{x = x,y = y},
					{x = x+len*math.sin(ang),y = y+len*math.cos(ang)},
					{x = x,y = y+len},
				})
			end
			if fr>0.25 then
				local ang = math.rad((math.min(fr,0.5)-0.25)*4*90)
			
				surface.DrawPoly({
					{x = x-len,y = y},
					{x = x,y = y},
					{x = x-len*math.cos(ang),y = y+len*math.sin(ang)},
				})
			end
			
			local ang = math.rad(math.min(fr,0.25)*4*90)
			
			surface.DrawPoly({
				{x = x,y = y-len},
				{x = x,y = y},
				{x = x-len*math.sin(ang),y = y-len*math.cos(ang)},
			})
			
			render.SetStencilCompareFunction(STENCIL_EQUAL)
			render.SetStencilPassOperation(STENCIL_KEEP)
	end		
			
			surface.SetDrawColor(c.r,c.g,c.b,c.a)
			surface.SetMaterial(mat)
			surface.DrawTexturedRect(x-r,y-r,r*2,r*2)
			
	if fr<1 then
		render.SetStencilEnable(false)
	end
end

local AddZeros = function(num,count)
	num = tostring(math.min(num,10^count-1))
	
	while #num<count do
		num = "0"..num
	end
	
	return num
end

local PosToAngleAroundScreen = function(pos,ang)
	local lpos = WorldToLocal(pos,angle_zero,LocalPlayer():EyePos(),ang)
	lpos.x = 0
	lpos:Normalize()
	
	local yang = math.deg(math.asin(-lpos.y))
	local zang = math.deg(math.asin(-lpos.z))
	local ang = yang>0 and (zang>0 and 180-yang or yang) or (zang>0 and -180-yang or yang)
	
	return ang
end

local DrawTeammateHUD = function(ply,color,x,y,w,h)
	TextureDraw_Start()

		surface.SetMaterial(circle)
		surface.SetDrawColor(background_color)
		surface.DrawTexturedRect(104,6,36,36)
		
		surface.SetDrawColor(color)
		surface.DrawTexturedRect(110,12,24,24)
		
		local nick = " "..ply:Nick().." "
		surface.SetFont("pd2_hud_nickname")
		local tw,th = surface.GetTextSize(nick)
		
		surface.SetDrawColor(background_color)
		surface.DrawRect(144,2,tw,th)
		draw.SimpleText(nick,"pd2_hud_nickname",144,2)
		
		surface.SetDrawColor(255,255,255)
		surface.SetMaterial(bg_mat)
		surface.DrawTexturedRect(0,0,104,104)
		
		local dmgtime = CurTime()-ply:GetNWFloat("pd2_hud_damage",0)
		if dmgtime<1 then
			surface.SetDrawColor(255,0,0,(1-dmgtime)*255)
			surface.SetMaterial(dmg_mat)
			surface.DrawTexturedRect(0,0,104,104)
		end
		
		local hp,maxhp = ply:Health(),ply:GetMaxHealth()
		local armor,maxarmor = ply:Armor(),ply:GetMaxArmor()
		
		surface.SetDrawColor(255,255,255)
		FractionCircle(52,52,52,hp_mat,hp/maxhp)
		FractionCircle(52,52,52,armor_mat,armor/maxarmor)
		
		draw.RoundedBox(8,110,56,68,48,background_color)
		draw.RoundedBox(8,180,56,68,48,background_color)
		
		local wep = ply:GetActiveWeapon()
		
		if IsValid(wep) then
			local maxclip = ply:GetNWInt("pd2_hud_clip1",-1)
			local ammo = ply:GetNWInt("pd2_hud_pammo",-1)
			
			if ammo>=0 then
				draw.SimpleText(AddZeros(ammo,3),"pd2_hud_fullammo",122,57,ammo==0 and red or maxclip>0 and ammo<=maxclip and yellow or color_white)
			end
			
			local maxclip = ply:GetNWInt("pd2_hud_clip2",-1)
			local ammo = ply:GetNWInt("pd2_hud_sammo",-1)
			
			if ammo>=0 then
				draw.SimpleText(AddZeros(ammo,3),"pd2_hud_fullammo",190,57,ammo==0 and red or maxclip>0 and ammo<=maxclip and yellow or color_white)
			end
		end
		
		draw.RoundedBox(8,252,62,86,42,background_color)
		draw.RoundedBox(8,340,62,86,42,background_color)
		draw.RoundedBox(8,428,62,86,42,background_color)
		
		draw.SimpleText(hp,"pd2_hud_fullammo",294,82,maxhp>0 and (hp<=0 and red or hp/maxhp<=0.4 and yellow) or color_white,1,1)
		draw.SimpleText(armor,"pd2_hud_fullammo",382,82,maxarmor>0 and (armor<=0 and red or armor/maxarmor<=0.4 and yellow) or color_white,1,1)
	
	TextureDraw_Finish(x,y,w,h)
end

local ScreenSpaceEffects = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0,
}

local fontdata = {
	font = "Payday2",
}

fontdata.size = 30
fontdata.weight = 600
surface.CreateFont("pd2_hud_ammotype",fontdata)

fontdata.size = 40
fontdata.weight = 500
surface.CreateFont("pd2_hud_nickname",fontdata)

fontdata.size = 52
fontdata.weight = 500
surface.CreateFont("pd2_hud_fullammo",fontdata)

fontdata.size = 74
fontdata.weight = 500
surface.CreateFont("pd2_hud_clipammo",fontdata)

local DamageData = {
	LastDamage = 0,
	DamageEffect = 0,
	DamageEffectBrigthness = 0,
	
	DamageDirs = {},
	Hits = {},
}

cvars.AddChangeCallback("pd2_hud_position",function(cvar,old,new)
	offset:SetString(new==0 and "50 50" or new==1 and "-50 50" or new==2 and "50 -50" or "-50 -50")
	team_pos:SetInt(new)
end,"pd2_hud_offset")

cvars.AddChangeCallback("pd2_hud_scale",function(cvar,old,new)
	local pos = team_pos:GetInt()
	if pos==0 or pos==2 then
		team_offset:SetString((50+w*new).." "..(pos==0 and 50 or -50))
	end
	
	team_width:SetInt(ScrW()-50-50-w*new)
end,"pd2_hud_team_offset")

cvars.AddChangeCallback("pd2_hud_team_position",function(cvar,old,new)
	team_offset:SetString(new==0 and (50+w*scale:GetFloat()).." 50" or new==1 and "50 50" or new==2 and (50+w*scale:GetFloat()).." -50" or "50 -50")
end,"pd2_hud_team_offset")

hook.Add("HUDShouldDraw","pd2_hud",function(name)
	if !enable:GetBool() then return end
	
	if nodraw[name] then return false end
end)

hook.Add("OnScreenSizeChanged","pd2_hud",function()
	ReloadHUDTexture()
	team_width:SetInt(ScrW()-50-50-w*scale:GetFloat())
end)

hook.Add("HUDPaint","pd2_hud",function()
	local W,H = ScrW(),ScrH()

	if enable:GetBool() and scale:GetFloat()>0 then
		local ply = LocalPlayer()
		local pos = position:GetInt()
		local offset = offset:GetString()
		local plycolor = plycolor:GetString()
		local scale = scale:GetFloat()
		
		local x = (pos==0 or pos==2) and 0 or W-w*scale
		local y = (pos==0 or pos==1) and 0 or H-h*scale
		
		local offsetdt = string.Explode(" ",offset)
		
		if #offsetdt==2 then
			local addx = tonumber(offsetdt[1])
			local addy = tonumber(offsetdt[2])
			
			if addx and addy then
				x = x+addx
				y = y+addy
			end
		end
		
		local pcolor = plycolors[1]
		local npcolor = tonumber(plycolor)
		
		if npcolor and plycolors[npcolor+1] then
			pcolor = plycolors[npcolor+1]
		else
			local dt = string.Explode(" ",plycolor)
			
			if #dt==3 then
				local r,g,b = tonumber(dt[1]),tonumber(dt[2]),tonumber(dt[3])
				
				if r and g and b then
					pcolor = Color(math.Clamp(r,0,255),math.Clamp(g,0,255),math.Clamp(b,0,255))
				end
			end
		end
	
		TextureDraw_Start()
		
			surface.SetMaterial(circle)
			surface.SetDrawColor(background_color)
			surface.DrawTexturedRect(0,4,36,36)
			
			surface.SetDrawColor(plycolors[1])
			surface.DrawTexturedRect(6,10,24,24)
			
			local nick = " "..ply:Nick().." "
			surface.SetFont("pd2_hud_nickname")
			local tw,th = surface.GetTextSize(nick)
			
			surface.SetDrawColor(background_color)
			surface.DrawRect(40,0,tw,th)
			draw.SimpleText(nick,"pd2_hud_nickname",40,0)
			
			surface.SetDrawColor(255,255,255)
			surface.SetMaterial(bg_mat)
			surface.DrawTexturedRect(2,48,132,132)
			
			local dmgtime = CurTime()-DamageData.LastDamage
			if dmgtime<1 then
				surface.SetDrawColor(255,0,0,(1-dmgtime)*255)
				surface.SetMaterial(dmg_mat)
				surface.DrawTexturedRect(2,48,132,132)
			end
			
			local hp,maxhp = ply:Health(),ply:GetMaxHealth()
			local armor,maxarmor = ply:Armor(),ply:GetMaxArmor()
			
			surface.SetDrawColor(255,255,255)
			FractionCircle(2+66,48+66,66,hp_mat,hp/maxhp)
			FractionCircle(2+66,48+66,66,armor_mat,armor/maxarmor)
			
			draw.RoundedBox(8,144,46,160,64,background_color)
			draw.RoundedBox(8,144,118,160,64,background_color)
			
			draw.RoundedBoxEx(8,280,46,24,64,foreground_color,false,true,false,true)
			draw.RoundedBoxEx(8,280,118,24,64,foreground_color,false,true,false,true)
			
			draw.SimpleText("1","pd2_hud_ammotype",290,44,color_black)
			draw.SimpleText("2","pd2_hud_ammotype",290,116,color_black)
			
			local wep = ply:GetActiveWeapon()
			
			if IsValid(wep) then
				if wep:GetPrimaryAmmoType()!=-1 then
					local clip = wep:Clip1()
					if clip==-1 then clip = 0 end
					
					if clip>=0 then
						draw.SimpleText(AddZeros(clip,3),"pd2_hud_clipammo",148,46,wep:GetMaxClip1()>0 and (clip==0 and red or clip/wep:GetMaxClip1()<0.33 and yellow) or color_white)
					end
					
					local ammo = ply:GetAmmoCount(wep:GetPrimaryAmmoType())+clip
					if ammo>=0 then
						draw.SimpleText(AddZeros(ammo,3),"pd2_hud_fullammo",228,64,ammo==0 and red or wep:GetMaxClip1()>0 and ammo<=wep:GetMaxClip1() and yellow or color_white)
					end
					
					if wep.Primary then
						surface.SetDrawColor(255,255,255)
						surface.SetMaterial(wep.Primary.Automatic and firemode_auto or firemode_single)
						surface.DrawTexturedRect(284,74,16,32)
					end
				end
				
				if wep:GetSecondaryAmmoType()!=-1 then
					local clip = wep:Clip2()
					if clip==-1 then clip = 0 end
					
					if clip>=0 then
						draw.SimpleText(AddZeros(clip,3),"pd2_hud_clipammo",148,118,wep:GetMaxClip2()>0 and (clip==0 and red or clip/wep:GetMaxClip2()<0.33 and yellow) or color_white)
					end
					
					local ammo = ply:GetAmmoCount(wep:GetSecondaryAmmoType())+clip
					if ammo>=0 then
						draw.SimpleText(AddZeros(ammo,3),"pd2_hud_fullammo",228,136,ammo==0 and red or wep:GetMaxClip2()>0 and ammo<=wep:GetMaxClip2() and yellow or color_white)
					end
					
					if wep.Secondary then
						surface.SetDrawColor(255,255,255)
						surface.SetMaterial(wep.Secondary.Automatic and firemode_auto or firemode_single)
						surface.DrawTexturedRect(284,146,16,32)
					end
				end
			end
			
			draw.RoundedBoxEx(8,312,46,96,42,background_color,true,true,false,false)
			draw.RoundedBoxEx(8,312,92,96,44,background_color,true,true,false,false)
			draw.RoundedBoxEx(8,312,140,96,42,background_color,true,true,false,false)
			
			draw.SimpleText(hp,"pd2_hud_fullammo",360,68,maxhp>0 and (hp<=0 and red or hp/maxhp<=0.4 and yellow) or color_white,1,1)
			draw.SimpleText(armor,"pd2_hud_fullammo",360,114,maxarmor>0 and (armor<=0 and red or armor/maxarmor<=0.4 and yellow) or color_white,1,1)
			
		TextureDraw_Finish(x,y,W*scale,H*scale)
		
		local teammates
		
		if allow_team:GetBool() then
			if team_custom:GetBool() then
				teammates = {}
			
				for k,v in ipairs(player.GetAll()) do
					if TeammatesList[v:SteamID()] then
						teammates[#teammates+1] = v
					end
				end
			else
				teammates = pd2_hud_GetTeammates()
			end
		end
		
		if teammates then
			local width = team_width:GetFloat()
			if width<0 then width = W+width end
			
			local pos = team_pos:GetInt()
			local max = team_max:GetInt()
			local offset = team_offset:GetString()
			local scale = team_scale:GetFloat()
			
			if scale>0 then
				local x = 0
				local y = (pos==2 or pos==3) and H-h2*scale or 0
				
				local offsetdt = string.Explode(" ",offset)
				if #offsetdt==2 then
					local addx = tonumber(offsetdt[1])
					local addy = tonumber(offsetdt[2])
					
					if addx and addy then
						x = x+addx
						y = y+addy
					end
				end
				
				local addw = width/math.min(max,#teammates)
				
				local num = 0
				for k,v in ipairs(teammates) do
					if !IsValid(v) or v==ply then continue end
					
					DrawTeammateHUD(v,team_custom:GetBool() and TeammatesList[v:SteamID()] or team.GetColor(v:Team()) or color_white,x+addw*num+((pos==0 or pos==2) and addw-w2*scale or 0),y,W*scale,H*scale)
					
					num = num+1
					if num>=max then break end
				end
			end
		end
	end
	
	local time = CurTime()
	
	for k,v in pairs(DamageData.DamageDirs) do
		local t = time-v.time
		if t>1 then continue end
		
		local radius = (1-t)*300
		v.color.a = (1-t)*255
		local sizemp = 0.5+(1-t)*0.5
		
		surface.SetDrawColor(v.color)
		surface.SetMaterial(dmgdir)
		surface.DrawTexturedRectRotated(W/2+math.sin(v.ang)*radius,H/2-math.cos(v.ang)*radius,dmgdirw*sizemp,dmgdirh*sizemp,-math.deg(v.ang)+90)
	end
	
	for k,v in pairs(DamageData.Hits) do
		local t = time-v.time
		if t>0.5 then continue end
		
		surface.SetDrawColor(255,255,255,255*(1-t/0.5))
		surface.SetMaterial(v.kill and hitkill or hit)
		surface.DrawTexturedRect(W/2-8,H/2-8,16,16)
	end
end)

hook.Add("Think","pd2_hud",function()
	if DamageData.DamageEffect>0 then
		DamageData.DamageEffect = math.max(0,DamageData.DamageEffect-FrameTime()/2)
	end
	
	if DamageData.DamageEffectBrigthness>0 then
		DamageData.DamageEffectBrigthness = math.max(0,DamageData.DamageEffectBrigthness-FrameTime()*4)
	end

	local time = CurTime()
	
	for k,v in pairs(DamageData.DamageDirs) do
		local t = time-v.time
		
		if t>1 then
			DamageData.DamageDirs[k] = nil
		end
	end
	
	for k,v in pairs(DamageData.Hits) do
		local t = time-v.time
		
		if t>0.5 then
			DamageData.Hits[k] = nil
		end
	end
end)

hook.Add("RenderScreenspaceEffects","pd2_hud",function()
	local modify = false

	if DamageData.DamageEffect>0 and LocalPlayer():Armor()<=0 then
		modify = true
	
		ScreenSpaceEffects["$pp_colour_addg"] = -DamageData.DamageEffect
		ScreenSpaceEffects["$pp_colour_addb"] = -DamageData.DamageEffect
	else
		ScreenSpaceEffects["$pp_colour_addg"] = 0
		ScreenSpaceEffects["$pp_colour_addb"] = 0
	end
	
	if DamageData.DamageEffectBrigthness>0 then
		modify = true
	
		ScreenSpaceEffects["$pp_colour_brightness"] = DamageData.DamageEffectBrigthness/4
	else
		ScreenSpaceEffects["$pp_colour_brightness"] = 0
	end
	
	if modify then
		DrawColorModify(ScreenSpaceEffects)
	end
end)

net.Receive("pd2_hud",function(len)
	local ply = LocalPlayer()
	if !IsValid(ply) then return end

	if net.ReadBool() then
		if !hitmarkers:GetBool() or !allow_hitmarker:GetBool() then return end
		
		local kill = net.ReadBool()
		local i = 1 while DamageData.Hits[i] do i = i+1 end
		
		DamageData.Hits[i] = {time = CurTime(),kill = kill}
	else
		if !damageind:GetBool() or !allow_damageind:GetBool() then return end
	
		local pos = net.ReadVector()
		local type = net.ReadUInt(3)
		local damage = net.ReadFloat()
		
		DamageData.LastDamage = CurTime()
		DamageData.DamageEffect = math.min(DamageData.DamageEffect+damage/ply:GetMaxHealth()*4,1)
		DamageData.DamageEffectBrigthness = 1
		
		util.ScreenShake(ply:EyePos(),5,100,0.25,100)
		
		local sound
		
		if type==0 then
			sound = table.Random({"2e26ebe3","19a68f0f","20af031b","292e132f","1164946e"})
		elseif type==1 then
			sound = "3feef399"
		elseif type==2 then
			sound = table.Random({"00ebacb9","2c0eb803","3e4419b1","0457c4e2","1016ba56"})
		end
		
		surface.PlaySound("pd2_hud/"..sound..".mp3")
		
		local i = 1 while DamageData.DamageDirs[i] do i = i+1 end
		
		DamageData.DamageDirs[i] = {
			ang = math.rad(PosToAngleAroundScreen(pos,Angle(90,ply:EyeAngles().y,0))),
			color = type==0 and Color(255,255,255) or type==1 and Color(255,150,150) or type==2 and Color(255,0,0) or type==3 and Color(90,200,255),
			time = CurTime(),
		}
	end
end)

local f = file.Read("pd2_hud_teammates.txt","DATA")
if f then TeammatesList = util.JSONToTable(f) or {} end

concommand.Add("pd2_hud_teammates",function(ply,cmd,args,argstr)
	local frame = vgui.Create("DFrame")
	frame:SetSize(400,300)
	frame:Center()
	frame:MakePopup()
	frame:SetTitle("PAYDAY 2 HUD: Setup teammates")
	frame:SetSizable(true)
	
	local control = vgui.Create("DPanel",frame)
	control:SetTall(25)
	control.Paint = nil
	control:Dock(TOP)
	
	local list = vgui.Create("DListView",frame)
	list:Dock(FILL)
	list:AddColumn("Steam ID",1)
	list:AddColumn("Active player",2)
	list:AddColumn("Circle color",3):SetWidth(10)
	
	local add = vgui.Create("DButton",control)
	add:SetText("Add/Change row")
	add:Dock(LEFT)
	add:SetWide(100)
	
	local color = vgui.Create("DButton",control)
	color:Dock(RIGHT)
	color:SetWide(50)
	color:SetText("Color")
	color.color = Color(255,255,255)
	color.Paint = function(s,w,h)
		derma.SkinHook("Paint","Button",s,w,h)
		
		surface.SetDrawColor(s.color)
		surface.DrawRect(1,1,w-2,h-2)
	end
	color.DoClick = function(s)
		if IsValid(s.mixer) then
			s.mixer:Remove()
		else
			s.mixer = vgui.Create("DPanel")
			s.mixer:SetSize(200,200)
			s.mixer.Think = function(self)
				if !IsValid(s) then self:Remove() return end
				
				local x,y = frame:GetPos()
				self:SetPos(x+frame:GetWide(),y)
			end
			
			s.mixer.mixer = vgui.Create("DColorMixer",s.mixer)
			s.mixer.mixer:Dock(FILL)
			s.mixer.mixer:DockMargin(5,5,5,5)
			s.mixer.mixer:SetColor(s.color)
			s.mixer.mixer:SetAlphaBar(false)
			s.mixer.mixer.ValueChanged = function(self,col)
				s.color.r = col.r
				s.color.g = col.g
				s.color.b = col.b
				
				s:SetTextColor((col.r+col.g+col.b)/3>127 and color_black or color_white)
			end
			
			local colorbtns = s.mixer.mixer.Palette.SetColorButtons
			s.mixer.mixer.Palette.SetColorButtons = function(s,tab)
				tab = table.Copy(tab)
				
				for k,v in ipairs(plycolors) do table.insert(tab,v) end
				
				colorbtns(s,tab)
			end
			s.mixer.mixer.Palette:Reset()
		end
	end
	
	local steamid = vgui.Create("DTextEntry",control)
	steamid:SetPlaceholderText("Player's Steam ID")
	steamid:Dock(FILL)
	steamid:SetWide(150)
	
	add.DoClick = function(s)
		local steam = steamid:GetText():Trim()
		local color = color.color
		
		if #steam==0 or steam==LocalPlayer():SteamID() or TeammatesList[steam]==color then return end
		
		TeammatesList[steam] = color
		file.Write("pd2_hud_teammates.txt",util.TableToJSON(TeammatesList))
		
		list:Update()
	end
	
	list.Update = function(s)
		s:Clear()
		
		for k,v in pairs(TeammatesList) do
			local ply = player.GetBySteamID(k)
		
			s:AddLine(k,ply and "Player: "..ply:Nick() or "*Player is offline*",v.r.." "..v.g.." "..v.b)
		end
	end
	list:Update()
	
	list.OnRowRightClick = function(s,index,row)
		local menu = DermaMenu()
		menu:AddOption("Remove",function()
			if !IsValid(row) then return end
			
			TeammatesList[row:GetColumnText(1)] = nil
			file.Write("pd2_hud_teammates.txt",util.TableToJSON(TeammatesList))
			
			s:Update()
		end)
		
		menu:Open()
	end
	
	list.OnRowSelected = function(s,index,row)
		local steam = row:GetColumnText(1)
		local col = string.Explode(" ",row:GetColumnText(3))
		col = Color(tonumber(col[1]),tonumber(col[2]),tonumber(col[3]))
		
		color.color = col
		color:SetTextColor((col.r+col.g+col.b)/3>127 and color_black or color_white)
		
		if IsValid(color.mixer) then
			color.mixer.mixer:SetColor(col)
		end
		
		steamid:SetText(steam)
	end
	
	
end)

net.Receive("pd2_dmgsys",function(len)
	if pd2_dmgsys_armorres_sound:GetBool() then
		surface.PlaySound("pd2_dmgsys/1d0bc9a4.mp3")
	end
end)