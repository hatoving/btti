local gFuncsSetBlindRef = G.FUNCS.select_blind
function G.FUNCS.select_blind(e)
    if jokerExists('j_btti_Spoingus') and G.jokers.cards[getJoker('j_btti_Spoingus')] then
        e = G.blind_select_opts.boss:get_UIE_by_ID('select_blind_button')
    end
    return gFuncsSetBlindRef(e)
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
        btti_PONG_initByItself = true
        btti_JDASH_initByItself = true

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
    if context.end_of_round then
        if btti_PONG_initialized then
            btti_PONG_kill()
        end
        if btti_JDASH_initialized then
            btti_JDASH_kill()
        end
    end
    if context.ante_change and context.ante_end then
        sendInfoMessage("Ante change!", "BTTI")
        local digitalCards = 0
        for i, pc in ipairs(G.playing_cards) do
            if pc.edition then
                if pc.edition.key == 'e_btti_digital' then
                    digitalCards = digitalCards + 1
                    pc:start_dissolve()
                end
            end
        end
        sendInfoMessage("glitchus deletus : " .. digitalCards, "BTTI")
        G.GAME.btti_isBlindBoss = false
    end
    return calcJokerRef(self, context)
end


local playSoundRef = play_sound
function play_sound(sound_code, per, vol)
    if string.find(sound_code, 'multhit') ~= nil then
        if G.jokers then
            for i, jk in ipairs(G.jokers.cards) do
                if jk.config.center.key == "j_btti_MetalPipe" then
                    sendInfoMessage("playing metal pipe instead", "BTTI")
                    return playSoundRef('btti_metalPipeMult', per, vol)
                end
            end
        end
    end
    return playSoundRef(sound_code, per, vol)
end

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

local canSellCardRef = Card.can_sell_card
function Card:can_sell_card(context)
    if (self.config.center.pools or {}).BTTI_modAddition_CREATICA or (self.ability and self.ability.extra and self.ability.extra.huntrix) then
        return true
    else
        return canSellCardRef(self, context)
    end
end

btti_whorseFlashbangAlpha = 0.0
btti_dwayneTheRockImage = loadImage('rock.png')
btti_dwayneTheRockAlpha = 0.0

