function percentOf(value, percent)
    return value * (percent / 100)
end

function getJokerID(card)
    if G.jokers then
        local _selfid = 0
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] == card then _selfid = i end
        end
        return _selfid
    end
end

-- MISC JOKERS
-- MISC JOKERS
-- MISC JOKERS
-- MISC JOKERS

-- Jonker
SMODS.Atlas {
    key = "Jonker",
    path = "bttiJonker.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'Jonker',
	loc_txt = {
		name = 'Jonker',
		text = {
			"{C:mult}+#1#{} Mult",
            "1 in 10 chance to steal {C:attention}$2-7{}"
		}
	},

	config = { extra = { mult = 10, odds = 10 } },
	loc_vars = function(self, info_queue, card)
		return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
	end,
	rarity = 1,
	atlas = 'Jonker',
	pos = { x = 0, y = 0 },
	cost = 4,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

	calculate = function(self, card, context)
		if context.joker_main then
            if pseudorandom('Jonker') < G.GAME.probabilities.normal / card.ability.extra.odds then
                local rand = math.random(-7, -2)
                return {
                    dollars = rand,
                    mult_mod = card.ability.extra.mult,
                    message = "i'm da jonker baybee!"
                }
            else
                return {
                    mult_mod = card.ability.extra.mult,
                    message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } },
                }
            end
		end
	end,
    in_pool = function(self, args)
		return true, { allow_duplicates = true }
	end
}

-- Metal Pipe
SMODS.Sound({ key = "metalPipeMult", path = "bttiMetalPipeMult.ogg" })

local ORIGINAL_play_sound = play_sound
function play_sound(sound_code, per, vol)
    if string.find(sound_code, 'multhit') ~= nil then
        for i, jk in ipairs(G.jokers.cards) do
            if jk.config.center.key == "j_btti_MetalPipe" then
                sendInfoMessage("playing metal pipe instead", "BTTI")
                return ORIGINAL_play_sound('btti_metalPipeMult', per, vol)
            end
        end
    end
    return ORIGINAL_play_sound(sound_code, per, vol)
end

SMODS.Atlas {
    key = "MetalPipe",
    path = "bttiMetalPipe.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'MetalPipe',
    loc_txt = {
        name = 'Metal Pipe',
        text = {
            "{X:mult,C:white}x2.75{} Mult per Steel Card in Deck",
            "1 in 20 Chance to turn played",
            "Cards into Steel Cards",
            "{C:inactive}Soothens your ears"
        }
    },

    config = { extra = { xmult = 2.75, odds = 20 } },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.xmult },
        }
    end,
    rarity = 1,
    atlas = 'MetalPipe',
    pos = { x = 0, y = 0 },
    cost = 4,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

    calculate = function(self, card, context)
        local cardAmount = 0
        if G.playing_cards then
            for _, pc in ipairs(G.playing_cards) do
                if pc.config.center.key == "m_steel" then
                    cardAmount = cardAmount + 1
                end
            end
        end

        if context.before then
            if pseudorandom('MetalPipe') < G.GAME.probabilities.normal / card.ability.extra.odds then
                for i, pc in ipairs(context.scoring_hand) do
                    pc:set_ability("m_steel")
                end
            end
        end

        if context.joker_main then
            sendInfoMessage("Found " .. cardAmount .. " cards = x" .. card.ability.extra.xmult * cardAmount .. " Mult")
            if card.ability.extra.xmult * cardAmount > 0 then
                return {
                    Xmult_mod = card.ability.extra.xmult * cardAmount,
                    "*metal pipe SFX*",
                    colour = G.C.GREY
                }
            end
        end

        if context.selling_card then
            if context.card == card then
                sendInfoMessage("playing metal pipe instead", "BTTI")
                play_sound('btti_metalPipeMult')
            end
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = true }
    end
}

-- Good Morning, Good Morning!
SMODS.Sound({ key = "goodMorningMult", path = "bttiGoodMorning0.ogg", })
SMODS.Sound({ key = "goodMorningOnceMore", path = "bttiGoodMorning1.ogg", })

