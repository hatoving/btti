--#region MISC. BLINDS

SMODS.Atlas {
    key = "tunaBlind",
    path = "bttiTunaBlind.png",
    px = 34,
    py = 34,
    frames = 21,
    atlas_table = 'ANIMATION_ATLAS'
}

SMODS.Blind {
    key = "bossBigTuna",
    atlas = "tunaBlind",
    pos = { x = 0, y = 0 },
    mult = 2,
    dollars = 10,
    loc_txt = {
        name = 'The Tuna',
        text = {
            '1 in 2 chance for each card',
            "discarded to be destroyed",
        }
    },
    boss = { min = 1 },
    boss_colour = HEX('ff7d32'),

    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.discard then
                for i, pc in ipairs(G.hand.highlighted) do
                    if pseudorandom('BigTuna') < G.GAME.probabilities.normal / 2 then
                        G.E_MANAGER:add_event(Event({
                            trigger = 'immediate',
                            blocking = false,
                            delay = 0,
                            func = function()
                                SMODS.destroy_cards(pc)
                                return true
                            end,
                        }))
                    end
                end
            end
        end
        return {}
    end,
    disable = function(self)
    end,
    defeat = function(self)
    end,
}

SMODS.Atlas {
    key = "flounderBlind",
    path = "bttiFlounderBlind.png",
    px = 34,
    py = 34,
    frames = 21,
    atlas_table = 'ANIMATION_ATLAS'
}
SMODS.Blind {
    key = "bossSmallFlounder",
    atlas = "flounderBlind",
    pos = { x = 0, y = 0 },
    mult = 2,
    dollars = 12,
    loc_txt = {
        name = 'The Flounder',
        text = {
            'Discarding cards will',
			'destroy a joker'
        }
    },
    boss = { min = 3 },
    boss_colour = HEX('0082cd'),

    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.discard then
                local idx = math.random(1, #G.jokers.cards)
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    blocking = false,
                    delay = 0,
                    func = function()
                        SMODS.destroy_cards(G.jokers.cards[idx])
                        return true
                    end,
                }))
            end
        end
        return {}
    end,
    disable = function(self)
    end,
    defeat = function(self)
    end,
}

SMODS.Atlas {
    key = "gooseBlind",
    path = "bttiGooseBlind.png",
    px = 34,
    py = 34,
    frames = 21,
    atlas_table = 'ANIMATION_ATLAS'
}
SMODS.Blind {
    key = "gooseBlind",
    atlas = "gooseBlind",
    pos = { x = 0, y = 0 },
    mult = 2,
    dollars = 10,
    loc_txt = {
        name = 'The Honk',
        text = {
            'Cards with an ODD',
            "rank are debuffed"
        }
    },
    boss = { min = 1 },
    boss_colour = HEX('ffffff'),

    recalc_debuff = function(self, card, from_blind)
        if card.area ~= G.jokers and not G.GAME.blind.disabled then
            if is_odd(card)
            then
                return true
            end
            return false
        end
    end,
}

SMODS.Atlas {
    key = "captainBlind",
    path = "bttiCaptainBlind.png",
    px = 34,
    py = 34,
    frames = 21,
    atlas_table = 'ANIMATION_ATLAS'
}

SMODS.Blind {
    key = "captainBlind",
    atlas = "captainBlind",
    pos = { x = 0, y = 0 },
    mult = 2,
    dollars = 10,
    loc_txt = {
        name = 'The Captain',
        text = {
            'Disables all',
            'xMult effects'
        }
    },
    boss = { min = 3 },
    boss_colour = HEX('ffc78d'),
    calculate = function(self, blind, context)
    end
}

--#endregion

--#region SCOLIOSIS MAN BLINDS
SMODS.Atlas {
    key = "scoliosisBlind",
    path = "bttiScoliosisBlind.png",
    px = 34,
    py = 34,
    frames = 21,
    atlas_table = 'ANIMATION_ATLAS'
}
SMODS.Blind {
    key = "scoliosisBlind",
    atlas = "scoliosisBlind",
    pos = { x = 0, y = 0 },
    mult = 2,
    dollars = 10,
    loc_txt = {
        name = 'The Scoliosis',
        text = {
            'Cards with an EVEN',
            "rank are debuffed"
        }
    },
    boss = { min = 1 },
    boss_colour = HEX('ffffff'),

    recalc_debuff = function(self, card, from_blind)
        if card.area ~= G.jokers and not G.GAME.blind.disabled then
            if is_even(card)
            then
                return true
            end
            return false
        end
    end,
}
--#endregion

--#region AOTA BLINDS

SMODS.Atlas {
    key = "emeraldBlind",
    path = "bttiPlaceholderBlind.png",
    px = 34,
    py = 34,
    frames = 21,
    atlas_table = 'ANIMATION_ATLAS'
}
SMODS.Blind {
    key = "emeraldBlind",
    atlas = "emeraldBlind",
    pos = { x = 0, y = 0 },
    mult = 2,
    dollars = 10,
    loc_txt = {
        name = 'The Emerald',
        text = {
            'Enhanced cards',
            'are debuffed'
        }
    },
    boss = { min = 5 },
    boss_colour = HEX('170081'),

    recalc_debuff = function(self, card, from_blind)
        if card.area ~= G.jokers and not G.GAME.blind.disabled then
            if next(SMODS.get_enhancements(card)) then
                return true
            else
                return false
            end
        end
    end,
}

