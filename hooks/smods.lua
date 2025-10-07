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
            if G.GAME.blind.config.blind.key == 'bl_btti_captainBlind' and not G.GAME.blind.disabled then
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

SMODS.collection_pool = function(_base_pool)
    local pool = {}
    if type(_base_pool) ~= 'table' then return pool end
    local is_array = _base_pool[1]
    local ipairs = is_array and ipairs or pairs
    for _, v in ipairs(_base_pool) do
        if (not G.ACTIVE_MOD_UI or v.mod == G.ACTIVE_MOD_UI) and (not v.no_collection or _base_pool == G.P_CENTER_POOLS.BTTI_modAddition_COMBO) then
            pool[#pool+1] = v
        end
    end
    if not is_array then table.sort(pool, function(a,b) return a.order < b.order end) end
    return pool
end