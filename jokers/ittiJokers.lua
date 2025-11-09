-- God Taco
SMODS.Atlas {
    key = "GT",
    path = "bttiGodTaco.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'GT',
	loc_txt = {
		name = 'God Taco',
		text = {
            "Shuffles all {C:attention}Jokers{} around before",
            "a hand is played and copies the",
            "{C:attention}Joker{} to the right",
		}
	},

	config = { extra = { gtTarget = 0 } },
	loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Inn-to the Insanity", "LightShine, Juicimated", "hatoving" } }
		return {
            vars = { },
        }
	end,
	rarity = 3,
	atlas = 'GT',
	pos = { x = 0, y = 0 },
	cost = 8,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_RARE"] = true, ["BTTI_modAddition_ITTI"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,

	calculate = function(self, card, context)
        if context.before and not context.blueprint then
            G.jokers:shuffle('aajk')
            play_sound('cardSlide1', 0.85)
            return {
                message = "Whoosh!",
            }
        end 
        
        if context.joker_main then
            if G.jokers.cards[getJokerID(card) + 1] then
                sendInfoMessage("supposed to retrigger: " .. getJokerID(card)+1, "BTTI")
                local ret = SMODS.blueprint_effect(card, G.jokers.cards[getJokerID(card)+1], context)
                return SMODS.merge_effects {
                    {
                        message = "AGAIN, AGAIN!!",
                        colour = G.C.PURPLE,
                    },
                    ret
                }
            elseif G.jokers.cards[1] then
                sendInfoMessage("supposed to retrigger: 1", "BTTI")
                local ret = SMODS.blueprint_effect(card, G.jokers.cards[1], context)
                return SMODS.merge_effects {
                    {
                        message = "AGAIN, AGAIN!!",
                        colour = G.C.PURPLE,
                    },
                    ret
                }
            end
        end
	end,
    in_pool = function(self, args)
		return true, { allow_duplicates = false }
	end
}

