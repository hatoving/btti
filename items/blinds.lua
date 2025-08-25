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
					for i, jk in ipairs(G.jokers.cards) do
						G.E_MANAGER:add_event(Event({
							trigger = 'immediate',
							blocking = false,
							delay = 0,
							func = function()
								ease_dollars(-jk.sell_cost)
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

-- from https://github.com/blazingulag/Prism/blob/main/objects/funcs.lua#L192
function is_numbered(card)
    return card.base and card.base.value and not SMODS.Ranks[card.base.value].face and card:get_id() ~= 14
end
function is_odd(card)
    if not card.base then return false end
    return (is_numbered(card) and card.base.nominal % 2 == 1) or card:get_id() == 14
        or (next(SMODS.find_card('j_mxms_perspective')) and card:get_id() == 6) --compat with maximus' prespective
end
function is_even(card)
    if not card.base then return false end
    return (is_numbered(card) and card.base.nominal % 2 == 0)
        or (next(SMODS.find_card('j_mxms_perspective')) and card:get_id() == 6) --compat with maximus' prespective
end

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

local smodsCalcRef = SMODS.calculate_individual_effect
function SMODS.calculate_individual_effect(effect, scored_card, key, amount, from_edition)
    if G.GAME.blind.config.blind.key == 'bl_btti_captainBlind' then
        if (
            key == "x_mult"
            or key == "xmult"
            or key == "Xmult"
            or key == "x_mult_mod"
            or key == "xmult_mod"
            or key == "Xmult_mod"
        ) then
            amount = 1
        end
    else
        sendInfoMessage("stupid: " .. G.GAME.blind.config.blind.key .. "", "BTTI")
    end
    return smodsCalcRef(effect, scored_card, key, amount, from_edition)
end

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