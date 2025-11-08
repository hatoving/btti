-- Hanako
SMODS.Atlas {
    key = "Hanako",
    path = "bttiHanako.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Hanako',
    loc_txt = {
        name = 'Hanako Takeuchi',
        text = {
            "Adds the {C:attention}sell value{} of",
            "{C:joker}Jokers{} sold to {C:chips}Chips{} and {C:mult}Mult{}",
            "Does not count previously",
            "sold {C:joker}Jokers{}",
            "{C:inactive}(Currently {C:chips}+#2#{} Chips, {C:mult}+#1#{} Mult)"
        }
    },

    config = { extra = { smult = 0, schips = 0} },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "YOURS TRULY, HANAKO", "hatoving" } }
        return {
            vars = { card.ability.extra.smult, card.ability.extra.schips },
        }
    end,
    rarity = 1,
    atlas = 'Hanako',
    pos = { x = 0, y = 0 },
    cost = 4,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_COMMON"] = true, },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.schips,
                mult = card.ability.extra.smult
            }
        end

        if context.selling_card and context.card.ability.set == 'Joker' then
            if context.card ~= card then
                card.ability.extra.schips = card.ability.extra.schips + context.card.cost
                card.ability.extra.smult = card.ability.extra.smult + context.card.sell_cost
                return {
                    message = "... oh ._.",
                    colour = G.C.YELLOW
                }
            end
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

SMODS.Atlas {
    key = "Cassidy",
    path = "bttiCassidy.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Cassidy',
    loc_txt = {
        name = 'Cassidy Kairi Mari',
        text = {
            "Uses {C:attention}${} to gain {C:chips}Chips{} and {C:mult}Mult",
            "{C:green}1 in 10{} chance to waste {C:attention}$",
            "and {C:red}destroy{} itself at end of {C:attention}round{}",
            "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips, {C:mult}+#1#{C:inactive} Mult)"
        }
    },

    config = { extra = { mult = 0, chips = 0} },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "YOURS TRULY, HANAKO", "hatoving" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.chips },
        }
    end,
    rarity = 1,
    atlas = 'Cassidy',
    pos = { x = 0, y = 0 },
    cost = 4,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_COMMON"] = true, },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.joker_main then
            local steal = pseudorandom("btti_" .. card.ability.name, 1, math.clamp(G.GAME.dollars, 1, 10))
            if steal > G.GAME.dollars then
                steal = G.GAME.dollars
            end
            card.ability.extra.chips = card.ability.extra.chips + steal * 2
            card.ability.extra.mult = card.ability.extra.mult + math.floor(steal / 2)
            return SMODS.merge_effects {
                {
                    message = "Thanks!",
                    dollars = -steal,
                    colour = G.C.YELLOW
                },
                {
                    chips = card.ability.extra.chips,
                    mult = card.ability.extra.mult
                }
            }
        end
        if context.end_of_round and context.cardarea == G.jokers then
            if pseudorandom('Cassidy') < G.GAME.probabilities.normal / 10 then
                local steal = pseudorandom("btti_" .. card.ability.name, 1, math.clamp(G.GAME.dollars, 1, 15))
                if steal > G.GAME.dollars then
                    steal = G.GAME.dollars
                end
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound("tarot1")
                        card:start_dissolve()
                        return true
                    end
                }))
                return {
                    message = "Gotta dip!",
                    dollars = -steal,
                    colour = G.C.YELLOW,
                }
            end
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}