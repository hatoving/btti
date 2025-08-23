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
    path = "bttiMysticalia.png", -- placeholder
    px = 65,
    py = 95
}
SMODS.Consumable {
    key = "mysticalia",
    set = "Planet",
    cost = 10,
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
    path = "bttiPedast.png", -- placeholder
    px = 65,
    py = 95
}
SMODS.Consumable {
    key = "pedast",
    set = "Planet",
    cost = 10,
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
    path = "bttiTrihooft.png", -- placeholder
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
    path = "bttiApocalypt.png", -- placeholder
    px = 65,
    py = 95
}
SMODS.Consumable {
    key = "apocalypt",
    set = "Planet",
    cost = 20,
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
    path = "bttiDEETS.png", -- placeholder
    px = 65,
    py = 95
}
SMODS.Consumable {
    key = "deets",
    set = "Planet",
    cost = 30,
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

-- Tarots

-- The Maze
SMODS.Atlas {
    key = "maze",
    path = "bttiMaze.png", -- placeholder
    px = 65,
    py = 95
}
SMODS.Consumable {
    key = "maze",
    set = "Tarot",
    cost = 5,
    pos = { x = 0, y = 0 },
    config = { max_highlighted = 1, mod_conv = 'm_btti_horseCard' },
    loc_txt = {
        name = "The Maze",
        text = {
            "Enhances one selected {C:attention}Card{} to",
            "a {C:deets}Horse Card{}"
        },
    },
    atlas = 'maze',
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
            }
        }
    end
}

-- The Maze
SMODS.Atlas {
    key = "purity",
    path = "bttiPurity.png", -- placeholder
    px = 65,
    py = 95
}
SMODS.Consumable {
    key = "purity",
    set = "Tarot",
    cost = 5,
    pos = { x = 0, y = 0 },
    config = { max_highlighted = 2 },
    loc_txt = {
        name = "The Purity",
        text = {
            "Removes {C:attention}Orange Seals{}",
            "from up to 2 selected {C:attention}Cards"
        },
    },
    atlas = 'purity',
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
            }
        }
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        for i = 1, #G.hand.highlighted do
            local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('card1', percent)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        delay(0.2)
        for i = 1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    G.hand.highlighted[i].seal = nil
                    G.hand.highlighted[i]:set_seal()
                    return true
                end
            }))
        end
        for i = 1, #G.hand.highlighted do
            local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('tarot2', percent, 0.6)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
        delay(0.5)
    end,
    can_use = function(self, card)
        return G.hand and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.max_highlighted
    end
}
