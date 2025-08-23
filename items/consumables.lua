-- Kepler
SMODS.Atlas {
    key = "kepler",
    path = "bttiKepler.png", -- placeholder
    px = 65,
    py = 95
}
SMODS.Consumable {
    key = "kepler",
    set = "Planet",
    cost = 3,
    pos = { x = 0, y = 0 },
    config = { hand_type = 'Bisexual' },
    loc_txt = {
        name = "Kepler",
        text = {
            "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
            "{C:attention}#2#",
            "{C:mult}+#3#{} Mult and",
            "{C:chips}+#4#{} chips",
        },
    },
    atlas = 'kepler',
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                G.GAME.hands[card.ability.hand_type].level,
                localize(card.ability.hand_type, 'poker_hands'),
                G.GAME.hands[card.ability.hand_type].l_mult,
                G.GAME.hands[card.ability.hand_type].l_chips,
                colours = { (G.GAME.hands[card.ability.hand_type].level == 1 and G.C.UI.TEXT_DARK or G.C.HAND_LEVELS[math.min(7, G.GAME.hands[card.ability.hand_type].level)]) }
            }
        }
    end
}

-- Pegasi
SMODS.Atlas {
    key = "pegasi",
    path = "bttiPegasi.png", -- placeholder
    px = 65,
    py = 95
}
SMODS.Consumable {
    key = "pegasi",
    set = "Planet",
    cost = 3,
    pos = { x = 0, y = 0 },
    config = { hand_type = 'BisexualFlush' },
    loc_txt = {
        name = "Pegasi",
        text = {
            "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
            "{C:attention}#2#",
            "{C:mult}+#3#{} Mult and",
            "{C:chips}+#4#{} chips",
        },
    },
    atlas = 'pegasi',
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                G.GAME.hands[card.ability.hand_type].level,
                localize(card.ability.hand_type, 'poker_hands'),
                G.GAME.hands[card.ability.hand_type].l_mult,
                G.GAME.hands[card.ability.hand_type].l_chips,
                colours = { (G.GAME.hands[card.ability.hand_type].level == 1 and G.C.UI.TEXT_DARK or G.C.HAND_LEVELS[math.min(7, G.GAME.hands[card.ability.hand_type].level)]) }
            }
        }
    end
}
