SMODS.Font({ 
    key = "isaac", 
    path = "bttiIsaac.ttf"
})

-- D6
SMODS.Atlas {
    key = "D6",
    path = "bttiJonker.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'D6',
	loc_txt = {
		name = '{f:btti_isaac}D6',
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "The Binding of Isaac", "Edmund McMillen, Nicalis", "Juicimated" } }
		return {
            vars = { },
        }
	end,
	rarity = 2,
	atlas = 'D6',
	pos = { x = 0, y = 0 },
	cost = 4,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_UNCOMMON"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

	calculate = function(self, card, context)
		-- TO DO
	end,
    in_pool = function(self, args)
		return true, { allow_duplicates = false }
	end
}

SMODS.Atlas {
    key = "Brimstone",
    path = "bttiBrimstone.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Brimstone',
    loc_txt = {
        name = '{f:btti_isaac}Brimstone',
        text = {
            "Shoots a {C:red}Brimstone laser{} to either",
            "the left or right, adding bonus {C:mult}Mult{} to each",
            "lasered {C:attention}Joker{} equivalent to its {C:attention}sell value"
        }
    },

    config = { extra = { brimstone = {} } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "The Binding of Isaac", "Edmund McMillen, Nicalis", "Juicimated" } }
        return {
            vars = { },
        }
    end,
    rarity = 3,
    atlas = 'Brimstone',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_RARE"] = true, },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.before and context.cardarea == G.jokers then
            local dir = pseudorandom("btti_" .. card.ability.name, 0, 1) == 1 and 1 or -1
            local j = G.jokers.cards[getJokerID(card) + dir]
            if j then
                j:juice_up()
                
                if not card.ability.extra.brimstone[j.ability.name] then
                    card.ability.extra.brimstone[j.ability.name] = 0
                end
                card.ability.extra.brimstone[j.ability.name] = card.ability.extra.brimstone[j.ability.name] + j.sell_cost
                sendInfoMessage("brimstone: " .. j.ability.name .. ", " .. card.ability.extra.brimstone[j.ability.name], "BTTI")
                
                return {
                    message = "Upgrade!",
                    colour = G.C.RED,
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        blocking = false,
                        delay = 0,
                        func = function()
                            play_sound('btti_brimstone' .. (math.random(3) - 1))
                            bttiEffectManagerPlay('brimstone', card.tilt_var.mx, card.tilt_var.my - math.random(10, 25), dir)
                            j:juice_up(0.6, 1)
                            return true
                        end,
                    }))
                }
            end
        end
        if context.joker_main then
            local ret = {}
            for n, m in pairs(card.ability.extra.brimstone) do
                local j = G.jokers.cards[getJoker(n)]
                if j then
                    table.insert(ret, {
                        mult = m,
                        G.E_MANAGER:add_event(Event({
                            trigger = 'immediate',
                            blocking = false,
                            delay = 0,
                            func = function()
                                j:juice_up()
                                return true
                            end,
                        }))
                    })
                end
            end
            return SMODS.merge_effects(ret)
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

SMODS.Atlas {
    key = "D62",
    path = "bttiJonker.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'D62',
	loc_txt = {
		name = '{f:btti_isaac}D6?',
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "The Binding of Isaac", "Edmund McMillen, Nicalis", "Juicimated" } }
		return {
            vars = { },
        }
	end,
	rarity = 2,
	atlas = 'D62',
	pos = { x = 0, y = 0 },
	cost = 4,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_UNCOMMON"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

	calculate = function(self, card, context)
		-- TO DO
	end,
    in_pool = function(self, args)
		return true, { allow_duplicates = false }
	end
}

SMODS.Atlas {
    key = "Brimstone2",
    path = "bttiJonker.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'Brimstone2',
	loc_txt = {
		name = '{f:btti_isaac}Brimstone?',
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "The Binding of Isaac", "Edmund McMillen, Nicalis", "Juicimated" } }
		return {
            vars = { },
        }
	end,
	rarity = 1,
	atlas = 'Brimstone2',
	pos = { x = 0, y = 0 },
	cost = 4,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_COMMON"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

	calculate = function(self, card, context)
		-- TO DO
	end,
    in_pool = function(self, args)
		return true, { allow_duplicates = false }
	end
}