function G.BTTI.countInstalledSteamApps(explicit_path)
    local function findLibraryVDF()
        if explicit_path and type(explicit_path) == "string" then
            return explicit_path
        end

        local candidates = {}

        -- Windows
        local pf86 = os.getenv("ProgramFiles(x86)")
        if pf86 and #pf86 > 0 then
            table.insert(candidates, pf86 .. "\\Steam\\steamapps\\libraryfolders.vdf")
        end
        local pf = os.getenv("ProgramFiles")
        if pf and #pf > 0 then
            table.insert(candidates, pf .. "\\Steam\\steamapps\\libraryfolders.vdf")
        end

        -- Linux
        local home = os.getenv("HOME")
        if home and #home > 0 then
            table.insert(candidates, home .. "/.steam/steam/steamapps/libraryfolders.vdf")
            table.insert(candidates, home .. "/.local/share/Steam/steamapps/libraryfolders.vdf")
        end

        -- macOS
        if home and #home > 0 then
            table.insert(candidates, home .. "/Library/Application Support/Steam/steamapps/libraryfolders.vdf")
        end

        for _, path in ipairs(candidates) do
            local f = io.open(path, "rb")
            if f then
                f:close()
                return path
            end
        end

        return nil
    end

    local path, ferr = findLibraryVDF()
    if not path then return nil, 0, ferr end

    local f, err = io.open(path, "rb")
    if not f then return nil, 0, "Error opening file: " .. tostring(err) end
    local content = f:read("*a")
    f:close()

    local total = 0

    for libid, libblock in content:gmatch('"(%d+)"%s*(%b{})') do
        local apps_block = libblock:match('"apps"%s*(%b{})')
        if apps_block then
            for _k, _v in apps_block:gmatch('%s*"([^"]+)"%s*"([^"]+)"') do
                total = total + 1
            end
        end
    end

    return total
end