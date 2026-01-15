-- Sayori
SMODS.Atlas {
    key = "Sayori",
    path = "bttiSayori.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'Sayori',
	loc_txt = {
		name = 'Sayori',
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Doki Doki Literature Club!", "Dan Salvato", "Juicimated" } }
		return {
            vars = { },
        }
	end,
	rarity = 1,
	atlas = 'Sayori',
	pos = { x = 0, y = 0 },
	cost = 4,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_COMMON"] = true, ["BTTI_modAddition_GAME"] = true },

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

-- Yuri
SMODS.Atlas {
    key = "Yuri",
    path = "bttiYuri.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'Yuri',
	loc_txt = {
		name = 'Yuri',
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Doki Doki Literature Club!", "Dan Salvato", "Juicimated" } }
		return {
            vars = { },
        }
	end,
	rarity = 2,
	atlas = 'Yuri',
	pos = { x = 0, y = 0 },
	cost = 5,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_UNCOMMON"] = true, ["BTTI_modAddition_GAME"] = true },

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

-- Natsuki
SMODS.Atlas {
    key = "Natsuki",
    path = "bttiNatsuki.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'Natsuki',
	loc_txt = {
		name = 'Natsuki',
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Doki Doki Literature Club!", "Dan Salvato", "Juicimated" } }
		return {
            vars = { },
        }
	end,
	rarity = 1,
	atlas = 'Natsuki',
	pos = { x = 0, y = 0 },
	cost = 5,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_COMMON"] = true, ["BTTI_modAddition_GAME"] = true },

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

-- Monika
SMODS.Atlas {
    key = "Monika",
    path = "bttiMonika.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'Monika',
	loc_txt = {
		name = 'Monika',
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Doki Doki Literature Club!", "Dan Salvato", "hatoving, Juicimated" } }
		return {
            vars = { },
        }
	end,
	rarity = 2,
	atlas = 'Monika',
	pos = { x = 0, y = 0 },
	cost = 5,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_UNCOMMON"] = true, ["BTTI_modAddition_GAME"] = true },

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