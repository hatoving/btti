G.C.BTTIPINK = HEX('FFA5A5')

local mod_path = "" .. SMODS.current_mod.path

SMODS.current_mod.optional_features = {
	retrigger_joker = true,
	post_trigger = true
}

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
