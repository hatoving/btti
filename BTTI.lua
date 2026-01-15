if G.BTTI == nil then
	G.BTTI = {}
end

G.BTTI.config = SMODS.current_mod.config
G.BTTI.combining = false

-- stolen from the yahiamouse
G.effectmanager = {}

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

G.C.BTTIBLACK = HEX('000000')
G.C.BTTICYAN = HEX('17e6e6')
G.C.BTTIPINK = HEX('FFA5A5')
G.C.BTTIORANGE = HEX('ff7b00')
G.C.BTTIDARKPINK = HEX('FF6183')
G.C.BTTIPINK = HEX('FFA5A5')
G.C.BTTISHARK = HEX('4996a1')
G.C.BTTIDEETS = HEX('9e5c00')
G.C.BTTISPOINGUS = HEX('a4000f')
SMODS.Gradient {
	key = "MAIN_MOD_C",
	colours = {
		G.C.BTTIPINK,
		G.C.BLUE,
		G.C.ORANGE
	},
	cycle = 2
}
SMODS.Gradient {
	key = "MAIN_MOD_C_SLOW",
	colours = {
		G.C.BTTIPINK,
		G.C.BLUE,
		G.C.ORANGE
	},
	cycle = 7.5
}
G.C.BTTIBI = SMODS.Gradients.btti_BISEXUAL_TITLE
G.C.BTTIGAY = SMODS.Gradients.btti_GAY
G.C.BTTI_MAINMODC = SMODS.Gradients.btti_MAIN_MOD_C
G.C.BTTI_MAINMODCSLOW = SMODS.Gradients.btti_MAIN_MOD_C_SLOW

local loc_colour_ref = loc_colour
function loc_colour(_c, _default)
	if not G.ARGS.LOC_COLOURS then
		loc_colour_ref()
	end

	G.ARGS.LOC_COLOURS.pink = G.C.BTTIPINK
	G.ARGS.LOC_COLOURS.darkpink = G.C.BTTIDARKPINK
	G.ARGS.LOC_COLOURS.black = G.C.BTTIBLACK
	G.ARGS.LOC_COLOURS.bisexual = G.C.BTTIBI
	G.ARGS.LOC_COLOURS.gay = G.C.BTTIGAY
	G.ARGS.LOC_COLOURS.shark = G.C.BTTISHARK
	G.ARGS.LOC_COLOURS.deets = G.C.BTTIDEETS
	G.ARGS.LOC_COLOURS.bttiorange = G.C.BTTIORANGE
	G.ARGS.LOC_COLOURS.balinsanity = G.C.BTTI_MAINMODC
	G.ARGS.LOC_COLOURS.balinsanity_slow = G.C.BTTI_MAINMODCSLOW

	return loc_colour_ref(_c, _default)
end

G.C.mid_flash = 0
G.C.vort_time = 3.5
G.C.vort_speed = 0.2
-- from yahimod :) (from cryptid :})
local oldfunc = Game.main_menu
Game.main_menu = function(change_context)
	local ret = oldfunc(change_context)
	G.SPLASH_BACK:define_draw_steps({
			{
				shader = "splash",
				send = {
					{ name = "time", ref_table = G.TIMERS, ref_value = "REAL_SHADER" },
           			{name = 'vort_speed', val = G.C.vort_speed},
            		{name = 'colour_1', ref_table = G.C, ref_value = 'BTTI_MAINMODCSLOW'},
            		{name = 'colour_2', ref_table = G.C, ref_value = 'BTTI_MAINMODCSLOW'},
            		{name = 'mid_flash', ref_table = G.C, ref_value = 'mid_flash'},
				},
			},
		})
	return ret
end

G.bttiModPath = "" .. SMODS.current_mod.path

SMODS.current_mod.optional_features = {
	retrigger_joker = true,
	post_trigger = true
}

local f, err = SMODS.load_file('utils.lua')
if err then
	error(err)
end
f()

-- Load items
local files = NFS.getDirectoryItems(G.bttiModPath .. "items")
for _, file in ipairs(files) do
	print("[BTTI] Loading lua file " .. file)
	f, err = SMODS.load_file("items/" .. file)
	if err then
		error(err)
	end
	f()
end

local jokers = {
    "jokers",
    "mcdonaldsJokers",
    "fgJokers",
    "smilingJokers",
    "boysJokers",
    "dexterJokers",
    "vocaloidJokers",
    "gungeonJokers",
    "ultrakillJokers",
    "isaacJokers",
    "fnafJokers",
    "ddlcJokers",
    "baldiJokers",
    "hkJokers",
    "utdrJokers",
    "avaJokers",
    "spongebobJokers",
    "kpdhJokers",
	"tadcJokers",
	"hellaJokers",
	"iiJokers",
    "bfdiJokers",
    "hanakoJokers",
    "deetsJokers",
    "ittiJokers",
    "dramatizedJokers",
    "staceyJokers",
    "ymfpJokers",
    "aotaJokers",
	"scoliosisJokers",
    "agasJokers",
    "creaticaJokers",
    "actsanityJokers",
    "jokerCombos",
}

local function load_jokers(filename)
	local path = "jokers/" .. filename .. ".lua"
    local f, err = SMODS.load_file(path)
    if err then
        error(("[BTTI] Error loading %s:\n%s"):format(path, err))
    end
    f()
end

for _, path in ipairs(jokers) do
    load_jokers(path)
end

files = NFS.getDirectoryItems(G.bttiModPath .. "bigboyblinds")
for _, file in ipairs(files) do
	print("[BTTI] Loading lua file " .. file)
	f, err = SMODS.load_file("bigboyblinds/" .. file)
	if err then
		error(err)
	end
	f()
end
local files = NFS.getDirectoryItems(G.bttiModPath .. "hooks")
for _, file in ipairs(files) do
	print("[BTTI] Loading lua file " .. file)
	f, err = SMODS.load_file("hooks/" .. file)
	if err then
		error(err)
	end
	f()
end

--Load Localization file
local files = NFS.getDirectoryItems(G.bttiModPath .. "localization")
for _, file in ipairs(files) do
	print("[BTTI] Loading localization file " .. file)
	local f, err = SMODS.load_file("localization/" .. file)
	if err then
		error(err) 
	end
	f()
end

G.BTTI.MICROPHONE = love.audio.getRecordingDevices()[1]

G.BTTI.initJokerCombos()
