if G.BTTI == nil then
	G.BTTI = {}
end

G.BTTI.config = SMODS.current_mod.config

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
G.C.BTTIBI = SMODS.Gradients.btti_BISEXUAL_TITLE
G.C.BTTIGAY = SMODS.Gradients.btti_GAY
G.C.BTTI_MAINMODC = SMODS.Gradients.btti_MAIN_MOD_C

local loc_colour_ref = loc_colour
function loc_colour(_c, _default)
	if not G.ARGS.LOC_COLOURS then
		loc_colour_ref()
	end

	G.ARGS.LOC_COLOURS.pink = G.C.BTTIPINK
	G.ARGS.LOC_COLOURS.black = G.C.BTTIBLACK
	G.ARGS.LOC_COLOURS.bisexual = G.C.BTTIBI
	G.ARGS.LOC_COLOURS.gay = G.C.BTTIGAY
	G.ARGS.LOC_COLOURS.deets = G.C.BTTIDEETS
	G.ARGS.LOC_COLOURS.balinsanity = G.C.BTTI_MAINMODC

	return loc_colour_ref(_c, _default)
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

f, err = SMODS.load_file('items/jokers/jokers.lua')
if err then
	error(err)
end
f()
f, err = SMODS.load_file('items/jokers/jokerCombos.lua')
if err then
	error(err)
end
f()

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
