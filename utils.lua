to_big = to_big or function(x) return x end -- for talisman
to_number = to_number or function(x) return x end -- for talisman

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

function checkCollision(ax, ay, aw, ah, bx, by, bw, bh)
    return ax < bx + bw and
        ax + aw > bx and
        ay < by + bh and
        ay + ah > by
end

function checkCollisionRect(a, b)
    return a.x < b.x + b.w and
        a.x + a.w > b.x and
        a.y < b.y + b.h and
        a.y + a.h > b.y
end

function drawRotatedRectangle(mode, x, y, width, height, angle)
    -- We cannot rotate the rectangle directly, but we
    -- can move and rotate the coordinate system.
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(angle)
    love.graphics.rectangle(mode, 0, 0, width, height) -- origin in the top left corner
    --	love.graphics.rectangle(mode, -width/2, -height/2, width, height) -- origin in the middle
    love.graphics.pop()

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

function getJoker(name)
    if G.jokers then
        local _selfid = 0
        if jokerExists(name) then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.name == name then _selfid = i end
            end
        end
        return _selfid
    end
    return 0
end

function table_contains(tbl, val)
    for _, v in ipairs(tbl) do
        if v == val then return true end
    end
    return false
end

function lerp(a, b, t)
    local result = a + t * (b - a)
    return result
end

function lerpAngle(a, b, t)
    local diff = (b - a + math.pi) % (2 * math.pi) - math.pi
    return a + diff * t
end

function findInTable(tbl, value)
    for i, v in ipairs(tbl) do
        if v == value then
            return i -- return index where found
        end
    end
    return nil -- not found
end

function angleDifference(a, b)
    local diff = (b - a) % (2 * math.pi)
    if diff > math.pi then
        diff = diff - 2 * math.pi
    end
    return diff
end

function Card:set_rank(new_rank)
    local suit_prefix = string.sub(self.base.suit, 1, 1) .. '_'
    local rank_suffix = new_rank

    if rank_suffix < 10 then
        rank_suffix = tostring(rank_suffix)
    elseif rank_suffix == 10 then
        rank_suffix = 'T'
    elseif rank_suffix == 11 then
        rank_suffix = 'J'
    elseif rank_suffix == 12 then
        rank_suffix = 'Q'
    elseif rank_suffix == 13 then
        rank_suffix = 'K'
    elseif rank_suffix == 14 then
        rank_suffix = 'A'
    end

    self:set_base(G.P_CARDS[suit_prefix .. rank_suffix])
end

function math.clamp(x, min, max)
    return math.max(min, math.min(max, x))
end

function LOSE_GAME_NOW()
    G.STATE = G.STATES.GAME_OVER
    if not G.GAME.won and not G.GAME.seeded and not G.GAME.challenge then
        G.PROFILES[G.SETTINGS.profile].high_scores.current_streak.amt = 0
    end
    G:save_settings()
    G.FILE_HANDLER.force = true
    G.STATE_COMPLETE = false
end

-- stolen from yahimod, thank you yaha mouse
function bttiEffectManagerPlay(effect,x,y)
    if effect == "explosion" then
        bttiEffectManagerNewEffect =
        {
            name = "explosion",
            duration = 45,

            frame = 1,
            maxframe = 17,
            fps = 45,
            tfps = 0, -- ticks per frame per second


            xpos = x,
            ypos = y,
            xvel = 0,
            yvel = 0,
        }
    end
    table.insert(G.effectmanager, { bttiEffectManagerNewEffect })
end
function loadImage(fn)
    local full_path = G.bttiModPath .. 'assets/images/' .. fn
    full_path = full_path:gsub('%\\', '/')
    local file_data = assert(NFS.newFileData(full_path), ("Epic fail"))
    local tempimagedata = assert(love.image.newImageData(file_data), ("Epic fail 2"))
    return (assert(love.graphics.newImage(tempimagedata), ("Epic fail 3")))
end
function loadSound(fn,type)
    local full_path = G.bttiModPath .. 'assets/sounds/' .. fn
    full_path = full_path:gsub('%\\', '/')
    local file_data = assert(NFS.newFileData(full_path), ("Epic AUDIO fail"))
    return assert(love.audio.newSource(file_data, type), ("Epic AUDIO fail 2"))
end
function loadImageSpriteSheet(fn, px, py, subimg, orientation)
    local full_path = G.bttiModPath .. 'assets/images/' .. fn
    full_path = full_path:gsub('%\\', '/')
    local file_data = assert(NFS.newFileData(full_path), ("Epic fail"))
    local tempimagedata = assert(love.image.newImageData(file_data), ("Epic fail 2"))
    local tempimg = assert(love.graphics.newImage(tempimagedata), ("Epic fail 3"))

    local spritesheet = {}
    for i = 1, subimg do
        if orientation == 0 then     -- 0 = downwards spritesheet
            table.insert(spritesheet, love.graphics.newQuad(0, (i - 1) * py, px, py, tempimg))
        end
        if orientation == 1 then     -- 1 = rightwards spritesheet
            table.insert(spritesheet, love.graphics.newQuad((i - 1) * px, 0, px, py, tempimg))
        end
    end

    return spritesheet
end
