function Card:click()
    if self.area and self.area:can_highlight(self) then
        if (self.area == G.hand) and (G.STATE == G.STATES.HAND_PLAYED) then return end
        if self.highlighted ~= true then
            self.area:add_to_highlighted(self)
            SMODS.calculate_context { clicked_card = self, card_highlighted = true }
        else
            SMODS.calculate_context { clicked_card = self, card_highlighted = false }
            self.area:remove_from_highlighted(self)
            play_sound('cardSlide2', nil, 0.3)
        end
    end
    if self.area and self.area == G.deck and self.area.cards[1] == self then
        G.FUNCS.deck_info()
    end
end

local smodsCalcRef = SMODS.calculate_effect -- don't really need it but just in case
SMODS.calculate_effect = function(effect, scored_card, from_edition, pre_jokers)
    local ret = {}
    local hasXMult = false
    for _, key in ipairs(SMODS.calculation_keys) do
        if effect[key] then
            if effect.juice_card and not SMODS.no_resolve then
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()
                        effect.juice_card:juice_up(0.1)
                        if (not effect.message_card) or (effect.message_card and effect.message_card ~= scored_card) then
                            scored_card:juice_up(0.1)
                        end
                        return true
                    end
                }))
            end
            if G.GAME.blind.config.blind.key == 'bl_btti_captainBlind' then
                if (
                        key == "x_mult"
                        or key == "xmult"
                        or key == "Xmult"
                        or key == "x_mult_mod"
                        or key == "xmult_mod"
                        or key == "Xmult_mod"
                    ) then
                    effect[key] = 1
                    hasXMult = true
                end

                if hasXMult then
                    if key == "message" then
                        effect.message = "Nope!"
                    end
                    if key == "sound" then
                        sendInfoMessage("replacing sound", "BTTI")
                        effect[key] = 'card1'
                    elseif effect['sound'] == nil then
                        sendInfoMessage("replacing sound", "BTTI")
                        effect['sound'] = 'card1'
                    end
                end
            end
            local calc = SMODS.calculate_individual_effect(effect, scored_card, key, effect[key], from_edition)
            if calc == true then ret.calculated = true end
            if type(calc) == 'string' then
                ret[calc] = true
            elseif type(calc) == 'table' then
                for k, v in pairs(calc) do ret[k] = v end
            end
            if not SMODS.silent_calculation[key] then
                percent = (percent or 0) + (percent_delta or 0.08)
            end
        end
    end
    return ret
end

-- both musicIdx and musicIdxBoss MUST have the same jokers. one can't have more or less than the other
btti_musicIdx = {
    ['j_btti_Tenna'] = {
        'music_TennaNormal'
    }
}
btti_musicIdxBoss = {
    ['j_btti_Tenna'] = {
        'music_TennaBoss'
    }
}
local calcJokerRef = Card.calculate_joker
function Card:calculate_joker(context)
    if G.GAME.btti_selectedMusicIdx == nil then
        G.GAME.btti_selectedMusicIdx = 'NOTHING'
    end
    if context.setting_blind then
        local jokers = {}
        for key, indexes in pairs(btti_musicIdx) do
            if jokerExists(key) then
                table.insert(jokers, key)
            end
        end

        if #jokers == 0 then
            G.GAME.btti_selectedMusicIdx = 'NOTHING'
        elseif #jokers == 1 then
            local list = (G.GAME.blind:get_type() == 'Boss') and btti_musicIdxBoss[jokers[1]] or
                btti_musicIdx[jokers[1]]
            if list and #list > 0 then
                G.GAME.btti_selectedMusicIdx = "btti_" .. list[math.random(1, #list)]
            else
                G.GAME.btti_selectedMusicIdx = "btti_" .. list[1]
            end
        else
            local chosenJoker = jokers[math.random(1, #jokers)]
            local list = (G.GAME.blind:get_type() == 'Boss') and btti_musicIdxBoss[chosenJoker] or
                btti_musicIdx[chosenJoker]
            if list and #list > 0 then
                G.GAME.btti_selectedMusicIdx = "btti_" .. list[math.random(1, #list)]
            else
                G.GAME.btti_selectedMusicIdx = "btti_" .. list[1]
            end
        end

        sendInfoMessage(
            "selecting music: " .. tostring(G.GAME.btti_selectedMusicIdx) ..
            ", is boss = " .. tostring((G.GAME.blind:get_type() == 'Boss')),
            "BTTI"
        )
    end
    return calcJokerRef(self, context)
end

local ORIGINAL_play_sound = play_sound
function play_sound(sound_code, per, vol)
    if string.find(sound_code, 'multhit') ~= nil then
        for i, jk in ipairs(G.jokers.cards) do
            if jk.config.center.key == "j_btti_MetalPipe" then
                sendInfoMessage("playing metal pipe instead", "BTTI")
                return ORIGINAL_play_sound('btti_metalPipeMult', per, vol)
            end
        end
    end
    return ORIGINAL_play_sound(sound_code, per, vol)
end

btti_whorseFlashbangAlpha = 0.0
btti_dwayneTheRockImage = loadImage('rock.png')
btti_dwayneTheRockAlpha = 0.0

local updateReal = love.update
function love.update(dt)
    updateReal(dt)

    if G.GAME.blind then
        if G.GAME.blind.config.blind.key == 'bl_btti_truckBlind' or G.GAME.blind.config.blind.key == 'bl_btti_ticketBlind' then
            --G.GAME.blind.loc_debuff_lines = { math.random(1, 69), math.random(1, 69), G.GAME.blind.debuffedHand or 'Nothing mistah white...' }
            G.GAME.blind:set_text()
        end
    end

    btti_whorseFlashbangAlpha = lerp(btti_whorseFlashbangAlpha, 0.0, dt / 4.0)
    btti_dwayneTheRockAlpha = lerp(btti_dwayneTheRockAlpha, 0.0, dt)
end

local drawReal = love.draw
function love.draw()
    drawReal()

    love.graphics.setColor(1, 1, 1, btti_dwayneTheRockAlpha)
    love.graphics.draw(btti_dwayneTheRockImage, 0, 0, 0, (love.graphics.getWidth() / btti_dwayneTheRockImage:getWidth()),
        (love.graphics.getHeight() / btti_dwayneTheRockImage:getHeight()))
    love.graphics.setColor(1, 1, 1, btti_whorseFlashbangAlpha)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
end