SMODS.Atlas {
    key = "GoodMorning",
    path = "bttiGoodMorning.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'GoodMorning',
    loc_txt = {
        name = 'Good Morning, Good Morning!',
        text = {
            "{C:mult}+#1#{} Mult per round",
            "Repeats itself for each Mult",
            "Blesses your ears when triggered"
        }
    },

    config = { extra = { mult = 1, rep = 0 } },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.mult, card.ability.extra.rep },
        }
    end,
    rarity = 1,
    atlas = 'GoodMorning',
    pos = { x = 0, y = 0 },
    cost = 4,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult_mod = card.ability.extra.mult,
                message = "Good morning!",
                sound = "btti_goodMorningMult",
                pitch = 1,
            }
        end

        if context.retrigger_joker_check and not context.retrigger_joker and context.other_card == card then
            local rep = card.ability.extra.rep or 1
            return {
                repetitions = rep,
            }
        end

        -- Thank you to the Balatro Discord for being awesome
        if (context.end_of_round == true and context.cardarea == G.jokers) and
            (context.main_eval and context.game_over == false) and
                (not context.retrigger_joker and not context.retrigger_joker_check)
                    and not context.repetition then
            sendInfoMessage("once more....", "BTTI")
            return {
                message = "SO SAY GOOD MORNING!!",
                colour = G.C.RED,
                func = function ()
                    local rep = card.ability.extra.rep or 1
                    card.ability.extra.rep = rep + 1
                    play_sound("btti_goodMorningOnceMore")
                end
            }
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = true }
    end
}

-- Gambler Cat
SMODS.Atlas {
    key = "GamblerCat",
    path = "bttiGamblerCat.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'GamblerCat',
	loc_txt = {
		name = 'Gambler Cat',
		text = {
			"1 in 2 chance of losing 75%",
            "of your money OR 1 in 2 chance",
            "of gaining 110% of your money",
            "{C:inactive}He's all in{}"
		}
	},

	config = { extra = { mult = 10, odds = 10 } },
	loc_vars = function(self, info_queue, card)
		return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
	end,
	rarity = 1,
	atlas = 'GamblerCat',
	pos = { x = 0, y = 0 },
	cost = 4,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

	calculate = function(self, card, context)
		if context.final_scoring_step then
            local rand = math.random(0, 1)
            
            local loserMoney = math.ceil(G.GAME.dollars * 0.75)
            local winnerMoney = math.floor(G.GAME.dollars * 1.1)

            if rand == 1 then
                return {
                    dollars = -loserMoney,
                    message = "Whoops",
                    colour = G.C.RED
                }
            end

            rand = math.random(0, 1)

            if rand == 1 then
                return {
                    dollars = winnerMoney,
                    message = "GAMBLING!!!",
                    colour = G.C.YELLOW
                }
            else
                return {
                    message = "Nothing...",
                    colour = G.C.WHITE
                }
            end
        end 
	end,
    in_pool = function(self, args)
		return true, { allow_duplicates = true }
	end
}

-- ITTI JOKERS
-- ITTI JOKERS
-- ITTI JOKERS
-- ITTI JOKERS

