-- Dexter Morgan
SMODS.Atlas {
    key = "Dexter",
    path = "bttiDexter.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'Dexter',
	loc_txt = {
		name = 'Dexter Morgan',
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Dexter", "Jeff Lindsay", "Juicimated" } }
		return {
            vars = { },
        }
	end,
	rarity = 2,
	atlas = 'Dexter',
	pos = { x = 0, y = 0 },
	cost = 7,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_UNCOMMON"] = true, ["BTTI_modAddition_MEDIA"] = true },

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

-- Sgt. James Doakes
SMODS.Atlas {
    key = "Doakes",
    path = "bttiDoakes.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'Doakes',
	loc_txt = {
		name = 'Sgt. James Doakes',
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Dexter", "Jeff Lindsay", "Juicimated" } }
		return {
            vars = { },
        }
	end,
	rarity = 1,
	atlas = 'Doakes',
	pos = { x = 0, y = 0 },
	cost = 5,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_COMMON"] = true, ["BTTI_modAddition_MEDIA"] = true },

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