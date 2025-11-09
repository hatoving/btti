--SpongeBob
SMODS.Atlas {
    key = "SpongeBob",
    path = "bttiSpongeBob.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'SpongeBob',
    loc_txt = {
        name = 'SpongeBob',
        text = {
            "All {C:attention}played cards{} count in scoring",
            "and get retriggered {C:blue}1-2{} times"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "SpongeBob SquarePants", "Stephen Hillenburg", "hatoving" } }
        return {
            vars = {},
        }
    end,
    rarity = 3,
    atlas = 'SpongeBob',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_RARE"] = true, },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.modify_scoring_hand and not context.blueprint then
            return {
                add_to_hand = true
            }
        end
        if context.repetition and context.cardarea == G.play then
            return {
                repetitions = pseudorandom("btti_" .. card.ability.name, 1, 2)
            }
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}