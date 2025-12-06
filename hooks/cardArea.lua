function CardArea:remove_from_highlighted(card, force)
    if (not force) and  card and card.ability.forced_selection and self == G.hand then return end
    local comb = G.BTTI.getCombinableJokerKeys(card.ability.name)
    if #comb ~= 0 then
        for index, value in ipairs(self.highlighted) do
            for i2, v2 in ipairs(comb) do
                if value.ability.name == v2 then
                    self:unhighlight_all()
                    G.BTTI.combining = false
                    return
                end
            end
        end
    end
    for i = #self.highlighted,1,-1 do
        if self.highlighted[i] == card then
            table.remove(self.highlighted, i)
            break
        end
    end
    card:highlight(false)
    if self == G.hand and G.STATE == G.STATES.SELECTING_HAND then
        self:parse_highlighted()
    end
end

function CardArea:add_to_highlighted(card, silent)
    --if self.config.highlighted_limit <= #self.highlighted then return end
    if self.config.type == 'shop' then
        if #self.highlighted >= self.config.highlighted_limit then
            self:remove_from_highlighted(self.highlighted[1])
        end
        --if not G.FUNCS.check_for_buy_space(card) then return false end
        self.highlighted[#self.highlighted+1] = card
        card:highlight(true)
        if not silent then play_sound('cardSlide1') end
    elseif self.config.type == 'joker' or self.config.type == 'consumeable' then
        local comb = G.BTTI.getCombinableJokerKeys(card.ability.name)
        local skip = false
        if #self.highlighted > 1 then
            for _, combo in pairs(G.BTTI.JOKER_COMBOS) do
                if combo.allowed then
                    for i, val in ipairs(self.highlighted) do
                        if table_contains(combo.jokers, val.ability.name) then
                            for i, val2 in ipairs(self.highlighted) do
                                self:remove_from_highlighted(val2, true)
                            end
                            self:add_to_highlighted(card, silent)
                            return
                        end
                    end
                end
            end
        end
        G.BTTI.combining = false
        if #comb ~= 0 then
            for index, value in ipairs(self.highlighted) do
                for i2, v2 in ipairs(comb) do
                    if value.ability.name == v2 then
                        if value.children.use_button ~= nil then
                            value.children.use_button:remove()
                            value.children.use_button = nil
                        end
                        skip = true
                        G.BTTI.combining = true
                    end
                end
            end
        else
            for index, value in ipairs(self.highlighted) do
                self:remove_from_highlighted(self.highlighted[index])
            end
        end
        if #self.highlighted >= self.config.highlighted_limit and not skip then 
            self:remove_from_highlighted(self.highlighted[1])
        end
        table.insert(self.highlighted, 1, card)
        card:highlight(true)
        if not silent then play_sound('cardSlide1') end
    else
        if #self.highlighted >= self.config.highlighted_limit then
            card:highlight(false)
        else
            self.highlighted[#self.highlighted+1] = card
            card:highlight(true)
            if not silent then play_sound('cardSlide1') end
        end
        if self == G.hand and G.STATE == G.STATES.SELECTING_HAND then
            self:parse_highlighted()
        end
    end
    
end

