-- Juicimated
SMODS.Atlas {
    key = "Juicimated",
    path = "bttiJuicimated.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Juicimated',
    loc_txt = {
        name = 'Juicimated',
        text = {
            "{C:green}1 in 17{} chance for {C:mult}+117{} Mult",
            "Turns {C:attention}played hand orange{}"
        }
    },

    config = { extra = { mult = 117, odds = 17 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Real Life", "Juicimated", "BlueBen8" } }
        return {
            vars = { card.ability.extra.mult },
        }
    end,
    rarity = 4,
    atlas = 'Juicimated',
    pos = { x = 0, y = 0 },
    cost = 20,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_LEGENDARY"] = true, },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.joker_main then
            local rets = {}
            if pseudorandom('Juicimated') < G.GAME.probabilities.normal / card.ability.extra.odds then
                table.insert(rets, {
                    mult_mod = card.ability.extra.mult,
                    message = "Joozin' it",
                    colour = G.C.ORANGE,
                })
            else
                table.insert(rets, {
                    message = "We chillin'",
                    colour = G.C.ORANGE,
                })
            end
            if G.play.cards then
                table.insert(rets, {
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        blocking = false,
                        delay = 0,
                        func = function()
                            for i, c in ipairs(G.play.cards) do
                                c:juice_up()
                                c:set_seal("btti_orangeSeal", false, true)
                                delay(0.1)
                            end
                            card_eval_status_text(card, 'extra', nil, nil, nil,
                                { message = "I joozed", colour = G.C.ORANGE })
                            return true
                        end,
                    }))
                })
            end
            return SMODS.merge_effects(rets)
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

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
            "Sloppily backreads {C:attention}Jokers{} to the left",
            "{C:mult}+10{} Mult per other {C:gay}Autism Jokers{}",
            "{X:mult,C:white}X69{} Mult if an",
            "{C:balinsanity}Inn-to the Insanity Joker{}",
            "is in hand"
        }
    },

    config = { extra = { mult = 10 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Real Life", "LightShine", "hatoving, BlueBen8" } }
        return {
            vars = { card.ability.extra.mult },
        }
    end,
    rarity = 4,
    atlas = 'LightShine',
    pos = { x = 0, y = 0 },
    cost = 20,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_LEGENDARY"] = true, },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.selling_card then
            if context.card == card then
                return {
                    message = "omga, ow",
                    colour = G.C.RED
                }
            end
        end

        if not context.joker_main then return end

        local rets = {}
        local itti = false

        -- Backread
        if getJokerID(card) ~= 1 then
            local jokersToBackRead = {}
            for _, jk in ipairs(G.jokers.cards) do
                local key = jk and jk.config and jk.config.center and jk.config.center.key
                sendInfoMessage("checking joekr : " .. key .. "...", "BTTI")
                if pseudorandom("btti_" .. card.ability.name, 0, 1) == 1 then
                    if key ~= card.config.center.key then
                        sendInfoMessage("adding joekr : " .. key .. "...", "BTTI")
                        table.insert(jokersToBackRead, jk)
                    end
                end
            end

            if #jokersToBackRead > 0 then
                for _, targetJk in ipairs(jokersToBackRead) do 
                    local ret = SMODS.blueprint_effect(card, targetJk, context)
                    
                    -- blueprint_effect may return a single effect (table) or a list of effects.
                    if ret ~= nil then
                        table.insert(rets, {
                            message = "Huh?",
                            colour = G.C.GREEN,
                            func = function()
                                targetJk:juice_up()
                            end
                        })
                        table.insert(rets, ret)
                    end
                end
            else
                table.insert(rets, { message = "I'm not backreading.", colour = G.C.GREY })
            end
        else
            table.insert(rets, { message = "I'm not backreading.", colour = G.C.GREY })
        end

        -- Scan jokers for multiplier keys and ITTI flags
        for _, jk in ipairs(G.jokers.cards) do
            local key = jk and jk.config and jk.config.center and jk.config.center.key
            if key then
                if key == "j_btti_AutismCreature" or key == "j_btti_BentismCreature" or key == "j_btti_BlueBen8" then
                    table.insert(rets, {
                        mult_mod = 10,
                        G.E_MANAGER:add_event(Event({
                            trigger = 'immediate',
                            blocking = false,
                            delay = 0,
                            func = function()
                                jk:juice_up()
                                card_eval_status_text(card, 'extra', nil, nil, nil,
                                    { message = "Me = gender!!", colour = G.C.GAY })
                                return true
                            end,
                        }))
                    })
                end

                if key == "j_btti_GT" or key == "j_btti_SL" or key == "j_btti_Mug" or key == "j_btti_Cubey" or key == "j_btti_Candle" then
                    itti = true
                end
            end
        end

        if itti then
            table.insert(rets, { message = "Bazinga!!", Xmult_mod = 69, colour = G.C.RED })
        end
        --sendInfoMessage(rets, "BTTI")
        return SMODS.merge_effects(rets)
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

-- hatoving
SMODS.Atlas {
    key = "Hatoving",
    path = "bttiHatoving.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Hatoving',
    loc_txt = {
        name = 'hatoving',
        text = {
            "Stores the final scored {C:mult}Mult{} and {C:chips}Chips{}",
            "of one ended round and unleashes it",
            "a random amount of rounds later",
            "{C:inactive}(Currently {C:mult}+#1#{} Mult and {C:chips}+#2#{} Chips)"
        }
    },

    config = { extra = { mult = 0, chips = 0, roundsLeft = 0 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Real Life", "hatoving", "hatoving" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.chips, card.ability.extra.roundsLeft },
        }
    end,
    rarity = 4,
    atlas = 'Hatoving',
    pos = { x = 0, y = 0 },
    cost = 20,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_LEGENDARY"] = true, },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.joker_main then
            if card.ability.extra.roundsLeft <= 0 and (card.ability.extra.chips > 0 and card.ability.extra.mult > 0) then
                local ch = card.ability.extra.chips
                local m = card.ability.extra.mult
                card.ability.extra.chips = 0
                card.ability.extra.mult = 0
                return SMODS.merge_effects {
                    {
                        message = "Awersome...",
                        colour = G.C.BTTIPINK
                    },
                    {
                        message = "+" .. ch .. " Chips",
                        colour = G.C.CHIPS,
                        chip_mod = ch,
                    },
                    {
                        message = "+" .. m .. " Mult",
                        colour = G.C.MULT,
                        mult_mod = card.ability.extra.mult,
                    }
                }
            end
        end
        if context.end_of_round and context.cardarea == G.jokers then
            if (card.ability.extra.mult <= 0 and card.ability.extra.chips <= 0) or card.ability.extra.roundsLeft <= 0 then
                card.ability.extra.mult = mult
                card.ability.extra.chips = hand_chips
                card:juice_up()
                sendInfoMessage(
                    "chips and mult for hatoving.. " .. card.ability.extra.mult .. ", " .. card.ability.extra.chips .. "",
                    "BTTI")
            end
            if card.ability.extra.roundsLeft <= 0 then
                card.ability.extra.roundsLeft = pseudorandom("btti_" .. card.ability.name, 1, 5)
                sendInfoMessage("rounds left for hatoving... " .. card.ability.extra.roundsLeft .. "", "BTTI")
                return {
                    message = "Not yet...",
                    colour = G.C.BTTIPINK
                }
            else
                card.ability.extra.roundsLeft = card.ability.extra.roundsLeft - 1
                sendInfoMessage("rounds left for hatoving... " .. card.ability.extra.roundsLeft .. "", "BTTI")

                return {
                    message = "Not yet...",
                    colour = G.C.BTTIPINK
                }
            end
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

--ca850
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
			"{C:mult}+100{} Mult if {C:mult}hatoving{},",
            "{C:attention}Juicimated{}, or {C:chips}BlueBen8{} aren't in hand",
            "{C:red}Kills{} LightShine if LightShine is in hand",
            "{C:inactive}He carries you{}"
		}
	},

	config = { extra = { mult = 100 } },
	loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Real Life", "ca850", "BlueBen8" } }
		return {
            vars = { card.ability.extra.mult },
        }
	end,
	rarity = 4,
    atlas = 'Ca850',
	pos = { x = 0, y = 0 },
	cost = 20,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_LEGENDARY"] = true, },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

	calculate = function(self, card, context)
        if context.before then
            for i, jk in ipairs(G.jokers.cards) do
                sendInfoMessage("checking joker " .. jk.config.center.key .. "..", "BTTI")
                if jk.config.center.key == "j_btti_LightShine" then
                    SMODS.destroy_cards(jk)
                    return {
                        message = "stfu light",
                        colour = G.C.BLUE,
                    }
                end
            end
        end
		if context.joker_main then
            if not next(SMODS.find_card("j_btti_Hatoving")) and not next(SMODS.find_card("j_btti_Juicimated")) and not next(SMODS.find_card("j_btti_BlueBen8")) then
                sendInfoMessage("them bitches aren't present!! party!!", "BTTI")
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
		return true, { allow_duplicates = false }
	end
}

-- BlueBen8
SMODS.Atlas {
    key = "BlueBen8",
    path = "bttiBlueBen8.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'BlueBen8',
    loc_txt = {
        name = 'BlueBen8',
        text = {
            "Any played {C:attention}Straight{} hand will",
            "be played as a {C:bisexual}Bisexual{} Hand",
            "{C:green}1 in 4{} chance to upgrade {C:attention}Flush{} when played",
            "{C:chips}+30{} Chips if an {C:gay}Autism Joker{} is in hand"
        }
    },

    config = { extra = { odds = 4 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Real Life", "BlueBen8", "BlueBen8" } }
        return {
            vars = { card.ability.extra.odds },
        }
    end,
    rarity = 4,
    atlas = 'BlueBen8',
    pos = { x = 0, y = 0 },
    cost = 20,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_LEGENDARY"] = true, },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.evaluate_poker_hand and context.poker_hands then
            if context.scoring_name == "Straight" then
                return {
                    replace_scoring_name = "Bisexual",
                }
            elseif context.scoring_name == "Straight Flush" then
                return {
                    replace_scoring_name = "BisexualFlush",
                }
            end
        end

        if context.joker_main then
            local rets = {}
            card.ability.extra.odds = 4
            if pseudorandom('BlueBen8') < G.GAME.probabilities.normal / card.ability.extra.odds then
                table.insert(rets, {
                    message = "Flush Upgrade!!", colour = G.C.BTTIGAY,
                    func = function()
                        SMODS.smart_level_up_hand(card, "Flush", nil, 1) -- Level up Flush by 1
                    end
                })
            end
            for _, jk in ipairs(G.jokers.cards) do
                local key = jk and jk.config and jk.config.center and jk.config.center.key
                if key then
                    if key == "j_btti_AutismCreature" or key == "j_btti_BentismCreature" or key == "j_btti_LightShine" then
                        table.insert(rets, {
                            chip = 30,
                            colour = G.C.BTTIGAY
                        })
                        break -- only want to do it once
                    end
                end
            end
            if #rets > 0 then
                return SMODS.merge_effects(rets)
            end
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}