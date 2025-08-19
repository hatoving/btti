function getJokerID(card)
    if G.jokers then
        local _selfid = 0
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] == card then _selfid = i end
        end
        return _selfid
    end
end

-- MISC JOKERS
-- MISC JOKERS
-- MISC JOKERS
-- MISC JOKERS

-- Jonker
SMODS.Atlas {
    key = "Jonker",
    path = "bttiJonker.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'Jonker',
	loc_txt = {
		name = 'Jonker',
		text = {
			"{C:mult}+#1#{} Mult",
            "1 in 10 chance to steal {C:attention}$2-7{}"
		}
	},

	config = { extra = { mult = 10, odds = 10 } },
	loc_vars = function(self, info_queue, card)
		return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
	end,
	rarity = 1,
	atlas = 'Jonker',
	pos = { x = 0, y = 0 },
	cost = 4,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

	calculate = function(self, card, context)
		if context.joker_main then
            if pseudorandom('Jonker') < G.GAME.probabilities.normal / card.ability.extra.odds then
                local rand = math.random(-7, -2)
                return {
                    dollars = rand,
                    mult_mod = card.ability.extra.mult,
                    message = "i'm da jonker baybee!"
                }
            else
                return {
                    mult_mod = card.ability.extra.mult,
                    message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } },
                }
            end
		end
	end,
    in_pool = function(self, args)
		return true, { allow_duplicates = true }
	end
}

-- Gambler Cat
--[[ SMODS.Atlas {
    key = "GamblerCat",
    path = "", 

} ]]

-- DRAMATIZED JOKERS
-- DRAMATIZED JOKERS
-- DRAMATIZED JOKERS
-- DRAMATIZED JOKERS

-- Jonker
SMODS.Atlas {
    key = "Teeriffic",
    path = "bttiTeeriffic.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'Teeriffic',
	loc_txt = {
		name = 'Teeriffic!',
		text = {
			"{C:mult}+#1#{} Mult per card",
            "Will debuff 1-2 played cards"
		}
	},

	config = { extra = { mult = 8, howMuch = 0 } },
	loc_vars = function(self, info_queue, card)
		return {
            vars = { card.ability.extra.mult, card.ability.extra.howMuch },
        }
	end,
	rarity = 1,
	atlas = 'Teeriffic',
	pos = { x = 0, y = 0 },
	cost = 4,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

	calculate = function(self, card, context)
		if context.before then
            local rand = math.random(1, 2)
            if #context.scoring_hand > rand then
                for i=1,rand,1 do
                    local rand2 = math.random(1, #context.scoring_hand)
                    context.scoring_hand[rand2]:set_debuff(true)
                end
            elseif #context.scoring_hand == 2 then
                local rand2 = math.random(1, #context.scoring_hand)
                context.scoring_hand[rand2]:set_debuff(true)
            end
		end

        if context.cardarea == G.play and context.individual and context.other_card then
            return {
                mult_mod = card.ability.extra.mult,
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } },
            }
		end
	end,
    in_pool = function(self, args)
		return true, { allow_duplicates = true }
	end
}

-- ITTI JOKERS
-- ITTI JOKERS
-- ITTI JOKERS
-- ITTI JOKERS

-- God Taco
SMODS.Atlas {
    key = "GodTaco",
    path = "bttiGodTaco.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'GodTaco',
	loc_txt = {
		name = 'God Taco',
		text = {
			"Copies the Joker to the right",
            "and shuffles all Jokers around",
            "at the end of a hand"
		}
	},

	config = { extra = { gtTarget = 0 } },
	loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'btti_FromWhere', set = 'Other', vars = { "Inn-to the Insanity" }}
		return {
            vars = { },
        }
	end,
	rarity = 1,
	atlas = 'GodTaco',
	pos = { x = 0, y = 0 },
	cost = 4,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

	calculate = function(self, card, context)
        if context.final_scoring_step then
            G.E_MANAGER:add_event(Event({ trigger = 'immediate', blocking = false, delay = 0.0, func = function() G.jokers:shuffle('aajk'); play_sound('cardSlide1', 0.85);return true end }))
            return {
                message = "Whoosh!",
            }
        end 
        
        if context.joker_main then
            if G.jokers.cards[getJokerID(card) + 1] then
                sendInfoMessage("supposed to retrigger: " .. getJokerID(card)+1, "BTTI")
                local ret = SMODS.blueprint_effect(card, G.jokers.cards[idx], context)
                return SMODS.merge_effects {
                    {
                        message = "AGAIN, AGAIN!!",
                        colour = G.C.PURPLE,
                    },
                    ret
                }
            elseif G.jokers.cards[1] then
                sendInfoMessage("supposed to retrigger: 1", "BTTI")
                local ret = SMODS.blueprint_effect(card, G.jokers.cards[1], context)
                return SMODS.merge_effects {
                    {
                        message = "AGAIN, AGAIN!!",
                        colour = G.C.PURPLE,
                    },
                    ret
                }
            end
        end
	end,
    in_pool = function(self, args)
		return true, { allow_duplicates = true }
	end
}

