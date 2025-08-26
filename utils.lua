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

function loadImage(fn)
    local full_path = SMODS.current_mod.path .. 'assets/images/' .. fn
    full_path = full_path:gsub('%\\', '/')
    local file_data = assert(NFS.newFileData(full_path), ("Epic fail"))
    local tempimagedata = assert(love.image.newImageData(file_data), ("Epic fail 2"))
    return (assert(love.graphics.newImage(tempimagedata), ("Epic fail 3")))
end
