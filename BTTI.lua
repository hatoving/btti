if G.BTTI == nil then
	G.BTTI = {}
end

G.BTTI.JOKER_COMBOS = {
	['j_btti_avariciousJoker'] = {
		rarity = 2,
		jokers = {
			'j_lusty_joker',
			'j_greedy_joker'
		}
	},
	['j_btti_sullenJoker'] = {
		rarity = 2,
		jokers = {
			'j_wrathful_joker',
			'j_gluttenous_joker'
		}
	},
	['j_btti_sinfulJoker'] = {
		rarity = 3,
		jokers = {
			'j_btti_avariciousJoker',
			'j_btti_sullenJoker'
		}
	},
	['j_btti_jovialJoker'] = {
		rarity = 1,
		jokers = {
			'j_jolly',
			'j_sly'
		}
	},
	['j_btti_confusedJoker'] = {
		rarity = 1,
		jokers = {
			'j_zany',
			'j_wily'
		}
	},
	['j_btti_geniusJoker'] = {
		rarity = 2,
		jokers = {
			'j_mad',
			'j_clever'
		}
	},
	['j_btti_bonkersJoker'] = {
		rarity = 3,
		jokers = {
			'j_crazy',
			'j_devious'
		}
	},
	['j_btti_deliberateJoker'] = {
		rarity = 3,
		jokers = {
			'j_droll',
			'j_crafty'
		}
	},
	['j_btti_ultimateJoker'] = {
		rarity = 4,
		jokers = {
			'j_btti_Universe'
		},
		allowed = {
			'j_btti_jovialJoker',
			'j_btti_confusedJoker',
			'j_btti_geniusJoker',
			'j_btti_bonkersJoker',
			'j_btti_deliberateJoker'
		}
	},
	['j_btti_splitJovialJoker'] = {
		rarity = 2,
		jokers = {
			'j_btti_jovialJoker',
			'j_half'
		}
	},
	['j_btti_splitConfusedJoker'] = {
		rarity = 2,
		jokers = {
			'j_btti_confusedJoker',
			'j_half'
		}
	},
	['j_btti_zeroTheo'] = {
		rarity = 2,
		jokers = {
			'j_even_steven',
			'j_odd_todd',
		}
	},
	['j_btti_trueBanana'] = {
		rarity = 3,
		jokers = {
			'j_gros_michel',
			'j_cavendish',
		}
	},
	['j_btti_royalMoon'] = {
		rarity = 2,
		jokers = {
			'j_baron',
			'j_shoot_the_moon',
		}
	},
	['j_btti_shortScholar'] = {
		rarity = 2,
		jokers = {
			'j_scholar',
			'j_wee',
		}
	},
	['j_btti_chanceOfClouds'] = {
		rarity = 2,
		jokers = {
			'j_8_ball',
			'j_cloud_9',
		}
	},
	['j_btti_celestius'] = {
		rarity = 4,
		jokers = {
			'j_btti_royalMoon',
			'j_btti_shortScholar',
			'j_btti_chanceOfClouds'
		}
	},
	['j_btti_mineralJoker'] = {
		rarity = 3,
		jokers = {
			'j_steel_joker',
			'j_stone'
		}
	},
	['j_btti_abstractbuckler'] = {
		rarity = 2,
		jokers = {
			'j_abstract',
			'j_swashbuckler'
		}
	},
	['j_btti_resume'] = {
		rarity = 3,
		jokers = {
			'j_marble',
			'j_certificate'
		}
	},
	['j_btti_bat'] = {
		rarity = 3,
		jokers = {
			'j_dusk',
			'j_acrobat'
		}
	},
	['j_btti_mountainBurglar'] = {
		rarity = 2,
		jokers = {
			'j_mystic_summit',
			'j_burglar'
		}
	},
	['j_btti_holoResume'] = {
		rarity = 3,
		jokers = {
			'j_btti_resume',
			'j_hologram'
		}
	},
	['j_btti_lunatic'] = {
		rarity = 3,
		jokers = {
			'j_cartomancer',
			'j_fortune_teller'
		}
	},
	['j_btti_wineJuggler'] = {
		rarity = 3,
		jokers = {
			'j_juggler',
			'j_drunkard'
		}
	},
	['j_btti_photoChad'] = {
		rarity = 3,
		jokers = {
			'j_photograph',
			'j_hanging_chad'
		}
	},
}

