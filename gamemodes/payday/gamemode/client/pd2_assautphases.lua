local clientmusic = CreateConVar("pd2_assaultphases_client_music","black_yellow_moebius",FCVAR_ARCHIVE,"Internal name of music to play.")
local musicvolume = CreateConVar("pd2_assaultphases_client_musicvolume","1",bit.bor(FCVAR_ARCHIVE,FCVAR_NEVER_AS_STRING),"Music volume.",0,3)
local assaultphase = CreateConVar("pd2_assaultphases_client_assaultphase","0",FCVAR_NEVER_AS_STRING,"Current assault phase. 0 - Disabled, 1 - Stealth, 2 - Control/Anticipation, 3 - Assault, 4 - Fade.",0,4)
local controltime = CreateConVar("pd2_assaultphases_client_controlduration","60",bit.bor(FCVAR_ARCHIVE,FCVAR_NEVER_AS_STRING),"Control phase duration. Used to properly play Anticipation music.",0,600)
local asbar_enabled = CreateConVar("pd2_assaultphases_client_assaultbar_enabled","1",bit.bor(FCVAR_ARCHIVE,FCVAR_NEVER_AS_STRING),"Enables assault bar drawing.",0,1)
local asbar_color = CreateConVar("pd2_assaultphases_client_assaultbar_color","255 255 0",FCVAR_ARCHIVE,"Assault bar color. Format 'r g b'. Unknown format will be treated as '255 255 0'")
local asbar_capenabled = CreateConVar("pd2_assaultphases_client_assaultbar_captainenabled","0",bit.bor(FCVAR_ARCHIVE,FCVAR_NEVER_AS_STRING),"Drawing assault bar as if there is a Captain Winters.",0,1)
local asbar_capcolor = CreateConVar("pd2_assaultphases_client_assaultbar_captaincolor","255 155 0",FCVAR_ARCHIVE,"Assault bar color on Captain Winters active. Format is 'r g b'. Unknown format will be treated as '255 155 0'")
local asbar_text = CreateConVar("pd2_assaultphases_client_assaultbar_text","",FCVAR_ARCHIVE,"Custom text for Assault bar. Make empty '' to use default.")
local asbar_pos = CreateConVar("pd2_assaultphases_client_assaultbar_position","1",bit.bor(FCVAR_ARCHIVE,FCVAR_NEVER_AS_STRING),"Position of Assault bar. 0 - left top, 1 - right top, 2 - left bottom, 3 - right bottom.",0,3)
local asbar_offset = CreateConVar("pd2_assaultphases_client_assaultbar_offset","-50 50",FCVAR_ARCHIVE,"Offset of Assault bar position. Format is 'x y'. Unknown format will be treated as '0 0'")
local asbar_scale = CreateConVar("pd2_assaultphases_client_assaultbar_scale","0.5",bit.bor(FCVAR_ARCHIVE,FCVAR_NEVER_AS_STRING),"Scale of Assault bar.",0,10)
local asbar_difficulty = CreateConVar("pd2_assaultphases_client_assaultbar_difficulty","0",bit.bor(FCVAR_ARCHIVE,FCVAR_NEVER_AS_STRING),"Affects on skulls on Assault bar, according to PAYDAY 2 difficulty. 0 - Normal, 1 - Hard, 2 - Very Hard, 3 - Overkill, 4 - Mayhem, 5 - Death Wish, 6 - Death Sentence.",0,6)

cvars.AddChangeCallback("pd2_assaultphases_client_assaultbar_position",function(convar,old,new)
	asbar_offset:SetString(new==0 and "50 50" or new==1 and "-50 50" or new==2 and "50 -50" or "-50 -50")
end,"pd2_assaultphases_client_assaultbar_offset")

local serverphases = CreateConVar("pd2_assaultphases_serverphases","0",FCVAR_REPLICATED,"If enabled, will be used server values on clients.",0,1)
local servermusic = CreateConVar("pd2_assaultphases_server_music","",FCVAR_REPLICATED,"Internal name of music to play.")
local sv_assaultphase = CreateConVar("pd2_assaultphases_server_assaultphase","0",FCVAR_REPLICATED,"Current assault phase. 0 - Disabled, 1 - Stealth, 2 - Control/Anticipation, 3 - Assault, 4 - Fade.",0,4)
local sv_controltime = CreateConVar("pd2_assaultphases_server_controlduration","60",FCVAR_REPLICATED,"Control phase duration. Used to properly play Anticipation music.",0,600)
local sv_asbar_capenabled = CreateConVar("pd2_assaultphases_server_assaultbar_captainenabled","0",FCVAR_REPLICATED,"Drawing assault bar as if there is a Captain Winters.",0,1)
local sv_asbar_text = CreateConVar("pd2_assaultphases_server_assaultbar_text","",FCVAR_REPLICATED,"Custom text for Assault bar. Make empty '' to use default.")
local sv_asbar_difficulty = CreateConVar("pd2_assaultphases_server_assaultbar_difficulty","0",FCVAR_REPLICATED,"Affects on skulls on Assault bar, according to PAYDAY 2 difficulty. 0 - Normal, 1 - Hard, 2 - Very Hard, 3 - Overkill, 4 - Mayhem, 5 - Death Wish, 6 - Death Sentence.",0,6)