SMODS.Atlas {
    key = "pillarBlind",
    path = "bttiPlaceholderBlind.png",
    px = 34,
    py = 34,
    frames = 21,
    atlas_table = 'ANIMATION_ATLAS'
}
SMODS.Blind {
    key = "pillarBlind",
    atlas = "pillarBlind",
    pos = { x = 0, y = 0 },
    mult = 2,
    dollars = 10,
    loc_txt = {
        name = 'The Pillar',
        text = {
            'Cards without suits',
            'are debuffed'
        }
    },
    boss = { min = 5 },
    boss_colour = HEX('170081'),

    recalc_debuff = function(self, card, from_blind)
        if card.area ~= G.jokers and not G.GAME.blind.disabled then
            if SMODS.has_no_suit(card) then
                return true
            else
                return false
            end
        end
    end,
}

SMODS.Atlas {
    key = "singularityBlind",
    path = "bttiPlaceholderBlind.png",
    px = 34,
    py = 34,
    frames = 21,
    atlas_table = 'ANIMATION_ATLAS'
}
SMODS.Blind {
    key = "singularityBlind",
    atlas = "singularityBlind",
    pos = { x = 0, y = 0 },
    mult = 2,
    dollars = 10,
    loc_txt = {
        name = 'The Singularity',
        text = {
            'Must only play one card',
        }
    },
    boss = { min = 6 },
    boss_colour = HEX('170081'),
    debuff = {h_size_le = 1}
}

--#endregion

--#region UT/DR BLINDS

SMODS.Sound {
    key = "music_Truck",
    path = "music_bttiTruck.ogg",
    pitch = 1,
    volume = 1.0,
    select_music_track = function(self)
        return G.GAME.blind and G.GAME.blind.in_blind and G.GAME.blind.config.blind.key == 'bl_btti_truckBlind'
    end
}
SMODS.Atlas {
    key = "truckBlind",
    path = "bttiTruckBlind.png",
    px = 34,
    py = 34,
    frames = 21,
    atlas_table = 'ANIMATION_ATLAS'
}
SMODS.Blind {
    key = "truckBlind",
    atlas = "truckBlind",
    pos = { x = 0, y = 0 },
    mult = 2,
    dollars = 10,
    loc_txt = {
        name = 'The Truck',
        text = {
            'Debuffs a random poker',
            'hand before every hand',
            '(Current: #1#)'
        }
    },
    loc_vars = function (self)
        if G.GAME.blind.debuffedHand then
            return {
                vars = { localize(G.GAME.blind.debuffedHand, 'poker_hands') },
            }
        end
        return {
            vars = { 'None' },
        }
    end,
    boss = { min = 3 },
    boss_colour = HEX('c90000'),
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.setting_blind or context.final_scoring_step then
                blind.debuffedHand = {}

                local hands = {}
                for k, _ in pairs(G.GAME.hands) do
                    if _.visible then
                        table.insert(hands, k)
                    end
                end
                local randomHand = hands[math.random(#hands)]
                sendInfoMessage("blind chose " .. randomHand .. "", "BTTI")

                blind.debuffedHand = randomHand
            end
            if context.debuff_hand then
                if context.scoring_name == blind.debuffedHand then
                    blind.triggered = true
                    return {
                        debuff = true
                    }
                end
            end
        end
        if context.hand_drawn then
            blind.prepped = nil
        end
    end,
    disable = function(self)
    end,
    defeat = function(self)
    end
}

SMODS.Sound {
    key = "music_Spamton",
    path = "music_bttiSpamton.ogg",
    pitch = 1,
    volume = 1.0,
    select_music_track = function(self)
        return G.GAME.blind and G.GAME.blind.in_blind and G.GAME.blind.config.blind.key == 'bl_btti_spamtonBlind'
    end
}
SMODS.Atlas {
    key = "spamtonBlind",
    path = "bttiSpamtonBlind.png",
    px = 34,
    py = 34,
    frames = 21,
    atlas_table = 'ANIMATION_ATLAS'
}
SMODS.Blind {
    key = "spamtonBlind",
    atlas = "spamtonBlind",
    pos = { x = 0, y = 0 },
    mult = 2,
    dollars = 25,
    loc_txt = {
        name = 'The Salesman',
        text = {
            'Steals [[Sweet Moolah!!]] equivalent',
            'to the [[Value, Value]] of all',
            '[[CLOWN]] each hand.'
        }
    },
    boss = { min = 4 },
    boss_colour = HEX('4f4f4f'),

    calculate = function(self, blind, context)
        if not blind.disabled then
            if G.jokers then
                if context.before then
                    local ret = {}
                    for i = 1, #G.jokers.cards do
                        table.insert(ret, {
                            dollars = -G.jokers.cards[i].sell_cost,
                            card = G.jokers.cards[i]
                        })
                    end
                    return SMODS.merge_effects(ret)
                end
            end
        end
        return {}
    end,
    disable = function(self)
    end,
    defeat = function(self)
    end,
}

--#endregion