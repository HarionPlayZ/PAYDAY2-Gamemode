AddCSLuaFile()

ENT.Base = "sb_advanced_nextbot_base"
DEFINE_BASECLASS(ENT.Base)

ENT.PrintName = "SB ANB PAYDAY 2"

ENT.TeamConvar = CreateConVar("sb_anb_payday2_team","police",FCVAR_USERINFO,"Name (or number) of team of next created bot. Used to make bots shot each other.")
ENT.SideConvar = CreateConVar("sb_anb_payday2_side",0,FCVAR_USERINFO,"Side of next created bot. 0 - Rebels, 1 - Combine, 2 - Ignore all.",0,2)
ENT.PSideConvar = CreateConVar("sb_anb_payday2_pside",0,FCVAR_USERINFO,"Player side of next created bot. 0 - Against players, 1 - For players, 2 - Neutral.",0,2)
ENT.HPDifficultyConvar = CreateConVar("sb_anb_payday2_hp_difficulty",0,FCVAR_USERINFO,"Multiplies health according to difficulty in PAYDAY 2. 0 - Normal/Hard, 1 - Very Hard, 2 - Overkill, 3 - Mayhem, 4 - Death Wish/Death Sentence",0,4)
ENT.VariantConvar = CreateConVar("sb_anb_payday2_variant",0,FCVAR_USERINFO,"Variant of class of next created bot. 0 - random.",0)
ENT.ProfConvar = CreateConVar("sb_anb_payday2_proficiency",0,FCVAR_USERINFO,"Sets weapon proficiency for next created bot. 0 - default (when changed in other ways), 1 - poor, 2 - average, 3 - good, 4 - very good, 5 - perfect",0,5)
ENT.LeaderConvar = CLIENT and CreateConVar("sb_anb_payday2_leader",0,FCVAR_USERINFO,"Should next created bot follow you as a leader?",0,1)
ENT.PoliceChaseConvar = CLIENT and CreateConVar("sb_anb_payday2_policechase",0,FCVAR_USERINFO,"If POLICE bot cannot find the enemy within a certain time, it will chase owner.",0,1)
ENT.HelmetsConvar = SERVER and CreateConVar("sb_anb_payday2_helmets",1,FCVAR_ARCHIVE,"Should helmets fly off on headshot kills and explosions?",0,1)
ENT.ShieldsConvar = SERVER and CreateConVar("sb_anb_payday2_shields",1,FCVAR_ARCHIVE,"Should keep shields after bot has been killed?",0,1)
ENT.NodeGraphConvar = SERVER and CreateConVar("sb_anb_payday2_nodegraph",0,FCVAR_ARCHIVE,"Should bots use nodegraph or navmesh when finding path?",0,1)
ENT.VoiceConvar = SERVER and CreateConVar("sb_anb_payday2_voice",1,FCVAR_ARCHIVE,"Should bots play voice lines?",0,1)
ENT.WeaponsConvar = SERVER and CreateConVar("sb_anb_payday2_weapons",1,FCVAR_ARCHIVE,"Should bots drop weapon on die? 0 - Don't drop, 1 - Drop and delete dropped weapon after 10 seconds, 2 - Drop and don't delete.",0,2)