local DefaultMusic = {
	["black_yellow_moebius"] = {
		Name = "Black Yellow Moebius",
		Stealth = {"870916783","403998394"},
		Control = {"850873986","119305510"},
		Anticipation = {"431586567"},
		Bridge = {"877185198"},
		Assault = {"1019647351","722087585"},
	},
	["full_force_forward"] = {
		Name = "Full Force Forward",
		Stealth = {"930821661"},
		Control = {"735710869","1069224959"},
		Anticipation = {"182787025"},
		Bridge = {"853366560"},
		Assault = {"863578215","624832084"},
	},
	["fuse_box"] = {
		Name = "Fuse Box",
		Stealth = {"600214202"},
		Control = {"1061405485","455853640"},
		Anticipation = {"797839708"},
		Bridge = {"503330150"},
		Assault = {"259762612","957485235"},
	},
	["the_mark"] = {
		Name = "The Mark",
		Stealth = {"100104254","67833679"},
		Control = {"426123979"},
		Anticipation = {"510089146"},
		Bridge = {"287523719"},
		Assault = {"601758268","519094145"},
	},
	["calling_all_units"] = {
		Name = "Calling All Units",
		Stealth = {"760782286","1008149627"},
		Control = {"532258517","565058515"},
		Anticipation = {"366971253"},
		Bridge = {"235165403"},
		Assault = {"114116796","153814994"},
	},
	["razormind"] = {
		Name = "Razormind",
		Stealth = {"195927453"},
		Control = {"709263041"},
		Anticipation = {"627867607"},
		Bridge = {"703790136"},
		Assault = {"359126176","312174304"},
	},
	["tick_tock"] = {
		Name = "Tick Tock",
		Stealth = {"974297764","786418120"},
		Control = {"832521948","571489706"},
		Anticipation = {"919606028"},
		Bridge = {"1039241270"},
		Assault = {"987164575","489609957"},
	},
	["time_window"] = {
		Name = "Time Window",
		Stealth = {"727867968"},
		Control = {"604756842"},
		Anticipation = {"47223761"},
		Bridge = {},
		Assault = {"688277698"},
	},
	["armed_to_the_teeth"] = {
		Name = "Armed to the Teeth",
		Stealth = {"534277233","785122015"},
		Control = {"666251047","942014836"},
		Anticipation = {"278013309"},
		Bridge = {"791371472"},
		Assault = {"403101328","675026110"},
	},
	["sirens_in_the_distance"] = {
		Name = "Sirens in the Distance",
		Stealth = {"190656619","56332872"},
		Control = {"585735054"},
		Anticipation = {"1055164756"},
		Bridge = {"51507470"},
		Assault = {"65101037","568559572"},
	},
	["wanted_dead_or_alive"] = {
		Name = "Wanted Dead or Alive",
		Stealth = {"717232350"},
		Control = {"540457009"},
		Anticipation = {"700856666"},
		Bridge = {"319151199"},
		Assault = {"3249816","523919664"},
	},
	["death_wish"] = {
		Name = "Death Wish",
		Stealth = {"1007501767"},
		Control = {"410788805","1017760489"},
		Anticipation = {"480271738"},
		Bridge = {"393265006"},
		Assault = {"737550110","567609487"},
	},
	["shadows_and_trickery"] = {
		Name = "Shadows and Trickery",
		Stealth = {"471133328"},
		Control = {"965428519"},
		Anticipation = {"586552360"},
		Bridge = {"989733159"},
		Assault = {"120831995","281413119"},
	},
	["wheres_the_van"] = {
		Name = "Where's the Van",
		Stealth = {"721548582","816665614"},
		Control = {"1072066638"},
		Anticipation = {"906144685"},
		Bridge = {"663913117"},
		Assault = {"630661274","1007136210"},
	},
	["ho_ho_ho"] = {
		Name = "Ho Ho Ho",
		Stealth = {"227124143"},
		Control = {"58947883"},
		Anticipation = {"557570769"},
		Bridge = {"799311735"},
		Assault = {"607196417","696499660"},
	},
	["breach_2015"] = {
		Name = "Breach 2015",
		Stealth = {"121224598"},
		Control = {"424446144"},
		Anticipation = {"949562076"},
		Bridge = {"549027766"},
		Assault = {"543863200"},
	},
	["searchlights"] = {
		Name = "Searchlights",
		Stealth = {"305190042","237755420"},
		Control = {"488771903"},
		Anticipation = {"163955161"},
		Bridge = {},
		Assault = {"631379431","9321154"},
	},
	["backstab"] = {
		Name = "Backstab",
		Stealth = {"628547067"},
		Control = {"583477099","583795348"},
		Anticipation = {"290315446"},
		Bridge = {"881202472"},
		Assault = {"51667919","1060533295"},
	},
	["shoutout"] = {
		Name = "Shoutout",
		Stealth = {"808523595","494445984"},
		Control = {"621377744","378681621"},
		Anticipation = {"678807792"},
		Bridge = {"115697354"},
		Assault = {"645629637","781224549"},
	},
	["dead_mans_hand"] = {
		Name = "Dead Man's Hand",
		Stealth = {"960246745"},
		Control = {"762337607","960714374"},
		Anticipation = {"43617179"},
		Bridge = {"295405054"},
		Assault = {"211738859","700266795"},
	},
	["utter_chaos"] = {
		Name = "Utter Chaos",
		Stealth = {"377411826"},
		Control = {"138174310","715332001"},
		Anticipation = {"1021840307"},
		Bridge = {"338949742"},
		Assault = {"928256954","1025947527"},
	},
	["gun_metal_grey_2015"] = {
		Name = "Gun Metal Grey 2015",
		Stealth = {"606969468"},
		Control = {"245258064","503390936"},
		Anticipation = {"858884871"},
		Bridge = {"295311340"},
		Assault = {"1015117908","1005115695"},
	},
	["donacdum"] = {
		Name = "Donacdum",
		Stealth = {"467820729","320751304"},
		Control = {"237273456","781086700"},
		Anticipation = {"582999691"},
		Bridge = {"58643925"},
		Assault = {"105904611","1065747090"},
	},
	["locke_and_load"] = {
		Name = "Locke And Load",
		Stealth = {"191687889"},
		Control = {"693874897","164336674"},
		Anticipation = {"784180736"},
		Bridge = {"567545344"},
		Assault = {"584284120","776957170"},
	},
	["death_row"] = {
		Name = "Death Row",
		Stealth = {"207835680"},
		Control = {"262657431","330695357"},
		Anticipation = {"745988553"},
		Bridge = {"817884357"},
		Assault = {"985158188","598803774"},
	},
	["iwgyma"] = {
		Name = "I Will Give You My All",
		Stealth = {"1s"},
		Control = {"2c"},
		Anticipation = {"3a"},
		Bridge = {"4b"},
		Assault = {"5a"},
	},
	["pimped_out_getaway"] = {
		Name = "Pimped Out Getaway",
		Stealth = {"stealt"},
		Control = {"contro"},
		Anticipation = {"anitip"},
		Bridge = {"bridg"},
		Assault = {"assaul"},
	},
	["8_bits_are_scary"] = {
		Name = "8 Bits Are Scary",
		Stealth = {"st"},
		Control = {"cont"},
		Anticipation = {"ant"},
		Bridge = {""},
		Assault = {"ass"},
	},
	["code_silver_2018"] = {
		Name = "Code Sliver 2018",
		Stealth = {"st"},
		Control = {"cont"},
		Anticipation = {"ant"},
		Bridge = {""},
		Assault = {"ass"},
	},
	["hot_pursuit"] = {
		Name = "Hot Pursuit",
		Stealth = {"st"},
		Control = {"cont"},
		Anticipation = {"ant"},
		Bridge = {""},
		Assault = {"ass"},
	},
	["ode_to_greed"] = {
		Name = "Ode To Greed",
		Stealth = {"st"},
		Control = {"cont"},
		Anticipation = {"antip"},
		Bridge = {""},
		Assault = {"ass"},
	},
	["the_gauntlet"] = {
		Name = "The Gauntlet",
		Stealth = {"st"},
		Control = {"cont"},
		Anticipation = {"ant"},
		Bridge = {""},
		Assault = {"ass"},
	},
	["left_in_the_cold"] = {
		Name = "Left In The Cold",
		Stealth = {"st"},
		Control = {"cont"},
		Anticipation = {"ant"},
		Bridge = {""},
		Assault = {"ass"},
	},
	["le_castle_vania"] = {
		Name = "Le Castle Vania",
		Stealth = {"st"},
		Control = {"cont"},
		Anticipation = {"ant"},
		Bridge = {""},
		Assault = {"ass"},
	},
	["break_the_rules"] = {
		Name = "Break The Rules",
		Stealth = {"st"},
		Control = {"cont"},
		Anticipation = {"ant"},
		Bridge = {""},
		Assault = {"ass"},
	},
}
local CustomMusic = util.JSONToTable(file.Read("pd2_assaultphases_custommusic.txt","DATA") or "") or {}

