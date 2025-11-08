-- Huntrix
SMODS.Atlas {
    key = "Huntrix",
    path = "bttiHuntrix.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Huntrix',
    loc_txt = {
        name = 'HUNTR/X',
        text = {
            "Makes other {C:joker}Jokers",
            "eternal but still {C:attention}sellable",
            "while in hand"
        }
    },

    config = { extra = {} },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "KPop Demon Hunters", "Netflix" } }
        return {
            vars = {},
        }
    end,
    rarity = 3,
    atlas = 'Huntrix',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_RARE"] = true, },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    update = function(self, card, dt)
        if (G and G.jokers and G.jokers.cards) and (jokerExists('j_btti_Huntrix')) then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.name ~= 'j_btti_Huntrix' and not G.jokers.cards[i].ability.eternal then
                    G.jokers.cards[i]:set_eternal(true)
                    G.jokers.cards[i].ability.huntrix = true
                end
            end
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}