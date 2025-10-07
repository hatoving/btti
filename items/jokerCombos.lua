--#region VANILLA COMBO JOKERS

-- Avariocious
SMODS.Atlas {
    key = "avariciousJoker",
    path = "bttiAvariciousJoker.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'avariciousJoker',
    loc_txt = {
        name = 'Avaricious Joker',
        text = {
            "Played cards with {C:diamonds}Diamond",
            "or {C:hearts}Heart{} suits give {C:mult}+3{} Mult",
            "when scored",
            "{C:inactive}(Lusty Joker + Greedy Joker)"
        }
    },

    config = { extra = { } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 2,
    atlas = 'avariciousJoker',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTI_modAddition_COMBO"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    no_collection = true,

    set_badges = function(self, card, badges)
        badges[#badges + 1] = create_badge('Combination Joker', G.C.DARK_EDITION, G.C.WHITE, 1.2)
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and
            (context.other_card:is_suit('Diamonds') or context.other_card:is_suit('Hearts')) then
            return {
                mult = 3
            }
        end
    end,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end
}

-- Sullen Joker
SMODS.Atlas {
    key = "sullenJoker",
    path = "bttiSullenJoker.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'sullenJoker',
    loc_txt = {
        name = 'Sullen Joker',
        text = {
            "Played cards with {C:spades}Spade",
            "or {C:clubs}Club{} suits give {C:mult}+3{} Mult",
            "when scored",
            "{C:inactive}(Wrathful Joker + Gluttonous Joker)"
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
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 2,
    atlas = 'sullenJoker',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTI_modAddition_COMBO"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    no_collection = true,

    set_badges = function(self, card, badges)
        badges[#badges + 1] = create_badge('Combination Joker', G.C.DARK_EDITION, G.C.WHITE, 1.2)
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and
            (context.other_card:is_suit('Spades') or context.other_card:is_suit('Clubs')) then
            return {
                mult = 3
            }
        end
    end,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end
}

SMODS.Atlas {
    key = "sinfulJoker",
    path = "bttiSinfulJoker.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'sinfulJoker',
    loc_txt = {
        name = 'Sinful Joker',
        text = {
            "Played cards give {C:mult}+5{}",
            "Mult when scored",
            "{C:inactive}(Avaricious Joker + Sullen Joker)"
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
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 3,
    atlas = 'sinfulJoker',
    pos = { x = 0, y = 0 },
    cost = 8,
    pools = { ["BTTI_modAddition_COMBO"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    no_collection = true,

    set_badges = function(self, card, badges)
        badges[#badges + 1] = create_badge('Combination Joker', G.C.DARK_EDITION, G.C.WHITE, 1.2)
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            return {
                mult = 5
            }
        end
    end,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end
}

SMODS.Atlas {
    key = "jovialJoker",
    path = "bttiJovialJoker.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'jovialJoker',
    loc_txt = {
        name = 'Jovial Joker',
        text = {
            "{C:mult}+8{} Mult and {C:chips}+50{} Chips",
            "if played hand contains a",
            "{C:attention}Pair",
            "{C:inactive}(Jolly Joker + Sly Joker)"
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
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 1,
    atlas = 'jovialJoker',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTI_modAddition_COMBO"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    no_collection = true,

    set_badges = function(self, card, badges)
        badges[#badges + 1] = create_badge('Combination Joker', G.C.DARK_EDITION, G.C.WHITE, 1.2)
    end,
    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands['Pair']) then
            return {
                mult = 8,
                chips = 50
            }
        end
    end,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end
}

SMODS.Atlas {
    key = "confusedJoker",
    path = "bttiConfusedJoker.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'confusedJoker',
    loc_txt = {
        name = 'Confused Joker',
        text = {
            "{C:mult}+12{} Mult and {C:chips}+100{} Chips",
            "if played hand contains a",
            "{C:attention}Three of a Kind",
            "{C:inactive}(Zany Joker + Wily Joker)"
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
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 1,
    atlas = 'confusedJoker',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTI_modAddition_COMBO"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    no_collection = true,

    set_badges = function(self, card, badges)
        badges[#badges + 1] = create_badge('Combination Joker', G.C.DARK_EDITION, G.C.WHITE, 1.2)
    end,
    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands['Three of a Kind']) then
            return {
                mult = 12,
                chips = 100
            }
        end
    end,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end
}

SMODS.Atlas {
    key = "geniusJoker",
    path = "bttiGeniusJoker.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'geniusJoker',
    loc_txt = {
        name = 'Genius Joker',
        text = {
            "{C:mult}+10{} Mult and {C:chips}+80{} Chips",
            "if played hand contains a",
            "{C:attention}Two Pair",
            "{C:inactive}(Mad Joker + Clever Joker)"
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
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 2,
    atlas = 'geniusJoker',
    pos = { x = 0, y = 0 },
    cost = 8,
    pools = { ["BTTI_modAddition_COMBO"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    no_collection = true,

    set_badges = function(self, card, badges)
        badges[#badges + 1] = create_badge('Combination Joker', G.C.DARK_EDITION, G.C.WHITE, 1.2)
    end,
    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands['Two Pair']) then
            return {
                mult = 10,
                chips = 80
            }
        end
    end,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end
}

SMODS.Atlas {
    key = "bonkersJoker",
    path = "bttiBonkersJoker.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'bonkersJoker',
    loc_txt = {
        name = 'Bonkers Joker',
        text = {
            "{C:mult}+12{} Mult and {C:chips}+100{} Chips",
            "if played hand contains a",
            "{C:attention}Straight",
            "{C:inactive}(Crazy Joker + Devious Joker)"
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
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 3,
    atlas = 'bonkersJoker',
    pos = { x = 0, y = 0 },
    cost = 8,
    pools = { ["BTTI_modAddition_COMBO"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    no_collection = true,

    set_badges = function(self, card, badges)
        badges[#badges + 1] = create_badge('Combination Joker', G.C.DARK_EDITION, G.C.WHITE, 1.2)
    end,
    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands['Straight']) then
            return {
                mult = 12,
                chips = 100
            }
        end
    end,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end
}

SMODS.Atlas {
    key = "deliberateJoker",
    path = "bttiDeliberateJoker.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'deliberateJoker',
    loc_txt = {
        name = 'Deliberate Joker',
        text = {
            "{C:mult}+10{} Mult and {C:chips}+80{} Chips",
            "if played hand contains a",
            "{C:attention}Flush",
            "{C:inactive}(Droll Joker + Crafty Joker)"
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
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 3,
    atlas = 'deliberateJoker',
    pos = { x = 0, y = 0 },
    cost = 8,
    pools = { ["BTTI_modAddition_COMBO"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    no_collection = true,

    set_badges = function(self, card, badges)
        badges[#badges + 1] = create_badge('Combination Joker', G.C.DARK_EDITION, G.C.WHITE, 1.2)
    end,
    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands['Flush']) then
            return {
                mult = 10,
                chips = 80
            }
        end
    end,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end
}

SMODS.Atlas {
    key = "splitJovialJoker",
    path = "bttiSplitJovialJoker.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'splitJovialJoker',
    loc_txt = {
        name = 'Split Jovial Joker',
        text = {
            "{C:mult}+28{} Mult and {C:chips}+80{} Chips",
            "if played hand contains a",
            "{C:attention}Pair",
            "{C:inactive}(Jovial Joker + Half Joker)"
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
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 2,
    atlas = 'splitJovialJoker',
    pos = { x = 0, y = 0 },
    cost = 8,
    pools = { ["BTTI_modAddition_COMBO"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    no_collection = true,

    set_badges = function(self, card, badges)
        badges[#badges + 1] = create_badge('Combination Joker', G.C.DARK_EDITION, G.C.WHITE, 1.2)
    end,
    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands['Pair']) then
            return {
                mult = 28,
                chips = 80
            }
        end
    end,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end
}

SMODS.Atlas {
    key = "splitConfusedJoker",
    path = "bttiSplitConfusedJoker.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'splitConfusedJoker',
    loc_txt = {
        name = 'Split Confused Joker',
        text = {
            "{C:mult}+32{} Mult and {C:chips}+100{} Chips",
            "if played hand contains a",
            "{C:attention}Three of a Kind",
            "{C:inactive}(Confused Joker + Half Joker)"
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
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 2,
    atlas = 'splitConfusedJoker',
    pos = { x = 0, y = 0 },
    cost = 8,
    pools = { ["BTTI_modAddition_COMBO"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    no_collection = true,

    set_badges = function(self, card, badges)
        badges[#badges + 1] = create_badge('Combination Joker', G.C.DARK_EDITION, G.C.WHITE, 1.2)
    end,
    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands['Three of a Kind']) then
            return {
                mult = 32,
                chips = 100
            }
        end
    end,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end
}

SMODS.Atlas {
    key = "zeroTheo",
    path = "bttiZeroTheo.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'zeroTheo',
    loc_txt = {
        name = 'Zero Theo',
        text = {
            "Played cards give {C:mult}+4{} Mult",
            "and {C:chips}+31{} Chips",
            "{C:inactive}(Even Steven + Odd Todd)"
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
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 2,
    atlas = 'zeroTheo',
    pos = { x = 0, y = 0 },
    cost = 8,
    pools = { ["BTTI_modAddition_COMBO"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    no_collection = true,

    set_badges = function(self, card, badges)
        badges[#badges + 1] = create_badge('Combination Joker', G.C.DARK_EDITION, G.C.WHITE, 1.2)
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            return {
                mult = 4,
                chips = 31
            }
        end
    end,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end
}

SMODS.Atlas {
    key = "trueBanana",
    path = "bttiTrueBanana.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'trueBanana',
    loc_txt = {
        name = 'True Banana',
        text = {
            "{X:mult,C:white}X15{} Mult",
            "{C:green}1 in 500{} chance to be",
            "{C:red}destroyed{} at the end of round",
            "{C:inactive}(Gros Michel + Cavendish)"
        }
    },

    config = { extra = { xmult = 15 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        return {
            vars = { },
        }
    end,
    rarity = 3,
    atlas = 'trueBanana',
    pos = { x = 0, y = 0 },
    cost = 10,
    pools = { ["BTTI_modAddition_COMBO"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    no_collection = true,

    set_badges = function(self, card, badges)
        badges[#badges + 1] = create_badge('Combination Joker', G.C.DARK_EDITION, G.C.WHITE, 1.2)
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if pseudorandom('TrueBanana') < G.GAME.probabilities.normal / 500 then
                card:start_dissolve()
            end
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end
}

SMODS.Atlas {
    key = "royalMoon",
    path = "bttiRoyalMoon.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'royalMoon',
    loc_txt = {
        name = 'Royal Moon',
        text = {
            "Each {C:attention}King{} held in hand",
            "gives {X:mult,C:white}X1.5{} Mult",
            "Each {C:attention}Queen{} held in hand",
            "gives {C:mult}+13{} Mult",
            "{C:inactive}(Baron + Shoot the Moon)"
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
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 2,
    atlas = 'royalMoon',
    pos = { x = 0, y = 0 },
    cost = 8,
    pools = { ["BTTI_modAddition_COMBO"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    no_collection = true,

    set_badges = function(self, card, badges)
        badges[#badges + 1] = create_badge('Combination Joker', G.C.DARK_EDITION, G.C.WHITE, 1.2)
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and not context.end_of_round then
            if context.other_card:get_id() == 13 then
                if context.other_card.debuff then
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED
                    }
                else
                    return {
                        x_mult = 1.5
                    }
                end
            elseif context.other_card:get_id() == 12 then
                if context.other_card.debuff then
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED
                    }
                else
                    return {
                        mult = 13
                    }
                end
            end
        end
    end,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end
}

SMODS.Atlas {
    key = "shortScholar",
    path = "bttiShortScholar.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'shortScholar',
    loc_txt = {
        name = 'Short Scholar',
        text = {
            "Played {C:aces}Aces{} give {C:chips}+20{} Chips",
            "and {C:mult}+4{} Mult when scored",
            "This {C:attention}Joker{} gains {C:chips}+8{} Chips",
            "when each played {C:attention}2{} is scored",
            "{C:inactive}Currently {C:chips}+#1#{C:inactive} Chips",
            "{C:inactive}(Scholar + Wee Joker)"
        }
    },

    config = { extra = { chips = 0, chip_mod = 8 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 2,
    atlas = 'shortScholar',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTI_modAddition_COMBO"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    no_collection = true,

    set_badges = function(self, card, badges)
        badges[#badges + 1] = create_badge('Combination Joker', G.C.DARK_EDITION, G.C.WHITE, 1.2)
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local rets = {}

            if context.other_card:get_id() == 14 then
                table.insert(rets, {
                    mult = 4,
                    chips = 20
                })
            end
            if context.other_card:get_id() == 2 and not context.blueprint then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod

                table.insert(rets, {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.CHIPS,
                    message_card = card
                })
            end

            return SMODS.merge_effects(rets)
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
    end,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end
}

SMODS.Atlas {
    key = "chanceOfClouds",
    path = "bttiChanceOfClouds.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'chanceOfClouds',
    loc_txt = {
        name = 'Chance of Clouds',
        text = {
            "{C:green}1 in 4{} chance for each played",
            "{C:attention}8{} to create a {C:purple}Tarot Card{} when scored",
            "Earn {C:attention}$1{} for each {C:attention}9{} in your {C:attention}full deck{}",
            "{C:inactive}(8 Ball + Cloud 9)"
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
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 2,
    atlas = 'chanceOfClouds',
    pos = { x = 0, y = 0 },
    cost = 8,
    pools = { ["BTTI_modAddition_COMBO"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    no_collection = true,

    set_badges = function(self, card, badges)
        badges[#badges + 1] = create_badge('Combination Joker', G.C.DARK_EDITION, G.C.WHITE, 1.2)
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and
            #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            if (context.other_card:get_id() == 8) and SMODS.pseudorandom_probability(card, 'btti', 1, 4) then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                return {
                    extra = {
                        message = localize('k_plus_tarot'),
                        message_card = card,
                        func = function() -- This is for timing purposes, everything here runs after the message
                            G.E_MANAGER:add_event(Event({
                                func = (function()
                                    SMODS.add_card {
                                        set = 'Tarot',
                                        key_append = 'btti' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
                                    }
                                    G.GAME.consumeable_buffer = 0
                                    return true
                                end)
                            }))
                        end
                    },
                }
            end
        end
    end,
    calc_dollar_bonus = function(self, card)
        local nine_tally = 0
        for _, playing_card in ipairs(G.playing_cards) do
            if playing_card:get_id() == 9 then nine_tally = nine_tally + 1 end
        end
        return nine_tally > 0 and 1 * nine_tally or nil
    end,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end
}

SMODS.Atlas {
    key = "celestius",
    path = "bttiCelestius.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'celestius',
    loc_txt = {
        name = 'Celestius',
        text = {
            'Each {C:attention}face card{} held in hand',
            'gives {X:mult,C:white}X13.5{} Mult',
            'Played {C:aces}Aces{} give {C:chips}+100{} Chips',
            'and {C:mult}+20{} Mult when scored',
            'This {C:attention}Joker{} gains {C:chips}+10{} Chips',
            'for each {C:attention}non-face card{} that is scored',
            '{C:green}1 in 4{} chance for each played {C:attention}8{}',
            'to create a {C:purple}Tarot Card{} when scored',
            'Earn an extra {C:attention}$9{} at end of {C:attention}round{}',
            '{C:inactive}Currently {C:chips}+#1#{} Chips',
            '{C:inactive}(Royal Moon + Short Scholar + Chance of Clouds)'
        }
    },

    config = { extra = { chips = 0, chip_mod = 10 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        return {
            vars = { card.ability.extra.chips },
        }
    end,
    rarity = 4,
    atlas = 'celestius',
    pos = { x = 0, y = 0 },
    cost = 20,
    pools = { ["BTTI_modAddition_COMBO"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    no_collection = true,

    set_badges = function(self, card, badges)
        badges[#badges + 1] = create_badge('Combination Joker', G.C.DARK_EDITION, G.C.WHITE, 1.2)
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and not context.end_of_round then
            if context.other_card.is_face(context.other_card) then
                if context.other_card.debuff then
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED
                    }
                else
                    return {
                        x_mult = 13.5
                    }
                end
            end
        end
        if context.individual and context.cardarea == G.play then
            local rets = {}

            if context.other_card:get_id() == 14 then
                table.insert(rets, {
                    mult = 20,
                    chips = 100
                })
            end
            if not context.other_card.is_face(context.other_card) and not context.blueprint then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod

                table.insert(rets, {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.CHIPS,
                    chips = card.ability.extra.chips,
                    message_card = card
                })
            end
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                if (context.other_card:get_id() == 8) and SMODS.pseudorandom_probability(card, 'btti', 1, 4) then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    table.insert(rets, {
                        extra = {
                            message = localize('k_plus_tarot'),
                            message_card = card,
                            func = function()
                                G.E_MANAGER:add_event(Event({
                                    func = (function()
                                        SMODS.add_card {
                                            set = 'Tarot',
                                            key_append = 'btti'
                                        }
                                        G.GAME.consumeable_buffer = 0
                                        return true
                                    end)
                                }))
                            end
                        },
                    })
                end
            end

            return SMODS.merge_effects(rets)
        end
    end,
    calc_dollar_bonus = function(self, card)
        return 9
    end,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end
}

SMODS.Atlas {
    key = "mineralJoker",
    path = "bttiMineralJoker.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'mineralJoker',
    loc_txt = {
        name = 'Mineral Joker',
        text = {
            "Gives {X:mult,C:white}X0.5{} Mult for each {C:attention}Steel Card",
            "in your {C:attention}full deck{} and {C:chips}+75{} Chips for",
            "each {C:attention}Stone Card{} in your {C:attentionfull deck{}",
            "{C:inactive}(Steel Joker + Stone Joker)"
        }
    },

    config = { extra = { xmult = 0 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        return {
            vars = { },
        }
    end,
    rarity = 3,
    atlas = 'mineralJoker',
    pos = { x = 0, y = 0 },
    cost = 10,
    pools = { ["BTTI_modAddition_COMBO"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    no_collection = true,

    set_badges = function(self, card, badges)
        badges[#badges + 1] = create_badge('Combination Joker', G.C.DARK_EDITION, G.C.WHITE, 1.2)
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local rets = {}
            local stone_tally = 0
            for _, playing_card in ipairs(G.playing_cards) do
                if SMODS.has_enhancement(playing_card, 'm_stone') then stone_tally = stone_tally + 1 end
            end
            table.insert(rets, {
                chips = 75 * stone_tally
            })

            table.insert(rets, {
                Xmult = card.ability.extra.xmult,
            })
        else
            local steel_tally = 0
            for _, playing_card in ipairs(G.playing_cards) do
                if SMODS.has_enhancement(playing_card, 'm_steel') then steel_tally = steel_tally + 1 end
            end
            card.ability.extra.xmult = 1 + 0.5 * steel_tally
        end
    end,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end
}

SMODS.Atlas {
    key = "abstractbuckler",
    path = "bttiAbstractbuckler.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'abstractbuckler',
    loc_txt = {
        name = 'Abstractbuckler',
        text = {
            "{C:mult}+3{} Mult for each {C:attention}Joker{} card",
            "Adds the {C:attention}sell value{} of all",
            "held {C:joker}Jokers{} to {C:mult}Mult",
            "{C:inactive}Currently {C:mult}+#1#{} Mult",
            "{C:inactive}(Abstract Joker + Swashbuckler)"
        }
    },

    config = { extra = { mult = 1 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        local sell_cost = 0
        for _, joker in ipairs(G.jokers and G.jokers.cards or {}) do
            if joker ~= card then
                sell_cost = sell_cost + joker.sell_cost + 3
            end
        end
        return {
            vars = { card.ability.extra.mult * sell_cost },
        }
    end,
    rarity = 2,
    atlas = 'abstractbuckler',
    pos = { x = 0, y = 0 },
    cost = 8,
    pools = { ["BTTI_modAddition_COMBO"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    no_collection = true,

    set_badges = function(self, card, badges)
        badges[#badges + 1] = create_badge('Combination Joker', G.C.DARK_EDITION, G.C.WHITE, 1.2)
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local sell_cost = 0
            for _, joker in ipairs(G.jokers.cards) do
                if joker ~= card then
                    sell_cost = sell_cost + joker.sell_cost + 3
                end
            end
            return {
                mult = card.ability.extra.mult * sell_cost
            }
        end
    end,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end
}

SMODS.Atlas {
    key = "resume",
    path = "bttiResume.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'resume',
    loc_txt = {
        name = 'Resume',
        text = {
            "When round begins, add a {C:attention}Stone Card",
            "with a random {C:attention}seal{} and a random",
            "{C:attention}playing card{} with a random {C:attention}seal{}",
            "to your hand",
            "{C:inactive}(Marble Joker + Certificate)"
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
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 3,
    atlas = 'resume',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTI_modAddition_COMBO"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    no_collection = true,

    set_badges = function(self, card, badges)
        badges[#badges + 1] = create_badge('Combination Joker', G.C.DARK_EDITION, G.C.WHITE, 1.2)
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            local stone_card = SMODS.create_card { set = "Base", enhancement = "m_stone", area = G.discard }
            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
            stone_card.playing_card = G.playing_card
            table.insert(G.playing_cards, stone_card)

            G.E_MANAGER:add_event(Event({
                func = function()
                    stone_card:start_materialize({ G.C.SECONDARY_SET.Enhanced })
                    G.play:emplace(stone_card)
                    return true
                end
            }))
            return {
                message = localize('k_plus_stone'),
                colour = G.C.SECONDARY_SET.Enhanced,
                func = function() -- This is for timing purposes, everything here runs after the message
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.deck.config.card_limit = G.deck.config.card_limit + 1
                            return true
                        end
                    }))
                    draw_card(G.play, G.hand, 90, 'up')
                    SMODS.calculate_context({ playing_card_added = true, cards = { stone_card } })
					local _card = SMODS.create_card { set = "Base", seal = SMODS.poll_seal({ guaranteed = true, type_key = 'vremade_certificate_seal' }), area = G.discard }
					G.playing_card = (G.playing_card and G.playing_card + 1) or 1
					_card.playing_card = G.playing_card
					table.insert(G.playing_cards, _card)

					G.E_MANAGER:add_event(Event({
						func = function()
							G.hand:emplace(_card)
							_card:start_materialize()
							G.GAME.blind:debuff_card(_card)
							G.hand:sort()
							if context.blueprint_card then
								context.blueprint_card:juice_up()
							else
								card:juice_up()
							end
							SMODS.calculate_context({ playing_card_added = true, cards = { _card } })
							save_run()
							return true
						end
					}))
                end
            }
        end
    end,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end
}

SMODS.Atlas {
    key = "bat",
    path = "bttiBat.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'bat',
    loc_txt = {
        name = 'Bat',
        text = {
            "Retrigger all played cards in",
            "{C:attention}final hand{} of round",
            "{X:mult,C:white}X3{} Mult per card in {C:attention}final hand",
            "of round",
            "{C:inactive}(Dusk + Acrobat)"
        }
    },

    config = { extra = { xmult = 3 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        return {
            vars = {},
        }
    end,
    rarity = 3,
    atlas = 'bat',
    pos = { x = 0, y = 0 },
    cost = 10,
    pools = { ["BTTI_modAddition_COMBO"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    no_collection = true,

    set_badges = function(self, card, badges)
        badges[#badges + 1] = create_badge('Combination Joker', G.C.DARK_EDITION, G.C.WHITE, 1.2)
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and G.GAME.current_round.hands_left == 0 then
            return {
                repetitions = 1,
                xmult = card.ability.extra.xmult,
            }
        end
    end,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end
}

SMODS.Atlas {
    key = "mountainBurglar",
    path = "bttiMountainBurglar.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'mountainBurglar',
    loc_txt = {
        name = 'Mountain Burglar',
        text = {
            "When {C:attention}Blind{} is selected,",
            "gain {C:blue}+3{} Hands and {C:red}lose all discards",
            "{C:mult}+20{} Mult",
            "{C:inactive}(Mystic Summit + Burglar)"
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
        return {
            vars = {},
        }
    end,
    rarity = 2,
    atlas = 'mountainBurglar',
    pos = { x = 0, y = 0 },
    cost = 8,
    pools = { ["BTTI_modAddition_COMBO"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    no_collection = true,

    set_badges = function(self, card, badges)
        badges[#badges + 1] = create_badge('Combination Joker', G.C.DARK_EDITION, G.C.WHITE, 1.2)
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            G.E_MANAGER:add_event(Event({
                func = function()
                    ease_discard(-G.GAME.current_round.discards_left, nil, true)
                    ease_hands_played(card.ability.extra.hands)
                    SMODS.set_badges = function(self, card, badges)
        badges[#badges + 1] = create_badge('Combination Joker', G.C.DARK_EDITION, G.C.WHITE, 1.2)
    end,
    calculate_effect(
                        { message = localize { type = 'variable', key = 'a_hands', vars = { card.ability.extra.hands } } },
                        context.blueprint_card or card)
                    return true
                end
            }))
            return nil, true -- This is for Joker retrigger purposes
        end

        if context.joker_main then
            return {
                mult = 20
            }
        end
    end,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end
}

SMODS.Atlas {
    key = "holoResume",
    path = "bttiHoloResume.png",
    px = 71,
    py = 95
}
SMODS.Atlas {
    key = "holoResumeFace",
    path = "bttiHoloResumeFace.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'holoResume',
    loc_txt = {
        name = 'Holo Resume',
        text = {
            "When round begins, add a {C:attention}Stone Card",
            "with a random {C:attention}seal{} and a random",
            "{C:attention}playing card{} with a random {C:attention}seal{}",
            "to your hand",
            "This {C:attention}Joker{} gains {X:mult,C:white}X0.5{} Mult every time",
            "a {C:attention}playing card{} is added to your deck",
            "{C:inactive}Currently {X:mult,C:white}X#1#{} Mult",
            "{C:inactive}(Resume + Hologram)"
        }
    },

    config = { extra = { Xmult_gain = 0.5, Xmult = 1 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        return {
            vars = { card.ability.extra.Xmult },
        }
    end,
    rarity = 3,
    atlas = 'holoResume',
    pos = { x = 0, y = 0 },
    cost = 10,
    pools = { ["BTTI_modAddition_COMBO"] = true },

    soul_atlas = 'holoResume',
    soul_pos = {
        x = 0, y = 0,
        draw = function(card, scale_mod, rotate_mod)
            card.hover_tilt = card.hover_tilt * 1.5
            card.children.floating_sprite:draw_shader('hologram', nil, card.ARGS.send_to_shader, nil,
            card.children.center, 2 * scale_mod, 2 * rotate_mod)
            card.hover_tilt = card.hover_tilt / 1.5
        end
    },
    set_sprites = function (self, card, front)
        card.children.center.atlas = G.ASSET_ATLAS['btti_holoResume']
        card.children.center:set_sprite_pos({ x = 0, y = 0 })
        card.children.floating_sprite.atlas = G.ASSET_ATLAS['btti_holoResumeFace']
        card.children.floating_sprite:set_sprite_pos({x = 0, y = 0})
    end,

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    no_collection = true,

    set_badges = function(self, card, badges)
        badges[#badges + 1] = create_badge('Combination Joker', G.C.DARK_EDITION, G.C.WHITE, 1.2)
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            local stone_card = SMODS.create_card { set = "Base", enhancement = "m_stone", area = G.hand }
            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
            stone_card.playing_card = G.playing_card
            table.insert(G.playing_cards, stone_card)

            G.E_MANAGER:add_event(Event({
                func = function()
                    stone_card:start_materialize({ G.C.SECONDARY_SET.Enhanced })
                    G.play:emplace(stone_card)
                    return true
                end
            }))
            return {
                message = localize('k_plus_stone'),
                colour = G.C.SECONDARY_SET.Enhanced,
                func = function() -- This is for timing purposes, everything here runs after the message
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.deck.config.card_limit = G.deck.config.card_limit + 2
                            return true
                        end
                    }))
                    draw_card(G.play, G.hand, 90, 'up')
                    SMODS.calculate_context({ playing_card_added = true, cards = { stone_card } })
					local _card = SMODS.create_card { set = "Base", seal = SMODS.poll_seal({ guaranteed = true, type_key = 'btti' }), area = G.hand }
					G.playing_card = (G.playing_card and G.playing_card + 1) or 1
					_card.playing_card = G.playing_card
					table.insert(G.playing_cards, _card)

					G.hand:emplace(_card)
                    _card:start_materialize()
                    G.GAME.blind:debuff_card(_card)
                    G.hand:sort()
                    if context.blueprint_card then
                        context.blueprint_card:juice_up()
                    else
                        card:juice_up()
                    end
                    SMODS.calculate_context({ playing_card_added = true, cards = { _card } })
                    save_run()

                    return true
                end
            }
        end
		if context.playing_card_added and not context.blueprint then
            -- See note about SMODS Scaling Manipulation on the wiki
            card.ability.extra.Xmult = card.ability.extra.Xmult + #context.cards * card.ability.extra.Xmult_gain
            return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
            }
        end
        if context.joker_main then
            return {
                Xmult = card.ability.extra.Xmult
            }
        end
    end,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end
}

SMODS.Atlas {
    key = "lunatic",
    path = "bttiLunatic.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'lunatic',
    loc_txt = {
        name = 'Lunatic',
        text = {
            "Create a {C:purple}Tarot Card{} when {C:attention}Blind",
            "is selected",
            "{X:mult,C:white}X0.5{} Mult per {C:purple}Tarot Card{} used",
            "{C:inactive}Currectly {X:mult,C:white}X#1#{} Mult",
            "{C:inactive}(Cartomancer + Fortune Teller)"
        }
    },

    config = { extra = { xmult = 1 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        return {
            vars = { card.ability.extra.xmult + (0.5 * (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.tarot or 0)) },
        }
    end,
    rarity = 3,
    atlas = 'lunatic',
    pos = { x = 0, y = 0 },
    cost = 10,
    pools = { ["BTTI_modAddition_COMBO"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    no_collection = true,

    set_badges = function(self, card, badges)
        badges[#badges + 1] = create_badge('Combination Joker', G.C.DARK_EDITION, G.C.WHITE, 1.2)
    end,
    calculate = function(self, card, context)
        if context.setting_blind and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                func = (function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            SMODS.add_card {
                                set = 'Tarot',
                                key_append = 'vremade_cartomancer' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
                            }
                            G.GAME.consumeable_buffer = 0
                            return true
                        end
                    }))
                    SMODS.calculate_effect({ message = localize('k_plus_tarot'), colour = G.C.PURPLE },
                        context.blueprint_card or card)
                    return true
                end)
            }))
            return nil, true -- This is for Joker retrigger purposes
        end
        if context.using_consumeable and not context.blueprint and context.consumeable.ability.set == "Tarot" then
            return {
                message = localize { type = 'variable', key = 'a_mult', vars = { G.GAME.consumeable_usage_total.tarot } },
            }
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.xmult +
                    (0.5 * (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.tarot or 0))
            }
        end
    end,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end
}

SMODS.Atlas {
    key = "wineJuggler",
    path = "bttiWineJuggler.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'wineJuggler',
    loc_txt = {
        name = 'Wine Juggler',
        text = {
            "{C:blue}+2{} hand size",
            "{C:red}+2{} discards",
            "{C:inactive}(Juggler + Drunkard)"
        }
    },

    config = { extra = { } },
    set_badges = function(self, card, badges)
        badges[#badges + 1] = create_badge('Combination Joker', G.C.DARK_EDITION, G.C.WHITE, 1.2)
    end,
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        return {
            vars = {  },
        }
    end,
    rarity = 3,
    atlas = 'wineJuggler',
    pos = { x = 0, y = 0 },
    cost = 10,
    pools = { ["BTTI_modAddition_COMBO"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    no_collection = true,

    add_to_deck = function(self, card, from_debuff)
        G.hand:change_size(2)
        G.GAME.round_resets.discards = G.GAME.round_resets.discards + 2
        ease_discard(2)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-2)
        G.GAME.round_resets.discards = G.GAME.round_resets.discards - 2
        ease_discard(-2)
    end,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end
}

SMODS.Atlas {
    key = "photoChad",
    path = "bttiPhotoChad.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'photoChad',
    loc_txt = {
        name = 'PhotoChad',
        text = {
            "First played {C:attention}face{} card gives",
            "{X:mult,C:white}x3{} Mult when scored and is",
            "retriggered {C:attention}2{} additional times",
            "{C:inactive}(Photograph + Hanging Chad)"
        }
    },

    config = { extra = { xmult = 3 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        return {
            vars = {},
        }
    end,
    rarity = 2,
    atlas = 'photoChad',
    pos = { x = 0, y = 0 },
    cost = 8,
    pools = { ["BTTI_modAddition_COMBO"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    no_collection = true,

    set_badges = function(self, card, badges)
        badges[#badges + 1] = create_badge('Combination Joker', G.C.DARK_EDITION, G.C.WHITE, 1.2)
    end,
    calculate = function(self, card, context)
        if (context.individual or context.repetition) and context.cardarea == G.play and context.other_card:is_face() then
            local is_first_face = false
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:is_face() then
                    is_first_face = context.scoring_hand[i] == context.other_card
                    break
                end
            end
            if is_first_face then
                return {
                    repetitions = 2,
                    Xmult = card.ability.extra.xmult,
                }
            end
        end
    end,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end
}

-- GIF Compression
SMODS.Atlas {
    key = "GIFCompression",
    path = "bttiGIFCompression.png",
    px = 71,
    py = 95,
}
SMODS.Joker {
    key = 'GIFCompression',
    loc_txt = {
        name = 'GIF Compression',
        text = {
            "Gives {C:blue}+8{} Chips and",
            "retriggers hand {C:blue}4{} times",
            "if {C:attention}played hand{} has exactly {C:blue}4{} cards",
            "{C:inactive} It\'s pronounced GIF",
            "{C:inactive}(Square Joker + ...Say that again?)"
        }
    },

    config = { extra = {} },
    set_badges = function(self, card, badges)
        badges[#badges + 1] = create_badge('Combination Joker', G.C.DARK_EDITION, G.C.WHITE, 1.2)
    end,
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Fant4stic", "Miles Teller" } }
        return {
            vars = {},
        }
    end,
    rarity = 2,
    atlas = 'GIFCompression',
    pos = { x = 0, y = 0 },
    cost = 4,
    pools = { ["BTTI_modAddition_COMBO"] = true },

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
    no_collection = true,

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            if #G.play.cards == 4 then
                return {
                    repetitions = 4
                }
            end
        end
        if context.joker_main then
            if #G.play.cards == 4 then
                return {
                    chips = 8
                }
            end
        end
    end,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end
}

--#endregion

--#region MOD COMBO JOKERS

SMODS.Atlas {
    key = "TripleBaka",
    path = "bttiTripleBaka.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'TripleBaka',
    loc_txt = {
        name = 'Triple-Baka!!',
        text = {
            "{C:chips}+10{} Chips, {C:mult}+4{} Mult and",
            "{C:attention}$2{} for each {C:clubs}Club{}, {C:hearts}Heart{},",
            "and {C:diamonds}Diamond{} respectively in",
            "your {C:attention}full deck{}",
            "{C:inactive}Currently +{C:chips}#1#{C:inactive} Chips, +{C:mult}#2#{C:inactive} Mult, +{C:attention}$#3#{C:inactive}",
            "{C:inactive}(Hatsune Miku + Kasane Teto",
            "{C:inactive}+ Akira Neru)"
        }
    },

    config = { extra = { chips = 10, mult = 4, dollars = 2 } },
    set_badges = function(self, card, badges)
        badges[#badges + 1] = create_badge('Combination Joker', G.C.DARK_EDITION, G.C.WHITE, 1.2)
    end,
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "VOCALOID / UTAU", "LamazeP" } }
        local cardCountM = 0
        local cardCountT = 0
        local cardCountN = 0
        if G.deck and G.deck.cards then
            for i, pc in ipairs(G.deck.cards) do
                if pc:is_suit('Clubs') then
                    cardCountM = cardCountM + 1
                end
                if pc:is_suit('Hearts') then
                    cardCountT = cardCountT + 1
                end
                if pc:is_suit('Diamonds') then
                    cardCountN = cardCountN + 1
                end
            end
        end
        return {
            vars = { card.ability.extra.chips * cardCountM, card.ability.extra.mult * cardCountT, card.ability.extra.dollars * cardCountN },
        }
    end,
    rarity = 4,
    atlas = 'TripleBaka',
    pos = { x = 0, y = 0 },
    cost = 20,
    pools = { ["BTTI_modAddition_COMBO"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    no_collection = true,

    calculate = function(self, card, context)
        if context.joker_main then
            local cardCountM = 0
            local cardCountT = 0
            local cardCountN = 0
            if G.deck and G.deck.cards then
                for i, pc in ipairs(G.deck.cards) do
                    if pc:is_suit('Clubs') then
                        cardCountM = cardCountM + 1
                    end
                    if pc:is_suit('Hearts') then
                        cardCountT = cardCountT + 1
                    end
                    if pc:is_suit('Diamonds') then
                        cardCountN = cardCountN + 1
                    end
                end
            end
            return {
                dollars = cardCountN * card.ability.extra.dollars,
                mult = cardCountT * card.ability.extra.mult,
                chips = cardCountM * card.ability.extra.chips
            }
        end
    end,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end
}

-- Skelebros
SMODS.Atlas {
    key = "Skelebros",
    path = "bttiSkelebros.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Skelebros',
    loc_txt = {
        name = 'Skelebros',
        text = {
            "This {C:attention}Joker{} is assigned",
            "the effect of a random {C:uncommon}Uncommon {C:joker}Joker{}",
            "at the beginning of each {C:attention}round",
            "Gives extra {C:mult}Mult{} equivalent to",
            "assigned Joker's {C:attention}sell value{}",
            "Resets at the end of each {C:attention}round",
            "{C:inactive}(sans. + THE GREAT PAPYRUS!)"
        }
    },

    config = { extra = { currentJoker = nil} },
    set_badges = function(self, card, badges)
        badges[#badges + 1] = create_badge('Combination Joker', G.C.DARK_EDITION, G.C.WHITE, 1.2)
    end,
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "UNDERTALE / DELTARUNE", "Toby Fox" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.chips },
        }
    end,
    rarity = 2,
    atlas = 'Skelebros',
    pos = { x = 0, y = 0 },
    cost = 8,
    pools = { ["BTTI_modAddition_COMBO"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    no_collection = true,

    -- Thank you to Somthingcom515 for the help with implementing this!!
    calculate = function(self, card, context)
        if context.setting_blind and context.cardarea == G.jokers then
            local jkr
            repeat
                jkr = pseudorandom_element(G.P_JOKER_RARITY_POOLS[2], 'seed')
            until jkr.discovered
            card.ability.extra.currentJoker = jkr.key
            sendInfoMessage("skelebros chose: " .. card.ability.extra.currentJoker .. "", "BTTI")
            return {
                message = (math.random(0, 1) == 1 and 'NYEH!') or 'heh.',
                colour = G.C.BLUE,
                sound = 'btti_Sans'
            }
        end
        if card.ability.extra.currentJoker then
            local key = card.ability.extra.currentJoker
            G.btti_savedJokerCards = G.btti_savedJokerCards or {}
            G.btti_savedJokerCards[card.sort_id] = G.btti_savedJokerCards[card.sort_id] or {}
            if not G.btti_savedJokerCards[card.sort_id][key] then
                local old_ability = copy_table(card.ability)
                local old_center = card.config.center
                local old_center_key = card.config.center_key
                card:set_ability(key, nil, 'quantum')
                card:update(0.016)
                G.btti_savedJokerCards[card.sort_id][key] = SMODS.shallow_copy(card)
                G.btti_savedJokerCards[card.sort_id][key].ability = copy_table(G.btti_savedJokerCards
                    [card.sort_id][key].ability)
                for i, v in ipairs({ "T", "VT", "CT" }) do
                    G.btti_savedJokerCards[card.sort_id][key][v] = copy_table(G.btti_savedJokerCards[card.sort_id]
                        [key][v])
                end
                G.btti_savedJokerCards[card.sort_id][key].config = SMODS.shallow_copy(G.btti_savedJokerCards
                    [card.sort_id][key].config)
                card.ability = old_ability
                card.config.center = old_center
                card.config.center_key = old_center_key
                for i, v in ipairs({ 'juice_up', 'start_dissolve', 'remove', 'flip' }) do
                    G.btti_savedJokerCards[card.sort_id][key][v] = function(_, ...)
                        return Card[v](card, ...)
                    end
                end
            end
            return SMODS.merge_effects {
                G.btti_savedJokerCards[card.sort_id][key]:calculate_joker(context),
                {
                    mult = G.btti_savedJokerCards[card.sort_id][key].sell_cost
                }
            }
        end
    end,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end
}

-- Ultimate Joker
SMODS.Atlas {
    key = "ultimateJoker",
    path = "bttiUltimateJoker.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'ultimateJoker',
    loc_txt = {
        name = 'Ultimate Joker',
        text = {
            "{C:mult}+16{} Mult and {C:chips}+120{} Chips",
            "for each {C:attention}Poker Hand{} contained in {C:attention}played hand",
            "{C:inactive}(Jovial Joker, Confused Joker, Genius Joker,",
            "{C:inactive}Bonkers Joker OR Deliberate Joker + ",
            "{C:inactive}The Universe)"
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
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 4,
    atlas = 'ultimateJoker',
    pos = { x = 0, y = 0 },
    cost = 20,
    pools = { ["BTTI_modAddition_COMBO"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    no_collection = true,

    set_badges = function(self, card, badges)
        badges[#badges + 1] = create_badge('Combination Joker', G.C.DARK_EDITION, G.C.WHITE, 1.2)
    end,
    calculate = function(self, card, context)
        
        if context.joker_main then
            local handAmount = 0
            for k, v in pairs(G.GAME.hands) do
                if next(context.poker_hands[k]) then
                    handAmount = handAmount + 1
                end
            end
            sendInfoMessage("there are " .. handAmount .. " hands", "BTTI")
            local m = 16 * handAmount
            local ch = 120 * handAmount
            return SMODS.merge_effects {
                {
                    message = "+" .. ch .. "",
                    colour = G.C.CHIPS,
                    chips = ch,
                },
                {
                    message = "+" .. m .. "",
                    colour = G.C.MULT,
                    mult = m,
                }
            }
        end
    end,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end
}

--#endregion