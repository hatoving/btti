-- McDonald's Fries
SMODS.Atlas {
    key = "McFries",
    path = "bttiMcFries.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'McFries',
	loc_txt = {
		name = 'McDonald\'s Fries',
		text = {
			"{C:mult}+10{} Mult",
            "After all {C:attention}Jokers{} have beeen",
            "triggered, additional {C:mult}+0-5{} Mult"
		}
	},

	config = { extra = { mult = 10 } },
	loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "McDonald's", "Ronald McDonald", "BlueBen8"} }
		return {
            vars = { },
        }
	end,
	rarity = 1,
	atlas = 'McFries',
	pos = { x = 0, y = 0 },
	cost = 4,
    pools = { ["BTTI_modAddition"] = true },

    unlocked = false,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

	calculate = function(self, card, context)
		if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
        if context.after then
            if pseudorandom('McFries') < G.GAME.probabilities.normal then
                local rand = pseudorandom("btti_" .. card.ability.name, 0, 5)
                return {
                    mult = rand,
                    mult_mod = card.ability.extra.mult,
                    message = "bag fries!"
                }
            end
	end
end,
    in_pool = function(self, args)
		return false, { allow_duplicates = false }
	end
}

-- Big Mac
SMODS.Atlas {
    key = "BigMac",
    path = "bttiBigMac.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'BigMac',
	loc_txt = {
		name = 'Big Mac',
		text = {
			"{X:mult,C:white}X1.5{} Mult if current {C:attention}Ante{}",
            "is a multiple of {C:attention}2{}"
		}
	},

	config = { extra = { mult = 10, odds = 10 } },
	loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "McDonald's", "Ronald McDonald" } }
		return {
            vars = { },
        }
	end,
	rarity = 2,
	atlas = 'BigMac',
	pos = { x = 0, y = 0 },
	cost = 6,
    pools = { ["BTTI_modAddition"] = true },

    unlocked = false,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

	calculate = function(self, card, context)
		-- TO DO
	end,
    in_pool = function(self, args)
		return false, { allow_duplicates = false }
	end
}

-- Happy Meal
SMODS.Atlas {
    key = "HappyMeal",
    path = "bttiJonker.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'HappyMeal',
	loc_txt = {
		name = 'Happy Meal',
		text = {
			"{C:attention}"
		}
	},

	config = { extra = { mult = 10, odds = 10 } },
	loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "McDonald's", "Ronald McDonald" } }
		return {
            vars = { },
        }
	end,
	rarity = 3,
	atlas = 'HappyMeal',
	pos = { x = 0, y = 0 },
	cost = 7,
    pools = { ["BTTI_modAddition"] = true },

    unlocked = false,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

	calculate = function(self, card, context)
		-- TO DO
	end,
    in_pool = function(self, args)
		return false, { allow_duplicates = false }
	end
}

-- McRib
SMODS.Atlas {
    key = "McRib",
    path = "bttiJonker.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'McRib',
	loc_txt = {
		name = 'McRib',
		text = {
			"{C:attention}"
		}
	},

	config = { extra = { mult = 10, odds = 10 } },
	loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "McDonald's", "Ronald McDonald" } }
		return {
            vars = { },
        }
	end,
	rarity = 3,
	atlas = 'McRib',
	pos = { x = 0, y = 0 },
	cost = 6,
    pools = { ["BTTI_modAddition"] = true },

    unlocked = false,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

	calculate = function(self, card, context)
		-- TO DO
	end,
    in_pool = function(self, args)
		return false, { allow_duplicates = false }
	end
}