local updateReal = love.update
function love.update(dt)
    updateReal(dt)

    if (G and G.jokers and G.jokers.cards) and (not jokerExists('j_btti_Huntrix')) then
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i].ability.extra and G.jokers.cards[i].ability.extra.huntrix then
                G.jokers.cards[i].ability.extra.huntrix = false
                G.jokers.cards[i].ability.eternal = false
            end
        end
    end
    
    if G and G.GAME then
        if G.STATE == G.STATES.MENU then
            if btti_PONG_state ~= btti_PONG_STATES.GAME_OVER then
                btti_PONG_initByItself = true
                btti_PONG_kill()
            end
            if btti_JDASH_state ~= btti_JDASH_STATES.GAME_OVER then
                btti_JDASH_initByItself = true
                btti_JDASH_kill()
            end
        end
    end

    btti_PONG_update(dt)
    btti_JDASH_update(dt)

    for i = 1, #G.effectmanager do
        if G.effectmanager[i] and G.effectmanager[i][1] then
            if G.effectmanager[i][1].duration ~= nil and G.effectmanager[i][1].duration >= -1 then
                local _eff = G.effectmanager[i][1]

                _eff.tfps = _eff.tfps + 1
                _eff.duration = _eff.duration - 1

                if _eff.tfps > 100 / _eff.fps and _eff.fps ~= 0 then
                    _eff.frame = _eff.frame + 1
                    _eff.tfps = 0
                end
                if _eff.frame > _eff.maxframe then
                    _eff.frame = 1
                end
            elseif G.effectmanager[i][1].duration ~= nil and G.effectmanager[i][1].duration <= 0 then
                G.effectmanager[i] = nil
            end
        end
    end
    
    if G.GAME.blind then
        if G.GAME.blind.config.blind.key == 'bl_btti_truckBlind' or G.GAME.blind.config.blind.key == 'bl_btti_ticketBlind' then
            --G.GAME.blind.loc_debuff_lines = { math.random(1, 69), math.random(1, 69), G.GAME.blind.debuffedHand or 'Nothing mistah white...' }
            G.GAME.blind:set_text()
        end

        if G.GAME.blind.config.blind.key == 'bl_btti_levelBlind' then
            G.GAME.btti_levelBlindCountdown = G.GAME.btti_levelBlindCountdown - dt
            if G.GAME.btti_levelBlindCountdown <= 0.0 then
                G.GAME.btti_levelBlindCountdown = 5.0
                local emptyEditionIndices = {}
                for i, card in ipairs(G.hand.cards) do
                    if card.edition == nil then
                        table.insert(emptyEditionIndices, i)
                    end
                end

                if #emptyEditionIndices > 0 then
                    local randomIndex = emptyEditionIndices[math.random(1, #emptyEditionIndices)]
                    local card = G.hand.cards[randomIndex]

                    card:set_edition('e_btti_digital')
                    card:juice_up()
                else
                    sendInfoMessage("All cards already have editions!", "BTTI")
                end
            end
        end
        if G.GAME.blind.config.blind.key == 'bl_btti_pongBlind' then
            if not btti_PONG_initialized and btti_PONG_initByItself then
                btti_PONG_init()
                btti_PONG_initByItself = false
            end
        else
            if btti_PONG_initialized and btti_PONG_state ~= btti_PONG_STATES.GAME_OVER then
                btti_PONG_kill()
                btti_PONG_initByItself = true
            end
        end
        if G.GAME.blind.config.blind.key == 'bl_btti_gdBlind' then
            if not btti_JDASH_initialized and btti_JDASH_initByItself then
                btti_JDASH_init()
                btti_JDASH_initByItself = false
            end
        else
            if btti_JDASH_initialized and btti_JDASH_state ~= btti_JDASH_STATES.GAME_OVER then
                btti_JDASH_kill()
                btti_JDASH_initByItself = true
            end
        end
        --btti_JDASH_init()
    end

    btti_whorseFlashbangAlpha = lerp(btti_whorseFlashbangAlpha, 0.0, dt / 4.0)
    btti_dwayneTheRockAlpha = lerp(btti_dwayneTheRockAlpha, 0.0, dt)
end

local explosion = loadImage("explosion.png")
local explosionSpriteSheet = loadImageSpriteSheet("explosion.png", 200,
                            282, 17, 0)
function btti_MODDRAW()
    love.graphics.push()

    love.graphics.setColor(1, 1, 1, btti_dwayneTheRockAlpha)
    love.graphics.draw(btti_dwayneTheRockImage, 0, 0, 0, (love.graphics.getWidth() / btti_dwayneTheRockImage:getWidth()),
        (love.graphics.getHeight() / btti_dwayneTheRockImage:getHeight()))
    love.graphics.setColor(1, 1, 1, btti_whorseFlashbangAlpha)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    btti_PONG_draw()
    btti_JDASH_draw()

    if G.effectmanager then
        --print("Effect manager has "..#G.effectmanager)
        for i = 1, #G.effectmanager do
            local _xscale = love.graphics.getWidth()/1920
            local _yscale = love.graphics.getHeight()/1080
            --print("G.effectmanager[i].name ".. G.effectmanager[i][1].name)
            if G.effectmanager[i] ~= nil then
                if G.effectmanager[i][1].name == "explosion" then
                    bttiEffectManagerImgToDraw = explosion
                    bttiEffectManagerQuadToDraw = explosionSpriteSheet
                    bttiEffectManagerImgIndex = G.effectmanager[i][1].frame
                    bttiEffectManagerXPos = G.effectmanager[i][1].xpos-(200/2)
                    bttiEffectManagerYPos = G.effectmanager[i][1].ypos-(282/2)
                    --print("_imgindex".. _imgindex)
                    love.graphics.setColor(1, 1, 1, 1)
                end
                if bttiEffectManagerQuadToDraw ~= nil then
                    love.graphics.draw(bttiEffectManagerImgToDraw, bttiEffectManagerQuadToDraw
                        [bttiEffectManagerImgIndex],
                        bttiEffectManagerXPos, bttiEffectManagerYPos, 0, 1, 1)
                end
            end
        end
    end

    love.graphics.pop()
end