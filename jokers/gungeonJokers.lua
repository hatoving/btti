-- The Dragun
SMODS.Atlas {
    key = "Dragun",
    path = "bttiDragun.png",
    px = 71,
    py = 95,
}
SMODS.Joker {
    key = 'Dragun',
    loc_txt = {
        name = 'The Dragun',
        text = {
            "{X:mult,C:white}X5{} Mult if played hand",
            "has exactly {C:blue}5{} cards"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Enter the Gungeon", "Dodge Roll Games, Devolver Digital", "BlueBen8" } }
        return {
            vars = {},
        }
    end,
    rarity = 3,
    atlas = 'Dragun',
    pos = { x = 0, y = 0 },
    cost = 5,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_RARE"] = true, },

    pixel_size = { w = 71, h = 95 },
    frame = 0,
    maxFrame = 32,
    frameDur = 0.085,
    ticks = 0,

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.joker_main then
            if #G.play.cards == 5 then
                return {
                    xmult = 5
                }
            end
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}