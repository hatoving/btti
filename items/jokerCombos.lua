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
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "Combo!!" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 2,
    atlas = 'avariciousJoker',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTImodadditionCOMBO"] = true },

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

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
            "or {C:clubs}Clubs{} suits give {C:mult}+3{} Mult",
            "when scored",
            "{C:inactive}(Wrathful Joker + Gluttonous Joker)"
        }
    },

    config = { extra = {} },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "Combo!!" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 1,
    atlas = 'sullenJoker',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTImodadditionCOMBO"] = true },

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

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
            "Played cards with give",
            "{C:mult}+5{} when scored",
            "{C:inactive}(Avaricious Joker + Sullen Joker)"
        }
    },

    config = { extra = {} },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "Combo!!" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 1,
    atlas = 'sinfulJoker',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTImodadditionCOMBO"] = true },

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

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
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "Combo!!" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 1,
    atlas = 'jovialJoker',
    pos = { x = 0, y = 0 },
    cost = 1,
    pools = { ["BTTImodadditionCOMBO"] = true },

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

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
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "Combo!!" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 1,
    atlas = 'confusedJoker',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTImodadditionCOMBO"] = true },

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

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
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "Combo!!" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 2,
    atlas = 'geniusJoker',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTImodadditionCOMBO"] = true },

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

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
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "Combo!!" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 3,
    atlas = 'bonkersJoker',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTImodadditionCOMBO"] = true },

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

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
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "Combo!!" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 3,
    atlas = 'deliberateJoker',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTImodadditionCOMBO"] = true },

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

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
            "for each {C:attention}Poker Hand{} contained in {C:attention}Hand",
            "{C:inactive}(Droll Joker + Crafty Joker)"
        }
    },

    config = { extra = {} },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "Combo!!" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 4,
    atlas = 'ultimateJoker',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTImodadditionCOMBO"] = true },

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

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
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "Combo!!" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 2,
    atlas = 'splitJovialJoker',
    pos = { x = 0, y = 0 },
    cost = 2,
    pools = { ["BTTImodadditionCOMBO"] = true },

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

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
    path = "bttiConfusedJoker.png",
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
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "Combo!!" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 2,
    atlas = 'splitConfusedJoker',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTImodadditionCOMBO"] = true },

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

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
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "Combo!!" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 2,
    atlas = 'zeroTheo',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTImodadditionCOMBO"] = true },

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

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
            "{C:green}1 in 500{}",
            "{C:inactive}(Gros Michel + Cavendish)"
        }
    },

    config = { extra = {} },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "Combo!!" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 3,
    atlas = 'trueBanana',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTImodadditionCOMBO"] = true },

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = 15
            }
        end
        if SMODS.pseudorandom_probability(card, 'trueBanana', 1, 500) then
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('tarot1')
                    card.T.r = -0.2
                    card:juice_up(0.3, 0.4)
                    card.states.drag.is = true
                    card.children.center.pinch.x = true
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.3,
                        blockable = false,
                        func = function()
                            card:remove()
                            return true
                        end
                    }))
                    return true
                end
            }))
            return {
                message = localize('k_extinct_ex')
            }
        else
            return {
                message = localize('k_safe_ex')
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
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "Combo!!" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 2,
    atlas = 'royalMoon',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTImodadditionCOMBO"] = true },

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

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
    key = "smallScholar",
    path = "bttiSmallScholar.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'smallScholar',
    loc_txt = {
        name = 'Small Scholar',
        text = {
            "Played {C:aces}Aces{} give {C:chips}+20{} Chips",
            "and {C:mult}+4{} Mult when scored",
            "This {C:attention}Joker{} gains {C:chips}+8{} Chips",
            "when each played {C:attention}2{} is scored",
            "{C:inactive}Currently {C:chips}+#1#{} Chips",
            "{C:inactive}(Scholar + Wee Joker)"
        }
    },

    config = { extra = { chips = 0 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "Combo!!" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 2,
    atlas = 'smallScholar',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTImodadditionCOMBO"] = true },

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

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
        name = 'Chance of CLouds',
        text = {
            "{C:green}1 in 4{} chance for each played",
            "{C:attention}8{} to create a {C:purple}Tarot Card{} when scored",
            "Earn {C:attention}$+1{} for each {C:attention}9{} in your {C:attention}Full Deck",
            "{C:inactive}(8 Ball + Cloud 9)"
        }
    },

    config = { extra = {} },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "Combo!!" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 2,
    atlas = 'chanceOfClouds',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTImodadditionCOMBO"] = true },

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

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
