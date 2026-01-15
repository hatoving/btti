-- Mr. Frog
SMODS.Atlas {
    key = "MrFrog",
    path = "bttiMrFrog.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'MrFrog',
	loc_txt = {
		name = 'Mr. Frog',
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Smiling Friends", "Zach Hadel, Michael Cusack" } }
		return {
            vars = { },
        }
	end,
	rarity = 2,
	atlas = 'MrFrog',
	pos = { x = 0, y = 0 },
	cost = 6,
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