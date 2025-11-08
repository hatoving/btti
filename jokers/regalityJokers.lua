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
            "are {C:attention}10%{} of required amount",
            "{C:green}1 in 9{} chance of being {C:red}crystallized{}"
		}
	},

	config = { extra = { odds = 9 } },
	loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "RegalitySMP", "BlueBen8" } }
		return {
            vars = { },
        }
	end,
	rarity = 3,
	atlas = 'RegBen',
	pos = { x = 0, y = 0 },
	cost = 10,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_RARE"] = true, ["BTTI_modAddition_SMP"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
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
		return true, { allow_duplicates = false }
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
            "{X:mult,C:white}X5{} Mult per {C:purple}Tarot Card{} sold",
            "Removes {C:mult}-15{} Mult from {C:attention}played hand{}",
            "per {C:purple}Tarot Card{} used",
            "{C:inactive}(Currently {X:mult,C:white}x#2#{C:inactive} Mult, {X:mult,C:white}#3#{} Mult)"
		}
	},

	config = { extra = { xmult = 0 } },
	loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "RegalitySMP", "vincemarz" } }
		return { vars = { card.ability.extra.xmult, card.ability.extra.xmultres, card.ability.extra.mult } }
	end,
	rarity = 2,
	atlas = 'RegVince',
	pos = { x = 0, y = 0 },
	cost = 6,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_UNCOMMON"] = true, ["BTTI_modAddition_SMP"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
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
		return true, { allow_duplicates = false }
	end
}

-- Moszy
SMODS.Atlas {
    key = "RegMoszy",
    path = "bttiRegMoszy.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'RegMoszy',
    loc_txt = {
        name = 'Reg!Moszy',
        text = {
            "{C:mult}+13{} Mult",
            "OR",
            "Apply {C:dark_edition}Negative{} to a random {C:attention}Joker",
            "{C:green}1 in 4{} chance of not triggering"
        }
    },

    config = { extra = {} },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "RegalitySMP", "_moszy13" } }
        return {
            vars = { },
        }
    end,
    rarity = 3,
    atlas = 'RegMoszy',
    pos = { x = 0, y = 0 },
    cost = 9,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_UNCOMMON"] = true, },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.joker_main then
            if pseudorandom('RegMoszy') < G.GAME.probabilities.normal / 4 then
                return {
                    message = "Nothin'...",
                    colour = G.C.GREEN
                }
            end
            if pseudorandom("btti_" .. card.ability.name, 0, 1) == 1 then
                --+13 mult
                return {
                    mult = 13
                }
            else
                local idx = pseudorandom("btti_" .. card.ability.name, 1, #G.jokers.cards)
                local ed = G.jokers.cards[idx].edition or nil

                if ed == nil then
                    return {
                        message = "Moss!!",
                        colour = G.C.DARK_EDITION,
                        G.E_MANAGER:add_event(Event({
                            trigger = 'immediate',
                            blocking = false,
                            delay = 0,
                            func = function()
                                G.jokers.cards[idx]:set_edition('e_negative')
                                G.jokers.cards[idx]:juice_up()

                                sendInfoMessage("setting negative", "BTTI")
                                card:juice_up()
                                return true
                            end,
                        }))
                    }
                end
            end
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
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
            "{C:mult}+#1#{} Mult for each Non-{C:attention}Stone{}/",
            "Non-{C:attention}Steel Card{} in {C:attention}full deck{}",
            "Debuffs {C:attention}Stone{} and {C:attention}Steel Cards{}",
            "{C:green}1 in 30{} chance to turn a",
            "random {C:attention}played card{} into a {C:attention}Stone Card{}",
            "{C:green}1 in 30{} chance to turn",
            "a random {C:attention}played card{} into a {C:attention}Steel Card"
        }
    },

    config = { extra = { mult = 5, odds = 30, debuffed = {} } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "RegalitySMP & Beyond...", "BlueBen8" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.odds },
        }
    end,
    rarity = 4,
    atlas = 'Myst',
    pos = { x = 0, y = 0 },
    cost = 20,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_LEGENDARY"] = true, ["BTTI_modAddition_SMP"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
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
                local idx = pseudorandom("btti_" .. card.ability.name, 1, #context.scoring_hand)
                context.scoring_hand[idx]:set_ability("m_stone")
                done = true
            end
            if not done then
                if pseudorandom('RegBen') < G.GAME.probabilities.normal / card.ability.extra.odds then
                    local idx = pseudorandom("btti_" .. card.ability.name, 1, #context.scoring_hand)
                    context.scoring_hand[idx]:set_ability("m_steel")
                end
            end
        end

        if context.cardarea == G.play and context.individual and context.other_card then
            if context.other_card.config.center.key == "m_stone" or context.other_card.config.center.key == "m_steel" then
                SMODS.debuff_card(context.other_card, true, 'Myst')
                context.other_card:juice_up()
                table.insert(card.ability.extra.debuffed, context.other_card)
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

        if context.final_scoring_step then
            for i, c in ipairs(card.ability.extra.debuffed) do
                SMODS.debuff_card(c, false, 'Myst')
                c:juice_up()
            end
            card.ability.extra.debuffed = {}
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
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
            "{C:mult}+#1#{} Mult",
            "If {C:attention}played hand{} is a {C:attention}Flush{}, this {C:attention}Joker{} will",
            "add the base {C:chips}Chips{} and {C:mult}Mult{} of {C:attention}Royal Flush{}",
            "(at the same level as {C:attention}Flush{}) to {C:attention}score{}",
            "{C:inactive}(Currently {C:chips}+#2#{} Chips, {C:mult}+#3#{} Mult)"
        }
    },

    config = { extra = { mult = 17, addChip = 0, addMult = 0, } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "RegalitySMP", "hatoving, BlueBen8" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.addChip, card.ability.extra.addMult },
        }
    end,
    rarity = 2,
    atlas = 'RoyalRegality',
    pos = { x = 0, y = 0 },
    cost = 5,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_UNCOMMON"] = true, ["BTTI_modAddition_SMP"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        card.ability.extra.addChip = G.GAME.hands['Straight Flush'].s_chips +
            (G.GAME.hands['Straight Flush'].l_chips * (G.GAME.hands['Flush'].level - 1))
        card.ability.extra.addMult = G.GAME.hands['Straight Flush'].s_mult +
            (G.GAME.hands['Straight Flush'].l_mult * (G.GAME.hands['Flush'].level - 1))

        if context.joker_main then
            local rets = {
                {
                    mult_mod = card.ability.extra.mult,
                    colour = G.C.MULT,
                    message = "+" .. card.ability.extra.mult .. " Mult",
                }
            }

            if next(context.poker_hands['Flush']) then
                table.insert(rets, {
                    chips = card.ability.extra.addChip,
                })
                table.insert(rets, {
                    mult = card.ability.extra.addMult,
                })
            end

            return SMODS.merge_effects(rets)
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}