-- God Taco
SMODS.Atlas {
    key = "GodTaco",
    path = "bttiGodTaco.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'GodTaco',
	loc_txt = {
		name = 'God Taco',
		text = {
            "Shuffles all Jokers around before",
            "a hand is played and copies the",
			"Joker to the right",
		}
	},

	config = { extra = { gtTarget = 0 } },
	loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'bttiFromWhere', set = 'Other', vars = { "Inn-to the Insanity" }}
		return {
            vars = { },
        }
	end,
	rarity = 1,
	atlas = 'GodTaco',
	pos = { x = 0, y = 0 },
	cost = 4,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
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
                local ret = SMODS.blueprint_effect(card, G.jokers.cards[idx], context)
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
		return true, { allow_duplicates = true }
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
		name = 'Strawberry Lemoande',
		text = {
			"Copies either a random Joker",
            "or a random Card in Hand",
            "Triggers twice if {C:purple}God Taco{}",
            "is present"
		}
	},

	config = { extra = { } },
	loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'bttiFromWhere', set = 'Other', vars = { "Inn-to the Insanity" }}
		return {
            vars = { },
        }
	end,
	rarity = 1,
	atlas = 'SL',
	pos = { x = 0, y = 0 },
	cost = 4,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

	calculate = function(self, card, context)
        if context.joker_main then
            local rand = math.random(0, 1)
            if rand == 0 then
                sendInfoMessage("SL rand: " .. rand, "BTTI")
                local idx = math.random(1, #G.jokers.cards)
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
                    if next(SMODS.find_card("j_btti_GodTaco")) then
                        local ret = SMODS.blueprint_effect(card, G.jokers.cards[idx], context)
                        local ret2 = SMODS.blueprint_effect(card, G.jokers.cards[idx], context)
                        return SMODS.merge_effects {
                            {
                                message = "Go, GT!!",
                                colour = G.C.BTTIPINK
                            }, ret, ret2
                        }
                    else
                        local ret = SMODS.blueprint_effect(card, G.jokers.cards[idx], context)
                        return SMODS.merge_effects {
                            {
                                message = "Yay!",
                                colour = G.C.BTTIPINK
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
                local idx = math.random(1, #context.scoring_hand)
                sendInfoMessage("SL idx: " .. idx, "BTTI")

                if next(SMODS.find_card("j_btti_GodTaco")) then
                    local ret = {
                        message = 'Hooray! +' .. context.scoring_hand[idx]:get_id(),
                        chip_mod = context.scoring_hand[idx]:get_id(),
                        colour = G.C.BTTIPINK,
                        func = function()
                            context.scoring_hand[idx]:juice_up()
                        end
                    }
                    local ret2 = {
                        message = 'Hooray! +' .. context.scoring_hand[idx]:get_id(),
                        chip_mod = context.scoring_hand[idx]:get_id(),
                        colour = G.C.BTTIPINK,
                        func = function()
                            context.scoring_hand[idx]:juice_up()
                        end
                    }
                    return SMODS.merge_effects {
                        {
                            message = "Go, GT!!",
                            colour = G.C.BTTIPINK
                        }, ret, ret2
                    }
                else
                    return {
                        message = 'Hooray! +' .. context.scoring_hand[idx]:get_id(),
                        chip_mod = context.scoring_hand[idx]:get_id(),
                        colour = G.C.BTTIPINK,
                    }
                end
            end
        end
	end,
    in_pool = function(self, args)
		return true, { allow_duplicates = true }
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
            "{C:mult}+#2#{} Mult to this Joker if played", 
            "hand has more Mult than Chips",
            "{C:mult}-#2#{} Mult if played hand has more",
            "Chips than Mult",
            "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
        }
    },

    config = {extra = {mult = 0, mult_gain = 1}},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'bttiFromWhere', set = 'Other', vars = { "Inn-to the Insanity" }}
        return {
            vars = {card.ability.extra.mult, card.ability.extra.mult_gain},
        }
    end,
    rarity = 1,
    atlas = 'Mug',
    pos = {x = 0, y = 0},
    cost = 7,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.joker_main then
            if card.ability.extra.mult > 0 then
                return {
                    mult_mod = card.ability.extra.mult,
                    message = "Mugtastic!"
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

-- DRAMATIZED JOKERS
-- DRAMATIZED JOKERS
-- DRAMATIZED JOKERS
-- DRAMATIZED JOKERS

-- Teeriffic!
SMODS.Atlas {
    key = "Teeriffic",
    path = "bttiTeeriffic.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'Teeriffic',
	loc_txt = {
		name = 'Teeriffic!',
		text = {
			"{C:mult}+#1#{} Mult per card",
            "Will debuff 1-2 played cards"
		}
	},

	config = { extra = { mult = 8, howMuch = 0 } },
	loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'bttiFromWhere', set = 'Other', vars = { "DRAMATIZED" }}
		return {
            vars = { card.ability.extra.mult, card.ability.extra.howMuch },
        }
	end,
	rarity = 1,
	atlas = 'Teeriffic',
	pos = { x = 0, y = 0 },
	cost = 4,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

	calculate = function(self, card, context)
		if context.before then
            local rand = math.random(1, 2)
            if #context.scoring_hand > rand then
                for i=1,rand,1 do
                    local rand2 = math.random(1, #context.scoring_hand)
                    context.scoring_hand[rand2]:set_debuff(true)
                end
            elseif #context.scoring_hand == 2 then
                local rand2 = math.random(1, #context.scoring_hand)
                context.scoring_hand[rand2]:set_debuff(true)
            end
		end

        if context.cardarea == G.play and context.individual and context.other_card then
            return {
                mult_mod = card.ability.extra.mult,
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } },
            }
		end
	end,
    in_pool = function(self, args)
		return true, { allow_duplicates = true }
	end
}

-- CREATICA JOKERS
-- CREATICA JOKERS
-- CREATICA JOKERS
-- CREATICA JOKERS

-- Joozie
SMODS.Atlas {
    key = "Joozie",
    path = "bttiJoozie.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'Joozie',
	loc_txt = {
		name = 'Joozie',
		text = {
			"Upgrades played {C:attention}Kings{} and {C:attention}Queens{}",
            "({C:chips}+117{} chips)"
		}
	},

	config = { extra = { } },
	loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'bttiFromWhere', set = 'Other', vars = { "Creatica" }}
		return {
            vars = { },
        }
	end,
	rarity = 1,
	atlas = 'Joozie',
	pos = { x = 0, y = 0 },
	cost = 6,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

	calculate = function(self, card, context)
		if context.cardarea == G.play and context.individual and context.other_card then
            local _trigger = false
            if context.other_card:get_id() == 12 then _trigger = true end --Kings
            if context.other_card:get_id() == 13 then _trigger = true end --Queens
            if _trigger then
                context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus + 117
                context.other_card:juice_up()
                return {
                    message = "Upgrade!"
                }
            end
		end
	end,
    in_pool = function(self, args)
		return true, { allow_duplicates = true }
	end
}

