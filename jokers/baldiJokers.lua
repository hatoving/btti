SMODS.Font({ 
    key = "sans", 
    path = "bttiSans.ttf" 
})

-- Baldi
SMODS.Atlas {
    key = "Baldi",
    path = "bttiBaldi1.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'Baldi',
	loc_txt = {
		name = '{f:btti_sans}Baldi',
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Baldi's Basics", "Basically Games", "BlueBen8" } }
		return {
            vars = { },
        }
	end,
	rarity = 2,
	atlas = 'Baldi',
	pos = { x = 0, y = 0 },
	cost = 5,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_COMMON"] = true },

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

-- Principal of the Thing
SMODS.Atlas {
    key = "PrincipalOfTheThing",
    path = "bttiJonker.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'PrincipalOfTheThing',
	loc_txt = {
		name = '{f:btti_sans}Principal of the Thing',
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Baldi's Basics", "Basically Games" } }
		return {
            vars = { },
        }
	end,
	rarity = 2,
	atlas = 'PrincipalOfTheThing',
	pos = { x = 0, y = 0 },
	cost = 4,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_UNCOMMON"] = true },

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

-- Arts and Crafters
SMODS.Atlas {
    key = "ArtsAndCrafters",
    path = "bttiJonker.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'ArtsAndCrafters',
	loc_txt = {
		name = '{f:btti_sans}Arts and Crafters',
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Baldi's Basics", "Basically Games" } }
		return {
            vars = { },
        }
	end,
	rarity = 2,
	atlas = 'ArtsAndCrafters',
	pos = { x = 0, y = 0 },
	cost = 4,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_UNCOMMON"] = true },

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