-- Strawberry Lemonade
SMODS.Atlas {
    key = "SL",
    path = "bttiSL.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'SL',
	loc_txt = {
		name = 'Strawberry Lemoande',
		text = {
			"Copies either a random Joker",
            "or a random Card in Hand",
            "Triggers twice if {C:purple}God Taco{}",
            "is present"
		}
	},

	config = { extra = { } },
	loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'btti_FromWhere', set = 'Other', vars = { "Inn-to the Insanity" }}
		return {
            vars = { },
        }
	end,
	rarity = 1,
	atlas = 'SL',
	pos = { x = 0, y = 0 },
	cost = 4,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

	calculate = function(self, card, context)
        if context.joker_main then
            local rand = math.random(0, 1)
            if rand == 0 then
                sendInfoMessage("SL rand: " .. rand, "BTTI")
                local idx = math.random(1, #G.jokers.cards)
                sendInfoMessage("SL idx: " .. idx, "BTTI")
                if idx == getJokerID(card) then
                    idx = (getJokerID(card) % #G.jokers.cards) + 1
                    if idx == getJokerID(card) then
                        return {
                            message = "Can't copy myself...",
                            colour = G.C.BTTIPINK,
                        }
                    end
                end

                if G.jokers.cards[idx] then
                    sendInfoMessage("yay: " .. idx, "BTTI")
                    if next(SMODS.find_card("j_btti_GodTaco")) then
                        local ret = SMODS.blueprint_effect(card, G.jokers.cards[idx], context)
                        local ret2 = SMODS.blueprint_effect(card, G.jokers.cards[idx], context)
                        return SMODS.merge_effects {
                            {
                                message = "Go, GT!!",
                                colour = G.C.BTTIPINK
                            }, ret, ret2
                        }
                    else
                        local ret = SMODS.blueprint_effect(card, G.jokers.cards[idx], context)
                        return SMODS.merge_effects {
                            {
                                message = "Yay!",
                                colour = G.C.BTTIPINK
                            }, ret
                        }
                    end
                else
                    return {
                        message = "I got nothin'...",
                        colour = G.C.BTTIPINK,
                    }
                end
            else
                sendInfoMessage("SL rand: " .. rand, "BTTI")
                local idx = math.random(1, #context.scoring_hand)
                sendInfoMessage("SL idx: " .. idx, "BTTI")

                if next(SMODS.find_card("j_btti_GodTaco")) then
                    local ret = {
                        message = 'Hooray! +' .. context.scoring_hand[idx]:get_id(),
                        chip_mod = context.scoring_hand[idx]:get_id(),
                        colour = G.C.BTTIPINK,
                    }
                    local ret2 = {
                        message = 'Hooray! +' .. context.scoring_hand[idx]:get_id(),
                        chip_mod = context.scoring_hand[idx]:get_id(),
                        colour = G.C.BTTIPINK,
                    }
                    return SMODS.merge_effects {
                        {
                            message = "Go, GT!!",
                            colour = G.C.BTTIPINK
                        }, ret, ret2
                    }
                else
                    return {
                        message = 'Hooray! +' .. context.scoring_hand[idx]:get_id(),
                        chip_mod = context.scoring_hand[idx]:get_id(),
                        colour = G.C.BTTIPINK,
                    }
                end
            end
        end
	end,
    in_pool = function(self, args)
		return true, { allow_duplicates = true }
	end
}

-- Mug
SMODS.Atlas {
    key = "Mug",
    path = "bttiMug.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Mug',
    loc_txt = {
        name = 'Mug',
        text = {
            "{C:mult}+#2#{} Mult to this Joker if played", 
            "hand has more Mult than Chips",
            "{C:mult}-#2#{} Mult if played hand has more",
            "Chips than Mult",
            "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
        }
    },

    config = {extra = {mult = 0, mult_gain = 1}},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'btti_FromWhere', set = 'Other', vars = { "Inn-to the Insanity" }}
        return {
            vars = {card.ability.extra.mult, card.ability.extra.mult_gain},
        }
    end,
    rarity = 1,
    atlas = 'Mug',
    pos = {x = 0, y = 0},
    cost = 7,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult_mod = card.ability.extra.mult,
                message = "Mugtastic!"
            }
        end

        if context.final_scoring_step then --We check if we're in the final scoring step...
            if mult > hand_chips then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
                return {
                    message = 'Upgraded!',
                    color = G.C.MULT,
                }
            elseif hand_chips > mult then
                card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.mult_gain
                if card.ability.extra.mult < 0 then
                    card.ability.extra.mult = 0
                end
                return {
                    message = ':(',
                    color = G.C.CHIPS,
                }
            end
        end
    end
}

-- CREATICA JOKERS
-- CREATICA JOKERS
-- CREATICA JOKERS
-- CREATICA JOKERS

-- Joozie
SMODS.Atlas {
    key = "Joozie",
    path = "bttiJoozie.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'Joozie',
	loc_txt = {
		name = 'Joozie',
		text = {
			"Upgrades played {C:attention}Kings{} and {C:attention}Queens{}",
            "({C:chips}+117{} chips)"
		}
	},

	config = { extra = { mult = 10, odds = 2 } },
	loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'btti_FromWhere', set = 'Other', vars = { "Creatica" }}
		return {
            vars = { },
        }
	end,
	rarity = 1,
	atlas = 'Joozie',
	pos = { x = 0, y = 0 },
	cost = 6,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

	calculate = function(self, card, context)
		if context.cardarea == G.play and context.individual and context.other_card then
            local _trigger = false
            if context.other_card:get_id() == 12 then _trigger = true end --Kings
            if context.other_card:get_id() == 13 then _trigger = true end --Queens
            if _trigger then
                context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus + 117
                context.other_card:juice_up()
                return {
                    message = "Upgrade!"
                }
            end
		end
	end,
    in_pool = function(self, args)
		return true, { allow_duplicates = true }
	end
}