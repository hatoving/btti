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

-- Mysticalia
SMODS.Atlas {
    key = "mysticalia",
    path = "bttiPegasi.png", -- placeholder
    px = 65,
    py = 95
}
SMODS.Consumable {
    key = "mysticalia",
    set = "Planet",
    cost = 3,
    pos = { x = 0, y = 0 },
    config = { hand_type = 'HighHorse' },
    loc_txt = {
        name = "Mysticalia",
        text = {
            "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
            "{C:attention}#2#",
            "{C:mult}+#3#{} Mult and",
            "{C:chips}+#4#{} chips", --idk how to change the values but it oughta be +2 mult and +20 chips
        },
    },
    atlas = 'mysticalia',
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

-- Pedast
SMODS.Atlas {
    key = "pedast",
    path = "bttiPegasi.png", -- placeholder
    px = 65,
    py = 95
}
SMODS.Consumable {
    key = "pedast",
    set = "Planet",
    cost = 3,
    pos = { x = 0, y = 0 },
    config = { hand_type = 'TwoHorse' },
    loc_txt = {
        name = "Pedast",
        text = {
            "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
            "{C:attention}#2#",
            "{C:mult}+#3#{} Mult and",
            "{C:chips}+#4#{} chips", --idk how to change the values but it oughta be +2 mult and +20 chips
        },
    },
    atlas = 'pedast',
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

-- Trihooft
SMODS.Atlas {
    key = "trihooft",
    path = "bttiPegasi.png", -- placeholder
    px = 65,
    py = 95
}
SMODS.Consumable {
    key = "trihooft",
    set = "Planet",
    cost = 3,
    pos = { x = 0, y = 0 },
    config = { hand_type = 'ThreeHorse' },
    loc_txt = {
        name = "Trihooft",
        text = {
            "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
            "{C:attention}#2#",
            "{C:mult}+#3#{} Mult and",
            "{C:chips}+#4#{} chips", --idk how to change the values but it oughta be +2 mult and +20 chips
        },
    },
    atlas = 'trihooft',
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

-- Apocalypt
SMODS.Atlas {
    key = "apocalypt",
    path = "bttiPegasi.png", -- placeholder
    px = 65,
    py = 95
}
SMODS.Consumable {
    key = "apocalypt",
    set = "Planet",
    cost = 3,
    pos = { x = 0, y = 0 },
    config = { hand_type = 'FourHorsemen' },
    loc_txt = {
        name = "Apocalypt",
        text = {
            "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
            "{C:attention}#2#",
            "{C:mult}+#3#{} Mult and",
            "{C:chips}+#4#{} chips", --idk how to change the values but it oughta be +2 mult and +20 chips
        },
    },
    atlas = 'apocalypt',
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

-- DEETS hb.117ca
SMODS.Atlas {
    key = "deets",
    path = "bttiPegasi.png", -- placeholder
    px = 65,
    py = 95
}
SMODS.Consumable {
    key = "deets",
    set = "Planet",
    cost = 3,
    pos = { x = 0, y = 0 },
    config = { hand_type = 'FullHorse' },
    loc_txt = {
        name = "DEETS hb.117ca",
        text = {
            "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
            "{C:attention}#2#",
            "{C:mult}+#3#{} Mult and",
            "{C:chips}+#4#{} chips", --idk how to change the values but it oughta be +2 mult and +20 chips
        },
    },
    atlas = 'deets',
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