-- REGALITY JOKERS
-- REGALITY JOKERS
-- REGALITY JOKERS
-- REGALITY JOKERS

-- G.GAME.consumeable_usage_total.tarot

-- Reg!Ben
SMODS.Atlas {
    key = "RegBen",
    path = "bttiRegBen.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'RegBen',
	loc_txt = {
		name = 'Reg!Ben',
		text = {
			"Saves you from death if scored chips",
            "are 10% of required amount. 1 in 9",
            "chance of being destroyed at the end",
            "of each round."
		}
	},

	config = { extra = { odds = 9 } },
	loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'bttiFromWhere', set = 'Other', vars = { "RegalitySMP" }}
		return {
            vars = { },
        }
	end,
	rarity = 1,
	atlas = 'RegBen',
	pos = { x = 0, y = 0 },
	cost = 4,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

	calculate = function(self, card, context)
		if context.game_over then
            sendInfoMessage("Need at least " .. math.floor(percentOf(G.GAME.blind.chips, 10)) .. " chips", "BTTI")
            if G.GAME.current_round.hands_left == 0 and G.GAME.chips >= math.floor(percentOf(G.GAME.blind.chips, 10)) then
                sendInfoMessage("Reg!Ben!! Requirement met!!", "BTTI")
                if pseudorandom('RegBen') < G.GAME.probabilities.normal / card.ability.extra.odds then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound("tarot1")
                            card:start_dissolve()
                            return true
                        end
                    }))
                    return {
                        saved = "bttiSavedByRegBen",
                        message = "Crystallized!",
                        colour = G.C.PURPLE,
                    }
                else
                    return {
                        saved = "bttiSavedByRegBen",
                        colour = G.C.PURPLE,
                        message = "Alive!",
                    }
                end
            end
        end
	end,
    in_pool = function(self, args)
		return true, { allow_duplicates = true }
	end
}

--Reg!Vince
SMODS.Atlas {
    key = "RegVince",
    path = "bttiRegVince.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'RegVince',
	loc_txt = {
		name = 'Reg!Vince',
		text = {
			"{X:mult,C:white}x5{} Mult per Tarot Card sold",
            "Removes {C:mult}-15{} Mult from played Hand",
            "per Tarot Card used",
            "{C:inactive}Currently {X:inactive,C:white}x#2#{C:inactive} Mult, #3# Mult{}"
		}
	},

	config = { extra = { xmult = 0 } },
	loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'bttiFromWhere', set = 'Other', vars = { "RegalitySMP" }}
		return { vars = { card.ability.extra.xmult, card.ability.extra.xmultres, card.ability.extra.mult } }
	end,
	rarity = 1,
	atlas = 'RegVince',
	pos = { x = 0, y = 0 },
	cost = 4,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

    update = function(self, card, dt)
        local tarot_uses = G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.tarot or 0
        local xmult = card.ability.extra.xmult or 0

        card.ability.extra.xmultres = xmult * 5
        card.ability.extra.mult = tarot_uses * -15
    end,

	calculate = function(self, card, context)
        if context.selling_card then
            if context.card.ability.set == "Tarot" then
                card.ability.extra.xmult = card.ability.extra.xmult + 1
                return {
                    message = "Proud of you.",
                    colour = G.C.GREEN
                }
            end
        end

        if context.using_consumeable then
            if context.consumeable.ability.set == "Tarot" then
                return {
                    message = "Not proud.",
                    colour = G.C.GREEN
                }
            end
        end

		if context.joker_main then
            local tarot_uses = G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.tarot or 0
            local xmult = card.ability.extra.xmult or 0

            card.ability.extra.xmult = xmult

            local neg_mult = -15 * tarot_uses
            local pos_xmult = 5 * xmult

            if neg_mult < 0 and pos_xmult < 1 then
                return SMODS.merge_effects {
                    { message = "Magic is bad.", colour = G.C.GREEN },
                    { mult_mod = neg_mult, message = neg_mult .. " Mult", colour = G.C.MULT }
                }
            elseif pos_xmult > 0 and neg_mult > -1 then
                return SMODS.merge_effects {
                    { message = "Choose gears!", colour = G.C.GREEN },
                    { Xmult_mod = pos_xmult, message = 'X' .. pos_xmult .. " Mult", colour = G.C.MULT }
                }
            elseif neg_mult < 0 and pos_xmult > 0 then
                return SMODS.merge_effects {
                    { message = "Magic is bad.", colour = G.C.GREEN },
                    { mult_mod = neg_mult, message = neg_mult .. " Mult", colour = G.C.MULT },
                    { message = "Choose gears!", colour = G.C.GREEN },
                    { Xmult_mod = pos_xmult, message = 'X' .. pos_xmult .. " Mult", colour = G.C.MULT }
                }
            end
        end

	end,
    in_pool = function(self, args)
		return true, { allow_duplicates = true }
	end
}

