SMODS.Font({ 
    key = "vcr", 
    path = "bttiVcr.ttf"
})


-- Mindflayer
SMODS.Atlas {
    key = "Mindflayer",
    path = "bttiMindflayer.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Mindflayer',
    loc_txt = {
        name = '{f:btti_vcr}Mindflayer',
        text = {
            "{C:chips}+15{} Chips",
            "{C:chips}+10{} Chips for every {C:attention}card",
            "played this {C:attention}round",
            "Resets at end of {C:attention}round",
            "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)"
        }
    },

    config = { extra = { chips = 15 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "ULTRAKILL", "Arsi \"Hakita\" Patala, New Blood Interactive", "BlueBen8" } }
        return {
            vars = { card.ability.extra.chips },
        }
    end,
    rarity = 1,
    atlas = 'Mindflayer',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_COMMON"] = true, },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            card.ability.extra.chips = card.ability.extra.chips + 10
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
        if context.end_of_round and context.cardarea == G.jokers then
            card.ability.extra.chips = 15
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}