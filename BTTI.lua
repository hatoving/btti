-- REMOVE THIS WHEN WE RELEASE IT ??
SMODS.Keybind{
	key = 'imrich',
	key_pressed = 'm',
    held_keys = {'lctrl'}, -- other key(s) that need to be held

    action = function(self)
        G.GAME.dollars = 1000000
        sendInfoMessage("money set to 1 million", "CustomKeybinds")
    end,
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