-- ???
SMODS.Atlas {
    key = "Myst",
    path = "bttiMyst.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Myst',
    loc_txt = {
        name = '???????????',
        text = {
            "+{C:mult}#1#{} Mult for each Non-Steel/",
            "Non-Stone Card in current Deck",
            "1 in 30 chance to turn a",
            "random Card into a Stone Card",
            "1 in 30 chance to turn",
            "a random Card into a Steel Card"
        }
    },

    config = { extra = { mult = 20, odds = 30 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "RegalitySMP" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.odds },
        }
    end,
    rarity = 3,
    atlas = 'Myst',
    pos = { x = 0, y = 0 },
    cost = 12,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

    calculate = function(self, card, context)
        local cardAmount = 0
        if G.playing_cards then
            for _, pc in ipairs(G.playing_cards) do
                if pc.config.center.key ~= "m_stone" and pc.config.center.key ~= "m_steel" then
                    cardAmount = cardAmount + 1
                end
            end
        end

        if context.before then
            local done = false
            if pseudorandom('RegBen') < G.GAME.probabilities.normal / card.ability.extra.odds then
                local idx = math.random(1, #context.scoring_hand)
                context.scoring_hand[idx]:set_ability("m_stone")
                done = true
            end
            if not done then
                if pseudorandom('RegBen') < G.GAME.probabilities.normal / card.ability.extra.odds then
                    local idx = math.random(1, #context.scoring_hand)
                    context.scoring_hand[idx]:set_ability("m_stone")
                end
            end
        end

        if context.cardarea == G.play and context.individual and context.other_card then
            if context.other_card.config.center.key == "m_stone" or context.other_card.config.center.key == "m_steel" then
                context.other_card:set_debuff(true)
            end
        end

        if context.joker_main then 
            sendInfoMessage("Found " .. cardAmount .. " cards = +" .. card.ability.extra.mult * cardAmount .. " Mult")
            return SMODS.merge_effects {
                { message = "Gray... oh so gray...", colour = G.C.GREY }, {
                    mult_mod = card.ability.extra.mult * cardAmount,
                    colour = G.C.RED,
                    message = "+" .. card.ability.extra.mult * cardAmount .. " Mult",
                }
            }
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = true }
    end
}

-- Royal Regality
SMODS.Atlas {
    key = "RoyalRegality",
    path = "bttiRoyalRegality.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'RoyalRegality',
    loc_txt = {
        name = 'Royal Regality',
        text = {
            "{C:mult}+#1#{} mult",
            "Played Flushes count as Royal Flushes,",
            "but retain Flush's current level"
        }
    },

    config = { extra = { mult = 17 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "RegalitySMP" } }
        return {
            vars = { card.ability.extra.mult },
        }
    end,
    rarity = 1,
    atlas = 'RoyalRegality',
    pos = { x = 0, y = 0 },
    cost = 4,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.evaluate_poker_hand then
            if context.poker_hands and next(context.poker_hands['Flush']) then
                local c = G.GAME.hands['Straight Flush'].s_chips +
                    (G.GAME.hands['Straight Flush'].l_chips * (G.GAME.hands['Flush'].level - 1))
                local m = G.GAME.hands['Straight Flush'].s_mult +
                    (G.GAME.hands['Straight Flush'].l_mult * (G.GAME.hands['Flush'].level - 1))
                update_hand_text({ delay = 0 }, { chips = c, mult = m })

                return {
                    replace_scoring_name = "Flush",
                    replace_display_name = "Royal Flush",
                }
            end
        end

        if context.initial_scoring_step and not context.blueprint then
            if context.poker_hands and next(context.poker_hands['Flush']) then
                -- I don't actually know how to change the hand,
                -- but we can pretend. :D
                return {
                    func = function ()
                        hand_chips = G.GAME.hands['Straight Flush'].s_chips +
                            (G.GAME.hands['Straight Flush'].l_chips * (G.GAME.hands['Flush'].level - 1))
                        mult = G.GAME.hands['Straight Flush'].s_mult +
                            (G.GAME.hands['Straight Flush'].l_mult * (G.GAME.hands['Flush'].level - 1))
                        update_hand_text({ delay = 0 }, { chips = hand_chips, mult = mult })
                    end
                }
            end
        end

        if context.joker_main then
            return {
                mult_mod = card.ability.extra.mult,
                colour = G.C.RED,
                message = "+" .. card.ability.extra.mult .. " Mult",
            }
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = true }
    end
}