ENT.BotClasses = {
	["SWAT"] = {
		Name = "SWAT",
		Icon = "sb_anb_payday2/swat.png",
		Type = "Police",
	
		Addons = {"794609277","1769443410"},
	
		Variants = {
			[1] = {
				Model = Model("models/payday2/units/blue_swat_player_pd2anim.mdl"),
				Skin = 0,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_mp5",
				
				HelmetBreak = {1,2,Model("models/payday2/helmets/blue_swat.mdl")},
			},
			[2] = {
				Model = Model("models/payday2/units/blue_swat_player_pd2anim.mdl"),
				Skin = 0,
				Bodygroups = {1,1},
				
				Weapon = "sb_anb_payday2_r870",
				
				HelmetBreak = {1,2,Model("models/payday2/helmets/blue_swat.mdl"),1},
			},
		},
		
		Health = 80,
		HeadshotMultiplier = 2,
		
		RunSpeed = 300,
		WalkSpeed = 200,
		SlowWalkSpeed = 100,
		AimSpeed = 180,
		
		CanCrouch = true,
		CanJump = true,
		CanDoMeleeAttack = true,
		ShouldDoHeavyDamage = true,
		
		Voices = {death = "default"},
	},
	["Gangster"] = {
		Name = "Gangster",
		Icon = "",
		Type = "Gang",
	
		Addons = {},
	
		Variants = {
			[1] = {
				Model = Model("models/player/phoenix.mdl"),
				Skin = 0,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_ump",
			},
			[2] = {
				Model = Model("models/player/leet.mdl"),
				Skin = 0,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_benelli",
			},
			[3] = {
				Model = Model("models/player/guerilla.mdl"),
				Skin = 0,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_saiga",
			},
			[4] = {
				Model = Model("models/player/arctic.mdl"),
				Skin = 0,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_m4",
			},
		},
		
		Health = 35,
		HeadshotMultiplier = 2,
		
		RunSpeed = 200,
		WalkSpeed = 150,
		SlowWalkSpeed = 75,
		AimSpeed = 200,
		
		CanCrouch = true,
		CanJump = true,
		CanDoMeleeAttack = true,
		ShouldDoHeavyDamage = true,
		
		Voices = {death = ""},
	},
	["HeavySWAT"] = {
		Name = "Heavy SWAT",
		Icon = "sb_anb_payday2/heavyswat.png",
		Type = "Police",
		
		Addons = {"795977590","1769443410"},
	
		Variants = {
			[1] = {
				Model = Model("models/payday2/units/heavy_swat_player_pd2anim.mdl"),
				Skin = 0,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_m4",
				
				HelmetBreak = {1,1,Model("models/payday2/helmets/heavy_swat.mdl")},
			},
			[2] = {
				Model = Model("models/payday2/units/heavy_swat_player_pd2anim.mdl"),
				Skin = 0,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_r870",
				
				HelmetBreak = {1,1,Model("models/payday2/helmets/heavy_swat.mdl")},
			},
		},
		
		Health = 160,
		HeadshotMultiplier = 2,
		
		RunSpeed = 300,
		WalkSpeed = 200,
		SlowWalkSpeed = 100,
		AimSpeed = 180,
		
		CanCrouch = true,
		CanJump = true,
		CanDoMeleeAttack = true,
		ShouldDoHeavyDamage = true,
		
		Voices = {death = "default"},
	},
	["SWATShield"] = {
		Name = "SWAT Shield",
		Icon = "sb_anb_payday2/swatshield.png",
		Type = "Police",
		
		Addons = {"795977590","1769443410"},
	
		Variants = {
			[1] = {
				Model = Model("models/payday2/units/heavy_swat_player_pd2anim_shield.mdl"),
				Skin = 0,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_c45",
				
				HelmetBreak = {1,1,Model("models/payday2/helmets/heavy_swat.mdl")},
			},
		},
		
		Health = 80,
		HeadshotMultiplier = 2,
		
		RunSpeed = 200,
		WalkSpeed = 150,
		SlowWalkSpeed = 100,
		AimSpeed = 180,
		
		CanCrouch = false,
		CanJump = false,
		CanDoMeleeAttack = false,
		ShouldDoHeavyDamage = false,
		
		Shield = "SWAT",
		Tasks = {"shield"},
		
		Voices = {death = "default",onsee = "shield"},
	},
	["Sniper"] = {
		Name = "Sniper",
		Icon = "sb_anb_payday2/sniper.png",
		Type = "Police",
		
		Addons = {"799804574","1769443410"},
	
		Variants = {
			[1] = {
				Model = Model("models/payday2/units/sniper_swat_player_pd2anim.mdl"),
				Skin = 0,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_sniper",
			},
		},
		
		Health = 40,
		HeadshotMultiplier = 2,
		
		RunSpeed = 0,
		WalkSpeed = 0,
		SlowWalkSpeed = 0,
		AimSpeed = 180,
		
		CanCrouch = true,
		CanJump = true,
		CanDoMeleeAttack = true,
		ShouldDoHeavyDamage = true,
		
		Voices = {death = "default"},
	},
	["FBI"] = {
		Name = "SWAT FBI",
		Icon = "sb_anb_payday2/fbi.png",
		Type = "Police",
		
		Addons = {"800483635","1769443410"},
	
		Variants = {
			[1] = {
				Model = Model("models/payday2/units/swat_fbi_player_pd2anim.mdl"),
				Skin = 0,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_m4",
				
				HelmetBreak = {1,3,Model("models/payday2/helmets/swat_fbi.mdl")},
			},
			[2] = {
				Model = Model("models/payday2/units/swat_fbi_player_pd2anim.mdl"),
				Skin = 0,
				Bodygroups = {2,2},
				
				Weapon = "sb_anb_payday2_r870",
				
				HelmetBreak = {1,3,Model("models/payday2/helmets/swat_fbi.mdl"),3},
			},
		},
		
		Health = 80,
		HeadshotMultiplier = 2,
		
		RunSpeed = 300,
		WalkSpeed = 200,
		SlowWalkSpeed = 100,
		AimSpeed = 180,
		
		CanCrouch = true,
		CanJump = true,
		CanDoMeleeAttack = true,
		ShouldDoHeavyDamage = true,
		
		Voices = {death = "default"},
	},
	["ArmorFBI"] = {
		Name = "Armored SWAT FBI",
		Icon = "sb_anb_payday2/armorfbi.png",
		Type = "Police",
		
		Addons = {"800483635","1769443410"},
	
		Variants = {
			[1] = {
				Model = Model("models/payday2/units/swat_fbi_player_pd2anim.mdl"),
				Skin = 2,
				Bodygroups = {4,0,2},
				
				Weapon = "sb_anb_payday2_m4",
				
				HelmetBreak = {1,3,Model("models/payday2/helmets/swat_fbi.mdl"),1},
			},
			[2] = {
				Model = Model("models/payday2/units/swat_fbi_player_pd2anim.mdl"),
				Skin = 2,
				Bodygroups = {5,2,4},
				
				Weapon = "sb_anb_payday2_r870",
				
				HelmetBreak = {1,3,Model("models/payday2/helmets/swat_fbi.mdl"),4},
			},
		},
		
		Health = 80,
		HeadshotMultiplier = 2,
		
		RunSpeed = 300,
		WalkSpeed = 200,
		SlowWalkSpeed = 100,
		AimSpeed = 180,
		
		CanCrouch = true,
		CanJump = true,
		CanDoMeleeAttack = true,
		ShouldDoHeavyDamage = true,
		
		Voices = {death = "default"},
	},
	["HeavyFBI"] = {
		Name = "Heavy SWAT FBI",
		Icon = "sb_anb_payday2/heavyfbi.png",
		Type = "Police",
		
		Addons = {"807385155","1769443410"},
	
		Variants = {
			[1] = {
				Model = Model("models/payday2/units/heavy_fbi_player_pd2anim.mdl"),
				Skin = 0,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_m4",
				
				HelmetBreak = {2,1,Model("models/payday2/helmets/heavy_fbi.mdl")},
			},
			[2] = {
				Model = Model("models/payday2/units/heavy_fbi_player_pd2anim.mdl"),
				Skin = 0,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_r870",
				
				HelmetBreak = {2,1,Model("models/payday2/helmets/heavy_fbi.mdl")},
			},
		},
		
		Health = 160,
		HeadshotMultiplier = 2,
		
		RunSpeed = 300,
		WalkSpeed = 200,
		SlowWalkSpeed = 100,
		AimSpeed = 180,
		
		CanCrouch = true,
		CanJump = true,
		CanDoMeleeAttack = true,
		ShouldDoHeavyDamage = true,
		
		Tasks = {"heavyarmor"},
		
		Voices = {death = "default"},
	},
	["FBIShield"] = {
		Name = "SWAT FBI Shield",
		Icon = "sb_anb_payday2/fbishield.png",
		Type = "Police",
		
		Addons = {"800483635","1769443410"},
	
		Variants = {
			[1] = {
				Model = Model("models/payday2/units/swat_fbi_player_pd2anim_shield.mdl"),
				Skin = 0,
				Bodygroups = {1,1},
				
				Weapon = "sb_anb_payday2_mp9",
				
				HelmetBreak = {1,3,Model("models/payday2/helmets/swat_fbi.mdl"),2},
			},
		},
		
		Health = 80,
		HeadshotMultiplier = 2,
		
		RunSpeed = 200,
		WalkSpeed = 150,
		SlowWalkSpeed = 100,
		AimSpeed = 120,
		
		CanCrouch = false,
		CanJump = false,
		CanDoMeleeAttack = false,
		ShouldDoHeavyDamage = false,
		
		Shield = "FBI",
		Tasks = {"shield"},
		
		Voices = {death = "default",onsee = "shield"},
	},
	["ArmorFBIShield"] = {
		Name = "Armored SWAT FBI Shield",
		Icon = "sb_anb_payday2/armorfbishield.png",
		Type = "Police",
		
		Addons = {"800483635","1769443410"},
		
		Variants = {
			[1] = {
				Model = Model("models/payday2/units/swat_fbi_player_pd2anim_shield.mdl"),
				Skin = 2,
				Bodygroups = {1,1,3},
				
				Weapon = "sb_anb_payday2_mp9",
				
				HelmetBreak = {1,3,Model("models/payday2/helmets/swat_fbi.mdl"),2},
			},
		},
		
		Health = 80,
		HeadshotMultiplier = 2,
		
		RunSpeed = 200,
		WalkSpeed = 150,
		SlowWalkSpeed = 100,
		AimSpeed = 120,
		
		CanCrouch = false,
		CanJump = false,
		CanDoMeleeAttack = false,
		ShouldDoHeavyDamage = false,
		
		Shield = "FBI",
		Tasks = {"shield"},
		
		Voices = {death = "default",onsee = "shield"},
	},
	["Taser"] = {
		Name = "Taser",
		Icon = "sb_anb_payday2/taser.png",
		Type = "Police",
		
		Addons = {"911552729","1769443410"},
		
		Variants = {
			[1] = {
				Model = Model("models/payday2/units/taser_player_pd2anim.mdl"),
				Skin = 0,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_m4_taser",
				
				HelmetBreak = {1,1,Model("models/payday2/helmets/taser.mdl")},
			},
			[2] = {
				Model = Model("models/payday2/units/taser_player_pd2anim.mdl"),
				Skin = 0,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_r870_taser",
				
				HelmetBreak = {1,1,Model("models/payday2/helmets/taser.mdl")},
			},
		},
		
		Health = 300,
		HeadshotMultiplier = 2,
		
		RunSpeed = 300,
		WalkSpeed = 200,
		SlowWalkSpeed = 100,
		AimSpeed = 180,
		
		CanCrouch = true,
		CanJump = true,
		CanDoMeleeAttack = true,
		ShouldDoHeavyDamage = true,
		
		Tasks = {"taser"},
		
		Voices = {death = "taser",onsee = "taser"},
	},
	["Medic"] = {
		Name = "Medic",
		Icon = "sb_anb_payday2/medic.png",
		Type = "Police",
		
		Addons = {"892493593","1769443410"},
	
		Variants = {
			[1] = {
				Model = Model("models/payday2/units/medic_player_pd2anim.mdl"),
				Skin = 0,
				Bodygroups = {0,1},
				
				Weapon = "sb_anb_payday2_m4",
				
				HelmetBreak = {1,1,Model("models/payday2/helmets/medic.mdl")},
			},
			[2] = {
				Model = Model("models/payday2/units/medic_player_pd2anim.mdl"),
				Skin = 0,
				Bodygroups = {0,1},
				
				Weapon = "sb_anb_payday2_r870",
				
				HelmetBreak = {1,1,Model("models/payday2/helmets/medic.mdl")},
			},
		},
		
		Health = 300,
		HeadshotMultiplier = 2,
		
		RunSpeed = 300,
		WalkSpeed = 200,
		SlowWalkSpeed = 100,
		AimSpeed = 180,
		
		CanCrouch = true,
		CanJump = true,
		CanDoMeleeAttack = true,
		ShouldDoHeavyDamage = true,
		
		Tasks = {"medic"},
		
		Voices = {death = "medic",onsee = "medic",medic = true},
	},
	["Gensec"] = {
		Name = "Elite Gensec",
		Icon = "sb_anb_payday2/gensec.png",
		Type = "Police",
		
		Addons = {"800483635","1769443410"},
	
		Variants = {
			[1] = {
				Model = Model("models/payday2/units/swat_fbi_player_pd2anim.mdl"),
				Skin = 1,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_g36",
				
				HelmetBreak = {1,3,Model("models/payday2/helmets/swat_fbi.mdl")},
			},
			[2] = {
				Model = Model("models/payday2/units/swat_fbi_player_pd2anim.mdl"),
				Skin = 1,
				Bodygroups = {2,2},
				
				Weapon = "sb_anb_payday2_r870",
				
				HelmetBreak = {1,3,Model("models/payday2/helmets/swat_fbi.mdl"),3},
			},
			[3] = {
				Model = Model("models/payday2/units/swat_fbi_player_pd2anim.mdl"),
				Skin = 1,
				Bodygroups = {2,2},
				
				Weapon = "sb_anb_payday2_benelli",
				
				HelmetBreak = {1,3,Model("models/payday2/helmets/swat_fbi.mdl"),3},
			},
			[4] = {
				Model = Model("models/payday2/units/swat_fbi_player_pd2anim.mdl"),
				Skin = 1,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_ump",
				
				HelmetBreak = {1,3,Model("models/payday2/helmets/swat_fbi.mdl")},
			},
		},
		
		Health = 80,
		HeadshotMultiplier = 2,
		
		RunSpeed = 300,
		WalkSpeed = 200,
		SlowWalkSpeed = 100,
		AimSpeed = 180,
		
		CanCrouch = true,
		CanJump = true,
		CanDoMeleeAttack = true,
		ShouldDoHeavyDamage = false,
		
		Voices = {death = "default"},
	},
	["ArmorGensec"] = {
		Name = "Armored Elite Gensec",
		Icon = "sb_anb_payday2/armorgensec.png",
		Type = "Police",
		
		Addons = {"800483635","1769443410"},
	
		Variants = {
			[1] = {
				Model = Model("models/payday2/units/swat_fbi_player_pd2anim.mdl"),
				Skin = 3,
				Bodygroups = {4,0,2},
				
				Weapon = "sb_anb_payday2_g36",
				
				HelmetBreak = {1,3,Model("models/payday2/helmets/swat_fbi.mdl"),1},
			},
			[2] = {
				Model = Model("models/payday2/units/swat_fbi_player_pd2anim.mdl"),
				Skin = 3,
				Bodygroups = {5,2,4},
				
				Weapon = "sb_anb_payday2_r870",
				
				HelmetBreak = {1,3,Model("models/payday2/helmets/swat_fbi.mdl"),4},
			},
			[3] = {
				Model = Model("models/payday2/units/swat_fbi_player_pd2anim.mdl"),
				Skin = 3,
				Bodygroups = {5,2,4},
				
				Weapon = "sb_anb_payday2_benelli",
				
				HelmetBreak = {1,3,Model("models/payday2/helmets/swat_fbi.mdl"),4},
			},
			[4] = {
				Model = Model("models/payday2/units/swat_fbi_player_pd2anim.mdl"),
				Skin = 3,
				Bodygroups = {4,0,2},
				
				Weapon = "sb_anb_payday2_ump",
				
				HelmetBreak = {1,3,Model("models/payday2/helmets/swat_fbi.mdl"),1},
			},
		},
		
		Health = 80,
		HeadshotMultiplier = 2,
		
		RunSpeed = 300,
		WalkSpeed = 200,
		SlowWalkSpeed = 100,
		AimSpeed = 180,
		
		CanCrouch = true,
		CanJump = true,
		CanDoMeleeAttack = true,
		ShouldDoHeavyDamage = false,
		
		Voices = {death = "default"},
	},
	["HeavyGensec"] = {
		Name = "Heavy Elite Gensec",
		Icon = "sb_anb_payday2/heavygensec.png",
		Type = "Police",
		
		Addons = {"807385155","1769443410"},
	
		Variants = {
			[1] = {
				Model = Model("models/payday2/units/heavy_fbi_player_pd2anim.mdl"),
				Skin = 1,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_g36",
				
				HelmetBreak = {2,1,Model("models/payday2/helmets/heavy_fbi.mdl")},
			},
			[2] = {
				Model = Model("models/payday2/units/heavy_fbi_player_pd2anim.mdl"),
				Skin = 1,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_r870",
				
				HelmetBreak = {2,1,Model("models/payday2/helmets/heavy_fbi.mdl")},
			},
		},
		
		Health = 160,
		HeadshotMultiplier = 2,
		
		RunSpeed = 300,
		WalkSpeed = 200,
		SlowWalkSpeed = 100,
		AimSpeed = 180,
		
		CanCrouch = true,
		CanJump = true,
		CanDoMeleeAttack = true,
		ShouldDoHeavyDamage = false,
		
		Tasks = {"heavyarmor"},
		
		Voices = {death = "default"},
	},
	["GensecShield"] = {
		Name = "Elite Gensec Shield",
		Icon = "sb_anb_payday2/gensecshield.png",
		Type = "Police",
		
		Addons = {"800483635","1769443410"},
	
		Variants = {
			[1] = {
				Model = Model("models/payday2/units/swat_fbi_player_pd2anim_shield.mdl"),
				Skin = 1,
				Bodygroups = {1,1},
				
				Weapon = "sb_anb_payday2_mp9",
				
				HelmetBreak = {1,3,Model("models/payday2/helmets/swat_fbi.mdl"),2},
			},
		},
		
		Health = 80,
		HeadshotMultiplier = 2,
		
		RunSpeed = 200,
		WalkSpeed = 150,
		SlowWalkSpeed = 100,
		AimSpeed = 120,
		
		CanCrouch = false,
		CanJump = false,
		CanDoMeleeAttack = false,
		ShouldDoHeavyDamage = false,
		
		Shield = "FBI",
		Tasks = {"shield"},
		
		Voices = {death = "default",onsee = "shield"},
	},
	["ArmorGensecShield"] = {
		Name = "Armored Elite Gensec Shield",
		Icon = "sb_anb_payday2/armorgensecshield.png",
		Type = "Police",
		
		Addons = {"800483635","1769443410"},
	
		Variants = {
			[1] = {
				Model = Model("models/payday2/units/swat_fbi_player_pd2anim_shield.mdl"),
				Skin = 3,
				Bodygroups = {1,1,3},
				
				Weapon = "sb_anb_payday2_mp9",
				
				HelmetBreak = {1,3,Model("models/payday2/helmets/swat_fbi.mdl"),2},
			},
		},
		
		Health = 80,
		HeadshotMultiplier = 2,
		
		RunSpeed = 200,
		WalkSpeed = 150,
		SlowWalkSpeed = 100,
		AimSpeed = 120,
		
		CanCrouch = false,
		CanJump = false,
		CanDoMeleeAttack = false,
		ShouldDoHeavyDamage = false,
		
		Shield = "FBI",
		Tasks = {"shield"},
		
		Voices = {death = "default",onsee = "shield"},
	},
	["Zeal"] = {
		Name = "Zeal SWAT",
		Icon = "sb_anb_payday2/zeal.png",
		Type = "Police",
		
		Addons = {"1437234196","1769443410"},
	
		Variants = {
			[1] = {
				Model = Model("models/payday2/units/zeal_swat_player_pd2anim.mdl"),
				Skin = 0,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_mp5",
				
				HelmetBreak = {1,1,Model("models/payday2/helmets/zeal.mdl")},
			},
			[2] = {
				Model = Model("models/payday2/units/zeal_swat_player_pd2anim.mdl"),
				Skin = 0,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_r870",
				
				HelmetBreak = {1,1,Model("models/payday2/helmets/zeal.mdl")},
			},
		},
		
		Health = 80,
		HeadshotMultiplier = 2,
		
		RunSpeed = 300,
		WalkSpeed = 200,
		SlowWalkSpeed = 100,
		AimSpeed = 180,
		
		CanCrouch = true,
		CanJump = true,
		CanDoMeleeAttack = true,
		ShouldDoHeavyDamage = false,
		
		Voices = {death = "default"},
	},
	["HeavyZeal"] = {
		Name = "Zeal Heavy SWAT",
		Icon = "sb_anb_payday2/heavyzeal.png",
		Type = "Police",
		
		Addons = {"1437234196","1769443410"},
	
		Variants = {
			[1] = {
				Model = Model("models/payday2/units/zeal_heavy_swat_player_pd2anim.mdl"),
				Skin = 0,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_m4",
				
				HelmetBreak = {1,1,Model("models/payday2/helmets/zeal_heavy.mdl")},
			},
		},
		
		Health = 160,
		HeadshotMultiplier = 2,
		
		RunSpeed = 300,
		WalkSpeed = 200,
		SlowWalkSpeed = 100,
		AimSpeed = 180,
		
		CanCrouch = true,
		CanJump = true,
		CanDoMeleeAttack = true,
		ShouldDoHeavyDamage = false,
		
		Tasks = {"heavyarmor"},
		
		Voices = {death = "default"},
	},
	["ZealTaser"] = {
		Name = "Zeal Taser",
		Icon = "sb_anb_payday2/zealtaser.png",
		Type = "Police",
		
		Addons = {"1437623864","1769443410"},
	
		Variants = {Weapon = "",
			[1] = {
				Model = Model("models/payday2/units/zeal_taser_player_pd2anim.mdl"),
				Skin = 0,
				Bodygroups = {},
				Icon = "payday2/help/zealtaser.png",
				
				Weapon = "sb_anb_payday2_m4_taser",
				
				
				HelmetBreak = {1,1,Model("models/payday2/helmets/zeal_taser.mdl")},
			},
			[2] = {
				Model = Model("models/payday2/units/zeal_taser_player_pd2anim.mdl"),
				Skin = 0,
				Bodygroups = {},
				Icon = "payday2/help/zealtaser.png",
				
				Weapon = "sb_anb_payday2_r870_taser",
				
				
				HelmetBreak = {1,1,Model("models/payday2/helmets/zeal_taser.mdl")},
			},
		},
		
		Health = 300,
		HeadshotMultiplier = 2,
		
		RunSpeed = 300,
		WalkSpeed = 200,
		SlowWalkSpeed = 100,
		AimSpeed = 180,
		
		CanCrouch = true,
		CanJump = true,
		CanDoMeleeAttack = true,
		ShouldDoHeavyDamage = false,
		
		Tasks = {"taser"},
		
		Voices = {death = "taser",onsee = "taser"},
	},
	["Winters"] = {
		Name = "Captain Winters",
		Icon = "sb_anb_payday2/winters.png",
		Type = "Police",
		
		Addons = {"1339739140","1769443410"},
	
		Variants = {
			[1] = {
				Model = Model("models/payday2/units/captain_player_pd2anim_shield.mdl"),
				Skin = 0,
				Bodygroups = {},
				Icon = "payday2/help/winters.png",
				
				Weapon = "sb_anb_payday2_mp9",
			},
		},
		
		Health = 2000,
		HeadshotMultiplier = 5,
		
		RunSpeed = 200,
		WalkSpeed = 150,
		SlowWalkSpeed = 100,
		AimSpeed = 90,
		
		CanCrouch = false,
		CanJump = false,
		CanDoMeleeAttack = false,
		ShouldDoHeavyDamage = false,
		
		Shield = "Winters",
		Tasks = {"shield"},
		
		Voices = {death = "default"},
	},
	["WintersPhalanx"] = {
		Name = "Captain Winters Phalanx",
		Icon = "sb_anb_payday2/wintersphalanx.png",
		Type = "Police",
		
		Addons = {"1339739140","1769443410"},
	
		Variants = {
			[1] = {
				Model = Model("models/payday2/units/captain_guard_player_pd2anim_shield.mdl"),
				Skin = 0,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_mp9",
				
				HelmetBreak = {1,1,Model("models/payday2/helmets/captain_guard.mdl")},
			},
		},
		
		Health = 1000,
		HeadshotMultiplier = 5,
		
		RunSpeed = 200,
		WalkSpeed = 150,
		SlowWalkSpeed = 100,
		AimSpeed = 90,
		
		CanCrouch = false,
		CanJump = false,
		CanDoMeleeAttack = false,
		ShouldDoHeavyDamage = false,
		
		Shield = "WintersPhalanx",
		Tasks = {"shield","movement_winters_phalanx"},
		
		Voices = {death = "default"},
	},
	["Cop"] = {
		Name = "Cop",
		Icon = "sb_anb_payday2/cop.png",
		Type = "Police",
		
		Addons = {"900284108","1769443410"},
	
		Variants = {
			[1] = {
				Model = Model("models/payday2/units/cop1_player_pd2anim.mdl"),
				Skin = 0,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_c45",
			},
			[2] = {
				Model = Model("models/payday2/units/cop2_player_pd2anim.mdl"),
				Skin = 0,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_raging_bull",
			},
			[3] = {
				Model = Model("models/payday2/units/cop3_player_pd2anim.mdl"),
				Skin = 0,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_mp5",
			},
			[4] = {
				Model = Model("models/payday2/units/cop4_player_pd2anim.mdl"),
				Skin = 0,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_r870",
			},
		},
		
		Health = 40,
		HeadshotMultiplier = 2,
		
		RunSpeed = 300,
		WalkSpeed = 200,
		SlowWalkSpeed = 100,
		AimSpeed = 180,
		
		CanCrouch = true,
		CanJump = true,
		CanDoMeleeAttack = true,
		ShouldDoHeavyDamage = true,
		
		Voices = {death = "default"},
	},
	["Guard"] = {
		Name = "Guard",
		Icon = "sb_anb_payday2/guard.png",
		Type = "Police",
		
		Addons = {"2379282996","1769443410"},
	
		Variants = {
			[1] = {
				Model = Model("models/payday2/units/security1_player_pd2anim.mdl"),
				Skin = 0,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_c45",
			},
			[2] = {
				Model = Model("models/payday2/units/security2_player_pd2anim.mdl"),
				Skin = 0,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_mp5",
			},
			[3] = {
				Model = Model("models/payday2/units/security3_player_pd2anim.mdl"),
				Skin = 0,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_c45",
			},
			[4] = {
				Model = Model("models/payday2/units/security4_player_pd2anim.mdl"),
				Skin = 0,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_c45",
			},
			[5] = {
				Model = Model("models/payday2/units/security5_player_pd2anim.mdl"),
				Skin = 0,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_c45",
			},
			[6] = {
				Model = Model("models/payday2/units/security6_player_pd2anim.mdl"),
				Skin = 0,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_c45",
			},
			[7] = {
				Model = Model("models/payday2/units/security7_player_pd2anim.mdl"),
				Skin = 0,
				Bodygroups = {1},
				
				Weapon = "sb_anb_payday2_mp5",
			},
		},
		
		Health = 40,
		HeadshotMultiplier = 2,
		
		RunSpeed = 300,
		WalkSpeed = 200,
		SlowWalkSpeed = 100,
		AimSpeed = 180,
		
		CanCrouch = true,
		CanJump = true,
		CanDoMeleeAttack = true,
		ShouldDoHeavyDamage = true,
		
		Voices = {death = "default"},
	},
	["Bulldozer"] = {
		Name = "Bulldozer",
		Icon = "sb_anb_payday2/bulldozer.png",
		Type = "Police",
		
		Addons = {"579592077","1769443410"},
		
		Variants = {
			[1] = {
				Model = Model("models/sb_anb_payday2/bulldozer_player_pd2anim.mdl"),
				Skin = 0,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_r870",
				
				Visor1Break = {1,1},
				Visor2Break1 = {1,2},
				Visor2Break2 = {1,3},
			},
			[2] = {
				Model = Model("models/sb_anb_payday2/bulldozer_player_pd2anim.mdl"),
				Skin = 1,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_saiga",
				
				Visor1Break = {1,1},
				Visor2Break1 = {1,2},
				Visor2Break2 = {1,3},
			},
			[3] = {
				Model = Model("models/sb_anb_payday2/bulldozer_player_pd2anim.mdl"),
				Skin = 2,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_m249",
				
				Visor1Break = {1,1},
				Visor2Break1 = {1,2},
				Visor2Break2 = {1,3},
			},
		},
		
		Health = 2000,
		HeadshotMultiplier = 5,
		
		RunSpeed = 200,
		WalkSpeed = 135,
		SlowWalkSpeed = 67,
		AimSpeed = 180,
		
		Aggressive = true,
		CanCrouch = false,
		CanJump = false,
		CanDoMeleeAttack = true,
		ShouldDoHeavyDamage = false,
		
		Tasks = {"bulldozer"},
		
		Voices = {death = "default",onsee = "bulldozer"},
	},
	["Cloaker"] = {
		Name = "Cloaker",
		Icon = "sb_anb_payday2/cloaker.png",
		Type = "Police",
		
		Addons = {"293351182","1769443410"},
		
		Variants = {
			[1] = {
				Model = Model("models/sb_anb_payday2/cloaker_player_pd2anim.mdl"),
				Skin = 0,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_mp5_tactical",
				
				ChargeOn = 1,
				ChargeOff = 0,
			},
		},
		
		Health = 600,
		HeadshotMultiplier = 6,
		
		RunSpeed = 300,
		WalkSpeed = 200,
		SlowWalkSpeed = 100,
		AimSpeed = 180,
		
		CanCrouch = true,
		CanJump = true,
		CanDoMeleeAttack = true,
		ShouldDoHeavyDamage = true,
		
		Tasks = {"cloaker"},
		
		Voices = {death = "cloaker"},
	},
	["ZealBulldozer"] = {
		Name = "Zeal Bulldozer",
		Icon = "sb_anb_payday2/zealbulldozer.png",
		Type = "Police",
		
		Addons = {"813261576","1769443410"},
	
		Variants = {
			[1] = {
				Model = Model("models/sb_anb_payday2/bulldozer_zeal_player_pd2anim.mdl"),
				Skin = 0,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_r870",
				
				Visor1Break = {5,1},
				Visor2Break1 = {2,1},
				Visor2Break2 = {2,2},
			},
			[2] = {
				Model = Model("models/sb_anb_payday2/bulldozer_zeal_player_pd2anim.mdl"),
				Skin = 1,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_saiga",
				
				Visor1Break = {5,1},
				Visor2Break1 = {2,1},
				Visor2Break2 = {2,2},
			},
			[3] = {
				Model = Model("models/sb_anb_payday2/bulldozer_zeal_player_pd2anim.mdl"),
				Skin = 2,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_m249",
				
				Visor1Break = {5,1},
				Visor2Break1 = {2,1},
				Visor2Break2 = {2,2},
			},
		},
		
		Health = 2000,
		HeadshotMultiplier = 5,
		
		RunSpeed = 200,
		WalkSpeed = 135,
		SlowWalkSpeed = 67,
		AimSpeed = 180,
		
		Aggressive = true,
		CanCrouch = false,
		CanJump = false,
		CanDoMeleeAttack = true,
		ShouldDoHeavyDamage = false,
		
		Tasks = {"bulldozer"},
		
		Voices = {death = "default",onsee = "bulldozer"},
	},
	["Minigundozer"] = {
		Name = "Minigun Bulldozer",
		Icon = "sb_anb_payday2/minigundozer.png",
		Type = "Police",
		
		Addons = {"813261576","1769443410"},
	
		Variants = {
			[1] = {
				Model = Model("models/sb_anb_payday2/bulldozer_zeal_player_pd2anim.mdl"),
				Skin = 4,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_mini",
				
				Visor1Break = {5,1},
				Visor2Break1 = {2,1},
				Visor2Break2 = {2,2},
			},
		},
		
		Health = 4000,
		HeadshotMultiplier = 5,
		
		RunSpeed = 200/2,
		WalkSpeed = 135/2,
		SlowWalkSpeed = 67/2,
		AimSpeed = 180,
		
		Aggressive = true,
		CanCrouch = false,
		CanJump = false,
		CanDoMeleeAttack = true,
		ShouldDoHeavyDamage = false,
		
		Tasks = {"bulldozer"},
		
		Voices = {death = "default",onsee = "bulldozer"},
	},
	["Medicdozer"] = {
		Name = "Medic Bulldozer",
		Icon = "sb_anb_payday2/medicdozer.png",
		Type = "Police",
		
		Addons = {"813261576","1769443410"},
	
		Variants = {
			[1] = {
				Model = Model("models/sb_anb_payday2/bulldozer_zeal_player_pd2anim.mdl"),
				Skin = 3,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_mp5",
				
				Visor1Break = {5,1},
				Visor2Break1 = {2,1},
				Visor2Break2 = {2,2},
			},
		},
		
		Health = 2000,
		HeadshotMultiplier = 5,
		
		RunSpeed = 200,
		WalkSpeed = 135,
		SlowWalkSpeed = 67,
		AimSpeed = 180,
		
		Aggressive = true,
		CanCrouch = false,
		CanJump = false,
		CanDoMeleeAttack = true,
		ShouldDoHeavyDamage = false,
		
		Tasks = {"bulldozer","medic"},
		
		Voices = {death = "default",onsee = "bulldozer"},
	},
	["ZealCloaker"] = {
		Name = "Zeal Cloaker",
		Icon = "sb_anb_payday2/zealcloaker.png",
		Type = "Police",
		
		Addons = {"810677997","1769443410"},
	
		Variants = {
			[1] = {
				Model = Model("models/sb_anb_payday2/cloaker_zeal_player_pd2anim.mdl"),
				Skin = 0,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_mp5_tactical",
				
				ChargeOn = 1,
				ChargeOff = 0,
			},
		},
		
		Health = 600,
		HeadshotMultiplier = 6,
		
		RunSpeed = 300,
		WalkSpeed = 200,
		SlowWalkSpeed = 100,
		AimSpeed = 180,
		
		CanCrouch = true,
		CanJump = true,
		CanDoMeleeAttack = true,
		ShouldDoHeavyDamage = false,
		
		Tasks = {"cloaker"},
		
		Voices = {death = "cloaker"},
	},
	["ZealShield"] = {
		Name = "Zeal SWAT Shield",
		Icon = "sb_anb_payday2/zealshield.png",
		Type = "Police",
		
		Addons = {"1437234196","817439512","1769443410"},
	
		Variants = {
			[1] = {
				Model = Model("models/payday2/units/zeal_swat_player_pd2anim_shield.mdl"),
				Skin = 0,
				Bodygroups = {},
				
				Weapon = "sb_anb_payday2_mp9",
				
				HelmetBreak = {1,1,Model("models/payday2/helmets/zeal.mdl")},
			},
		},
		
		Health = 80,
		HeadshotMultiplier = 2,
		
		RunSpeed = 200,
		WalkSpeed = 150,
		SlowWalkSpeed = 100,
		AimSpeed = 120,
		
		CanCrouch = false,
		CanJump = false,
		CanDoMeleeAttack = false,
		ShouldDoHeavyDamage = false,
		
		Shield = "Zeal",
		Tasks = {"shield"},
		
		Voices = {death = "default",onsee = "shield"},
	},
}
hook.Run("SB_ANB_PAYDAY2_SetupBotClasses",ENT.BotClasses)