local SoundCache = {}
local CurrentMusicData

local function GetMusicConfig(name)
	return DefaultMusic[name] or CustomMusic[name]
end

local function GetActiveMusic()
	return serverphases:GetBool() and servermusic:GetString()!="" and servermusic:GetString() or clientmusic:GetString()
end

local function CacheSound(path,attempt)
	attempt = attempt or 1
	
	sound.PlayFile("sound/pd2_assaultphases/music/"..path..".ogg","noplay noblock",function(snd,errid,err)
		if err then
			MsgC(Color(200,50,0),"pd2_assaultphases: Failed to cache sound "..path..". Attempt "..attempt..", ErrID: "..errid..", Error: "..err..".")
			
			if errid==41 and attempt<5 then
				MsgC(Color(200,200,0)," Trying cache again...\n")
				
				CacheSound(path,attempt+1)
			else
				MsgC("\n")
			end
		
			return
		end
		
		SoundCache[path] = snd
		snd:EnableLooping(true)
	end)
end

local function CacheMusic(name)
	local cfg = GetMusicConfig(name)
	if !cfg then return end
	
	local tocache = {}
	
	for k,v in ipairs(cfg.Stealth) do tocache[name.."/"..v] = true end
	for k,v in ipairs(cfg.Control) do tocache[name.."/"..v] = true end
	for k,v in ipairs(cfg.Anticipation) do tocache[name.."/"..v] = true end
	for k,v in ipairs(cfg.Bridge) do tocache[name.."/"..v] = true end
	for k,v in ipairs(cfg.Assault) do tocache[name.."/"..v] = true end
	
	for k,v in pairs(tocache) do
		CacheSound(k)
	end