SMODS.Gradient {
	key = "BISEXUAL_TITLE",
	colours = {
		HEX("d70071"),
		HEX("d70071"),
		HEX("0035a9"),
	},
	cycle = 3
}
SMODS.Gradient {
	key = "GAY",
	colours = {
		G.C.RED,
		HEX('ff4400'),
		G.C.YELLOW,
		G.C.GREEN,
		HEX('00ecff'),
		G.C.BLUE,
		G.C.PURPLE,
		HEX('ff0091')
	},
	cycle = 8
}

G.C.BTTIPINK = HEX('FFA5A5')
G.C.BTTIDEETS = HEX('9e5c00')
G.C.BTTIBI = SMODS.Gradients.btti_BISEXUAL_TITLE
G.C.BTTIGAY = SMODS.Gradients.btti_GAY

local loc_colour_ref = loc_colour
function loc_colour(_c, _default)
	if not G.ARGS.LOC_COLOURS then
		loc_colour_ref()
	end

	G.ARGS.LOC_COLOURS.bisexual = G.C.BTTIBI
	G.ARGS.LOC_COLOURS.gay = G.C.BTTIGAY
	G.ARGS.LOC_COLOURS.deets = G.C.BTTIDEETS

	return loc_colour_ref(_c, _default)
end

local mod_path = "" .. SMODS.current_mod.path

SMODS.current_mod.optional_features = {
	retrigger_joker = true,
	post_trigger = true
}

--#region Pool creation

SMODS.ObjectType({
	key = "BTTImodaddition",
	default = "j_reserved_parking",
	cards = {},
	inject = function(self)
		SMODS.ObjectType.inject(self)
		-- insert base game food jokers
	end,
})
SMODS.ObjectType({
	key = "BTTImodadditionCOMBO",
	default = "j_reserved_parking",
	cards = {},
	inject = function(self)
		SMODS.ObjectType.inject(self)
		-- insert base game food jokers
	end,
})
SMODS.ObjectType({
	key = "BTTImodadditionplanets",
	default = "j_reserved_parking",
	cards = {},
	inject = function(self)
		SMODS.ObjectType.inject(self)
		-- insert base game food jokers
	end,
})
SMODS.ObjectType({
	key = "BTTImodadditiontarots",
	default = "j_reserved_parking",
	cards = {},
	inject = function(self)
		SMODS.ObjectType.inject(self)
		-- insert base game food jokers
	end,
})
SMODS.ObjectType({
	key = "BTTImodadditionspectrals",
	default = "j_reserved_parking",
	cards = {},
	inject = function(self)
		SMODS.ObjectType.inject(self)
		-- insert base game food jokers
	end,
})
SMODS.ObjectType({
	key = "BTTImodadditionITTI",
	default = "j_reserved_parking",
	cards = {},
	inject = function(self)
		SMODS.ObjectType.inject(self)
		-- insert base game food jokers
	end,
})
SMODS.ObjectType({
	key = "BTTImodadditionSMP",
	default = "j_reserved_parking",
	cards = {},
	inject = function(self)
		SMODS.ObjectType.inject(self)
		-- insert base game food jokers
	end,
})
SMODS.ObjectType({
	key = "BTTImodadditionDEETS",
	default = "j_reserved_parking",
	cards = {},
	inject = function(self)
		SMODS.ObjectType.inject(self)
		-- insert base game food jokers
	end,
})
SMODS.ObjectType({
	key = "BTTImodadditionDEETSPlanets",
	default = "j_reserved_parking",
	cards = {},
	inject = function(self)
		SMODS.ObjectType.inject(self)
		-- insert base game food jokers
	end,
})

--#endregion

local f, err = SMODS.load_file('utils.lua')
if err then
	error(err)
end
f()
f, err = SMODS.load_file('hooks.lua')
if err then
	error(err)
end
f()

-- Load items
local files = NFS.getDirectoryItems(mod_path .. "items")
for _, file in ipairs(files) do
	print("[BTTI] Loading lua file " .. file)
	f, err = SMODS.load_file("items/" .. file)
	if err then
		error(err)
	end
	f()
end

--Load Localization file
local files = NFS.getDirectoryItems(mod_path .. "localization")
for _, file in ipairs(files) do
	print("[BTTI] Loading localization file " .. file)
	local f, err = SMODS.load_file("localization/" .. file)
	if err then
		error(err) 
	end
	f()
end