ENT.BotGroups = {
	["SWAT"] = {
		Name = "SWAT Group",
		Icon = "sb_anb_payday2/group_swat.png",
		
		LeaderClass = "SWAT",
		MemberClass = "SWAT",
		
		Min = 2,
		Max = 4,
	},
	["HeavySWAT"] = {
		Name = "Heavy SWAT Group",
		Icon = "sb_anb_payday2/group_heavyswat.png",
		
		LeaderClass = "HeavySWAT",
		MemberClass = "SWAT",
		
		Min = 2,
		Max = 4,
	},
	["HeavySWAT2"] = {
		Name = "Heavy SWAT Group 2",
		Icon = "sb_anb_payday2/group_heavyswat2.png",
		
		LeaderClass = "HeavySWAT",
		MemberClass = "HeavySWAT",
		
		Min = 2,
		Max = 4,
	},
	["SWATShieldGroup"] = {
		Name = "SWAT Shield Group",
		Icon = "sb_anb_payday2/group_swatshield.png",
	
		LeaderClass = "SWATShield",
		MemberClass = "SWATShield",
		
		Min = 2,
		Max = 2,
	},
	["FBIGroup"] = {
		Name = "SWAT FBI Group",
		Icon = "sb_anb_payday2/group_fbi.png",
	
		LeaderClass = "FBI",
		MemberClass = "FBI",
		
		Min = 2,
		Max = 4,
	},
	["ArmorFBIGroup"] = {
		Name = "Armored SWAT FBI Group",
		Icon = "sb_anb_payday2/group_armorfbi.png",
	
		LeaderClass = "ArmorFBI",
		MemberClass = "ArmorFBI",
		
		Min = 2,
		Max = 4,
	},
	["HeavyFBIGroup"] = {
		Name = "Heavy SWAT FBI Group",
		Icon = "sb_anb_payday2/group_heavyfbi.png",
	
		LeaderClass = "HeavyFBI",
		MemberClass = "FBI",
		
		Min = 2,
		Max = 4,
	},
	["HeavyFBIArmorGroup"] = {
		Name = "Heavy Armored SWAT FBI Group",
		Icon = "sb_anb_payday2/group_heavyarmorfbi.png",
	
		LeaderClass = "HeavyFBI",
		MemberClass = "ArmorFBI",
		
		Min = 2,
		Max = 4,
	},
	["HeavyFBIGroup2"] = {
		Name = "Heavy SWAT FBI Group 2",
		Icon = "sb_anb_payday2/group_heavyfbi2.png",
	
		LeaderClass = "HeavyFBI",
		MemberClass = "HeavyFBI",
		
		Min = 2,
		Max = 4,
	},
	["FBIShieldGroup"] = {
		Name = "SWAT FBI Shield Group",
		Icon = "sb_anb_payday2/group_fbishield.png",
	
		LeaderClass = "FBIShield",
		MemberClass = "FBIShield",
		
		Min = 2,
		Max = 2,
	},
	["ArmorFBIShieldGroup"] = {
		Name = "Armored SWAT FBI Shield Group",
		Icon = "sb_anb_payday2/group_armorfbishield.png",
	
		LeaderClass = "ArmorFBIShield",
		MemberClass = "ArmorFBIShield",
		
		Min = 2,
		Max = 2,
	},
	["TaserGroup"] = {
		Name = "Taser Group",
		Icon = "sb_anb_payday2/group_taser.png",
	
		LeaderClass = "Taser",
		MemberClass = "SWAT",
		
		Min = 2,
		Max = 4,
	},
	["Winters"] = {
		Name = "Captain Winters Group",
		Icon = "sb_anb_payday2/group_winters.png",
		
		LeaderClass = "Winters",
		MemberClass = "WintersPhalanx",
		
		Min = 11,
		Max = 11,
	},
	["MedicGroup"] = {
		Name = "Medic Group",
		Icon = "sb_anb_payday2/group_medic.png",
	
		LeaderClass = "Medic",
		MemberClass = "ArmorFBI",
		
		Min = 2,
		Max = 4,
	},
	["GensecGroup"] = {
		Name = "Elite Gensec Group",
		Icon = "sb_anb_payday2/group_gensec.png",
	
		LeaderClass = "Gensec",
		MemberClass = "Gensec",
		
		Min = 2,
		Max = 4,
	},
	["ArmorGensecGroup"] = {
		Name = "Armored Elite Gensec Group",
		Icon = "sb_anb_payday2/group_armorgensec.png",
	
		LeaderClass = "ArmorGensec",
		MemberClass = "ArmorGensec",
		
		Min = 2,
		Max = 4,
	},
	["HeavyGensecGroup"] = {
		Name = "Heavy Elite Gensec Group",
		Icon = "sb_anb_payday2/group_heavygensec.png",
	
		LeaderClass = "HeavyGensec",
		MemberClass = "Gensec",
		
		Min = 2,
		Max = 4,
	},
	["HeavyGensecArmorGroup"] = {
		Name = "Heavy Armored Elite Gensec Group",
		Icon = "sb_anb_payday2/group_heavyarmorgensec.png",
	
		LeaderClass = "HeavyGensec",
		MemberClass = "ArmorGensec",
		
		Min = 2,
		Max = 4,
	},
	["HeavyGensecGroup2"] = {
		Name = "Heavy Elite Gensec Group 2",
		Icon = "sb_anb_payday2/group_heavygensec2.png",
	
		LeaderClass = "HeavyGensec",
		MemberClass = "HeavyGensec",
		
		Min = 2,
		Max = 4,
	},
	["GensecShieldGroup"] = {
		Name = "Elite Gensec Shield Group",
		Icon = "sb_anb_payday2/group_gensecshield.png",
	
		LeaderClass = "GensecShield",
		MemberClass = "GensecShield",
		
		Min = 2,
		Max = 2,
	},
	["ArmorGensecShieldGroup"] = {
		Name = "Armored Elite Gensec Shield Group",
		Icon = "sb_anb_payday2/group_armorgensecshield.png",
	
		LeaderClass = "ArmorGensecShield",
		MemberClass = "ArmorGensecShield",
		
		Min = 2,
		Max = 2,
	},
	["ZealGroup"] = {
		Name = "Zeal SWAT Group",
		Icon = "sb_anb_payday2/group_zeal.png",
	
		LeaderClass = "HeavyZeal",
		MemberClass = "Zeal",
		
		Min = 2,
		Max = 4,
	},
	["HeavyZealGroup"] = {
		Name = "Zeal Heavy SWAT Group",
		Icon = "sb_anb_payday2/group_heavyzeal.png",
	
		LeaderClass = "HeavyZeal",
		MemberClass = "HeavyZeal",
		
		Min = 2,
		Max = 4,
	},
	["ZealMedicGroup"] = {
		Name = "Zeal Medic Group",
		Icon = "sb_anb_payday2/group_zealmedic.png",
	
		LeaderClass = "Medic",
		MemberClass = "Zeal",
		
		Min = 2,
		Max = 4,
	},
	["ZealTaserGroup"] = {
		Name = "Zeal Taser Group",
		Icon = "sb_anb_payday2/group_zealtaser.png",
	
		LeaderClass = "ZealTaser",
		MemberClass = "Zeal",
		
		Min = 2,
		Max = 4,
	},
	["CopsGroup"] = {
		Name = "Cops Group",
		Icon = "sb_anb_payday2/group_cops.png",
	
		LeaderClass = "Cop",
		MemberClass = "Cop",
		
		Min = 2,
		Max = 4,
	},
	["BulldozerGroup"] = {
		Name = "Bulldozers Group",
		Icon = "sb_anb_payday2/group_bulldozers.png",
	
		LeaderClass = "Bulldozer",
		MemberClass = "Bulldozer",
		
		Min = 2,
		Max = 2,
	},
	["ZealBulldozerGroup"] = {
		Name = "Zeal Bulldozers Group",
		Icon = "sb_anb_payday2/group_zealbulldozers.png",
	
		LeaderClass = "ZealBulldozer",
		MemberClass = "ZealBulldozer",
		
		Min = 2,
		Max = 2,
	},
	["MinigunBulldozerGroup"] = {
		Name = "Minigun Bulldozer Group",
		Icon = "sb_anb_payday2/group_minigunbulldozer.png",
	
		LeaderClass = "Minigundozer",
		MemberClass = "Medicdozer",
		
		Min = 2,
		Max = 2,
	},
	["ZealShieldGroup"] = {
		Name = "Zeal SWAT Shield Group",
		Icon = "sb_anb_payday2/group_zealshield.png",
	
		LeaderClass = "ZealShield",
		MemberClass = "ZealShield",
		
		Min = 2,
		Max = 2,
	},
}
hook.Run("SB_ANB_PAYDAY2_SetupBotGroups",ENT.BotGroups)

local function AddonMounted(id)
	for k,v in ipairs(engine.GetAddons()) do
		if v.wsid==id then
			return v.mounted,true
		end
	end
	
	return false,false
end

local function AddonsMounted(tab)
	for k,v in ipairs(tab) do
		if !AddonMounted(v) then return false end
	end
	
	return true
end

local MainAddonInstalled = AddonMounted("2148063174")

