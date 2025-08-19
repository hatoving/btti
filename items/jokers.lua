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
    key = "bttiJonker",
    path = "bttiJonker.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'bttiJonker',
	loc_txt = {
		name = 'Jonker',
		text = {
			"{C:mult}+#1#{} Mult",
            "1 in 10 chance to steal {C:attention}$2-7{}"
		}
	},

	config = { extra = { mult = 10, odds = 2 } },
	loc_vars = function(self, info_queue, card)
		return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
	end,
	rarity = 1,
	atlas = 'bttiJonker',
	pos = { x = 0, y = 0 },
	cost = 4,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

	calculate = function(self, card, context)
		if context.joker_main then
            if pseudorandom('bttiJonker') < G.GAME.probabilities.normal / card.ability.extra.odds then
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
    key = "bttiGamblerCat",
    path = "", 

} ]]

-- ITTI JOKERS
-- ITTI JOKERS
-- ITTI JOKERS
-- ITTI JOKERS

-- God Taco
SMODS.Atlas {
    key = "bttiGodTaco",
    path = "bttiGodTaco.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'bttiGodTaco',
	loc_txt = {
		name = 'God Taco',
		text = {
			"Shuffles Jokers around every time",
            "you play a hand and copies the",
            "Joker to the right's ability"
		}
	},

	config = { extra = { gtTarget = 0 } },
	loc_vars = function(self, info_queue, card)
		return {
            vars = { },
        }
	end,
	rarity = 1,
	atlas = 'bttiGodTaco',
	pos = { x = 0, y = 0 },
	cost = 4,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    update = function(self, card, front)
        if G.jokers then
            if G.jokers.cards[getJokerID(card) + 1] then
                card.ability.extra.gtTarget = G.jokers.cards[getJokerID(card) + 1]
            elseif getJokerID(card) == #G.jokers.cards and G.jokers.cards[1] and G.jokers.cards[1] ~= card then
                card.ability.extra.gtTarget = G.jokers.cards[1]
            end
        end
    end,

	calculate = function(self, card, context)
        if context.before then
            G.E_MANAGER:add_event(Event({ trigger = 'immediate', blocking = false, delay = 0.0, func = function() G.jokers:shuffle('aajk'); play_sound('cardSlide1', 0.85);return true end }))
            return {
                message = "Whoosh!",
            }
        end 
        
        if context.other_joker and card ~= context.other_joker then
            if G.jokers.cards[getJokerID(card) + 1] then
                if context.other_joker == G.jokers.cards[getJokerID(card) + 1] then --If there's a joker to the right of this one, retrigger it
                    sendInfoMessage("supposed to retrigger: " .. getJokerID(card)+1, "BTTI")
                    return {
                        message = "AGAIN !!",
                        repetitions = 1,
                        card = context.other_joker,
                        colour = G.C.PURPLE,
                    }
                else
                    return nil, true end
            end
        end
	end,
    in_pool = function(self, args)
		return true, { allow_duplicates = true }
	end
}

-- Mug
SMODS.Atlas {
    key = "bttiMug",
    path = "bttiMug.png",
    px = 71,
    px = 95
}
SMODS.Joker {
    key = 'bttiMug',
    loc_txt = {
        name = 'Mug',
        text = {
            "{C:mult}+#1# {} Mult to this Joker if played", 
            "hand has more Mult than Chips",
            "{C:mult}-#1# {} Mult if played hand has more",
            "Chips than Mult",
            "{C:inactive}(Currently {C:mult}+#0#{C:inactive} Mult)"
        }
    },

    config = {extra = {mult = 0, mult_gain = 0}},
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.mult, card.ability.extra.mult_gain},
        }
    end,
    rarity = 1,
    atlas = 'bttiMug',
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
                mult_mod = card.ability.extra.mult
            }
        end

        if context.before then
            if card.ability.current_hand_mult > card.ability.current_hand_chips then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
                return {
                    message = 'Upgraded!',
                    color = G.C.MULT,
                    card = card
                }
            else
                card.ability.extra.mult = card.ability.extra_mult - card.ability.extra.mult_gain
                return {
                    message = ':(',
                    color = G.C.CHIPS,
                    card = card
                }
            end
        end
}

-- CREATICA JOKERS
-- CREATICA JOKERS
-- CREATICA JOKERS
-- CREATICA JOKERS

-- Joozie
SMODS.Atlas {
    key = "bttiJoozie",
    path = "bttiJoozie.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'bttiJoozie',
	loc_txt = {
		name = 'Joozie',
		text = {
			"Upgrades played {C:attention}Kings{} and {C:attention}Queens{}",
            "({C:chips}+117{} chips)"
		}
	},

	config = { extra = { mult = 10, odds = 2 } },
	loc_vars = function(self, info_queue, card)
		return {
            vars = { },
        }
	end,
	rarity = 1,
	atlas = 'bttiJoozie',
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