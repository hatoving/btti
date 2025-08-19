function getJokerID(card)
    if G.jokers then
        local _selfid = 0
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] == card then _selfid = i end
        end
        return _selfid
    end
end

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
        
        if context.retrigger_joker_check and context.other_card ~= self then
            if G.jokers.cards[getJokerID(card) + 1] then
                if context.other_card == G.jokers.cards[getJokerID(card) + 1] then --If there's a joker to the right of this one, retrigger it
                    sendInfoMessage("supposed to retrigger: " .. getJokerID(card)+1, "BTTI")
                    return {
                        message = "AGAIN !!",
                        repetitions = 1,
                        card = card,
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