for k,v in pairs(ENT.BotClasses) do
	if !MainAddonInstalled or !AddonsMounted(v.Addons) then
		list.Set("NPC","sb_anb_payday2_stub_"..k:lower(),{
			Name = v.Name,
			Addons = table.Add({"2148063174"},v.Addons),
			Category = "SB ANB PAYDAY 2",
			IconOverride = "sb_anb_payday2/noaddon.png",
		})
		
		v.AddonsMounted = false
	else
		list.Set("NPC","sb_advanced_nextbot_payday2_"..k:lower(),{
			Name = v.Name,
			Class = "sb_advanced_nextbot_payday2",
			Category = "SB ANB PAYDAY 2",
			IconOverride = v.Icon,
			KeyValues = {Class = k},
		})
		
		local npcweps = list.GetForEdit("NPCUsableWeapons")
		
		if npcweps then
			for k,v in ipairs(v.Variants) do
				if v.Weapon then
					for k2,v2 in ipairs(npcweps) do
						if v2.class==v.Weapon then
							table.remove(npcweps,k2)
							break
						end
					end
					
					table.insert(npcweps,{class = v.Weapon,title = "SB ANB PD2: "..weapons.Get(v.Weapon).PrintName})
				end
			end
		end
		
		v.AddonsMounted = true
	end
end

for k,v in pairs(ENT.BotGroups) do
	if !ENT.BotClasses[v.LeaderClass] or !ENT.BotClasses[v.MemberClass] then continue end

	if !MainAddonInstalled or !AddonsMounted(ENT.BotClasses[v.LeaderClass].Addons) or !AddonsMounted(ENT.BotClasses[v.MemberClass].Addons) then
		list.Set("NPC","sb_anb_payday2_stubg_"..k:lower(),{
			Name = v.Name,
			Addons = table.Add(table.Add({"2148063174"},ENT.BotClasses[v.LeaderClass].Addons),ENT.BotClasses[v.MemberClass].Addons),
			Category = "SB ANB PAYDAY 2 Groups",
			IconOverride = "sb_anb_payday2/noaddon.png",
		})
		
		v.AddonsMounted = false
	else
		list.Set("NPC","sb_advanced_nextbot_payday2group_"..k:lower(),{
			Name = v.Name,
			Class = "sb_advanced_nextbot_payday2",
			Category = "SB ANB PAYDAY 2 Groups",
			IconOverride = v.Icon,
			KeyValues = {Group = k},
		})
		
		v.AddonsMounted = true
	end
end

local AddNetworkVar = function(type,slot,name)
	ENT["Set"..name] = function(self,value)
		self["SetDT"..type](self,slot,value)
	end
	
	ENT["Get"..name] = function(self)
		return self["GetDT"..type](self,slot)
	end
end

AddNetworkVar("String",3,"Team")

local OWNER_TO_SET
function ENT:Initialize()
	BaseClass.Initialize(self)
	
	self:SetCustomCollisionCheck(true)
	
	if SERVER then
		self.PostureActive = false
		self:SetUseNodeGraph(self.NodeGraphConvar:GetBool())
	
		local ply = IsValid(self.Owner) and self.Owner or OWNER_TO_SET
		self.Owner = ply
		
		if self:GetKeyValue("Class") or self:GetKeyValue("Group") then
			local data = self.CustomSpawnData or IsValid(ply) and {
				team = ply:GetInfo("sb_anb_payday2_team"),
				side = math.floor(ply:GetInfoNum("sb_anb_payday2_side",0)),
				pside = math.floor(ply:GetInfoNum("sb_anb_payday2_pside",0)),
				hpdiff = math.floor(ply:GetInfoNum("sb_anb_payday2_hp_difficulty",0)),
				variant = math.floor(ply:GetInfoNum("sb_anb_payday2_variant",0)),
				ownerleader = tobool(ply:GetInfoNum("sb_anb_payday2_leader",0)),
				proficiency = math.floor(ply:GetInfoNum("sb_anb_payday2_proficiency",0)),
				policechase = tobool(ply:GetInfoNum("sb_anb_payday2_policechase",0)),
			} or {
				team = self.TeamConvar:GetString(),
				side = self.SideConvar:GetInt(),
				pside = self.PSideConvar:GetInt(),
				hpdiff = self.HPDifficultyConvar:GetInt(),
				variant = self.VariantConvar:GetInt(),
				ownerleader = false,
				proficiency = self.ProfConvar:GetInt(),
				policechase = false,
			}
		
			if self:GetKeyValue("Class") then
				self:Setup(self:GetKeyValue("Class"),data)
			else
				self:SetupGroup(self:GetKeyValue("Group"),data)
			end
			
			return
		end
		
		self:Remove()
	end
end

hook.Add("ShouldCollide","sb_advanced_nextbot_payday2",function(ent1,ent2)
	if ent1:GetClass()=="sb_advanced_nextbot_payday2" and ent2:GetClass()=="sb_advanced_nextbot_payday2" and ent1.GetTeam and ent2.GetTeam and ent1:GetTeam()==ent2:GetTeam() then
		return false
	end
	if ent2:IsPlayer() and ent1:IsNextBot() then
		local vec1 = ent2:GetPos()*Vector(1,1,0)
		local vec2 = ent1:GetPos()*Vector(1,1,0)
		local distance = vec1:Distance(vec2)
		if distance<32 then return false end
	end
end)

hook.Add("StartCommand","sb_advanced_nextbot_payday2",function(ply,cmd)
	local taser = ply:GetNWFloat("sb_anb_pd2_taserattacked",0)
	
	if CurTime()<taser then
		cmd:RemoveKey(IN_RELOAD)
		
		if CurTime()<taser-1 then
			cmd:SetButtons(bit.bor(cmd:GetButtons(),IN_ATTACK))
		end
	end
end)

hook.Add("SetupMove","sb_advanced_nextbot_payday2",function(ply,mv,cmd)
	local taser = ply:GetNWFloat("sb_anb_pd2_taserattacked",0)
	
	if CurTime()<taser then
		if ply.sb_anb_pd2_taserattacked_duck==nil then
			ply.sb_anb_pd2_taserattacked_duck = cmd:KeyDown(IN_DUCK)
		end
	
		cmd:ClearMovement()
		cmd:RemoveKey(IN_JUMP)
		
		local btnsremove = bit.bor(IN_FORWARD,IN_LEFT,IN_RIGHT,IN_MOVELEFT,IN_MOVERIGHT,IN_BACK,IN_JUMP)
		mv:SetButtons(bit.bxor(bit.bor(mv:GetButtons(),btnsremove),btnsremove))
		
		mv:SetForwardSpeed(0)
		mv:SetSideSpeed(0)
		
		if ply.sb_anb_pd2_taserattacked_duck then
			cmd:SetButtons(bit.bor(cmd:GetButtons(),IN_DUCK))
			mv:AddKey(IN_DUCK)
		else
			cmd:RemoveKey(IN_DUCK)
			mv:SetButtons(bit.bxor(bit.bor(mv:GetButtons(),IN_DUCK),IN_DUCK))
		end
	else
		ply.sb_anb_pd2_taserattacked_duck = nil
	end
end)

hook.Add("PlayerSwitchWeapon","sb_advanced_nextbot_payday2",function(ply,old,new)
	if CurTime()<ply:GetNWFloat("sb_anb_pd2_taserattacked",0) then return true end
end)

if CLIENT then
	function ENT:Think()
		BaseClass.Think(self)
		
		if self:GetNWBool("TaserActive",false) then
			local m = self:GetBoneMatrix(self:LookupBone("ValveBiped.Bip01_R_Hand") or 0)
			if !m then return end
			
			local t = DynamicLight(self:EntIndex())
			t.pos = m:GetTranslation()
			t.r = 90
			t.g = 200
			t.b = 255
			t.brightness = 2
			t.decay = 1000
			t.size = 200
			t.dietime = CurTime()+1
		elseif self:GetNWBool("CloakerActive",false) then
			local m = self:GetBoneMatrix(self:LookupBone("ValveBiped.Bip01_Head1") or 0)
			if !m then return end
			
			local t = DynamicLight(self:EntIndex())
			t.pos = m:GetTranslation()+m:GetAngles():Right()*10+m:GetAngles():Forward()*6-m:GetAngles():Up()*0.5
			t.r = 0
			t.g = 200
			t.b = 0
			t.brightness = 2
			t.decay = 1000
			t.size = 100
			t.dietime = CurTime()+1
		end
	end
	
	net.Receive("sb_anb_payday2_addons",function(len)
		local addons = {}
		
		while net.ReadBool() do
			local id = net.ReadString()
			addons[id] = !AddonMounted(id) or nil
		end
		
		if table.IsEmpty(addons) then
			Derma_Query("All required addons mounted, but you need reconnect to take effect.","Reconnect need","OK",nil,"Reconnect",function()
				RunConsoleCommand("retry")
			end)
		
			return
		end
		
		local frame = vgui.Create("DFrame")
		frame:SetSize(800,400)
		frame:Center()
		frame:MakePopup()
		frame:SetTitle("To spawn this bot, mount required addons!")
		
		local scroll = frame:Add("DScrollPanel")
		scroll:Dock(FILL)
		
		for k,v in pairs(addons) do
			local p = scroll:Add("DButton")
			p:SetFont("DermaLarge")
			p:SetText("Loading info...")
			p:SetTextColor(color_white)
			p:SetTall(100)
			p:Dock(TOP)
			p:DockMargin(0,0,0,10)
			p.installed = select(2,AddonMounted(k))
			p.Paint = function(s,w,h)
				draw.RoundedBox(8,0,0,w,h,Color(27,40,56))
			
				if s.LoadState and s.LoadState!=2 then
					draw.SimpleText(s.Title,"DermaLarge",100,10)
					
					if p.installed then
						draw.SimpleText("Installed, not mounted","DermaLarge",w-10,h-10,nil,2,4)
					else
						draw.SimpleText(s.Downloading and "Downloading..." or "Press to download","DermaLarge",w-10,h-10,nil,2,4)
					end
				end
			end
			p.DoClick = function(s)
				if !p.installed then
					gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id="..k)
				else
					Derma_Message("You should enable addon in menu","Enable addon","OK")
				end
			end
			p.Fail = function(s)
				s:SetText("Failed to load info. Try later.")
				s.LoadState = 2
			end
			
			steamworks.FileInfo(k,function(data)
				if !IsValid(p) then return end
				if !data then p:Fail() return end
				
				p.Title = data.title
				
				steamworks.Download(data.previewid,true,function(path)
					if !IsValid(p) then return end
					if !path then p:Fail() return end
					
					local mat = AddonMaterial(path)
					if !mat then p:Fail() return end
					
					p.LoadState = 1
					p:SetText("")
					
					p.matpanel = p:Add("DImage")
					p.matpanel:Dock(LEFT)
					p.matpanel:DockMargin(10,10,0,10)
					p.matpanel:SetWide(80)
					p.matpanel:SetMaterial(mat)
					p.matpanel:SetMouseInputEnabled(false)
				end)
			end)
		end
	end)
end

if CLIENT then return end

util.AddNetworkString("sb_anb_payday2_addons")

local ENEMY_FRIENDLY,ENEMY_HOSTILE,ENEMY_MONSTER,ENEMY_NEUTRAL = 0,1,2,3
local ENEMY_CLASSES = {
	npc_crow = ENEMY_NEUTRAL,
	npc_monk = ENEMY_FRIENDLY,
	npc_pigeon = ENEMY_NEUTRAL,
	npc_seagull = ENEMY_NEUTRAL,
	npc_combine_camera = ENEMY_NEUTRAL,
	npc_cscanner = ENEMY_HOSTILE,
	npc_combinegunship = ENEMY_HOSTILE,
	npc_combine_s = ENEMY_HOSTILE,
	npc_helicopter = ENEMY_HOSTILE,
	npc_manhack = ENEMY_HOSTILE,
	npc_metropolice = ENEMY_HOSTILE,
	npc_rollermine = ENEMY_HOSTILE,
	npc_clawscanner = ENEMY_HOSTILE,
	npc_stalker = ENEMY_HOSTILE,
	npc_strider = ENEMY_HOSTILE,
	npc_turret_floor = ENEMY_HOSTILE,
	npc_sniper = ENEMY_HOSTILE,
	npc_alyx = ENEMY_FRIENDLY,
	npc_barney = ENEMY_FRIENDLY,
	npc_citizen = ENEMY_FRIENDLY,
	npc_dog = ENEMY_FRIENDLY,
	npc_kleiner = ENEMY_FRIENDLY,
	npc_mossman = ENEMY_FRIENDLY,
	npc_eli = ENEMY_FRIENDLY,
	npc_gman = ENEMY_NEUTRAL,
	npc_odessa = ENEMY_FRIENDLY,
	npc_vortigaunt = ENEMY_FRIENDLY,
	npc_magnusson = ENEMY_FRIENDLY,
	npc_breen = ENEMY_NEUTRAL,
	npc_antlion = ENEMY_MONSTER,
	npc_antlionguard = ENEMY_MONSTER,
	npc_barnacle = ENEMY_MONSTER,
	npc_headcrab_fast = ENEMY_MONSTER,
	npc_fastzombie = ENEMY_MONSTER,
	npc_fastzombie_torso = ENEMY_MONSTER,
	npc_headcrab = ENEMY_MONSTER,
	npc_headcrab_poison = ENEMY_MONSTER,
	npc_headcrab_black = ENEMY_MONSTER,
	npc_poisonzombie = ENEMY_MONSTER,
	npc_zombie = ENEMY_MONSTER,
	npc_zombie_torso = ENEMY_MONSTER,
	npc_antlion_grub = ENEMY_MONSTER,
	npc_antlionguardian = ENEMY_MONSTER,
	npc_antlion_worker = ENEMY_MONSTER,
	npc_zombine = ENEMY_MONSTER,
	npc_hunter = ENEMY_HOSTILE,
}
ENT.ENEMY_NO_SPECIAL_ATTACK	= {
	npc_combine_camera = true,
	npc_cscanner = true,
	npc_combinegunship = true,
	npc_helicopter = true,
	npc_clawscanner = true,
	npc_strider = true,
	npc_turret_floor = true,
	npc_barnacle = true,
	npc_manhack = true,
	npc_crow = true,
	npc_pigeon = true,
	npc_seagull = true,
	npc_rollermine = true,
}

ENT.PathGoalTolerance = 20
ENT.MovingMaxSeeDistances = {1000,250}
ENT.MeleeAttackRange = 75
ENT.MeleeDamage = 150
ENT.FinalGoalDistance = 200
ENT.AccurateMotionStartDistance = 250
ENT.AccurateMotionMinSpeed = 75
ENT.TravelingDistances = {250,2000}
ENT.LineOfSightMask = MASK_VISIBLE

ENT.CollisionBounds = {Vector(-16,-16,0),Vector(16,16,72)}
ENT.CrouchCollisionBounds = {Vector(-16,-16,0),Vector(16,16,46)}

ENT.SolidMask = MASK_PLAYERSOLID_BRUSHONLY

ENT.PassiveActivities = {
	rifle = {
		[ACT_MP_STAND_IDLE]					= ACT_HL2MP_IDLE_PASSIVE,
		[ACT_MP_WALK]						= ACT_HL2MP_WALK_PASSIVE,
		[ACT_MP_RUN]						= ACT_HL2MP_RUN_PASSIVE,
		[ACT_MP_CROUCH_IDLE]				= ACT_HL2MP_IDLE_CROUCH_PASSIVE,
		[ACT_MP_CROUCHWALK]					= ACT_HL2MP_WALK_CROUCH_PASSIVE,
		[ACT_MP_ATTACK_STAND_PRIMARYFIRE]	= ACT_HL2MP_GESTURE_RANGE_ATTACK_PASSIVE,
		[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]	= ACT_HL2MP_GESTURE_RANGE_ATTACK_PASSIVE,
		[ACT_MP_RELOAD_STAND]				= ACT_HL2MP_GESTURE_RELOAD_PASSIVE,
		[ACT_MP_RELOAD_CROUCH]				= ACT_HL2MP_GESTURE_RELOAD_PASSIVE,
		[ACT_MP_JUMP]						= ACT_HL2MP_JUMP_PASSIVE,
		[ACT_MP_SWIM]						= ACT_HL2MP_SWIM_PASSIVE,
		[ACT_LAND]							= ACT_LAND,
	},
	pistol = {
		[ACT_MP_STAND_IDLE]					= ACT_IDLE,
		[ACT_MP_WALK]						= ACT_WALK,
		[ACT_MP_RUN]						= ACT_RUN,
		[ACT_MP_CROUCH_IDLE]				= ACT_CROUCH,
		[ACT_MP_CROUCHWALK]					= ACT_WALK_CROUCH,
		[ACT_MP_ATTACK_STAND_PRIMARYFIRE]	= ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL,
		[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]	= ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL,
		[ACT_MP_RELOAD_STAND]				= ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		[ACT_MP_RELOAD_CROUCH]				= ACT_HL2MP_GESTURE_RELOAD_PISTOL,
		[ACT_MP_JUMP]						= ACT_HL2MP_JUMP_PISTOL,
		[ACT_MP_SWIM]						= ACT_HL2MP_SWIM_PISTOL,
		[ACT_LAND]							= ACT_LAND,
	},
}

