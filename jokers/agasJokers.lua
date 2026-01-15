-- Dad Character
SMODS.Atlas {
    key = "DadCharacter",
    path = "bttiDadCharacter.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'DadCharacter',
	loc_txt = {
		name = 'Dad Character',
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "A Generic Adult Sitcom", "Connor Wozniak" } }
		return {
            vars = { },
        }
	end,
	rarity = 1,
	atlas = 'DadCharacter',
	pos = { x = 0, y = 0 },
	cost = 4,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_MEDIA"] = true },

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

-- Punching Bag Wife
SMODS.Atlas {
    key = "PunchingBagWife",
    path = "bttiPunchingBagWife.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'PunchingBagWife',
	loc_txt = {
		name = 'Punching Bag Wife',
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "A Generic Adult Sitcom", "Connor Wozniak" } }
		return {
            vars = { },
        }
	end,
	rarity = 2,
	atlas = 'PunchingBagWife',
	pos = { x = 0, y = 0 },
	cost = 4,
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

-- Emo Daughter
SMODS.Atlas {
    key = "EmoDaughter",
    path = "bttiEmoDaughter.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'EmoDaughter',
	loc_txt = {
		name = 'Emo Daughter',
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "A Generic Adult Sitcom", "Connor Wozniak" } }
		return {
            vars = { },
        }
	end,
	rarity = 1,
	atlas = 'EmoDaughter',
	pos = { x = 0, y = 0 },
	cost = 4,
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

-- Marketable Sidekick
SMODS.Atlas {
    key = "MarketableSidekick",
    path = "bttiMarketableSidekick.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'MarketableSidekick',
	loc_txt = {
		name = 'Marketable Sidekick',
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "A Generic Adult Sitcom", "Connor Wozniak" } }
		return {
            vars = { },
        }
	end,
	rarity = 3,
	atlas = 'MarketableSidekick',
	pos = { x = 0, y = 0 },
	cost = 7,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_RARE"] = true, ["BTTI_modAddition_MEDIA"] = true },

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