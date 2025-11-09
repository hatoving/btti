-- Great Archbird
SMODS.Atlas {
    key = "GreatArchbird",
    path = "bttiGreatArchbird.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'GreatArchbird',
    loc_txt = {
        name = ' Great Archbird',
        text = {
            "{C:green}1 in 10{} chance to bring back",
            "a {C:attention}Joker{} that was just {C:red}destroyed{}"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "AOTA", "BlueBen8", "BlueBen8" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 3,
    atlas = 'GreatArchbird',
    pos = { x = 0, y = 0 },
    cost = 8,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_RARE"] = true, },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.joker_main then
            if context.joker_type_destroyed and not context.blueprint and not context.selling_card and context.card ~= card then
                if pseudorandom('GreatArchbird') < G.GAME.probabilities.normal / 10 then
                    local key = context.card.config.center.key
                    sendInfoMessage("bringing back joker :) ... " .. key .. "", "BTTI")
                    SMODS.add_card { key }
                end
            end
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

-- Abyss
SMODS.Atlas {
    key = "Abyss",
    path = "bttiTheAbyss.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Abyss',
    loc_txt = {
        name = 'The Abyss',
        text = {
            "{X:mult,C:white}X0.75{} Mult for each {C:attention}Joker{} destroyed",
            "after this {C:attention}Joker{} is acquired",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)"
        }
    },

    config = { extra = { Xmult = 1, jokersDestroyed = 0 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "AOTA", "BlueBen8", "BlueBen8" } }
        return {
            vars = { card.ability.extra.Xmult + ((card.ability.extra.jokersDestroyed or 0) * 0.75) },
        }
    end,
    rarity = 2,
    atlas = 'Abyss',
    pos = { x = 0, y = 0 },
    cost = 5,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_UNCOMMON"] = true, },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if not context.combined_joker then
            if context.joker_type_destroyed and not context.blueprint and not context.selling_card and context.card ~= card then
                -- Stupid way of doing this but assuming that the context gets calculated twice every time a joker gets destroyed,
                -- this is the only idea i had
                card.ability.extra.jokersDestroyed = card.ability.extra.jokersDestroyed + 1
                sendInfoMessage("destroyed joker :( ... " .. card.ability.extra.jokersDestroyed .. "", "BTTI")
            end
        end
        if context.joker_main then
            return {
                Xmult = card.ability.extra.Xmult + ((card.ability.extra.jokersDestroyed or 0) * 0.75),
            }
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

-- The Universe
SMODS.Atlas {
    key = "Universe",
    path = "bttiUniverse.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Universe',
    loc_txt = {
        name = 'The Universe',
        text = {
            "Levels up all {C:attention}poker hands",
            "by {C:blue}1{} at the end of each {C:attention}round{}",
            "{C:green}1 in 40{} chance to",
            "fade away at end of {C:attention}round{}"
        }
    },

    config = { extra = { } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "AOTA", "BlueBen8", "BlueBen8" } }
        return {
            vars = { },
        }
    end,
    rarity = 4,
    atlas = 'Universe',
    pos = { x = 0, y = 0 },
    cost = 20,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_LEGENDARY"] = true, },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.end_of_round and context.cardarea == G.jokers then
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                blocking = false,
                delay = 0,
                func = function()
                    update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3 },
                        { handname = localize('k_all_hands'), chips = '...', mult = '...', level = '' })
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.2,
                        func = function()
                            play_sound('tarot1')
                            card:juice_up(0.8, 0.5)
                            G.TAROT_INTERRUPT_PULSE = true
                            return true
                        end
                    }))
                    update_hand_text({ delay = 0 }, { mult = '+', StatusText = true })
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.9,
                        func = function()
                            play_sound('tarot1')
                            card:juice_up(0.8, 0.5)
                            return true
                        end
                    }))
                    update_hand_text({ delay = 0 }, { chips = '+', StatusText = true })
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.9,
                        func = function()
                            play_sound('tarot1')
                            card:juice_up(0.8, 0.5)
                            G.TAROT_INTERRUPT_PULSE = nil
                            return true
                        end
                    }))
                    update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.9, delay = 0 }, { level = '+1' })
                    delay(1.3)
                    for poker_hand_key, _ in pairs(G.GAME.hands) do
                        SMODS.smart_level_up_hand(card, poker_hand_key, true)
                    end
                    update_hand_text({ sound = 'button', volume = 0.7, pitch = 1.1, delay = 0 },
                        { mult = 0, chips = 0, handname = '', level = '' })
                    return true
                end,
            }))
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

-- NOBODY
SMODS.Atlas {
    key = "Nobody",
    path = "bttiJonker.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'Nobody',
	loc_txt = {
		name = 'NOBODY',
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "AOTA", "BlueBen8", "BlueBen8" } }
		return {
            vars = { },
        }
	end,
	rarity = 2,
	atlas = 'Nobody',
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