ENT.CrossbowActivities = {
	[ACT_MP_STAND_IDLE]					= ACT_HL2MP_IDLE_AR2,
	[ACT_MP_WALK]						= ACT_HL2MP_WALK_AR2,
	[ACT_MP_RUN]						= ACT_HL2MP_RUN_AR2,
	[ACT_MP_CROUCH_IDLE]				= ACT_HL2MP_IDLE_CROUCH_AR2,
	[ACT_MP_CROUCHWALK]					= ACT_HL2MP_WALK_CROUCH_AR2,
	[ACT_MP_ATTACK_STAND_PRIMARYFIRE]	= ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,
	[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]	= ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,
	[ACT_MP_RELOAD_STAND]				= ACT_HL2MP_GESTURE_RELOAD_AR2,
	[ACT_MP_RELOAD_CROUCH]				= ACT_HL2MP_GESTURE_RELOAD_AR2,
	[ACT_MP_JUMP]						= ACT_HL2MP_JUMP_AR2,
	[ACT_MP_SWIM]						= ACT_HL2MP_SWIM_AR2,
	[ACT_LAND]							= ACT_LAND,
}

ENT.PassiveHoldTypes = {
	pistol		= "pistol",
	smg			= "rifle",
	ar2			= "rifle",
	shotgun		= "rifle",
	passive		= "rifle",
	revolver	= "pistol",
}

ENT.DeathAnimations = {
	front = {
		other = ACT_DIE_CHESTSHOT,
		[HITGROUP_LEFTLEG] = ACT_DIE_GUTSHOT,
		[HITGROUP_HEAD] = ACT_DIE_HEADSHOT,
	},
	back = {
		other = ACT_DIE_BACKSHOT,
	},
}

ENT.HeavyDamageAnimations = {
	front = {
		other = ACT_MP_GESTURE_FLINCH_CHEST,
		[HITGROUP_HEAD] = ACT_MP_GESTURE_FLINCH_HEAD,
	},
	back = {
		other = ACT_MP_GESTURE_FLINCH_STOMACH,
	},
}

ENT.DifficultyData = {
	[0] = {HP = 1,Headshot = 2},
	[1] = {HP = 2,Headshot = 4},
	[2] = {HP = 3,Headshot = 6},
	[3] = {HP = 6,Headshot = 4},
	[4] = {HP = 6,Headshot = 3},
}

ENT.Voices = {
	Death = {
		default = {
			"default/death/1003011234.1.mp3",
			"default/death/15237935.1.mp3",
			"default/death/18281706.1.mp3",
			"default/death/38050603.1.mp3",
			"default/death/45543700.1.mp3",
			"default/death/66572380.1.mp3",
			"default/death/685485541.1.mp3",
			"default/death/838802291.1.mp3",
			"default/death/87460061.1.mp3",
			"default/death/880674776.1.mp3",
		},
		taser = {
			"taser/death/death-01.mp3",
			"taser/death/death-03.mp3",
			"taser/death/death-07.mp3",
			"taser/death/death-15.mp3",
			"taser/death/death-18.mp3",
		},
		medic = {
			"medic/death/203447196.english.mp3",
			"medic/death/228405582.english.mp3",
			"medic/death/260133290.english.mp3",
			"medic/death/34727969.english.mp3",
			"medic/death/448105967.english.mp3",
		},
		cloaker = {
			"cloaker/death/10310592.1.mp3",
			"cloaker/death/40191340.1.mp3",
			"cloaker/death/475828224.1.mp3",
			"cloaker/death/507314873.1.mp3",
			"cloaker/death/90031657.1.mp3",
		},
	},
	OnSeeEnemy = {
		taser = {
			"taser/enemyfound/target-02.mp3",
			"taser/enemyfound/target-05.mp3",
			"taser/enemyfound/target-11.mp3",
			"taser/enemyfound/target-25.mp3",
			"taser/enemyfound/target-42.mp3",
		},
		medic = {
			"medic/enemyfound/101358235.english.mp3",
			"medic/enemyfound/116011411.english.mp3",
			"medic/enemyfound/152099561.english.mp3",
			"medic/enemyfound/199609595.english.mp3",
		},
		bulldozer = {
			"bulldozer/enemyfound/bulldozer-07.mp3",
			"bulldozer/enemyfound/bulldozer-17.mp3",
			"bulldozer/enemyfound/bulldozer-28.mp3",
			"bulldozer/enemyfound/bulldozer-33.mp3",
		},
		shield = {
			"shield/641696862.mp3",
		},
	},
	MedicHelp = {
		"medic/onhelp/123648013.english.mp3",
		"medic/onhelp/142637101.english.mp3",
		"medic/onhelp/203952554.english.mp3",
		"medic/onhelp/287516577.english.mp3",
		"medic/onhelp/33768141.english.mp3",
	},
	BulldozerVisorBreak = {
		"bulldozer/visorbreak/bulldozer-109.mp3",
		"bulldozer/visorbreak/bulldozer-115.mp3",
		"bulldozer/visorbreak/bulldozer-124.mp3",
		"bulldozer/visorbreak/bulldozer-35.mp3",
		"bulldozer/visorbreak/bulldozer-92.mp3",
	},
}

ENT.Tasks = {
	["attack_handler"] = {
		OnStart = function(self,data)
			data.Crouch = false
			data.SuppressShoot = CurTime()
		end,
		BehaveUpdate = function(self,data,interval)
			if self.IsSeeEnemy then
				self:SetDesiredEyeAngles((self.LastEnemyEyePos-self:GetShootPos()):Angle())
				
				local wep = self:GetActiveWeapon()
				local taserattacked = self.sb_anb_pd2_taserattacked or 0
				
				if IsValid(wep) then
					if CurTime()>=data.SuppressShoot and (CurTime()<taserattacked-1 or self:ShouldAttack(self.LastEnemyShootPos)) then
						self:WeaponPrimaryAttack()
					end
					
					if wep:Clip1()==0 and CurTime()>taserattacked then
						self:WeaponReload()
					end
				end
				
				if self.ClassData.CanDoMeleeAttack and CurTime()>taserattacked and IsValid(self:GetEnemy()) and self:GetRangeTo(self:GetEnemy():GetPos())<self.MeleeAttackRange then
					if data.MeleeAttack and CurTime()>=data.MeleeAttack and CurTime()<=data.MeleeAttack+1 then
						data.MeleeAttack = nil
						
						if self:HaveEnemy() then
							local dmg = DamageInfo()
							dmg:SetDamage(self.MeleeDamage)
							dmg:SetAttacker(self)
							dmg:SetInflictor(self)
							dmg:SetDamageType(DMG_CLUB)
							dmg:SetDamagePosition(self.LastEnemyShootPos)
							
							self:GetEnemy():TakeDamageInfo(dmg)
							
							if self:GetEnemy():IsPlayer() then
								self:GetEnemy():ViewPunch(Angle(-20,math.Rand(-20,20),math.Rand(-20,20)))
							end
						end
					end
				
					data.MeleeTime = data.MeleeTime or CurTime()+1
					
					if CurTime()>=data.MeleeTime and (!data.MeleeCooldown or CurTime()>=data.MeleeCooldown) then
						data.MeleeCooldown = CurTime()+3
						data.MeleeTime = nil
						data.MeleeAttack = CurTime()+0.3
						data.SuppressShoot = math.max(data.SuppressShoot,CurTime()+0.75)
					
						self:DoGesture(IsValid(wep) and (self.PassiveHoldTypes[wep:GetHoldType()] or wep:GetHoldType()=="crossbow") and ACT_MELEE_ATTACK1 or ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST)
					end
				else
					data.MeleeTime = nil
				end
			else
				local wep = self:GetActiveWeapon()
				
				if IsValid(wep) and wep:Clip1()==0 and CurTime()>(self.sb_anb_pd2_taserattacked or 0) then
					self:WeaponReload()
				end
			end
		end,
		OnIsSeeEnemyChanged = function(self,data,see)
			data.Crouch = see and math.random(1,3)==1
			
			if see then
				data.SuppressShoot = math.max(data.SuppressShoot,CurTime()+0.5)
				data.MeleeTime = nil
			end
		end,
		ShouldCrouch = function(self,data)
			if data.Crouch then return true end
		end,
		OnInjured = function(self,data,dmg)
			if !data.Crouch and self.CanCrouch and math.random(1,3)==1 then
				data.Crouch = true
			end
		end,
		CustomAimVector = function(self,data)
			if self.IsSeeEnemy and !self:IsControlledByPlayer() then
				local dir = self.LastEnemyShootPos-self:GetShootPos()
				dir:Normalize()
				
				return dir
			end
		end,
	},
	["movement_handler"] = {
		OnStart = function(self,data)
			self:StartTask("movement_wait",{Wait = 1.1})
		end,
		ModifyMovementSpeed = function(self,data,speed)
			if self.sb_anb_pd2_taserattacked and CurTime()<self.sb_anb_pd2_taserattacked then return 0 end
		
			if self:PathIsValid() then
				if !self:ShouldAccurateMotionBeDisabled() then
					local fr = self:GetAccurateMotionFraction()
					
					if fr>0 then
						return math.max(self.AccurateMotionMinSpeed,speed*(1-fr))
					end
				end
			end
		end,
		StartControlByPlayer = function(self,data,ply)
			self:GetPath():Invalidate()
		end,
	},
	["movement_select"] = {
		OnStart = function(self,data)
			local task,tdata = "movement_wait",{}
			
			if self.GroupData and self.GroupData.Leader!=self and IsValid(self.GroupData.Leader) then
				task = "movement_followleader"
			elseif self.OwnerLeader and IsValid(self.Owner) then
				task,tdata = "movement_followleader",{LeaderIsOwner = true,Tolerance = 150}
			else
				if self.IsSeeEnemy then
					task = "movement_followenemy"
				elseif self.LastEnemyPosition then
					task,tdata = "movement_topos",{Pos = self.LastEnemyPosition}
					self.LastEnemyPosition = nil
				else
					local lasttime = self.LastEnemyTime and math.max(self:GetCreationTime(),self.LastEnemyTime) or self:GetCreationTime()
					
					if self.ClassData.Type=="Police" and self.PoliceChase and IsValid(self.Owner) and CurTime()-lasttime>1 then
						task,tdata = "movement_traveling",{Pos = self.Owner:GetPos()}
					else
						task = "movement_traveling"
					end
				end
			end
			
			self:TaskComplete("movement_select")
			self:StartTask(task,tdata)
		end,
	},
	["movement_wait"] = {
		OnStart = function(self,data)
			data.Wait = CurTime()+(data.Wait or math.random(3,10))
		end,
		BehaveUpdate = function(self,data)
			if CurTime()>=data.Wait then
				self:TaskComplete("movement_wait")
				self:StartTask("movement_select")
			end
		end,
	},
	["movement_followleader"] = {
		OnStart = function(self,data)
			data.Tolerance = data.Tolerance or self.FinalGoalDistance
			data.GetLeader = function() return data.LeaderIsOwner and self.Owner or self.GroupData.Leader end
		
			local pos = data.GetLeader():GetPos()
			
			if self:GetRangeTo(pos)<data.Tolerance and self:CanSeePosition(data.GetLeader()) then
				self:TaskComplete("movement_followleader")
				self:StartTask("movement_wait",{Wait = math.Rand(1,3)})
				
				return
			end
			
			if !self:SetupPath(pos) then
				self:TaskFail("movement_followleader")
				self:StartTask("movement_wait",{Wait = math.Rand(1,3)})
				
				return
			end
		end,
		BehaveUpdate = function(self,data)
			local leader = data.GetLeader()
		
			if !IsValid(leader) then
				self:TaskFail("movement_followleader")
				self:StartTask("movement_wait",{Wait = math.Rand(1,3)})
				
				return
			end
			
			local pos = leader:GetPos()
			if pos:Distance(self:GetPathPos())>50 and !self:SetupPath(pos) then
				self:TaskFail("movement_followleader")
				self:StartTask("movement_wait",{Wait = math.Rand(1,3)})
				
				return
			end
			
			local state = self:ControlPath(!self.IsSeeEnemy)
			
			if state or state==nil and self:GetRangeTo(self:GetPathPos())<data.Tolerance and self:CanSeePosition(leader) then
				self:TaskComplete("movement_followleader")
				self:StartTask("movement_wait",{Wait = math.Rand(1,3)})
			elseif state==false then
				self:TaskFail("movement_followleader")
				self:StartTask("movement_wait",{Wait = math.Rand(1,3)})
			end
		end,
		OnDelete = function(self,data)
			self:GetPath():Invalidate()
		end,
		ShouldCrouch = function(self,data)
			if data.LeaderIsOwner then
				if IsValid(self.Owner) and self.Owner:IsPlayer() and self.Owner:Crouching() then return true end
			else
				if IsValid(self.GroupData.Leader) and self.GroupData.Leader!=self and self.GroupData.Leader:IsCrouching() then return true end
			end
		end,
		ShouldRun = function(self,data)
			if data.LeaderIsOwner then
				if IsValid(self.Owner) and self:GetRangeTo(self.Owner)>300 then return true end
			else
				if IsValid(self.GroupData.Leader) and self.GroupData.Leader!=self and self.GroupData.Leader:ShouldRun() then return true end
			end
		end,
	},
	["movement_followenemy"] = {
		OnStart = function(self,data)
			if !IsValid(self:GetEnemy()) then
				self:TaskFail("movement_followenemy")
				self:StartTask("movement_wait")
				
				return
			end
		
			local pos = self:GetEnemy():GetPos()
			
			if self:GetRangeTo(pos)<self.FinalGoalDistance then
				self:TaskComplete("movement_followenemy")
				self:StartTask("movement_wait")
				
				return
			end
			
			if !self:SetupPath(pos) then
				self:TaskFail("movement_followenemy")
				self:StartTask("movement_wait")
				
				return
			end
		end,
		BehaveUpdate = function(self,data)
			local state = self:ControlPath(!self.IsSeeEnemy)
			
			if state or state==nil and self:GetRangeTo(self:GetPathPos())<self.FinalGoalDistance then
				self:TaskComplete("movement_followenemy")
				self:StartTask("movement_wait")
			elseif state==false then
				self:TaskFail("movement_followenemy")
				self:StartTask("movement_wait")
			end
		end,
		OnDelete = function(self,data)
			self:GetPath():Invalidate()
		end,
	},
	["movement_topos"] = {
		OnStart = function(self,data)
			if self:GetRangeTo(data.Pos)<self.FinalGoalDistance then
				self:TaskComplete("movement_topos")
				self:StartTask("movement_wait")
				
				return
			end
			
			if !self:SetupPath(data.Pos) then
				self:TaskFail("movement_topos")
				self:StartTask("movement_wait")
				
				return
			end
		end,
		BehaveUpdate = function(self,data)
			local state = self:ControlPath(!self.IsSeeEnemy)
			
			if state then
				self:TaskComplete("movement_topos")
				self:StartTask("movement_wait")
			elseif state==false then
				self:TaskFail("movement_topos")
				self:StartTask("movement_wait")
			end
		end,
		OnDelete = function(self,data)
			self:GetPath():Invalidate()
		end,
		OnIsSeeEnemyChanged = function(self,data,see)
			if see and self.ClassData.Aggressive and (!self.OwnerLeader or !IsValid(self.Owner)) then
				self:TaskFail("movement_topos")
				self:StartTask("movement_followenemy")
			end
		end,
	},
	["movement_traveling"] = {
		OnStart = function(self,data)
			local pos = data.Pos or self:GetTravelingPosition()
		
			if !pos then
				self:TaskFail("movement_traveling")
				self:StartTask("movement_wait")
				
				return
			end
		
			if self:GetRangeTo(pos)<self.FinalGoalDistance then
				self:TaskComplete("movement_traveling")
				self:StartTask("movement_wait")
				
				return
			end
			
			if !self:SetupPath(pos) then
				self:TaskFail("movement_traveling")
				self:StartTask("movement_wait")
				
				return
			end
			
			data.Crouch = math.random(1,3)==1
		end,
		BehaveUpdate = function(self,data)
			local state = self:ControlPath(!self.IsSeeEnemy)
			
			if state then
				self:TaskComplete("movement_traveling")
				self:StartTask("movement_wait")
			elseif state==false then
				self:TaskFail("movement_traveling")
				self:StartTask("movement_wait")
			end
		end,
		OnDelete = function(self,data)
			self:GetPath():Invalidate()
		end,
		OnIsSeeEnemyChanged = function(self,data,see)
			if see and self.ClassData.Aggressive and (!self.OwnerLeader or !IsValid(self.Owner)) then
				self:TaskFail("movement_traveling")
				self:StartTask("movement_followenemy")
			end
		end,
		ShouldCrouch = function(self,data)
			if data.Crouch then return true end
		end,
		ShouldRun = function(self,data)
			return !self.IsSeeEnemy
		end,
	},
	["animation_handler"] = {
		OnInjured = function(self,data,dmg)
			if self:ShouldDoHeavyDamage() and !self:IsPostureActive() and (dmg:IsBulletDamage() or dmg:IsExplosionDamage()) and math.random()<dmg:GetDamage()/self:Health() then
				local pos = dmg:IsBulletDamage() and IsValid(dmg:GetAttacker()) and self:EntShootPos(dmg:GetAttacker()) or dmg:GetDamagePosition()
				local dir = pos-self:GetPos()
				dir.z = 0
				dir:Normalize()
				
				local dot = self:GetAngles():Forward():Dot(dir)
				local t = self.HeavyDamageAnimations[dot>0 and "front" or "back"]
				
				self:DoPosture(t[self.LastHitGroup] or t.other)
				
				self:RunTask("OnTakeHeavyDamage",dmg)
			end
			
			if dmg:IsExplosionDamage() and self.HelmetsConvar:GetBool() and !self.HelmetBreaked then
				self.HelmetBreaked = true
				self:HelmetBreak()
			end
		end,
		PreventBecomeRagdollOnKilled = function(self,data,dmg)
			if dmg:IsBulletDamage() and !self:IsPostureActive() then
				local pos = IsValid(dmg:GetAttacker()) and self:EntShootPos(dmg:GetAttacker()) or dmg:GetDamagePosition()
				local dir = pos-self:GetPos()
				dir.z = 0
				dir:Normalize()
				
				local dot = self:GetAngles():Forward():Dot(dir)
				local t = self.DeathAnimations[dot>0 and "front" or "back"]
				
				timer.Simple(self:DoPosture(t[self.LastHitGroup] or t.other,false,1,true),function()
					if IsValid(self) then
						self:DropWeapon(nil,true)
						self:BecomeRagdoll(DamageInfo())
					end
				end)
				
				data.DeathAnim = true
				
				return true
			end
		end,
		OnKilledBeforeWeaponDrop = function(self,data,wep)
			data.DroppedWeapon = wep
			
			if self.WeaponsConvar:GetInt()==1 then
				SafeRemoveEntityDelayed(self:GetActiveWeapon(),10)
			end
		end,
		OnKilled = function(self,data,dmg)
			if dmg:IsBulletDamage() and self.LastHitGroup==HITGROUP_HEAD and self.HelmetsConvar:GetBool() and !self.HelmetBreaked then
				self.HelmetBreaked = true
				self:HelmetBreak()
			end
			
			if data.DeathAnim and IsValid(data.DroppedWeapon) then
				self:SetupWeapon(data.DroppedWeapon)
			end
		end,
		DisableBehaviour = function(self,data)
			if data.DeathAnim then
				return true
			end
		end,
		TranslateActivity = function(self,data,act)
			if self:ShouldWeaponBeDowned() then
				local wep = self:GetActiveWeapon()
				
				if IsValid(wep) then
					local passiveact = self.PassiveHoldTypes[wep:GetHoldType()=="crossbow" and "ar2" or wep:GetHoldType()]
					
					if passiveact then
						return self.PassiveActivities[passiveact][act]
					end
				end
			end
			
			if self:HasWeapon() and self:GetActiveWeapon():GetHoldType()=="crossbow" then
				return self.CrossbowActivities[act]
			end
		end,
	},
	["enemy_handler"] = {
		OnStart = function(self,data)
			data.UpdateEnemies = CurTime()
			data.HasEnemy = false
			self.IsSeeEnemy = false
			self.LastEnemyTime = 0
			self:SetEnemy(NULL)
		end,
		BehaveUpdate = function(self,data,interval)
			local prevenemy = self:GetEnemy()
			local newenemy = prevenemy
			local issee = self.IsSeeEnemy
			
			if !data.UpdateEnemies or CurTime()>data.UpdateEnemies or data.HasEnemy and !IsValid(prevenemy) then
				data.UpdateEnemies = CurTime()+1
				
				self:FindEnemies()
				
				local enemy = self:FindPriorityEnemy()
				if IsValid(enemy) then
					newenemy = enemy
					self.IsSeeEnemy = self:CanSeePosition(enemy)
				end
			end
			
			if IsValid(newenemy) then
				if !data.HasEnemy then
					self:RunTask("OnEnemyFound",newenemy)
				elseif prevenemy!=newenemy then
					self:RunTask("OnEnemyChanged",newenemy,prevenemy)
				end
				
				data.HasEnemy = true
				
				if self:CanSeePosition(newenemy) then
					self.LastEnemyShootPos = self:EntShootPos(newenemy)
					self.LastEnemyEyePos = newenemy:EyePos()
					
					self:UpdateEnemyMemory(newenemy,newenemy:GetPos())
				end
			else
				if data.HasEnemy then
					self:RunTask("OnEnemyLost",prevenemy)
				end
				
				data.HasEnemy = false
				self.IsSeeEnemy = false
			end
			
			self:SetEnemy(newenemy)
			
			if self.IsSeeEnemy!=issee then
				self:RunTask("OnIsSeeEnemyChanged",self.IsSeeEnemy)
			end
			
			if self.IsSeeEnemy and IsValid(newenemy) then
				self.LastEnemyPosition = newenemy:GetPos()
				self.LastEnemyTime = CurTime()
			end
		end,
	},
	["group_handler"] = {
		OnKilled = function(self,data)
			if self.GroupData.Leader==self then
				for k,v in ipairs(self.GroupData.Members) do
					if IsValid(v) and v:Health()>0 and self!=v then
						self.GroupData.Leader = v
					end
				end
			end
		end,
		Think = function(self,data)
			if !IsValid(self.GroupData.Leader) then
				self:Remove()
			end
		end,
	},
	["voice_handler"] = {
		OnStart = function(self,data)
			data.PlaySound = function(snds)
				if !snds or !self.VoiceConvar:GetBool() then return end
			
				if data.CurSnd then
					self:StopSound(data.CurSnd)
				end
				
				local snd = table.Random(snds)
				
				data.CurSnd = snd
				self:EmitSound("sb_anb_payday2/"..snd)
			end
		end,
		OnKilled = function(self,data)
			data.PlaySound(self.ClassData.Voices and self.ClassData.Voices.death and self.Voices.Death[self.ClassData.Voices.death])
		end,
		OnMedicHelp = function(self,data,ent)
			if self.ClassData.Voices and self.ClassData.Voices.medic then
				data.PlaySound(self.Voices.MedicHelp)
			end
		end,
		OnIsSeeEnemyChanged = function(self,data,see)
			if see and (!data.SeeEnemyEmit or CurTime()>=data.SeeEnemyEmit) then
				data.SeeEnemyEmit = CurTime()+10
				
				data.PlaySound(self.ClassData.Voices and self.ClassData.Voices.onsee and self.Voices.OnSeeEnemy[self.ClassData.Voices.onsee])
			end
		end,
		OnBulldozerVisorBreak = function(self,data,dmg)
			data.PlaySound(self.Voices.BulldozerVisorBreak)
		end,
		OnCloakerPunch = function(self,data,enemy)
			//data.PlaySound(self.Voices.CloakerPunch)
		end,
	},
}

