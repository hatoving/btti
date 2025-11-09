-- One
SMODS.Atlas {
    key = "One",
    path = "bttiOne.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'One',
    loc_txt = {
        name = 'One',
        text = {
            "{C:green}1 in 4{} chance to drain {C:dark_edition}editions{} of",
            "other {C:joker}Jokers",
            "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips, {X:mult,C:white}X#2#{C:inactive} Mult, {C:mult}+#3#{} Mult)"
        }
    },

    config = { extra = { chips = 0, mult = 0, Xmult = 0.0 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Battle for Dream Island", "jacknjellify", "BlueBen8" } }
        return {
            vars = { card.ability.extra.chips, card.ability.extra.Xmult, card.ability.extra.mult },
        }
    end,
    rarity = 3,
    atlas = 'One',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_RARE"] = true, },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.setting_blind or context.before or (context.end_of_round and context.cardarea == G.jokers) or context.final_scoring_step then
            if pseudorandom('One') < G.GAME.probabilities.normal / 4 then
                local idx = pseudorandom("btti_" .. card.ability.name, 1, #G.jokers.cards)
                local ed = G.jokers.cards[idx].edition or nil

                sendInfoMessage("one chose " .. idx .. "", "BTTI")

                -- only drain powers if the selected card ain't herself + if the selected card has an edition to drain
                if ed ~= nil and idx ~= getJokerID(card) then
                    return {
                        message = "Ahahaha!!",
                        colour = G.C.BLUE,
                        G.E_MANAGER:add_event(Event({
                            trigger = 'immediate',
                            blocking = false,
                            delay = 0,
                            func = function()
                                G.jokers.cards[idx]:set_edition()
                                G.jokers.cards[idx]:juice_up()

                                sendInfoMessage("one chose " .. ed.key .. "", "BTTI")

                                if ed.key == 'e_foil' then
                                    card.ability.extra.chips = card.ability.extra.chips + 50
                                elseif ed.key == 'e_polychrome' then
                                    card.ability.extra.Xmult = card.ability.extra.Xmult + 1.5
                                elseif ed.key == 'e_holo' then
                                    card.ability.extra.mult = card.ability.extra.mult + 10
                                elseif ed.key == 'e_negative' then
                                    card:set_edition('e_negative')
                                end

                                card:juice_up()
                                return true
                            end,
                        }))
                    }
                end
            else
                return {
                    message = "Nope...",
                    colour = G.C.BLUE,
                }
            end
        end
        if context.joker_main then
            local rets = {}
            if card.ability.extra.chips > 0 then
                table.insert(rets, {
                    chips = card.ability.extra.chips
                })
            end
            if card.ability.extra.mult > 0 then
                table.insert(rets, {
                    mult = card.ability.extra.mult
                })
            end
            if card.ability.extra.Xmult > 0 then
                table.insert(rets, {
                    Xmult = card.ability.extra.Xmult
                })
            end
            return SMODS.merge_effects(rets)
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}