end

local function CacheAllMusic()
	for k,v in pairs(DefaultMusic) do CacheMusic(k) end
	for k,v in pairs(CustomMusic) do CacheMusic(k) end
end
CacheAllMusic()

local function StopMusic()
	if CurrentMusicData then
		if CurrentMusicData.sound then
			CurrentMusicData.sound:Pause()
			CurrentMusicData.sound:SetTime(0)
			
			CurrentMusicData = nil
		end
	end
end

local function GetSoundLen(sound)
	return SoundCache[sound] and SoundCache[sound]:GetLength() or 0
end

local function PlayStealthMusic()
	StopMusic()
	
	local curmusic = GetActiveMusic()
	local musiccfg = GetMusicConfig(curmusic)
	if !musiccfg or !musiccfg.Stealth then return end
	
	local start = SysTime()
	
	CurrentMusicData = {
		music = curmusic,
		type = "stealth",
		data = {},
	}
	
	for k,v in ipairs(musiccfg.Stealth) do
		local sound = curmusic.."/"..v
		local len = GetSoundLen(sound)
		
		table.insert(CurrentMusicData.data,{sound = sound,start = start})
		start = start+len
	end
end

local function PlayControlAnticipationMusic()
	StopMusic()
	
	local curmusic = GetActiveMusic()
	local musiccfg = GetMusicConfig(curmusic)
	if !musiccfg or !musiccfg.Control or !musiccfg.Anticipation then return end

	local start = SysTime()//serverphases:GetBool() and SysTime()-(CurTime()-GetGlobalFloat("pd2_assaultphases_controlstart",CurTime())) or SysTime()
	local len = serverphases:GetBool() and sv_controltime:GetFloat() or controltime:GetFloat()
	local End = start+len
	
	CurrentMusicData = {
		music = curmusic,
		type = "control",
		data = {},
	}
	
	for k,v in ipairs(musiccfg.Control) do
		local sound = curmusic.."/"..v
		local len = GetSoundLen(sound)
		
		table.insert(CurrentMusicData.data,{sound = sound,start = start})
		start = start+len
	end
	
	local anticipation_len = 0
	
	for k,v in ipairs(musiccfg.Anticipation) do
		anticipation_len = anticipation_len+GetSoundLen(curmusic.."/"..v)
	end
	
	start = End-anticipation_len
	
	for k,v in ipairs(musiccfg.Anticipation) do
		local sound = curmusic.."/"..v
		local len = GetSoundLen(sound)
		
		table.insert(CurrentMusicData.data,{sound = sound,start = start})
		start = start+len
	end
	
	for k,v in ipairs(musiccfg.Bridge) do
		local sound = curmusic.."/"..v
		local len = GetSoundLen(sound)
		
		table.insert(CurrentMusicData.data,{sound = sound,start = start})
		start = start+len
	end
end

local function PlayAssaultMusic()
	StopMusic()
	
	local curmusic = GetActiveMusic()
	local musiccfg = GetMusicConfig(curmusic)
	if !musiccfg or !musiccfg.Assault then return end
	
	local start = SysTime()
	
	CurrentMusicData = {
		music = curmusic,
		type = "assault",
		data = {},
	}
	
	for k,v in ipairs(musiccfg.Assault) do
		local sound = curmusic.."/"..v
		local len = GetSoundLen(sound)
		
		table.insert(CurrentMusicData.data,{sound = sound,start = start})
		start = start+len
	end