ENT.UniqueTasks = {
	["shield"] = {
		OnStart = function(self,data)
			local sdata = self.Shields[self.ClassData.Shield]
			
			data.Shield = ents.Create("sb_advanced_nextbot_payday2_shield")
			data.Shield:SetModel(sdata.Model)
			data.Shield.Owner = self.Owner
			data.Shield:Spawn()
			data.Shield:Parent(self,self:LookupBone(sdata.Bone) or 0,sdata.Pos,sdata.Ang)
		end,
		OnKilled = function(self,data)
			if !IsValid(data.Shield) then return end
		
			if self.ShieldsConvar:GetBool() then
				data.Shield:TransformToProp()
			else
				data.Shield:Remove()
			end
		end,
		OnDelete = function(self,data)
			SafeRemoveEntity(data.Shield)
		end,
		ShouldWeaponBeDowned = function(self,data)
			return false
		end,
	},
	["heavyarmor"] = {
		OnInjured = function(self,data,dmg)
			if dmg:IsBulletDamage() and (self.LastHitGroup==HITGROUP_CHEST or self.LastHitGroup==HITGROUP_STOMACH) then
				local pos = IsValid(dmg:GetAttacker()) and self:EntShootPos(dmg:GetAttacker()) or dmg:GetDamagePosition()
				local dir = pos-self:GetPos()
				dir.z = 0
				dir:Normalize()
				
				local dot = self:GetAngles():Forward():Dot(dir)
				
				if dot>=0 then
					dmg:SetDamage(0)
				end
			end
		end,
	},
	["taser"] = {
		OnStart = function(self,data)
			data.State = 0
			data.Time = 0
			data.Enemy = nil
			
			data.CanUseTaser = function()
				if !self.IsSeeEnemy then return false end
				if !self:HasWeapon() or (self:GetActiveWeapon():GetClass()!="sb_anb_payday2_m4_taser" and self:GetActiveWeapon():GetClass()!="sb_anb_payday2_r870_taser") then return false end
			
				local enemy = self:GetEnemy()
				if !IsValid(enemy) then return false end
				
				if self.ENEMY_NO_SPECIAL_ATTACK[enemy:GetClass()] then return false end
				
				if enemy:GetClass()!=self:GetClass() and !enemy:IsPlayer() and (enemy.SBAdvancedNextBot or !enemy:IsNPC()) then return false end
				
				if self:GetRangeTo(enemy)>300 then return false end
				
				if enemy.sb_anb_pd2_taserattacked and CurTime()<enemy.sb_anb_pd2_taserattacked and enemy.sb_anb_pd2_taserattacker!=self then return false end
				
				return true
			end
			
			data.CanTaserAttack = function(enemy)
				local pos = self:EntShootPos(enemy)
				
				local dir = pos-self:GetShootPos()
				dir.z = 0
				dir:Normalize()
				
				if math.deg(math.acos(self:GetAngles():Forward():Dot(dir)))>20 then return false end
				
				if self:CheckAttackPathBlocked(self:GetShootPos(),self:EntShootPos(enemy),{self,enemy}) then return false end
				
				return true
			end
		end,
		BehaveUpdate = function(self,data,interval)
			if data.State==0 and data.CanUseTaser() then
				data.State = 1
				data.Time = CurTime()+1
				
				self:EmitSound("sb_anb_payday2/taser/attack/208969068.mp3",70)
			elseif data.State==1 and CurTime()>=data.Time then
				data.State = 2
			elseif data.State==2 and data.CanUseTaser() and data.CanTaserAttack(self:GetEnemy()) then
				data.State = 3
				data.Time = 0
				data.Enemy = self:GetEnemy()
				
				self:SetNWBool("TaserActive",true)
			end
			
			if data.State==3 then
				if data.CanUseTaser() and data.Enemy==self:GetEnemy() then
					local enemy = data.Enemy
				
					if data.CanTaserAttack(enemy) and CurTime()>=data.Time then
						data.Time = CurTime()+math.Rand(0.5,1)
						
						local npc
						
						enemy.sb_anb_pd2_taserattacked = CurTime()+1
						enemy.sb_anb_pd2_taserattacker = self
						
						if enemy:GetClass()==self:GetClass() then
							enemy:ViewPunch(Angle(math.Rand(-100,100),math.Rand(-100,100)))
						elseif enemy:IsPlayer() then
							enemy:SetNWFloat("sb_anb_pd2_taserattacked",CurTime()+1)
							enemy:ViewPunch(Angle(math.Rand(-100,100),math.Rand(-100,100)))
						elseif enemy:IsNPC() then
							npc = true
							
							enemy:SetSchedule(SCHED_FLINCH_PHYSICS)
						end
						
						local dmg = DamageInfo()
						dmg:SetAttacker(self)
						dmg:SetInflictor(self:GetActiveWeapon())
						dmg:SetDamage(10)
						dmg:SetDamageType(DMG_SHOCK)
						dmg:SetDamagePosition(self:EntShootPos(enemy))
						
						enemy:StopSound("sb_anb_payday2/taser/attack/taserattack.ogg")
						enemy:EmitSound("sb_anb_payday2/taser/attack/taserattack.ogg",70)
						
						enemy:TakeDamageInfo(dmg)
					end
				else
					data.State = 0
					self:SetNWBool("TaserActive",false)
				end
			end
		end,
		StartControlByPlayer = function(self,data,ply)
			data.State = 0
			self:SetNWBool("TaserActive",false)
		end,
		OnTakeHeavyDamage = function(self,data)
			data.State = 0
			self:SetNWBool("TaserActive",false)
		end,
		ShouldAttack = function(self,data,pos)
			if data.State==3 then return false end
		end,
	},
	["medic"] = {
		OnStart = function(self,data)
			data.HealTime = 0
		end,
		OnOtherInjured = function(self,data,ent,dmg)
			if self.Team==ent.Team and CurTime()>=data.HealTime and ent:Health()-dmg:GetDamage()<=ent:GetMaxHealth()*0.25 and self:GetRangeTo(ent)<150 then
				data.HealTime = CurTime()+3
				dmg:SetDamage(0)
				
				ent:SetHealth(ent:GetMaxHealth())
				
				self:DoGesture(ACT_GMOD_GESTURE_BECON,2,true)
				
				self:RunTask("OnMedicHelp",ent)
			end
		end,
	},
	["movement_winters_phalanx"] = {
		As = "movement_followleader",
		DontStart = true,
		OnStart = function(self,data)
			data.Tolerance = data.Tolerance or self.FinalGoalDistance
			data.GetLeader = function() return data.LeaderIsOwner and self.Owner or self.GroupData.Leader end
		
			data.GetPosition = function()
				local leader = data.GetLeader()
				if !IsValid(leader) or leader==self then return end
				
				local cnum,num = 0
				
				for k,v in ipairs(self.GroupData.Members) do
					if IsValid(v) and v!=leader then
						cnum = cnum+1
						
						if v==self then num = cnum end
					end
				end
				
				if !num then return end
				
				local ang = math.rad(360/cnum*num)
				local rad = 70
				local pos = leader:GetPos()
				
				pos.x = pos.x+math.sin(ang)*rad
				pos.y = pos.y+math.cos(ang)*rad
				
				return pos
			end
			
			local pos = data.LeaderIsOwner and data.GetLeader():GetPos() or data.GetPosition()
		
			if !pos then
				self:TaskFail("movement_followleader")
				self:StartTask("movement_wait",{Wait = math.Rand(1,3)})
				
				return
			end
			
			if self:GetRangeTo(pos)<data.Tolerance and self:CanSeePosition(data.GetLeader()) then
				self:TaskComplete("movement_followleader")
				self:StartTask("movement_wait",{Wait = math.Rand(1,3)})
				
				return
			end
			
			if !self:SetupPath(pos) then
				self:TaskFail("movement_followleader")
				self:StartTask("movement_wait",{Wait = math.Rand(1,3)})
				
				return
			end
		end,
		BehaveUpdate = function(self,data)
			local leader = data.GetLeader()
		
			if !IsValid(leader) then
				self:TaskFail("movement_followleader")
				self:StartTask("movement_wait",{Wait = math.Rand(1,3)})
				
				return
			end
			
			local pos = data.LeaderIsOwner and leader:GetPos() or data.GetPosition()
			if !pos then
				self:TaskFail("movement_followleader")
				self:StartTask("movement_wait",{Wait = math.Rand(1,3)})
				
				return
			end
			
			if pos:Distance(self:GetPathPos())>50 and !self:SetupPath(pos) then
				self:TaskFail("movement_followleader")
				self:StartTask("movement_wait",{Wait = math.Rand(1,3)})
				
				return
			end
			
			local state = self:ControlPath(!self.IsSeeEnemy)
			
			if state or state==nil and data.LeaderIsOwner and self:GetRangeTo(pos)<data.Tolerance and self:CanSeePosition(leader) then
				self:TaskComplete("movement_followleader")
				self:StartTask("movement_wait",{Wait = math.Rand(1,3)})
			elseif state==false then
				self:TaskFail("movement_followleader")
				self:StartTask("movement_wait",{Wait = math.Rand(1,3)})
			end
		end,
		OnDelete = function(self,data)
			self:GetPath():Invalidate()
		end,
		ShouldCrouch = function(self,data)
			if data.LeaderIsOwner then
				if IsValid(self.Owner) and self.Owner:IsPlayer() and self.Owner:Crouching() then return true end
			else
				if IsValid(self.GroupData.Leader) and self.GroupData.Leader!=self and self.GroupData.Leader:IsCrouching() then return true end
			end
		end,
		ShouldRun = function(self,data)
			if data.LeaderIsOwner then
				if IsValid(self.Owner) and self:GetRangeTo(self.Owner)>300 then return true end
			else
				if IsValid(self.GroupData.Leader) and self.GroupData.Leader!=self and self.GroupData.Leader:ShouldRun() then return true end
			end
		end,
	},
	["bulldozer"] = {
		OnStart = function(self,data)
			local mp = self:GetMaxHealth()/2000
		
			data.Visor1HP = 150*mp
			data.Visor2HP = 160*mp
			data.Visor2HPmax = data.Visor2HP
		end,
		OnInjured = function(self,data,dmg)
			if dmg:IsBulletDamage() then
				if self.LastHitGroup!=HITGROUP_HEAD then return end
			
				local pos = IsValid(dmg:GetAttacker()) and self:EntShootPos(dmg:GetAttacker()) or dmg:GetDamagePosition()
				local dir = pos-self:GetPos()
				dir.z = 0
				dir:Normalize()
				
				local dot = self:GetAngles():Forward():Dot(dir)
				
				if dot<0 or data.Visor2HP>0 then
					dmg:ScaleDamage(1/self.ClassData.HeadshotMultiplier)
				end
				
				if dot<0 then return end
			end
			
			if data.Visor2HP<=0 or !dmg:IsBulletDamage() and !dmg:IsExplosionDamage() then return end
			
			if data.Visor1HP>0 then
				data.Visor1HP = data.Visor1HP-dmg:GetDamage()
				
				if dmg:IsBulletDamage() then dmg:SetDamage(0) end
				
				if data.Visor1HP<=0 then
					self:SetBodygroup(self.VariantData.Visor1Break[1],self.VariantData.Visor1Break[2])
					self:EmitSound("sb_anb_payday2/bulldozer/visorbreak/24f2ffcd.mp3",70)
				end
			elseif data.Visor2HP/data.Visor2HPmax>0.5 then
				data.Visor2HP = data.Visor2HP-dmg:GetDamage()
				
				if dmg:IsBulletDamage() then dmg:SetDamage(0) end
				
				if data.Visor2HP/data.Visor2HPmax<=0.5 then
					self:SetBodygroup(self.VariantData.Visor2Break1[1],self.VariantData.Visor2Break1[2])
				end
			end
			
			if data.Visor2HP/data.Visor2HPmax<=0.5 then
				data.Visor2HP = data.Visor2HP-dmg:GetDamage()
				
				if dmg:IsBulletDamage() then dmg:SetDamage(0) end
				
				if data.Visor2HP<=0 then
					self:SetBodygroup(self.VariantData.Visor2Break2[1],self.VariantData.Visor2Break2[2])
					self:EmitSound("sb_anb_payday2/bulldozer/visorbreak/0cdfd269.mp3",70)
					
					self:RunTask("OnBulldozerVisorBreak",dmg)
				end
			end
		end,
		ShouldWeaponBeDowned = function(self,data)
			return false
		end,
		OnFootstep = function(self,data,pos,foot,snd,volume,filter)
			local sounds = {"392e7b89","28ca8176","11f7f77d","1d9dc49e"}
			
			self:EmitSound("sb_anb_payday2/bulldozer/footsteps/"..table.Random(sounds)..".mp3",70,100,volume,CHAN_BODY)
		
			return true
		end,
	},
	["cloaker"] = {
		OnStart = function(self,data)
			data.ChargeCooldown = 0
			
			data.CanCharge = function()
				if self.sb_anb_pd2_taserattacked and CurTime()<self.sb_anb_pd2_taserattacked then return false end
				
				if self:IsOnFire() then return false end
				
				return true
			end
			
			data.CanContinueCharge = function()
				if !data.CanCharge() then return false end
				
				local enemy = data.ChargeEnemy
				
				if !IsValid(enemy) then return false end
				if !self:ShouldBeEnemy(enemy) then return false end
				
				if !self:PathIsValid() and !self:SetupPath(enemy:GetPos()) then return false end
			
				return true
			end
			
			data.CanStartCharge = function()
				if CurTime()<data.ChargeCooldown then return false end
				if !data.SeeEnemy or CurTime()<data.SeeEnemy then return false end
				
				if !data.CanCharge() then return false end
				
				local enemy = self:GetEnemy()
				if !IsValid(enemy) then return false end
				
				if self.ENEMY_NO_SPECIAL_ATTACK[enemy:GetClass()] then return false end
				
				if self:GetRangeTo(enemy)>400 then return false end
				
				local path = self:UsingNodeGraph() and self:NodeGraphPath() or Path("Follow")
				local generator = !self:UsingNodeGraph() and function(area,from,ladder,elevator,len) return self:NavMeshPathCostGenerator(self:GetPath(),area,from,ladder,elevator,len) end or nil
				
				path:SetMinLookAheadDistance(self.PathMinLookAheadDistance)
				path:SetGoalTolerance(self.PathGoalTolerance)
				
				if !path:Compute(self,enemy:GetPos(),generator) or path:GetLength()>400 then return false end
				
				return true
			end
			
			data.StartCharge = function(enemy)
				if data.ChargeActive then return end
				data.ChargeActive = true
				
				data.ChargeEnemy = enemy
				data.ChargePos = enemy:GetPos()
				
				self:SetSkin(self.VariantData.ChargeOn)
				self:EmitSound("sb_anb_payday2/cloaker/414027436.mp3",70)
				self:SetNWBool("CloakerActive",true)
				
				for k,v in pairs(self.m_ActiveTasks) do
					if k!="movement_handler" and k:StartWith("movement_") then
						self:TaskFail(k)
					end
				end
				
				self:TaskFail("attack_handler")
				self:TaskFail("enemy_handler")
			end
			
			data.StopCharge = function()
				if !data.ChargeActive then return end
				data.ChargeActive = false
				
				data.ChargeEnemy = nil
				data.ChargePos = nil
				
				self:SetSkin(self.VariantData.ChargeOff)
				self:StopSound("sb_anb_payday2/cloaker/414027436.mp3")
				self:SetNWBool("CloakerActive",false)
				
				self:StartTask("movement_wait")
				self:StartTask("attack_handler")
				self:StartTask("enemy_handler")
				
				data.StopPunch()
			end
			
			data.PerformPunch = function(enemy)
				data.Punching = true
				data.ChargeCooldown = CurTime()+15
				
				self:DoPosture("pd2_cloakerkick_"..math.random(1,2),true)
				
				local ang = (self:EntShootPos(enemy)-self:GetPos()):Angle()
				ang.p = 0
				ang.r = 0
				
				self:SetAngles(ang)
				
				timer.Simple(0.33,function()
					if !data.Punching or !IsValid(self) or self:Health()<=0 then return end
					
					if IsValid(enemy) and self:ShouldBeEnemy(enemy) then
						local dmg = DamageInfo()
						dmg:SetDamage(5000)
						dmg:SetAttacker(self)
						dmg:SetInflictor(self)
						dmg:SetDamageType(DMG_CLUB)
						dmg:SetDamagePosition(self:EntShootPos(enemy))
						
						enemy:EmitSound("sb_anb_payday2/cloaker/53645521.mp3",65)
						enemy:TakeDamageInfo(dmg)
						
						if enemy:IsPlayer() and enemy:Alive() then
							enemy:ViewPunch(Angle(-20,math.Rand(-20,20),math.Rand(-20,20)))
						end
						
						self:RunTask("OnCloakerPunch",enemy)
					end
					
					data.StopCharge()
				end)
			end
			
			data.StopPunch = function()
				data.Punching = false
			end
			
			self:EmitSound("sb_anb_payday2/cloaker/3fc77bd7.wav",65)
			
			local index = self:EntIndex().."cloakersound"
			hook.Add("EntityRemoved",index,function(ent)
				if ent==self then
					hook.Remove("EntityRemoved",index)
					
					data.StopCharge()
					self:StopSound("sb_anb_payday2/cloaker/3fc77bd7.wav")
				end
			end)
		end,
		OnIsSeeEnemyChanged = function(self,data,see)
			if see then
				data.SeeEnemy = CurTime()+math.Rand(1,3)
			else
				data.SeeEnemy = nil
			end
		end,
		BehaveUpdate = function(self,data,interval)
			if !data.ChargeActive and !data.Punching then
				
				if data.CanStartCharge() then
					data.StartCharge(self:GetEnemy())
				end
			end
			
			if data.ChargeActive and !data.Punching then
				if !data.CanContinueCharge() then
					data.StopCharge()
				else
					local enemy = data.ChargeEnemy
					local pos = enemy:GetPos()
					local dist = pos:Distance(data.ChargePos)>50
				
					if dist and !self:SetupPath(pos,{tolerance = 50}) then
						data.StopCharge()
					else
						if dist then
							data.ChargePos = pos
						end
						
						if self:ControlPath(true) or self:GetRangeTo(enemy)<50 and !self:CheckAttackPathBlocked(self:GetShootPos(),self:EntShootPos(enemy),{self,enemy}) then
							self:GetPath():Invalidate()
							
							data.PerformPunch(enemy)
						end
					end
				end
			end
		end,
		StartControlByPlayer = function(self,data,ply)
			data.StopCharge()
		end,
		OnKilled = function(self,data)
			data.StopCharge()
			self:StopSound("sb_anb_payday2/cloaker/3fc77bd7.wav")
		end,
		ShouldWeaponBeDowned = function(self,data)
			if data.ChargeActive then return true end
		end,
		ShouldDoHeavyDamage = function(self,data)
			if data.ChargeActive then return false end
		end,
		ShouldRun = function(self,data)
			if data.ChargeActive then return true end
		end,
		ShouldAccurateMotionBeDisabled = function(self,data)
			if data.ChargeActive then return true end
		end,
	},
}
hook.Run("SB_ANB_PAYDAY2_SetupUniqueTasks",ENT.UniqueTasks)

