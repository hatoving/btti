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
    if (self.config.center.pools or {}).BTTI_modAddition_CREATICA or ((self.ability and self.ability.extra and type(self.ability.extra) ~= "number") and self.ability.huntrix) then
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
        if context.cardarea == G.jokers and G.GAME.btti_iAlwaysComeBack and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
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
        G.GAME.btti_isBlindBoss = false
    end
    local ret = calcJokerRef(self, context)
    return ret
end

local startDissolveRef = Card.start_dissolve
function Card:start_dissolve(dissolve_colours, silent, dissolve_time_fac, no_juice)
    if self.ability.name == 'j_btti_Springtrap' and not G.GAME.btti_iAlwaysComeBack then
        sendInfoMessage("he always comes back...", "BTTI")
        G.GAME.btti_iAlwaysComeBack = true
    end
    return startDissolveRef(self, dissolve_colours, silent, dissolve_time_fac, no_juice)
end

function Card:highlight(is_higlighted)
    self.highlighted = is_higlighted
    if self.ability.consumeable or self.ability.set == 'Joker' or (self.area and self.area == G.pack_cards) then
        if self.highlighted and self.area and self.area.config.type ~= 'shop' then
            if self.children.use_button then
                self.children.use_button:remove()
                self.children.use_button = nil
            end
            if self.children.extra_button then
                self.children.extra_button:remove()
                self.children.extra_button = nil
            end
            local x_off = (self.ability.consumeable and -0.1 or 0)
            self.children.use_button = UIBox{
                definition = G.UIDEF.use_and_sell_buttons(self), 
                config = {align=
                        ((self.area == G.jokers) or (self.area == G.consumeables)) and "cr" or
                        "bmi"
                    , offset = 
                        ((self.area == G.jokers) or (self.area == G.consumeables)) and {x=x_off - 0.4,y=0} or
                        {x=0,y=0.65},
                    parent =self}
            }
            self.children.extra_button = UIBox{
                definition = G.UIDEF.extra_button(self), 
                config = {align="bm"
                    , offset = 
                        ((self.area == G.jokers) or (self.area == G.consumeables)) and {x=x_off,y=0} or
                        {x=0,y=-.6},
                    parent =self}
            }
        elseif self.children.use_button and self.children.extra_button then
            self.children.use_button:remove()
            self.children.use_button = nil
            self.children.extra_button:remove()
            self.children.extra_button = nil
        elseif self.children.use_button then
            self.children.use_button:remove()
            self.children.use_button = nil
        elseif self.children.extra_button then
            self.children.extra_button:remove()
            self.children.extra_button = nil
        end
        
    end
    if self.ability.consumeable or self.ability.set == 'Joker' then
        if not self.highlighted and self.area and self.area.config.type == 'joker' and
            (#G.jokers.cards >= G.jokers.config.card_limit or (self.edition and self.edition.negative)) then
                if G.shop_jokers then G.shop_jokers:unhighlight_all() end
        end
    end
end

local ogCardDraw = Card.draw
function Card:draw(layer)
    ogCardDraw(self, layer)
    if self.children.extra_button and self.highlighted then self.children.extra_button:draw() end
end