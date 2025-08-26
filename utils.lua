function jokerExists(name)
    local _check = false
    if G.jokers and G.jokers.cards then
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i].ability.name == name then
                _check = true
            end
        end
    end
    return _check
end

function percentOf(value, percent)
    return value * (percent / 100)
end

function getJokerID(card)
    if G.jokers then
        local _selfid = 0
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] == card then _selfid = i end
        end
        return _selfid
    end
end

function lerp(a, b, t)
    local result = a + t * (b - a)
    return result
end

-- stolen from yahimod, thank you yaha mouse
function loadImage(fn)
    local full_path = SMODS.current_mod.path .. 'assets/images/' .. fn
    full_path = full_path:gsub('%\\', '/')
    local file_data = assert(NFS.newFileData(full_path), ("Epic fail"))
    local tempimagedata = assert(love.image.newImageData(file_data), ("Epic fail 2"))
    return (assert(love.graphics.newImage(tempimagedata), ("Epic fail 3")))
end