-- Strawberry Lemonade
SMODS.Atlas {
    key = "SL",
    path = "bttiSL.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'SL',
	loc_txt = {
		name = 'Strawberry Lemonade',
		text = {
            "Copies either a random {C:attention}Joker{}",
            "or retriggers a random {C:attention}card{} in {C:attention}played hand{}",
            "Triggers twice if {C:purple}God Taco{}",
            "is in hand"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Inn-to the Insanity", "LightShine, Juicimated", "hatoving" } }
		return {
            vars = { },
        }
	end,
	rarity = 3,
	atlas = 'SL',
	pos = { x = 0, y = 0 },
	cost = 6,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_RARE"] = true, ["BTTI_modAddition_ITTI"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,

	calculate = function(self, card, context)
        if context.joker_main then
            local rand = pseudorandom("btti_" .. card.ability.name, 0, 1)
            if rand == 0 then
                sendInfoMessage("SL rand: " .. rand, "BTTI")
                local idx = pseudorandom("btti_" .. card.ability.name, 1, #G.jokers.cards)
                sendInfoMessage("SL idx: " .. idx, "BTTI")
                if idx == getJokerID(card) then
                    idx = (getJokerID(card) % #G.jokers.cards) + 1
                    if idx == getJokerID(card) then
                        return {
                            message = "Can't copy myself...",
                            colour = G.C.BTTIPINK,
                        }
                    end
                end

                if G.jokers.cards[idx] then
                    sendInfoMessage("yay: " .. idx, "BTTI")
                    if next(SMODS.find_card("j_btti_GT")) then
                        local ret = SMODS.blueprint_effect(card, G.jokers.cards[idx], context)
                        local ret2 = SMODS.blueprint_effect(card, G.jokers.cards[idx], context)
                        return SMODS.merge_effects {
                            {
                                message = "Go, GT!!",
                                colour = G.C.BTTIPINK,
                                func = function ()
                                    G.jokers.cards[idx]:juice_up()
                                end
                            }, ret, ret2
                        }
                    else
                        local ret = SMODS.blueprint_effect(card, G.jokers.cards[idx], context)
                        return SMODS.merge_effects {
                            {
                                message = "Again!",
                                colour = G.C.BTTIPINK,
                                func = function()
                                    G.jokers.cards[idx]:juice_up()
                                end
                            }, ret
                        }
                    end
                else
                    return {
                        message = "I got nothin'...",
                        colour = G.C.BTTIPINK,
                    }
                end
            else
                sendInfoMessage("SL rand: " .. rand, "BTTI")
                local idx = pseudorandom("btti_" .. card.ability.name, 1, #context.scoring_hand)
                sendInfoMessage("SL idx: " .. idx, "BTTI")

                if next(SMODS.find_card("j_btti_GT")) then
                    local ret, ret2 = {}, {}
                    if not context.scoring_hand[idx].debuff then
                        ret = {
                            message = 'Again! +' .. context.scoring_hand[idx]:get_chip_bonus(),
                            chip_mod = context.scoring_hand[idx]:get_chip_bonus(),
                            colour = G.C.BTTIPINK,
                            func = function()
                                context.scoring_hand[idx]:juice_up()
                            end
                        }
                        ret2 = {
                            message = 'Hooray! +' .. context.scoring_hand[idx]:get_chip_bonus(),
                            chip_mod = context.scoring_hand[idx]:get_chip_bonus(),
                            colour = G.C.BTTIPINK,
                            func = function()
                                context.scoring_hand[idx]:juice_up()
                            end
                        }
                    end
                    return SMODS.merge_effects {
                        {
                            message = "Go, GT!!",
                            colour = G.C.BTTIPINK
                        }, ret, ret2
                    }
                else
                    if not context.scoring_hand[idx].debuff then
                        return {
                            message = 'Hooray! +' .. context.scoring_hand[idx]:get_chip_bonus(),
                            chip_mod = context.scoring_hand[idx]:get_chip_bonus(),
                            colour = G.C.BTTIPINK,
                        }
                    else
                        return {
                            message = 'Aw...',
                            colour = G.C.BTTIPINK,
                        }
                    end
                end
            end
        end
	end,
    in_pool = function(self, args)
		return true, { allow_duplicates = false }
	end
}

-- Mug
SMODS.Atlas {
    key = "Mug",
    path = "bttiMug.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Mug',
    loc_txt = {
        name = 'Mug',
        text = {
            "{C:mult}+#2#{} Mult to this {C:attention}Joker{} if {C:attention}played{}",
            "{C:attention}hand{} has more {C:mult}Mult{} than {C:chips}Chips{}",
            "{C:mult}-#2#{} Mult if played hand has more",
            "{C:chips}Chips{} than {C:mult}Mult{}",
            "{C:mult}+5{} Mult Bonus per {C:deets}Stained Card{}",
            "in played hand",
            "{C:inactive}(Currently{} {C:mult}+#1#{}{C:inactive} Mult){}"
        }
    },

    config = {extra = {mult = 0, mult_gain = 1}},
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Inn-to the Insanity", "Lightshine, Juicimated", "BlueBen8" } }
        return {
            vars = {card.ability.extra.mult, card.ability.extra.mult_gain},
        }
    end,
    rarity = 2,
    atlas = 'Mug',
    pos = {x = 0, y = 0},
    cost = 7,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_UNCOMMON"] = true, ["BTTI_modAddition_ITTI"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.joker_main then
            if card.ability.extra.mult > 0 then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end

        if context.individual and context.cardarea == G.play then
            local pc = context.other_card
            if pc and SMODS.has_enhancement(pc, "m_btti_stainedCard") then
                return {
                    mult = 5
                }
            end
        end

        if context.final_scoring_step then --We check if we're in the final scoring step...
            if mult > hand_chips then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
                return {
                    message = 'Upgraded!',
                    color = G.C.MULT,
                }
            elseif hand_chips > mult then
                card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.mult_gain
                if card.ability.extra.mult < 0 then
                    card.ability.extra.mult = 0
                end
                return {
                    message = ':(',
                    color = G.C.CHIPS,
                }
            end
        end
    end
}

-- Candle
SMODS.Atlas {
    key = "Candle",
    path = "bttiCandle.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Candle',
    loc_txt = {
        name = 'Candle',
        text = {
            "If {C:attention}played hand{} has more",
            "{C:chips}Chips{} than {C:mult}Mult{}, switch",
            "{C:chips}Chips{} and {C:mult}Mult{}",
            "Adds {X:mult,C:white}X0.2{} Mult per every",
            "time {C:chips}fire{} {C:mult}score{} is triggered",
            "{C:inactive}(Currently{} {X:mult,C:white}X#1#{}{C:inactive} Mult){}"
        }
    },

    config = { extra = { xmult = 1.0 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Inn-to the Insanity", "LightShine, Juicimated", "BlueBen8" } }
        return {
            vars = { card.ability.extra.xmult },
        }
    end,
    rarity = 2,
    atlas = 'Candle',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_UNCOMMON"] = true, ["BTTI_modAddition_ITTI"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.joker_main then
            local ch = hand_chips
            local m = mult
            if ch > m then
                sendInfoMessage("gaming candle", "BTTI")
                hand_chips = m
                mult = ch
                update_hand_text({delay = 0}, {mult = ch, chips = m})
                return {
                    message = "Switched!",
                    colour = G.C.YELLOW,
                    card = card
                }
            else
                return {
                    message = "Nope!",
                    colour = G.C.YELLOW
                }
            end
        end

        if context.after then
            if SMODS.last_hand_oneshot then
                card.ability.extra.xmult = card.ability.extra.xmult + 0.2
                return {
                    message = "Hot, hot!!",
                    colour = G.C.YELLOW,
                    card = card
                }
            end
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

-- Music Box
SMODS.Atlas {
    key = "MusicBox",
    path = "bttiJonker.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'MusicBox',
	loc_txt = {
		name = 'Music Box',
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Inn-to the Insanity", "LightShine, Juicimated", "Juicimated" } }
		return {
            vars = { },
        }
	end,
	rarity = 2,
	atlas = 'MusicBox',
	pos = { x = 0, y = 0 },
	cost = 4,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_UNCOMMON"] = true, ["BTTI_modAddition_ITTI"] = true },

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

-- Camera
SMODS.Atlas {
    key = "Camera",
    path = "bttiJonker.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'Camera',
	loc_txt = {
		name = 'Camera',
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Inn-to the Insanity", "LightShine, Juicimated", "Juicimated" } }
		return {
            vars = { },
        }
	end,
	rarity = 3,
	atlas = 'Camera',
	pos = { x = 0, y = 0 },
	cost = 4,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_RARE"] = true, ["BTTI_modAddition_ITTI"] = true },

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

-- Cubey
SMODS.Atlas {
    key = "Cubey",
    path = "bttiCubey.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Cubey',
    loc_txt = {
        name = 'C U B E Y',
        text = {
            "{C:chips}+100-1000{} Chips and {X:mult,C:white}X2-10{} Mult",
            "per other {C:balinsanity}Inn-to the Insanity Jokers{}",
            "in hand"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Inn-to the Insanity", "beanrollup", "hatoving" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 4,
    atlas = 'Cubey',
    pos = { x = 0, y = 0 },
    cost = 20,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_LEGENDARY"] = true, ["BTTI_modAddition_ITTI"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.joker_main then
           local rets = {}
            for _, jk in ipairs(G.jokers.cards) do
                local key = jk and jk.config and jk.config.center and jk.config.center.key
                if key then
                    if key == "j_btti_GT" or key == "j_btti_SL" or key == "j_btti_Mug" or key == "j_btti_Candle" then
                        table.insert(rets, {
                            chip_mod = pseudorandom("btti_" .. card.ability.name, 100, 1000),
                            Xmult_mod = pseudorandom("btti_" .. card.ability.name, 2, 10),
                            message = "...",
                            colour = G.C.BLUE
                        })
                    end
                end
            end
            return SMODS.merge_effects(rets)
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}