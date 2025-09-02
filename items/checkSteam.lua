function G.BTTI.countInstalledSteamApps(explicit_path)
    local function findLibraryVDF()
        local function file_exists(path)
            if not path or path == "" then return false end
            local f, err = io.open(path, "rb")
            if f then
                f:close(); return true
            end
            return false
        end

        local function trim(s) return (s:gsub("^%s+", ""):gsub("%s+$", "")) end

        local candidates = {}
        local home = os.getenv("HOME")
        local user = os.getenv("USER")

        if home and #home > 0 then
            table.insert(candidates, home .. "/Library/Application Support/Steam/steamapps/libraryfolders.vdf")
            table.insert(candidates, home .. "/Library/Application Support/Steam")
            table.insert(candidates, home .. "/.local/share/Steam/steamapps/libraryfolders.vdf")
            table.insert(candidates, home .. "/.steam/steam/steamapps/libraryfolders.vdf")
        end

        if user and #user > 0 then
            table.insert(candidates,
                "/Users/" .. user .. "/Library/Application Support/Steam/steamapps/libraryfolders.vdf")
            table.insert(candidates, "/Users/" .. user .. "/Library/Application Support/Steam")
        end

        local is_windows = package.config:sub(1, 1) == "\\"
        if is_windows then
            local ok, proc = pcall(io.popen, [[reg query "HKLM\SOFTWARE\Wow6432Node\Valve\Steam" /v InstallPath 2>nul]])
            if ok and proc then
                local out = proc:read("*a")
                proc:close()
                local install = out:match("InstallPath%s+REG_SZ%s+(.+)")
                if install then
                    table.insert(candidates, install .. "\\steamapps\\libraryfolders.vdf")
                    table.insert(candidates, install)
                end
            end

            local pf86 = os.getenv("ProgramFiles(x86)")
            if pf86 and #pf86 > 0 then
                table.insert(candidates, pf86 .. "\\Steam\\steamapps\\libraryfolders.vdf")
                table.insert(candidates, pf86 .. "\\Steam")
            end
            local pf = os.getenv("ProgramFiles")
            if pf and #pf > 0 then
                table.insert(candidates, pf .. "\\Steam\\steamapps\\libraryfolders.vdf")
                table.insert(candidates, pf .. "\\Steam")
            end
        else
            local valid_windows_fstypes = {
                ntfs = true, vfat = true, exfat = true, fuseblk = true, ntfs4 = true
            }

            if home and #home > 0 then
                local wineprefix = os.getenv("WINEPREFIX")
                if wineprefix and #wineprefix > 0 then
                    table.insert(candidates,
                        wineprefix .. "/drive_c/Program Files (x86)/Steam/steamapps/libraryfolders.vdf")
                    table.insert(candidates, wineprefix .. "/drive_c/Program Files/Steam/steamapps/libraryfolders.vdf")
                    table.insert(candidates,
                        wineprefix ..
                        "/drive_c/Users/" .. (user or "User") .. "/AppData/Roaming/Steam/steamapps/libraryfolders.vdf")
                end

                table.insert(candidates, home .. "/.wine/drive_c/Program Files (x86)/Steam/steamapps/libraryfolders.vdf")
                table.insert(candidates, home .. "/.wine/drive_c/Program Files/Steam/steamapps/libraryfolders.vdf")
                table.insert(candidates,
                    home ..
                    "/.wine/drive_c/Users/" .. (user or "User") .. "/AppData/Roaming/Steam/steamapps/libraryfolders.vdf")

                local compat_base = home .. "/.steam/steam/steamapps/compatdata"
                local okc, proc = pcall(io.popen, 'ls -1A "' .. compat_base .. '" 2>/dev/null')
                if okc and proc then
                    local out = proc:read("*a")
                    proc:close()
                    if out and out ~= "" then
                        for entry in out:gmatch("[^\r\n]+") do
                            entry = trim(entry)
                            if entry ~= "" then
                                local pfx = compat_base ..
                                "/" .. entry .. "/pfx/drive_c/Program Files (x86)/Steam/steamapps/libraryfolders.vdf"
                                table.insert(candidates, pfx)
                                table.insert(candidates,
                                    compat_base ..
                                    "/" .. entry .. "/pfx/drive_c/Program Files/Steam/steamapps/libraryfolders.vdf")
                            end
                        end
                    end
                end
            end

            local mounts_file = "/proc/mounts"
            local okm, mfh = pcall(io.open, mounts_file, "r")
            if okm and mfh then
                for line in mfh:lines() do
                    local dev, mnt, fstype = line:match("^(%S+)%s+(%S+)%s+(%S+)%s+")
                    if mnt and fstype and valid_windows_fstypes[fstype] then

                        table.insert(candidates, mnt .. "/Program Files (x86)/Steam/steamapps/libraryfolders.vdf")
                        table.insert(candidates, mnt .. "/Program Files/Steam/steamapps/libraryfolders.vdf")

                        table.insert(candidates, mnt .. "/drive_c/Program Files (x86)/Steam/steamapps/libraryfolders.vdf")
                        table.insert(candidates, mnt .. "/drive_c/Program Files/Steam/steamapps/libraryfolders.vdf")

                        if user and #user > 0 then
                            table.insert(candidates,
                                mnt .. "/Users/" .. user .. "/AppData/Roaming/Steam/steamapps/libraryfolders.vdf")
                            table.insert(candidates,
                                mnt ..
                                "/Users/" ..
                                user .. "/Local Settings/Application Data/Steam/steamapps/libraryfolders.vdf")
                        end

                        table.insert(candidates, "/media/" .. (user or "") .. "/Steam/steamapps/libraryfolders.vdf")
                        table.insert(candidates, "/run/media/" .. (user or "") .. "/Steam/steamapps/libraryfolders.vdf")
                    end
                end
                mfh:close()
            end
        end

        local seen = {}
        local final = {}

        local function push_candidate_norm(p)
            if not p or p == "" then return end
            if is_windows then
                p = p:gsub("/", "\\")
            else
                p = p:gsub("\\", "/")
            end
            if not seen[p] then
                seen[p] = true; table.insert(final, p)
            end
        end

        for _, p in ipairs(candidates) do
            if p:match("libraryfolders%.vdf$") then
                push_candidate_norm(p)
            else
                push_candidate_norm(p)
                if is_windows then
                    push_candidate_norm((p:gsub("[\\/]$", "")) .. "\\steamapps\\libraryfolders.vdf")
                else
                    push_candidate_norm((p:gsub("[\\/]$", "")) .. "/steamapps/libraryfolders.vdf")
                end
            end
        end

        for _, p in ipairs(final) do
            if file_exists(p) then
                sendInfoMessage("Found Steam installation at " .. p .. "!", "BTTI")
                return p
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

    sendInfoMessage("Found " .. total .. " installed game(s)!", "BTTI")
    return total
end