ENT.Shields = {
	["SWAT"] = {
		Model = Model("models/payday2/shield_swat.mdl"),
		Bone = "ValveBiped.Bip01_L_Hand",
		
		Pos = Vector(-3,0,-14),
		Ang = Angle(0,-90,-3),
	},
	["FBI"] = {
		Model = Model("models/payday2/shield_fbi.mdl"),
		Bone = "ValveBiped.Bip01_L_Hand",
		
		Pos = Vector(-2,0,-16),
		Ang = Angle(-3,180,0),
	},
	["Zeal"] = {
		Model = Model("models/mark2580/payday2/pd2_swat_shield_zeal_shield.mdl"),
		Bone = "ValveBiped.Bip01_L_Hand",
		
		Pos = Vector(0,2,-45),
		Ang = Angle(0,90,3),
	},
	["Winters"] = {
		Model = Model("models/payday2/shield_captain.mdl"),
		Bone = "ValveBiped.Bip01_L_Hand",
		
		Pos = Vector(-3,-6,-8),
		Ang = Angle(0,-90,-3),
	},
	["WintersPhalanx"] = {
		Model = Model("models/payday2/shield_captain_guard.mdl"),
		Bone = "ValveBiped.Bip01_L_Hand",
		
		Pos = Vector(-3,-6,-8),
		Ang = Angle(0,-90,-3),
	},
}

