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

-- from https://github.com/blazingulag/Prism/blob/main/objects/funcs.lua#L192
function is_numbered(card)
    return card.base and card.base.value and not SMODS.Ranks[card.base.value].face and card:get_id() ~= 14
end

function is_odd(card)
    if not card.base then return false end
    return (is_numbered(card) and card.base.nominal % 2 == 1) or card:get_id() == 14
        or (next(SMODS.find_card('j_mxms_perspective')) and card:get_id() == 6) --compat with maximus' prespective
end

function is_even(card)
    if not card.base then return false end
    return (is_numbered(card) and card.base.nominal % 2 == 0)
        or (next(SMODS.find_card('j_mxms_perspective')) and card:get_id() == 6) --compat with maximus' prespective
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