end

local function GetAssaultPhase()
	return serverphases:GetBool() and sv_assaultphase:GetInt() or assaultphase:GetInt()
end

local PhaseCycle
local AssaultBarData = {
	Active = false,
	Fraction = 0,
	
	Texts = {},
	
	Wide = 484,
}

hook.Add("Think","pd2_assaultphases",function()
	if PhaseCycle then
		local time = SysTime()
		local phase = assaultphase:GetInt()
		local newphase = phase
		
		while true do
			if newphase==0 then
				newphase = 1
			elseif newphase==1 and time-PhaseCycle.Time>=PhaseCycle.Stealth then
				newphase = 2
				PhaseCycle.Time = time
				controltime:SetFloat(PhaseCycle.Control)
			elseif newphase==2 and time-PhaseCycle.Time>=PhaseCycle.Control then
				newphase = 3
				PhaseCycle.Time = time
			elseif newphase==3 and time-PhaseCycle.Time>=PhaseCycle.Assault then
				newphase = 4
				PhaseCycle.Time = time
			elseif newphase==4 and time-PhaseCycle.Time>=PhaseCycle.Fade then
				newphase = 1
				PhaseCycle.Time = time
				
				if phase==0 or phase==1 then
					newphase = phase
					PhaseCycle = nil
					assaultphase:SetInt(0)
					
					break
				end
			else
				break
			end
		end
		
		if newphase!=phase then assaultphase:SetInt(newphase) end
	end

	local assaultphase = GetAssaultPhase()
	local music = GetActiveMusic()

	if assaultphase==0 then
		StopMusic()
	else
		local mdata = CurrentMusicData
		local desiredmusictype = assaultphase==1 and "stealth" or assaultphase==2 and "control" or "assault"
	
		if !mdata or mdata.music!=music or mdata.type!=desiredmusictype then
			if desiredmusictype=="stealth" then
				PlayStealthMusic()
			elseif desiredmusictype=="control" then
				PlayControlAnticipationMusic()
			elseif desiredmusictype=="assault" then
				PlayAssaultMusic()
			end
		end
	end

	local mdata = CurrentMusicData
	
	if mdata then
		local desiredsound
		local time = SysTime()
		
		for k,v in ipairs(mdata.data) do
			if time>=v.start then
				desiredsound = v.sound
			end
		end
		
		local newsound = SoundCache[desiredsound]
		
		if desiredsound!=mdata.soundname or newsound!=mdata.sound then
			if mdata.sound then
				mdata.sound:Pause()
				mdata.sound:SetTime(0)
			end
		
			mdata.soundname = desiredsound
			mdata.sound = SoundCache[desiredsound]
		end
		
		if mdata.sound then
			local volume = musicvolume:GetFloat()
			
			if mdata.sound:GetVolume()!=volume then
				mdata.sound:SetVolume(volume)
			end
		
			if mdata.sound:GetState()!=GMOD_CHANNEL_PLAYING then
				mdata.sound:Play()
			end
		end
	end
	
	local asbaractive = asbar_enabled:GetBool() and (assaultphase==3 or assaultphase==4)
	local adata = AssaultBarData
	
	if adata.Active!=asbaractive then
		adata.Active = asbaractive
		adata.Fraction = asbaractive and 0 or 1
		
		if asbaractive then
			adata.Texts = {}
		end
	end
	
	local ft = FrameTime()
	
	if adata.Active and adata.Fraction<1 then
		adata.Fraction = math.min(1,adata.Fraction+ft/2)
	elseif !adata.Active and adata.Fraction>0 then
		adata.Fraction = math.max(0,adata.Fraction-ft)
	end
	
	if adata.Fraction>0 then
		local i = 1
		while true do
			local dt = adata.Texts[i]
			if !dt then break end
			
			dt.pos = dt.pos+ft*adata.Wide/2.5
			
			if dt.pos>=adata.Wide+dt.wide then
				table.remove(adata.Texts,i)
				continue
			end
			
			i = i+1
		end
		
		local last = adata.Texts[#adata.Texts]
		
		if !last or last.pos>last.wide then
			local text = "POLICE ASSAULT IN PROGRESS"
		
			if serverphases:GetBool() and sv_asbar_text:GetString()!="" then
				text = sv_asbar_text:GetString()
			elseif !serverphases:GetBool() and asbar_text:GetString()!="" then
				text = asbar_text:GetString()
			end
			
			local separator = "    "..(Either(serverphases:GetBool(),sv_asbar_capenabled:GetBool(),asbar_capenabled:GetBool()) and "Ñ" or "///").."    "
			
			text = text..separator
			
			local difficulty = serverphases:GetBool() and sv_asbar_difficulty:GetInt() or asbar_difficulty:GetInt()
		
			if 	difficulty>0 then
				if difficulty>=1 then text = text.."Å " end
				if difficulty>=2 then text = text.."Å " end
				if difficulty>=3 then text = text.."Å " end
				if difficulty>=4 then text = text.."Ä " end
				if difficulty>=5 then text = text.."Ç " end
				if difficulty>=6 then text = text.."É " end
			
				text = text:sub(1,-2)..separator
			end
			
			surface.SetFont("pd2_assaultphases_assaultbar")
		
			local tdata = {
				text = text,
				wide = surface.GetTextSize(text),
				pos = !last and 0 or last.pos-last.wide,
			}
			
			table.insert(adata.Texts,tdata)
		end
	end
end)

concommand.Add("pd2_assaultphases_client_cycle",function(ply,cmd,args,argstr)
	if #args==0 then
		PhaseCycle = nil
		assaultphase:SetInt(0)
	
		return
	end

	local stealth = math.max(0,tonumber(args[1]) or 0)
	local control = math.max(0,tonumber(args[2]) or 60)
	local assault = math.max(0,tonumber(args[3]) or 180)
	local fade = math.max(0,tonumber(args[4]) or 20)
	
	PhaseCycle = {
		Time = SysTime(),
		Stealth = stealth,
		Control = control,
		Assault = assault,
		Fade = fade,
	}
	
	assaultphase:SetInt(0)
end,function(cmd,str)
	return {
		cmd.." <stealth time, def 0> <control time, def 60> <assault time, def 180> <fade time, def 20>",
		cmd.." (No arguments to disable cycle)",
	}
end,"Used to create phases cycle. Format: stealth_time control_time assault_time fade_time")

hook.Add("PopulateToolMenu","pd2_assaultphases",function()
	spawnmenu.AddToolMenuOption("Utilities","PAYDAY 2","pd2_assaultphases","Assault Phases Music","","",function(pnl)
		pnl:Help("You can create here your own music and use it with pd2_assaultphases_client_music ConVar.\n\nFiles should be located at `sound/pd2_assaultphases/music/<internal music name>/` and have .ogg extension.")
		
		local box,label = pnl:ComboBox("Select music")
		box.LoadMusics = function(s)
			s:Clear()
			
			for k,v in pairs(DefaultMusic) do
				s:AddChoice(v.Name,k)
			end
			
			for k,v in pairs(CustomMusic) do
				s:AddChoice(v.Name,k)
			end
		end
		
		local internal = pnl:TextEntry("Internal Name")
		pnl:ControlHelp("Internal name of music. Affects on file location and uniqueness.")
		
		local name = pnl:TextEntry("Name")
		pnl:ControlHelp("Nice name of music.")
		
		local stealth = pnl:TextEntry("Stealth sounds")
		stealth:SetMultiline(true)
		stealth:SetTall(50)
		pnl:ControlHelp("Stealth phase sounds for music. One sound name per line.")
		
		local control = pnl:TextEntry("Control sounds")
		control:SetMultiline(true)
		control:SetTall(50)
		pnl:ControlHelp("Control phase sounds for music. One sound name per line.")
		
		local anticipation = pnl:TextEntry("Anticipation sounds")
		anticipation:SetMultiline(true)
		anticipation:SetTall(50)
		pnl:ControlHelp("Anticipation phase sounds for music. One sound name per line.")
		
		local bridge = pnl:TextEntry("Bridge sounds")
		bridge:SetMultiline(true)
		bridge:SetTall(50)
		pnl:ControlHelp("Bridge phase sounds for music. One sound name per line.")
		
		local assault = pnl:TextEntry("Assault sounds")
		assault:SetMultiline(true)
		assault:SetTall(50)
		pnl:ControlHelp("Assault phase sounds for music. One sound name per line.")
		
		local save = pnl:Button("Save music")
		save.DoClick = function(s)
			local int = internal:GetText()
		
			if int=="" or tonumber(int) or DefaultMusic[int] then return end
		
			CustomMusic[int] = {
				Name = name:GetText(),
				Stealth = string.Explode("\n",stealth:GetText()),
				Control = string.Explode("\n",control:GetText()),
				Anticipation = string.Explode("\n",anticipation:GetText()),
				Bridge = string.Explode("\n",bridge:GetText()),
				Assault = string.Explode("\n",assault:GetText()),
			},
			
			file.Write("pd2_assaultphases_custommusic.txt",util.TableToJSON(CustomMusic))
			box:LoadMusics()
			
			CacheMusic(int)
		end
		
		local remove = pnl:Button("Remove music")
		remove.DoClick = function(s)
			if CustomMusic[internal:GetText()] then
				CustomMusic[internal:GetText()] = nil
				
				file.Write("pd2_assaultphases_custommusic.txt",util.TableToJSON(CustomMusic))
				box:LoadMusics()
			end
		end
		
		local template = pnl:Button("New music template")
		template.DoClick = function(s)
			internal:SetEnabled(true)
			name:SetEnabled(true)
			stealth:SetEnabled(true)
			control:SetEnabled(true)
			anticipation:SetEnabled(true)
			bridge:SetEnabled(true)
			assault:SetEnabled(true)
			save:SetEnabled(true)
			remove:SetEnabled(true)
			
			internal:SetText("my_music_name")
			name:SetText("My Music Name")
			stealth:SetText("stealth_sound_1\nstealth_sound_2")
			control:SetText("control_sound_1\ncontrol_sound_2")
			anticipation:SetText("anticipation_sound_1\nanticipation_sound_2")
			bridge:SetText("bridge_sound_1\nbridge_sound_2")
			assault:SetText("assault_sound_1\nassault_sound_2")
		end
		
		box.OnSelect = function(s,index,value,data)
			local dt = DefaultMusic[data] or CustomMusic[data]
			
			if dt then
				internal:SetText(data)
				name:SetText(dt.Name)
				stealth:SetText(table.concat(dt.Stealth,"\n"))
				control:SetText(table.concat(dt.Control,"\n"))
				anticipation:SetText(table.concat(dt.Anticipation,"\n"))
				bridge:SetText(table.concat(dt.Bridge,"\n"))
				assault:SetText(table.concat(dt.Assault,"\n"))
			else
				internal:SetText("")
				name:SetText("")
				stealth:SetText("")
				control:SetText("")
				anticipation:SetText("")
				bridge:SetText("")
				assault:SetText("")
			end
			
			local default = DefaultMusic[data]!=nil
			
			internal:SetEnabled(!default)
			name:SetEnabled(!default)
			stealth:SetEnabled(!default)
			control:SetEnabled(!default)
			anticipation:SetEnabled(!default)
			bridge:SetEnabled(!default)
			assault:SetEnabled(!default)
			save:SetEnabled(!default)
			remove:SetEnabled(!default)
		end
		
		box:LoadMusics()
	end)
	
	spawnmenu.AddToolMenuOption("Utilities","PAYDAY 2","pd2_assaultphases_cvars","Assault Phases Settings","","",function(pnl)
		local function AddConVar(cvar,type)
			pnl:Help(cvar:GetName())
		
			if type=="int" then
				pnl:NumSlider("ConVar value",cvar:GetName(),cvar:GetMin(),cvar:GetMax(),0)
			elseif type=="float" then
				pnl:NumSlider("ConVar value",cvar:GetName(),cvar:GetMin(),cvar:GetMax(),2)
			elseif type=="bool" then
				pnl:CheckBox("ConVar value",cvar:GetName())
			elseif type=="string" then
				pnl:TextEntry("ConVar value",cvar:GetName())
			end
			
			pnl:ControlHelp(cvar:GetHelpText())
			pnl:Help("")
		end
		
		local function AddCommand(cmd,help)
			pnl:Help(cmd)
			
			pnl:TextEntry("Command args").OnEnter = function(s,text)
				LocalPlayer():ConCommand(cmd.." "..text)
			end
			
			pnl:ControlHelp(help)
			pnl:Help("")
		end
		
		AddConVar(clientmusic,"string")
		AddConVar(musicvolume,"float")
		AddConVar(assaultphase,"int")
		AddConVar(controltime,"float")
		AddConVar(asbar_enabled,"bool")
		AddConVar(asbar_color,"string")
		AddConVar(asbar_capenabled,"bool")
		AddConVar(asbar_capcolor,"string")
		AddConVar(asbar_text,"string")
		AddConVar(asbar_pos,"int")
		AddConVar(asbar_offset,"string")
		AddConVar(asbar_scale,"float")
		AddConVar(asbar_difficulty,"int")
		
		AddCommand("pd2_assaultphases_client_cycle","Used to create phases cycle. Format: <stealth_time, default 0> <control_time, default 60> <assault_time, default 180> <fade_time, default 20>. Use without arguments to stop cycle.")
	end)
end)

surface.CreateFont("pd2_assaultphases_assaultbar",{
	font = "Payday2",
	size = 56,
	extended = true,
})

local hud_texture,hud_material

local ReloadHUDTexture = function()
	local w,h = ScrW(),ScrH()
	
	hud_texture = GetRenderTargetEx("pd2_assaultphases_"..w.."x"..h,w,h,RT_SIZE_NO_CHANGE,MATERIAL_RT_DEPTH_SEPARATE,bit.bor(2,256,8192),0,IMAGE_FORMAT_BGRA8888)
	hud_material = CreateMaterial("pd2_assaultphases_"..w.."x"..h,"UnlitGeneric",{["$basetexture"] = hud_texture:GetName(),["$ignorez"] = "1",["$translucent"] = "1"})
end
ReloadHUDTexture()

local w,h = 536+20+76,76
local corner = Material("pd2_assaultphases/assaultbar_corner.png","smooth")
local icon = Material("pd2_assaultphases/info_assault.png","smooth")
local icon2 = Material("pd2_assaultphases/info_padlock.png","smooth")
local shield = Material("pd2_assaultphases/shield.png","smooth")

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

hook.Add("OnScreenSizeChanged","pd2_assaultphases",ReloadHUDTexture)

hook.Add("HUDPaint","pd2_assaultphases",function()
	local data = AssaultBarData
	if data.Fraction==0 or asbar_scale:GetFloat()==0 then return end
	
	local W,H = ScrW(),ScrH()
	
	local pos = asbar_pos:GetInt()
	local offset = asbar_offset:GetString()
	local scale = asbar_scale:GetFloat()
	
	local captain = Either(serverphases:GetBool(),sv_asbar_capenabled:GetBool(),asbar_capenabled:GetBool())
	
	local r,g,b = 255,captain and 155 or 255,0
	
	local colordt = string.Explode(" ",captain and asbar_capcolor:GetString() or asbar_color:GetString())
	if #colordt==3 then
		local _r = tonumber(colordt[1])
		local _g = tonumber(colordt[2])
		local _b = tonumber(colordt[3])
		
		if _r and _g and _b then
			r = math.Clamp(_r,0,255)
			g = math.Clamp(_g,0,255)
			b = math.Clamp(_b,0,255)
		end
	end
	
	local color = Color(r,g,b)
	
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
	
	TextureDraw_Start()
		
		if data.Fraction==1 or SysTime()%0.33<=0.16 then
			surface.SetDrawColor(color)
			surface.SetMaterial(captain and icon2 or icon)
			surface.DrawTexturedRect((pos==0 or pos==2) and 0 or w-44,(pos==0 or pos==1) and 2 or h-44-2,44,44)
		end
		
		local barwidefr = data.Active and (data.Fraction<0.5 and 0 or data.Fraction>0.75 and 1 or (data.Fraction-0.5)*4) or (data.Fraction<0.75 and 0 or (data.Fraction-0.75)*4)
		
		if barwidefr>0 then
			local start = (pos==0 or pos==2) and 44+8 or h+20+(1-barwidefr)*data.Wide
			local endp = (pos==0 or pos==2) and start+barwidefr*data.Wide or h+20+data.Wide
			
			local x = start
			local w = endp-x
			
			local incolorfr = (1+math.sin(SysTime()*1.5%1*math.pi*2))/2
			incolorfr = 0.3+incolorfr*0.7
			
			local H,S,V = ColorToHSV(color)
			V = V*incolorfr
			local incolor = HSVToColor(H,S,V)
			incolor.a = 150
			
			surface.SetDrawColor(incolor)
			surface.DrawRect(x,0,w,h)
			
			surface.SetDrawColor(color)
			surface.SetMaterial(corner)
			
			surface.DrawTexturedRectRotated(start+16/2,h-16/2,16,16,0)
			surface.DrawTexturedRectRotated(start+16/2,0+16/2,16,16,-90)
			surface.DrawTexturedRectRotated(endp-16/2,0+16/2,16,16,180)
			surface.DrawTexturedRectRotated(endp-16/2,h-16/2,16,16,90)
			
			render.SetStencilEnable(true)
				render.SetStencilWriteMask(255)
				render.SetStencilTestMask(255)
			
				render.ClearStencilBufferRectangle(start,0,endp,h,1)
			
				render.SetStencilReferenceValue(1)
				render.SetStencilCompareFunction(STENCIL_EQUAL)
				render.SetStencilPassOperation(STENCIL_KEEP)
				render.SetStencilFailOperation(STENCIL_KEEP)
				render.SetStencilZFailOperation(STENCIL_KEEP)
				
				for k,v in ipairs(data.Texts) do
					draw.SimpleText(v.text,"pd2_assaultphases_assaultbar",endp-v.pos,h/2,color,0,1)
				end
			
			render.SetStencilEnable(false)
			
			if captain then
				local start = (pos==0 or pos==2) and endp+16 or start-16-h
				local endp = start+h
				
				local x = start
				local w = h
				
				local incolor = HSVToColor(208,0.75,0.78*incolorfr)
				incolor.a = 150
				
				surface.SetDrawColor(incolor)
				surface.DrawRect(x,0,w,h)
				
				surface.SetDrawColor(255,255,255)
				surface.SetMaterial(corner)
				
				surface.DrawTexturedRectRotated(start+16/2,h-16/2,16,16,0)
				surface.DrawTexturedRectRotated(start+16/2,0+16/2,16,16,-90)
				surface.DrawTexturedRectRotated(endp-16/2,0+16/2,16,16,180)
				surface.DrawTexturedRectRotated(endp-16/2,h-16/2,16,16,90)
				
				surface.SetDrawColor(255,255,255)
				surface.SetMaterial(shield)
				surface.DrawTexturedRect(x,0,w,h)
			end
		end
	TextureDraw_Finish(x,y,W*scale,H*scale)
end)