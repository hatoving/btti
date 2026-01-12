-- Loser, Baby
SMODS.Atlas {
    key = "Husk",
    path = "bttiHusk.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'Husk',
	loc_txt = {
		name = 'Loser, Baby',
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Hazbin Hotel", "Vivienne Medrano", "Juicimated" } }
		return {
            vars = { },
        }
	end,
	rarity = 2,
	atlas = 'Husk',
	pos = { x = 0, y = 0 },
	cost = 4,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_UNCOMMON"] = true, ["BTTI_modAddition_INTERNET"] = true },

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

-- Alastor
SMODS.Atlas {
    key = "Alastor",
    path = "bttiAlastor.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'Alastor',
	loc_txt = {
		name = 'Don\'t You Forget',
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Hazbin Hotel", "Vivienne Medrano", "hatoving" } }
		return {
            vars = { },
        }
	end,
	rarity = 3,
	atlas = 'Alastor',
	pos = { x = 0, y = 0 },
	cost = 7,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_RARE"] = true, ["BTTI_modAddition_INTERNET"] = true },

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

-- VOX POPULI
SMODS.Atlas {
    key = "Vox",
    path = "bttiVox.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'Vox',
	loc_txt = {
		name = 'VOX POPULI',
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Hazbin Hotel", "Vivienne Medrano", "Juicimated" } }
		return {
            vars = { },
        }
	end,
	rarity = 'btti_dynamic',
	atlas = 'Vox',
	pos = { x = 0, y = 0 },
	cost = 4,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_DYNAMIC"] = true, ["BTTI_modAddition_INTERNET"] = true },

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