-- DIRECTOR JOKERS
-- DIRECTOR JOKERS
-- DIRECTOR JOKERS
-- DIRECTOR JOKERS

-- LightShine
SMODS.Atlas {
    key = "LightShine",
    path = "bttiLightShine.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'LightShine',
    loc_txt = {
        name = 'LightShine',
        text = {
            "1 in 10 chance to sloppily",
            "backread Jokers in hand",
            "{C:mult}+10{} Mult per Autism Joker",
            "{X:chips,C:white}x300{} Chips if an",
            "{C:purple}Inn-to the Insanity{} joker",
            "is present"
        }
    },

    config = { extra = { mult = 10 } },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.mult },
        }
    end,
    rarity = 4,
    atlas = 'LightShine',
    pos = { x = 0, y = 0 },
    cost = 20,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.joker_main then
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = true }
    end
}

--ca850
-- Jonker
SMODS.Atlas {
    key = "Ca850",
    path = "bttiCa850.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Ca850',
	loc_txt = {
		name = 'ca850',
		text = {
			"{C:mult}+100{} Mult if {C:pink}hatoving{},",
            "{C:orange}Juicimated{}, and {C:chips}BlueBen8{} aren't present",
            "Kills LightShine if she is present",
            "{C:inactive}He carries you{}"
		}
	},

	config = { extra = { mult = 100 } },
	loc_vars = function(self, info_queue, card)
		return {
            vars = { card.ability.extra.mult },
        }
	end,
	rarity = 4,
    atlas = 'Ca850',
	pos = { x = 0, y = 0 },
	cost = 20,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

	calculate = function(self, card, context)
		if context.joker_main then
            local killedLight = false
            for i, jk in ipairs(G.jokers.cards) do
                sendInfoMessage("checking joker " .. jk.config.center.key .. "..", "BTTI")
                if jk.config.center.key == "j_btti_LightShine" then
                    jk:start_dissolve()
                    killedLight = true
                    break
                end
            end

            if not next(SMODS.find_card("j_btti_Hatoving")) and not next(SMODS.find_card("j_btti_Juicimated")) and not next(SMODS.find_card("j_btti_BlueBen8")) then
                sendInfoMessage("them bitches aren't present!! party!!", "BTTI")
                if not killedLight then
                    return SMODS.merge_effects {
                        {
                            colour = G.C.BLUE,
                            message = "i carried",
                        },
                        {
                            mult_mod = card.ability.extra.mult,
                            colour = G.C.RED,
                            message = "+" .. card.ability.extra.mult .. " Mult",
                        }
                    }
                else 
                    return SMODS.merge_effects {
                        {
                            colour = G.C.BLUE,
                            message = "stfu",
                        },
                        {
                            mult_mod = card.ability.extra.mult,
                            colour = G.C.RED,
                            message = "+" .. card.ability.extra.mult .. " Mult",
                        }
                    }
                end
            else
                sendInfoMessage("nvm", "BTTI")
                return SMODS.merge_effects {
                    {
                        colour = G.C.BLUE,
                        message = "i hate those guys",
                    }
                }
            end
		end
	end,
    in_pool = function(self, args)
		return true, { allow_duplicates = true }
	end
}