-- Honse
SMODS.Atlas {
    key = "Honse",
    path = "bttiHonse.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Honse',
    loc_txt = {
        name = 'Mystical Honse',
        text = {
            "{C:chips}+20{} Chips per {C:deets}Horse Card{} in {C:attention}full deck",
            "{C:mult}+5{} Mult per {C:deets}DEETS Joker{}",
            "Gives you {C:attention}$1{} at the end of the {C:attention}round{}",
            "Selling this card may result in {C:red}consequences{}"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "DEETS", "hatoving", "BlueBen8" } }
        return {
            vars = {},
        }
    end,
    rarity = 2,
    atlas = 'Honse',
    pos = { x = 0, y = 0 },
    cost = 1,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_UNCOMMON"] = true, ["BTTI_modAddition_DEETS"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.selling_card and context.card == card then
            G.GAME.horseCondemn = true
            for _, c in ipairs(G.playing_cards) do
                if SMODS.has_enhancement(c, "m_btti_horseCard") then
                    SMODS.destroy_cards(c)
                end
            end
            for _, jk in ipairs(G.jokers.cards) do
                local key = jk and jk.config and jk.config.center and jk.config.center.key
                if key then
                    if key == "j_btti_Horse" or key == "j_btti_Whorse" or key == "j_btti_Emma" or key == "j_btti_Chicken" or key == "j_btti_Haykeeper" then
                        SMODS.destroy_cards(jk)
                    end
                end
            end
            return {
                message = "I'll never forgive you.",
                colour = G.C.BTTIDEETS
            }
        end

        if context.joker_main then
            local rets = {}

            local ch = 0
            for _, c in ipairs(G.playing_cards) do
                if SMODS.has_enhancement(c, "m_btti_horseCard") then
                    ch = ch + 20
                end
            end
            if ch > 0 then
                table.insert(rets, {
                    chips = ch,
                })
            end

            for _, jk in ipairs(G.jokers.cards) do
                local key = jk and jk.config and jk.config.center and jk.config.center.key
                if key then
                    if key == "j_btti_Horse" or key == "j_btti_Whorse" or key == "j_btti_Emma" or key == "j_btti_Chicken" or key == "j_btti_Haykeeper" then
                        table.insert(rets, {
                            mult_mod = 10,
                            message = "Mystical",
                            colour = G.C.BTTIDEETS,
                            func = function()
                                jk:juice_up()
                            end
                        })
                    end
                end
            end

            return SMODS.merge_effects(rets)
        end
        if context.end_of_round and context.cardarea == G.jokers then
            return {
                dollars = 1,
                colour = G.C.BTTIDEETS
            }
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

-- Horse
SMODS.Atlas {
    key = "Horse",
    path = "bttiHorse.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Horse',
    loc_txt = {
        name = 'Horse',
        text = {
            "{C:chips}+80{} Chips per {C:deets}Horse Card{} in {C:attention}full deck",
            "{X:mult,C:white}X3{} Mult if {C:attention}played hand{} is a {C:deets}horse hand{}",
            "{C:green}1 in 5{} chance to turn random card",
            "in hand into a {C:deets}Horse Card"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "DEETS", "hatoving", "BlueBen8" } }
        return {
            vars = {},
        }
    end,
    rarity = 2,
    atlas = 'Horse',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_UNCOMMON"] = true, ["BTTI_modAddition_DEETS"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.joker_main then
            local rets = {}

            for _, c in ipairs(G.deck.cards) do
                if SMODS.has_enhancement(c,"m_btti_horseCard") then
                    table.insert(rets, {
                        chip_mod = 80,
                        message = "+80 Chips",
                        colour = G.C.BTTIDEETS,
                    })
                end
            end
            if string.find(string.lower(context.scoring_name), 'horse') ~= nil then
                table.insert(rets, {
                    Xmult_mod = 3,
                    message = "x3 Mult",
                    colour = G.C.BTTIDEETS,
                })
            end
            return SMODS.merge_effects(rets)
        end
        if context.final_scoring_step then
            if pseudorandom('Horse') < G.GAME.probabilities.normal / 5 then
                if context.scoring_hand then
                    local idx = pseudorandom("btti_" .. card.ability.name, 0, #context.scoring_hand)
                    if context.scoring_hand[idx] then
                        return {
                            message = "Horse",
                            colour = G.C.BTTIDEETS,
                            func = function()
                                if not G.GAME.horseCondemn then
                                    context.scoring_hand[idx]:set_ability("m_btti_horseCard")
                                    context.scoring_hand[idx]:juice_up()
                                    return true
                                end
                            end
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

-- Haykeeper
SMODS.Atlas {
    key = "Haykeeper",
    path = "bttiHaykeeper.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Haykeeper',
    loc_txt = {
        name = 'The Haykeeper',
        text = {
            "Adds half of {C:attention}${} to {C:mult}Mult{}",
            "Once triggered, it will start a cooldown; if this",
            "{C:attention}Joker{} is played again during",
            "this cooldown, it will instead add 1/8th of",
            "{C:attention}${} to {C:mult}Mult{} until the",
            "cooldown is over.",
            "{C:inactive}Cooldown: #2#s"
        }
    },

    config = { extra = { cooldown = 0.0, angry = false } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "DEETS", "hatoving, BlueBen8", "hatoving" } }
        return {
            vars = { card.ability.extra.cooldown, card.ability.extra.cooldownFloored },
        }
    end,
    rarity = 2,
    atlas = 'Haykeeper',
    pos = { x = 0, y = 0 },
    cost = 8,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_UNCOMMON"] = true, ["BTTI_modAddition_DEETS"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    update = function (self, card, dt)
        if card.ability.extra.cooldown > 0.0 then
            card.ability.extra.cooldownFloored = math.floor(card.ability.extra.cooldown)
            --sendInfoMessage("timer : " .. card.ability.extra.cooldown, "BTTI")
            card.ability.extra.cooldown = card.ability.extra.cooldown - (dt / G.SETTINGS.GAMESPEED)
        end
    end,

    calculate = function(self, card, context)
        if card.ability.extra.cooldown == nil then
            card.ability.extra.cooldown = 0.0
        end
        if card.ability.extra.angry == nil then
            card.ability.extra.angry = false
        end
        if context.joker_main then
            local rets = {}
            if card.ability.extra.cooldown > 0.0 then
                card.ability.extra.angry = true
                table.insert(rets, {
                    message = "Dude...",
                    colour = G.C.BTTIDEETS
                })
            elseif card.ability.extra.cooldown <= 0.0 then
                table.insert(rets, {
                    message = "Open!",
                    colour = G.C.BTTIDEETS
                })
                if card.ability.extra.angry then
                    card.ability.extra.angry = false
                end
            end
            if not card.ability.extra.angry then
                table.insert(rets, {
                    mult_mod = math.floor(G.GAME.dollars / 2),
                    message = "+" .. math.floor(G.GAME.dollars / 2) .. "",
                    colour = G.C.BTTIDEETS
                })
                table.insert(rets, {
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        blocking = false,
                        delay = 0,
                        func = function()
                            card.ability.extra.cooldown = pseudorandom("btti_" .. card.ability.name, 5, 10)
                            card_eval_status_text(card, 'extra', nil, nil, nil,
                                { message = "Closed! Don't come!!", colour = G.C.DEETS })
                            return true
                        end,
                    }))
                    }
                )
            else
                table.insert(rets, {
                    mult_mod = math.floor(G.GAME.dollars / 8),
                    message = "+" .. math.floor(G.GAME.dollars / 8) .. "",
                    colour = G.C.BTTIDEETS
                })
            end

            return SMODS.merge_effects(rets)
        end

    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

-- Chicken
SMODS.Sound({ key = "chicken", path = "bttiChicken.ogg" })
SMODS.Sound({ key = "chickenKick", path = "bttiChickenKick.ogg" })
SMODS.Atlas {
    key = "Chicken",
    path = "bttiChicken.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Chicken',
    loc_txt = {
        name = 'Chicken',
        text = {
            "Temporarily kicks a {C:attention}Joker{} out of a played hand",
            "and adds 3 times its {C:attention}sell value{} to {C:attention}score{}"
        }
    },

    config = { extra = { mult = 0, kickedJoker = '' } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "DEETS", "hatoving", "hatoving" } }
        return {
            vars = { card.ability.extra.mult },
        }
    end,
    rarity = 2,
    atlas = 'Chicken',
    pos = { x = 0, y = 0 },
    cost = 5,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_UNCOMMON"] = true, ["BTTI_modAddition_DEETS"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.before then
            if #G.jokers.cards ~= 1 then
                local idx
                repeat
                    idx = pseudorandom("btti_" .. card.ability.name, 1, #G.jokers.cards)
                until idx ~= getJokerID(card)
                if idx ~= getJokerID(card) then
                    card.ability.extra.kickedJoker = G.jokers.cards[idx].config.center.key
                    card.ability.extra.mult = G.jokers.cards[idx].sell_cost * 3
                    return SMODS.merge_effects { {
                            message = "CHICKEN!!",
                            colour = G.C.BTTIDEETS,
                            sound = 'btti_chickenKick',
                        },
                        {
                            func = function()
                                SMODS.debuff_card(G.jokers.cards[idx], true, "Chicken")
                                G.jokers.cards[idx]:juice_up()
                            end
                        }
                    }
                end
            end
        end
        if context.joker_main then
            if card.ability.extra.mult > 0 then
                return SMODS.merge_effects { {
                        message = "+" .. card.ability.extra.mult .. " Mult",
                        colour = G.C.BTTIDEETS,
                        mult_mod = card.ability.extra.mult,
                    sound = 'btti_chicken'
                    },
                    {
                        G.E_MANAGER:add_event(Event({
                            trigger = 'immediate',
                            blocking = false,
                            delay = 0,
                            func = function()
                                card.ability.extra.mult = 0
                                if card.ability.extra.kickedJoker ~= nil or card.ability.extra.kickedJoker ~= '' then
                                    for i = 1, #G.jokers.cards, 1 do
                                        if G.jokers.cards[i].config.center.key == card.ability.extra.kickedJoker then
                                            delay(0.1)
                                            SMODS.debuff_card(G.jokers.cards[i], false, "Chicken")
                                            G.jokers.cards[i]:juice_up()
                                        end
                                    end
                                    card.ability.extra.kickedJoker = ''
                                end
                                return true
                            end,
                        }))
                    }
                }
            end
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

-- Whorse
SMODS.Sound({ key = "whorseFlashbang", path = "bttiWhorseFlashbang.ogg" })
SMODS.Atlas {
    key = "Whorse",
    path = "bttiWhorse.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Whorse',
    loc_txt = {
        name = 'Whorse',
        text = {
            "{X:mult,C:white}X2{} Mult for each",
            "{C:attention}non-enhanced{} card in {C:attention}played hand",
            "{C:green}1 in 5{} chance to flashbang you"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "DEETS", "BlueBen8, ca850", "BlueBen8" } }
        return {
            vars = { card.ability.extra.xmult },
        }
    end,
    rarity = 3,
    atlas = 'Whorse',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_RARE"] = true, ["BTTI_modAddition_DEETS"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.before then
            card.ability.extra.xmult = 0
            if G.play.cards then
                for i, pc in ipairs(G.play.cards) do
                    if next(SMODS.get_enhancements(pc)) == nil then
                        card.ability.extra.xmult = card.ability.extra.xmult + 2
                        sendInfoMessage("AHHH " .. card.ability.extra.xmult .. "!!", "BTTI")
                    end
                end
            end
            if pseudorandom('Whorse') < G.GAME.probabilities.normal / 5 then                
                return {
                    message = "Whorse",
                    colour = G.C.WHITE,
                    func = function ()
                        G.BTTI.whorseFlashbangAlpha = 1.0
                        play_sound("btti_whorseFlashbang")
                        return true
                    end
                }
            end
        end
        if context.joker_main then
            if card.ability.extra.xmult > 0 then
                sendInfoMessage("AHHH " .. card.ability.extra.xmult .. "!!", "BTTI")
                return {
                    Xmult_mod = card.ability.extra.xmult,
                    message = "Whorse. X" .. card.ability.extra.xmult .. "",
                    colour = G.C.MULT
                }
            end
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

-- Emma
SMODS.Atlas {
    key = "Emma",
    path = "bttiEmma.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Emma',
    loc_txt = {
        name = 'Emma',
        text = {
            "{C:chips}+0-50{} Chips",
            "{C:mult}+0-100{} Mult",
            "{C:mult}+5{} Mult for every",
            "{C:deets}DEETS Joker{}"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "DEETS", "Juicimated", "hatoving" } }
        return {
            vars = { },
        }
    end,
    rarity = 2,
    atlas = 'Emma',
    pos = { x = 0, y = 0 },
    cost = 5,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_UNCOMMON"] = true, ["BTTI_modAddition_DEETS"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.joker_main then
            local rets = {}
            local m = pseudorandom("btti_" .. card.ability.name, 0, 100)
            local ch = pseudorandom("btti_" .. card.ability.name, 0, 50)

            table.insert(rets, {
                message = "+" .. ch .. " Chips",
                colour = G.C.PURPLE,
                chip_mod = ch
            })
            table.insert(rets, {
                message = "+" .. m .. " Mult",
                colour = G.C.PURPLE,
                mult_mod = m
            })

            for _, jk in ipairs(G.jokers.cards) do
                local key = jk and jk.config and jk.config.center and jk.config.center.key
                if key then
                    if key == "j_btti_Horse" or key == "j_btti_Whorse" or key == "j_btti_Honse" or key == "j_btti_Chicken" or key == "j_btti_Haykeeper" then
                        table.insert(rets, {
                            mult_mod = 10,
                            message = "Horse!!",
                            colour = G.C.PURPLE,
                            func = function ()
                                jk:juice_up()
                            end
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

-- DEETS ?????
SMODS.Atlas {
    key = "SecretDEETS",
    path = "bttiSecretDEETS.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'SecretDEETS',
    loc_txt = {
        name = 'RXZEbw==',
        text = {
            "{C:green}1 in 3 chance{} to {C:deets}consume{} a",
            "{C:attention}random card{} from your {C:attention}deck,",
            "gaining {C:chips}Chips{}, {C:mult}Mult{} and {X:mult,C:white}XMult{}",
            "equivalent to the card's rank",
            "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips{}, {C:mult}+#2#{} Mult, {X:mult,C:white}X#3#{} Mult)"
        }
    },

    config = { extra = { mult = 0, xmult = 1, chips = 0 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "DEETS", "Juicimated", "Juicimated" } }
        return {
            vars = { card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.xmult },
        }
    end,
    rarity = 3,
    atlas = 'SecretDEETS',
    pos = { x = 0, y = 0 },
    cost = 5,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_RARE"] = true, },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.before and context.cardarea == G.jokers then
            if pseudorandom('SecretDEETS') < G.GAME.probabilities.normal / 3 then
                local pc = G.deck.cards[pseudorandom("btti_" .. card.ability.name, 1, #G.deck.cards)]
                local ch = pc:get_chip_bonus()
                local mult = pc:get_chip_mult()
                local xMult = pc:get_chip_x_mult()

                card.ability.extra.chips = card.ability.extra.chips + ch
                card.ability.extra.mult = card.ability.extra.mult + mult
                card.ability.extra.xmult = card.ability.extra.xmult + xMult

                SMODS.destroy_cards(pc)

                return {
                    message = "Upgrade!"
                }
            else
                return {
                    message = "Nope!"
                }
            end
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult,
                xmult = card.ability.extra.xmult,
                chips = card.ability.extra.chips
            }
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}