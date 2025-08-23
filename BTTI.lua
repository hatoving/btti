if G.BTTI == nil then
	G.BTTI = {}
end

G.BTTI.JOKER_COMBOS = {
	['j_btti_avariciousJoker'] = {
		jokers = {
			'j_lusty_joker',
			'j_greedy_joker'
		}
	},
	['j_btti_sullenJoker'] = {
		jokers = {
			'j_wrathful_joker',
			'j_gluttenous_joker'
		}
	},
	['j_btti_sinfulJoker'] = {
		jokers = {
			'j_btti_avariciousJoker',
			'j_btti_sullenJoker'
		}
	},
	['j_btti_bonkersJoker'] = {
		jokers = {
			'j_crazy_joker',
			'j_devious_joker'
		}
	}
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

-- Load items
local files = NFS.getDirectoryItems(mod_path .. "items")
for _, file in ipairs(files) do
	print("[BTTI] Loading lua file " .. file)
	local f, err = SMODS.load_file("items/" .. file)
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
