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
    if (self.config.center.pools or {}).BTTI_modAddition_CREATICA or ((self.ability and self.ability.extra and type(self.ability.extra) ~= "number") and self.ability.extra.huntrix) then
        return true
    else
        return canSellCardRef(self, context)
    end
end

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
    if context.selling_card then
        if context.card.ability.name == 'j_btti_Springtrap' and not G.GAME.btti_iAlwaysComeBack then
            sendInfoMessage("he always comes back...", "BTTI")
            G.GAME.btti_iAlwaysComeBack = true
        end
    end
    if context.end_of_round then
        if btti_PONG_initialized then
            btti_PONG_kill()
        end
        if btti_JDASH_initialized then
            btti_JDASH_kill()
        end
        if context.cardarea == G.jokers and G.GAME.btti_iAlwaysComeBack then
            if pseudorandom('WilliamAfton') < G.GAME.probabilities.normal / 4 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('glass'..math.random(1, 6), math.random()*0.2 + 0.9,0.5)
                        play_sound('generic1', math.random()*0.2 + 0.9,0.5)
                        play_sound("btti_Springtrap")
                        SMODS.add_card {
                            key = 'j_btti_Springtrap',
                            area = G.jokers
                        }
                        return true
                    end
                }))
                G.GAME.btti_iAlwaysComeBack = false
            end
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

local startDissolveRef = Card.start_dissolve
function Card:start_dissolve(dissolve_colours, silent, dissolve_time_fac, no_juice)
    if self.ability.name == 'j_btti_Springtrap' and not G.GAME.btti_iAlwaysComeBack then
        sendInfoMessage("he always comes back...", "BTTI")
        G.GAME.btti_iAlwaysComeBack = true
    end
    return startDissolveRef(self, dissolve_colours, silent, dissolve_time_fac, no_juice)
end