function ENT:Setup(class,spawndata)
	local data = self.BotClasses[class]
	
	if !data then
		ErrorNoHalt("Unknown Bot class '"..tostring(class).."' for SB ANB PAYDAY 2\n")
	
		self:Remove()
		return
	end
	
	local team = data.Type..":"..spawndata.team

	self:SetTeam(team)
	self.Team = team
	self.Side = spawndata.side
	self.PSide = spawndata.pside
	self.HPDiff = spawndata.hpdiff
	self.OwnerLeader = spawndata.ownerleader
	self.PoliceChase = spawndata.policechase
	
	self:CollisionRulesChanged()
	
	if spawndata.proficiency>0 then
		self:SetCurrentWeaponProficiency(spawndata.proficiency-1)
	end
	
	local variant = data.Variants[spawndata.variant>0 and math.Clamp(spawndata.variant,1,#data.Variants) or math.random(1,#data.Variants)]
	
	self.ClassData = data
	self.VariantData = variant
	
	self:SetModel(variant.Model)
	self:SetSkin(variant.Skin)
	for k,v in ipairs(variant.Bodygroups) do self:SetBodygroup(k,v) end
	
	local hp = data.Health*self.DifficultyData[spawndata.hpdiff].HP
	
	self:SetMaxHealth(hp)
	self:SetHealth(hp)
	
	self.RunSpeed = data.RunSpeed
	self.MoveSpeed = data.WalkSpeed
	self.WalkSpeed = data.SlowWalkSpeed
	self.AimSpeed = data.AimSpeed
	
	self.CanCrouch = data.CanCrouch
	
	if !data.CanJump then
		self.JumpHeight = 0
		self.MaxJumpToPosHeight = 0
		self.loco:SetJumpHeight(0)
	else
		self:CapabilitiesAdd(CAP_MOVE_JUMP)
	end
	
	if !self:HasWeapon() then
		self:Give(variant.Weapon)
	end
	
	self:SetupRelationships()
end

function ENT:SetupGroup(group,spawndata)
	local data = self.BotGroups[group]
	
	if !data then
		ErrorNoHalt("Unknown Bot group '"..tostring(group).."' for SB ANB PAYDAY 2\n")
	
		self:Remove()
		return
	end
	
	self:Setup(data.LeaderClass,spawndata)
	
	self.GroupData = {Leader = self,Members = {self}}
	
	local undoents
	
	for i=1,math.random(data.Min,data.Max)-1 do
		local member = ents.Create("sb_advanced_nextbot_payday2")
		
		table.insert(self.GroupData.Members,member)
		member.GroupData = self.GroupData
		
		member:SetPos(self:GetPos())
		member:SetAngles(self:GetAngles())
		member:SetCreator(self:GetCreator())
		member.Owner = self.Owner
		member:SetKeyValue("Class",data.MemberClass)
		
		if self:GetKeyValue("additionalequipment") then
			member:SetKeyValue("additionalequipment",self:GetKeyValue("additionalequipment"))
		end
		
		member:Spawn()
	end
	
	timer.Simple(0,function()
		if !IsValid(self) or !self.GroupData then return end
		
		if IsValid(self.Owner) and self.OnDieFunctions then
			for k,v in pairs(self.OnDieFunctions) do
				if k:StartWith("undo") then
					local id = tonumber(k:sub(5,-1))
					
					if id then
						local undos = undo.GetTable()[self.Owner:UniqueID()][id]
						
						for k,v in pairs(self.GroupData.Members) do
							if IsValid(v) and v!=self then
								DoPropSpawnedEffect(v)
							
								table.insert(undos.Entities,v)
							end
						end
					
						break
					end
				end
			end
		end
	end)
	
	return self.GroupData.Members
end

function ENT:SetupTaskList(list)
	for k,v in pairs(self.Tasks) do
		list[k] = v
	end
	
	if self.ClassData.Tasks then
		for k,v in ipairs(self.ClassData.Tasks) do
			list[self.UniqueTasks[v].As or v] = self.UniqueTasks[v]
		end
	end
end

function ENT:SetupTasks()
	self:StartTask("attack_handler")
	self:StartTask("movement_handler")
	self:StartTask("animation_handler")
	self:StartTask("enemy_handler")
	self:StartTask("voice_handler")
	
	if self.GroupData then
		self:StartTask("group_handler")
	end
	
	if self.ClassData.Tasks then
		for k,v in ipairs(self.ClassData.Tasks) do
			if !self.UniqueTasks[v].DontStart then
				self:StartTask(self.UniqueTasks[v].As or v)
			end
		end
	end
end

function ENT:BehaviourThink()
	if self.EntityStuckMoveTo then
		self:Approach(self.EntityStuckMoveTo)
		self.EntityStuckMoveTo = nil
	end
end

function ENT:CheckAttackPathBlocked(start,pos,filter)
	local tr = util.TraceLine({
		start = start,
		endpos = pos,
		filter = filter,
		mask = MASK_SHOT,
	})
	
	return tr.Hit and tr.Entity
end

function ENT:ShouldBeEnemy(ent)
	if !BaseClass.ShouldBeEnemy(self,ent) then return false end
	if ent:IsPlayer() and (!ent:Alive() or ent:HasGodMode()) then return false end
	
	if self:IsMoving() then
		local entdir = self:EntShootPos(ent)-self:GetPos()
		entdir.z = 0
		entdir:Normalize()
		
		local ang = math.deg(math.acos(self:GetEyeAngles():Forward():Dot(entdir)))
		local maxdist = math.Remap(ang,0,180,self.MovingMaxSeeDistances[1],self.MovingMaxSeeDistances[2])
		
		if self:GetRangeTo(ent)>maxdist then return false end
	end
	
	return true
end

function ENT:ShouldAttack(pos)
	local dir = pos-self:GetShootPos()
	dir:Normalize()
	
	local sdir = self:GetEyeAngles():Forward()
	local cos = dir:Dot(sdir)
	local ang = math.deg(math.acos(cos))
	
	if ang>20 then return false end
	
	if self:CheckAttackPathBlocked(self:GetShootPos(),pos,function(ent)
		if ent==self:GetEnemy() or ent==self then return false end
		if ent:GetClass()==self:GetClass() and ent.Team==self.Team then return false end
		if ent:GetClass():StartWith("func_breakable") then return false end
		if ent:GetClass()=="sb_advanced_nextbot_payday2_shield" and ent.ShouldCollide and !ent:ShouldCollide(self) then return false end
		
		return true
	end) then return false end
	
	if self:RunTask("ShouldAttack",pos)==false then return false end 
	
	return true
end

function ENT:ShouldWeaponBeDowned()
	if self:IsControlledByPlayer() then return false end
	if CurTime()<self.m_WeaponData.NextReloadTime then return false end
	
	local hook = self:RunTask("ShouldWeaponBeDowned")
	return hook==nil and !self.IsSeeEnemy or hook
end

function ENT:SetupRelationships()
	for k,v in ipairs(ents.GetAll()) do
		self:SetupEntityRelationship(v)
	end
	
	hook.Add("OnEntityCreated",self,function(self,ent)
		self:SetupEntityRelationship(ent)
	end)
end

function ENT:SetupEntityRelationship(ent)
	local stdd = ENEMY_CLASSES[ent:GetClass()]
	
	if stdd or ent:IsPlayer() or ent:GetClass()==self:GetClass() and ent.Team then
		local d = self:GetDesiredEntityRelationship(ent,stdd)
		self:SetEntityRelationship(ent,d,1)
	
		if ent:IsNPC() then
			ent:AddEntityRelationship(self,d,1)
		end
	end
end

function ENT:OnInjured(dmg)
	BaseClass.OnInjured(self,dmg)
	
	for k,v in ipairs(ents.FindByClass(self:GetClass())) do
		if v==self or v:Health()<=0 then continue end
	
		v:OnOtherInjured(self,dmg)
	end

	if self.PSide!=2 then return end

	local att = dmg:GetAttacker()
	if !IsValid(att) or !att:IsPlayer() then return end
	
	for k,v in ipairs(ents.FindByClass(self:GetClass())) do
		if v.PSide==2 and v.Team==self.Team then
			v:SetEntityRelationship(att,D_HT,2)
		end
	end
end

function ENT:OnOtherInjured(ent,dmg)
	self:RunTask("OnOtherInjured",ent,dmg)
end

function ENT:GetDesiredEntityRelationship(ent,stdd)
	if stdd==ENEMY_MONSTER then return D_HT end
	if stdd==ENEMY_FRIENDLY then return (self.Side==0 or self.Side==2) and D_LI or D_HT end
	if stdd==ENEMY_HOSTILE then return (self.Side==1 or self.Side==2) and D_LI or D_HT end
	
	if ent:GetClass()==self:GetClass() then
		return self.Team==ent.Team and D_LI or D_HT
	end
	
	if ent:IsPlayer() then
		return self.PSide==0 and D_HT or self.PSide==1 and D_LI or D_NU
	end
	
	return D_NU
end

function ENT:HelmetBreak()
	local data = self.VariantData.HelmetBreak
	if !data then return end
	
	self:SetBodygroup(data[1],data[2])
	
	if !data[3] then return end
	
	local m = self:GetBoneMatrix(self:LookupBone("ValveBiped.Bip01_Head1") or 0)
	if !m then return end
	
	local helmet = ents.Create("prop_physics")
	helmet:SetModel(data[3])
	helmet:SetPos(m:GetTranslation())
	helmet:SetAngles(m:GetAngles())
	helmet:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	helmet:SetBodygroup(0,data[4] or 0)
	
	helmet:Spawn()
	helmet:Activate()
	SafeRemoveEntityDelayed(helmet,10)
	
	local phys = helmet:GetPhysicsObject()
	local vel = self.loco:GetVelocity()
	
	phys:Wake()
	phys:SetVelocity(vel+Vector(math.Rand(-100,100),math.Rand(-100,100),math.Rand(150,300)))
	phys:AddAngleVelocity(Vector(math.Rand(-360,360),math.Rand(-360,360),math.Rand(-360,360))*2)
end

function ENT:MoveAlongPath(lookatgoal)
	local path = self:GetPath()
	local segment = path:GetCurrentGoal()
	if !segment then return false end
	
	if lookatgoal then
		local destpos = segment.pos
	
		if !self:ShouldAccurateMotionBeDisabled() and self:GetAccurateMotionFraction()>0 then
			local segments,next = path:GetAllSegments()
			
			for k,v in ipairs(segments) do
				if v.pos==destpos then
					next = segments[self:UsingNodeGraph() and k==1 and 3 or k+1]
					break
				end
			end
			
			if next then
				destpos = next.pos
			end
		end
	
		local ang = (destpos-self:GetShootPos()):Angle()
		ang.p = 0
		
		self:SetDesiredEyeAngles(ang)
	end
	
	return BaseClass.MoveAlongPath(self,false)
end

function ENT:GetAccurateMotionFraction()
	local path = self:GetPath()
	local segment = path:GetCurrentGoal()
	
	local curv = math.abs(segment.curvature)*2
	if curv<=0 then return 0 end

	local dist = self:GetPos():Distance(segment.pos)
	if dist>self.AccurateMotionStartDistance then return 0 end
	
	return (1-dist/self.AccurateMotionStartDistance)*curv
end

function ENT:ShouldAccurateMotionBeDisabled()
	return self:RunTask("ShouldAccurateMotionBeDisabled")
end

function ENT:GetTravelingPosition()
	local destlen = math.Rand(self.TravelingDistances[1],self.TravelingDistances[2])^2
	local pos = self:GetPos()

	if self:UsingNodeGraph() then
		local cur = SBAdvancedNextbotNodeGraph.GetNearestNode(pos)
		if !cur then return end
		
		local opened = {[cur:GetID()] = true}
		local closed = {}
		local costs = {[cur:GetID()] = cur:GetOrigin():DistToSqr(pos)}
		local maxcost,maxcostpos = 0
		
		while !table.IsEmpty(opened) do
			local _,nodeid = table.Random(opened)
			opened[nodeid] = nil
			closed[nodeid] = true
			
			local node = SBAdvancedNextbotNodeGraph.GetNodeByID(nodeid)
			
			if costs[nodeid]>=destlen then
				return node:GetOrigin()
			end
			
			if costs[nodeid]>maxcost then
				maxcost,maxcostpos = costs[nodeid],node:GetOrigin()
			end
			
			for k,v in ipairs(node:GetAdjacentNodes()) do
				if !closed[v:GetID()] then
					local cost = costs[nodeid]+v:GetOrigin():DistToSqr(node:GetOrigin())
					costs[v:GetID()] = cost
					
					opened[v:GetID()] = true
				end
			end
		end
		
		return maxcostpos
	else
		local cur = navmesh.GetNearestNavArea(pos)
		if !IsValid(cur) then return end
		
		local opened = {[cur:GetID()] = true}
		local closed = {}
		local costs = {[cur:GetID()] = cur:GetCenter():DistToSqr(pos)}
		local maxcost,maxcostpos = 0
		
		while !table.IsEmpty(opened) do
			local _,areaid = table.Random(opened)
			opened[areaid] = nil
			closed[areaid] = true
			
			local area = navmesh.GetNavAreaByID(areaid)
			
			if costs[areaid]>=destlen then
				return area:GetRandomPoint()
			end
			
			if costs[areaid]>maxcost then
				maxcost,maxcostpos = costs[areaid],area:GetRandomPoint()
			end
			
			for k,v in ipairs(area:GetAdjacentAreas()) do
				if !closed[v:GetID()] then
					local cost = costs[areaid]+v:GetCenter():DistToSqr(area:GetCenter())
					costs[v:GetID()] = cost
					
					opened[v:GetID()] = true
				end
			end
		end
		
		return maxcostpos
	end
end

function ENT:StuckCheckShouldIgnoreEntity(ent)
	if ent.ShouldCollide and ent:GetClass()=="sb_advanced_nextbot_payday2_shield" and !ent:ShouldCollide(self) then return true end
	return BaseClass.StuckCheckShouldIgnoreEntity(self,ent)
end

function ENT:Think()
	BaseClass.Think(self)
	
	if self.PostureActive!=self:IsPostureActive() then
		self.PostureActive = self:IsPostureActive()
		
		self:SetupCollisionBounds()
	end
end

function ENT:SetupCollisionBounds()
	for k, v in pairs(player.GetAll()) do
		if v:Team() == 2 then return true end
	end
	if self:IsPostureActive() then
		local seq = self:GetSequenceInfo(self:GetSequence())
		
		local b1 = seq.bbmin
		local b2 = seq.bbmax
		local b3 = Vector(b2.x,b1.y,b1.z)
		local b4 = Vector(b1.x,b2.y,b1.z)
		local b5 = Vector(b2.x,b2.y,b1.z)
		local b6 = Vector(b2.x,b1.y,b2.z)
		local b7 = Vector(b1.x,b2.y,b2.z)
		local b8 = Vector(b1.x,b1.y,b2.z)
		
		local pos = self:GetPos()
		
		b1 = self:LocalToWorld(b1)-pos
		b2 = self:LocalToWorld(b2)-pos
		b3 = self:LocalToWorld(b3)-pos
		b4 = self:LocalToWorld(b4)-pos
		b5 = self:LocalToWorld(b5)-pos
		b6 = self:LocalToWorld(b6)-pos
		b7 = self:LocalToWorld(b7)-pos
		b8 = self:LocalToWorld(b8)-pos

		local minx = math.min(b1.x,b2.x,b3.x,b4.x,b5.x,b6.x,b7.x,b8.x)
		local miny = math.min(b1.y,b2.y,b3.y,b4.y,b5.y,b6.y,b7.y,b8.y)
		local minz = math.min(b1.z,b2.z,b3.z,b4.z,b5.z,b6.z,b7.z,b8.z)
		local maxx = math.max(b1.x,b2.x,b3.x,b4.x,b5.x,b6.x,b7.x,b8.x)
		local maxy = math.max(b1.y,b2.y,b3.y,b4.y,b5.y,b6.y,b7.y,b8.y)
		local maxz = math.max(b1.z,b2.z,b3.z,b4.z,b5.z,b6.z,b7.z,b8.z)+7.5

		b1,b2 = Vector(minx,miny,minz),Vector(maxx,maxy,maxz)
		
		self:SetCollisionBounds(b1,b2)
	else
		BaseClass.SetupCollisionBounds(self)
	end
end

function ENT:ShouldWeaponAttackUseBurst(wep)
	if BaseClass.ShouldWeaponAttackUseBurst(self,wep) then
		if self.sb_anb_pd2_taserattacked and CurTime()<self.sb_anb_pd2_taserattacked then
			return false
		end
	
		return true
	end
	
	return false
end

function ENT:OnTouch(ent,trace)
	if IsValid(ent) and trace.Normal==vector_up and !self:PathIsValid() and ent:GetClass()!="sb_advanced_nextbot_payday2_shield" then
		local dir = self:GetPos()-ent:WorldSpaceCenter()
		dir.z = 0
	
		self.EntityStuckMoveTo = self:GetPos()+dir
	end
end

function ENT:ShouldDoHeavyDamage()
	if !self.ClassData.ShouldDoHeavyDamage then return false end
	
	local v = self:RunTask("ShouldDoHeavyDamage")
	return v==nil or v
end

function ENT:CanDropWeaponOnDie(wep)
	if self.WeaponsConvar:GetInt()==0 then return false end

	self:RunTask("OnKilledBeforeWeaponDrop",wep)

	return true
end

function ENT:GetAimVector()
	local dir = self:RunTask("CustomAimVector")
	
	if dir then
		local deg = self:GetActiveLuaWeapon():GetNPCBulletSpread(self:GetCurrentWeaponProficiency())
		deg = math.sin(math.rad(deg))/2
		
		dir:Add(Vector(math.Rand(-deg,deg),math.Rand(-deg,deg),math.Rand(-deg,deg)))
		
		return dir
	end
	
	return BaseClass.GetAimVector(self)
end

hook.Add("PostPlayerDeath","sb_advanced_nextbot_payday2",function(ply)
	for k,v in ipairs(ents.FindByClass("sb_advanced_nextbot_payday2")) do
		if v.PSide==2 then
			v:SetEntityRelationship(ply,D_NU,1)
		end
	end
	
	if CurTime()<ply:GetNWFloat("sb_anb_pd2_taserattacked",0) then
		ply:StopSound("sb_anb_payday2/taser/attack/taserattack.ogg")
	end
end)

hook.Add("ScaleNPCDamage","sb_advanced_nextbot_payday2",function(ent,group,dmg)
	if ent:GetClass()=="sb_advanced_nextbot_payday2" then
		ent.LastHitGroup = group
		
		if group==HITGROUP_HEAD then
			dmg:ScaleDamage(0.5*ent.DifficultyData[ent.HPDiff].Headshot*ent.ClassData.HeadshotMultiplier)
		end
		
		if group==HITGROUP_LEFTARM or group==HITGROUP_RIGHTARM or group==HITGROUP_LEFTLEG or group==HITGROUP_RIGHTLEG or group==HITGROUP_GEAR then
			dmg:ScaleDamage(4)
		end
		
		
	end
end)

hook.Add("PlayerSpawnNPC","sb_advanced_nextbot_payday2",function(ply,class,wep)
	local data = list.Get("NPC")[class]

	if class:StartWith("sb_anb_payday2_stub") then
		if data then
			local addons = data.Addons
			
			net.Start("sb_anb_payday2_addons")
				for k,v in ipairs(addons) do
					net.WriteBool(true)
					net.WriteString(v)
				end
				
				net.WriteBool(false)
			net.Send(ply)
		end
	
		return false
	end

	if data and data.Class=="sb_advanced_nextbot_payday2" and data.KeyValues and (data.KeyValues["Class"] or data.KeyValues["Group"]) then
		OWNER_TO_SET = ply
	end
end)

hook.Add("PlayerSpawnedNPC","sb_advanced_nextbot_payday2",function(ply,ent)
	if ent:GetClass()=="sb_advanced_nextbot_payday2" and (ent:GetKeyValue("Class") or ent:GetKeyValue("Group")) then
		OWNER_TO_SET = nil
	end
end)

hook.Add("OnNPCKilled","sb_advanced_nextbot_payday2",function(npc,att,inf)
	if npc.sb_anb_pd2_taserattacked and CurTime()<npc.sb_anb_pd2_taserattacked then
		npc:StopSound("sb_anb_payday2/taser/attack/taserattack.ogg")
	end
end)