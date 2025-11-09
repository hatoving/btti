G.FUNCS.can_combine_card = function(e)
    if G.BTTI.combining then 
        e.config.colour = G.C.PURPLE
        e.config.button = 'combine_card'
    else
      e.config.colour = G.C.UI.BACKGROUND_INACTIVE
      e.config.button = nil
    end
end

local function card_key(card)
    if card.key then return card.key end
    if card.get_key then return card:get_key() end
    if card.config and card.config.center and card.config.center.key then
        return card.config.center.key
    end
    return nil
end

G.FUNCS.combine_card = function(e)
    local card = e.config.ref_table

    local results = {}
    for combo_key, combo_data in pairs(G.BTTI.JOKER_COMBOS) do
        local needed = combo_data.jokers
        local allowed = combo_data.allowed or {}
        local found = {}

        local matched_needed = {}
        local matched_allowed = {}

        for _, player_card in ipairs(G.jokers.highlighted) do
            for _, required in ipairs(needed) do
                if player_card.config.center.key == required then
                    found[required] = true
                    table.insert(matched_needed, player_card)
                end
            end
            for _, allowed_jk in ipairs(allowed) do
                if player_card.config.center.key == allowed_jk then
                    found[allowed_jk] = true
                    table.insert(matched_allowed, player_card)
                    break
                end
            end
        end

        local all_found = true
        for _, required in ipairs(needed) do
            if not found[required] then
                all_found = false
                break
            end
        end

        if all_found and #needed < 2 and #allowed > 0 then
            local any_allowed = false
            for _, allowed_jk in ipairs(allowed) do
                if found[allowed_jk] then
                    any_allowed = true
                    break
                end
            end
            all_found = any_allowed
        end

        if all_found then
            table.insert(results, {
                key = combo_key,
                neededToDiscard = matched_needed,
                allowedToDiscard = matched_allowed,
                rarity = combo_data.rarity or 1
            })
            --sendInfoMessage("found " .. combo_key, "BTTI")
        end
    end

    table.sort(results, function(a, b)
        return a.rarity < b.rarity
    end)

    if #results > 0 then
        local result = results[1]

        -- only destroy one card per joker key
        local destroyed_keys = {}
        for _, c in ipairs(result.neededToDiscard) do
            local k = card_key(c)
            if k and not destroyed_keys[k] then
                c:remove()
                destroyed_keys[k] = true
            end
        end

        if #result.allowedToDiscard > 0 then
            local idx = math.random(1, #result.allowedToDiscard)
            result.allowedToDiscard[idx]:remove()
        end

        local c = SMODS.add_card { key = result.key }
        c:juice_up()
        SMODS.calculate_context { combined_joker = c }
    end
    delay(0.5)
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.2,
        func = function()
            G.jokers:unhighlight_all()
            return true
        end
    }))
    delay(0.5)
end

local gFuncsSetBlindRef = G.FUNCS.select_blind
G.FUNCS.select_blind = function(e)
    if jokerExists('j_btti_Spoingus') and G.jokers.cards[getJoker('j_btti_Spoingus')] then
        G.jokers.cards[getJoker('j_btti_Spoingus')].ability.extra.effect = math.random(1, 8)
        sendInfoMessage("spoingus effect " .. G.jokers.cards[getJoker('j_btti_Spoingus')].ability.extra.effect .. "",
            "BTTI")
        if G.jokers.cards[getJoker('j_btti_Spoingus')].ability.extra.effect == 7 then
            e = G.blind_select_opts.boss:get_UIE_by_ID('select_blind_button')
        end
    end
    return gFuncsSetBlindRef(e)
end
