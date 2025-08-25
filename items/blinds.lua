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
    boss = { min = 1 },
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
    key = "spamtonBlind",
    path = "bttiSpamtonBlind.png",
    px = 34,
    py = 34,
    frames = 21,
    atlas_table = 'ANIMATION_ATLAS'
}
SMODS.Blind {
    key = "bossSpamton",
    atlas = "spamtonBlind",
    pos = { x = 0, y = 0 },
    mult = 2,
    dollars = 25,
    loc_txt = {
        name = 'The Salesman',
        text = {
            'Steals [[Sweet MOOLAH!!]] equivalent',
			'to the [[Value, Value]] of all',
			'[[CLOWN]] each hand.'
        }
    },
    boss = { min = 1 },
    boss_colour = HEX('4f4f4f'),

    calculate = function(self, blind, context)
        if not blind.disabled then
			if G.jokers then
				if context.before and context.cardarea == G.jokers then
					for i, jk in ipairs(G.jokers.cards) do
						G.E_MANAGER:add_event(Event({
							trigger = 'immediate',
							blocking = false,
							delay = 0,
							func = function()
								ease_dollars(-G.jokers.cards[i].sell_cost)
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
    key = "scoliosisBlind",
    path = "bttiScoliosisBlind.png",
    px = 34,
    py = 34,
    frames = 21,
    atlas_table = 'ANIMATION_ATLAS'
}
local debuffedScoliosisCards = {}
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

    recalc_debuff = function(self)
        for k, v in ipairs(G.playing_cards) do
            if v:get_id() <= 10 and v:get_id() >= 0 and v:get_id() % 2 == 0 then
                SMODS.juice_up_blind()
                G.GAME.blind:debuff_card(v)
            end
        end
    end,
    disable = function(self)
    end,
    defeat = function(self)
    end,
}
