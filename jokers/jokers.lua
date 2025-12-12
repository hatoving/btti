require("nativefs")

G.BTTI.JOKER_FUNCS = {

}

SMODS.Sound {
    key = "music_LeBron",
    path = "music_bttiLebron.ogg",
    pitch = 1,
    volume = 1.0,
    select_music_track = function(self)
        return not G.BTTI.config.streamer_mode and ((not jokerExists("j_btti_Ca850") and jokerExists("j_btti_LeBron")) and (G.GAME.blind and not G.GAME.blind.in_blind))
    end
}
SMODS.Sound {
    key = "music_LeBronCA",
    path = "music_bttiLebronCA.ogg",
    pitch = 1,
    volume = 1.0,
    select_music_track = function(self)
        return not G.BTTI.config.streamer_mode and ((jokerExists("j_btti_Ca850") and jokerExists("j_btti_LeBron")) and (G.GAME.blind and not G.GAME.blind.in_blind))
    end
}

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
            "{C:green}1 in 10{} chance to steal {C:attention}$2-7{}"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "The Internet", "BlueBen8", "BlueBen8" } }
		return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
	end,
	rarity = 1,
	atlas = 'Jonker',
	pos = { x = 0, y = 0 },
	cost = 4,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_COMMON"] = true, ["BTTI_modAddition_INTERNET"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

	calculate = function(self, card, context)
		if context.joker_main then
            if pseudorandom('Jonker') < G.GAME.probabilities.normal / card.ability.extra.odds then
                local rand = pseudorandom("btti_" .. card.ability.name, -7, -2)
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
		return true, { allow_duplicates = false }
	end
}

-- Metal Pipe
SMODS.Sound({ key = "metalPipeMult", path = "bttiMetalPipeMult.ogg" })

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
            "{X:mult,C:white}X2.75{} Mult per {C:attention}Steel Card{} in {C:attention}full deck",
            "{C:green}1 in 20{} Chance to turn {C:attention}played",
            "{C:attention}cards{} into {C:attention}Steel Cards{}",
            "{C:inactive}Soothens your ears",
            "{C:inactive}(Currently{} {X:mult,C:white}X#3#{}{C:inactive} Mult)"
        }
    },

    config = { extra = { xmult = 2.75, odds = 20, cur = 0 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Real Life", "William Murdock", "BlueBen8" } }
        return {
            vars = { card.ability.extra.xmult, card.ability.extra.odds, card.ability.extra.cur },
        }
    end,
    rarity = 2,
    atlas = 'MetalPipe',
    pos = { x = 0, y = 0 },
    cost = 5,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_UNCOMMON"] = true, ["BTTI_modAddition_INTERNET"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
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

        card.ability.extra.cur = card.ability.extra.xmult * cardAmount

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
        return true, { allow_duplicates = false }
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
			"{C:red}Lose{} 75% of {C:attention}${}",
            "OR",
            "{C:green}Win{} 110% of {C:attention}${}",
            "{C:inactive}He's all in{}"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "The Internet", "cdub_synth", "BlueBen8" } }
		return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
	end,
	rarity = 1,
	atlas = 'GamblerCat',
	pos = { x = 0, y = 0 },
	cost = 5,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_COMMON"] = true, ["BTTI_modAddition_INTERNET"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

	calculate = function(self, card, context)
		if context.final_scoring_step then
            local rand = pseudorandom("btti_" .. card.ability.name, 0, 1)
            
            local loserMoney = math.floor(G.GAME.dollars * 0.75)
            local winnerMoney = math.ceil(G.GAME.dollars * 1.1)

            if rand == 1 then
                return {
                    dollars = -loserMoney,
                    message = "Meow",
                    colour = G.C.RED
                }
            else
                return {
                    dollars = winnerMoney,
                    message = "Meow",
                    colour = G.C.YELLOW
                }
            end
        end 
	end,
    in_pool = function(self, args)
		return true, { allow_duplicates = false }
	end
}

-- Autism Creature
SMODS.Atlas {
    key = "AutismCreature",
    path = "bttiAutismCreature.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'AutismCreature',
    loc_txt = {
        name = '{C:gay}Autism{} Creature',
        text = {
            "{X:mult,C:white}X3{} Mult per card with {C:gay}Autism Seal{} in {C:attention}hand{}",
            "{C:green}1 in 10{} chance to add {C:gay}Autism Seal{} to random card",
            "in {C:attention}hand{}",
            "{C:mult}+20{} Mult per other {C:gay}Autism Jokers{}"
        }
    },

    config = { extra = { odds = 10, cardAmount = 0, multAmount = 0 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "The Internet", "acmeiku", "BlueBen8" } }
        return {
            vars = { card.ability.extra.odds, card.ability.extra.cardAmount, card.ability.extra.multAmount },
        }
    end,
    rarity = 2,
    atlas = 'AutismCreature',
    pos = { x = 0, y = 0 },
    cost = 7,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_UNCOMMON"] = true, ["BTTI_modAddition_INTERNET"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.joker_main then
            local rets = {}
            card.ability.extra.cardAmount = 0
            if context.scoring_hand then
                for _, pc in ipairs(context.scoring_hand) do
                    if pc.seal ~= nil then
                        --sendInfoMessage("context.scoring_hand " .. pc.seal .. "", "BTTI")
                        if pc.seal == "btti_autismSeal" then
                            card.ability.extra.cardAmount = (card.ability.extra.cardAmount or 0) + 1
                            --sendInfoMessage("AUTISTIC CARD AMOUNT " .. card.ability.extra.cardAmount, "BTTI")
                        end
                    else
                        --sendInfoMessage("context.scoring_hand NONE", "BTTI")
                    end
                end
            end
            if G.hand.cards then
                for _, pc in ipairs(G.hand.cards) do
                    if pc.seal ~= nil then
                        --sendInfoMessage("context.full_hand " .. pc.seal .. "", "BTTI")
                        if pc.seal == "btti_autismSeal" then
                            card.ability.extra.cardAmount = (card.ability.extra.cardAmount or 0) + 1
                            --sendInfoMessage("AUTISTIC CARD AMOUNT " .. card.ability.extra.cardAmount, "BTTI")
                        end
                    else
                        --sendInfoMessage("context.full_hand NONE", "BTTI")
                    end
                end
            end
            card.ability.extra.multAmount = 0
            for _, jk in ipairs(G.jokers.cards) do
                local key = jk and jk.config and jk.config.center and jk.config.center.key
                if key then
                    if key == "j_btti_LightShine" then
                        card.ability.extra.multAmount = (card.ability.extra.multAmount or 0) + 20
                    end
                    if key == "j_btti_BentismCreature" then
                        card.ability.extra.multAmount = (card.ability.extra.multAmount or 0) + 20
                    end
                    if key == "j_btti_BlueBen8" then
                        card.ability.extra.multAmount = (card.ability.extra.multAmount or 0) + 20
                    end
                end
            end

            if card.ability.extra.multAmount > 0 then
                table.insert(rets, {
                    message = "Yippe! +" .. card.ability.extra.multAmount .. " Mult",
                    colour = G.C.DARK_EDITION,
                    mult_mod = card.ability.extra.multAmount
                })
            end
            if card.ability.extra.cardAmount > 0 then
                table.insert(rets, {
                    message = "Yippe! X" .. card.ability.extra.cardAmount * 3 .. " Mult",
                    colour = G.C.DARK_EDITION,
                    Xmult_mod = card.ability.extra.cardAmount * 3
                })
            end
            if pseudorandom('AutismCreature') < G.GAME.probabilities.normal / card.ability.extra.odds then
                if G.play.cards then
                    table.insert(rets, {
                        G.E_MANAGER:add_event(Event({
                            trigger = 'immediate',
                            blocking = false,
                            delay = 0,
                            func = function()
                                local idx = pseudorandom("btti_" .. card.ability.name, 1, #G.play.cards)
                                sendInfoMessage("Making that shity ass card autistic 2...", "BTTI")
                                G.play.cards[idx]:juice_up()
                                G.play.cards[idx]:set_seal("btti_autismSeal", false, true)
                                card_eval_status_text(card, 'extra', nil, nil, nil,
                                    { message = "Yay!", colour = G.C.DARK_EDITION })
                                return true
                            end,
                        }))
                    })
                end
            else
                table.insert(rets, {
                    message = "Nope!",
                    colour = G.C.DARK_EDITION,
                })
            end
            return SMODS.merge_effects(rets)
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

-- Bentism Creature
SMODS.Atlas {
    key = "BentismCreature",
    path = "bttiBentismCreature.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'BentismCreature',
    loc_txt = {
        name = '{C:gay}Bentism{} Creature',
        text = {
            "{C:chips}+143{} Chips per card with {C:gay}Autism Seal{} in {C:attention}full deck{}",
            "{C:green}1 in 40{} chance to add {C:dark_edition}Polychrome{} to random card",
            "in {C:attention}hand{}",
            "{X:chips,C:white}X8{} Chips per other {C:gay}Autism Jokers{}"
        }
    },

    config = { extra = { odds = 40, cardAmount = 0, multAmount = 0 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "BlueHQ", "lavendarbunny_creations, BlueBen8", "BlueBen8" } }
        return {
            vars = { card.ability.extra.odds, card.ability.extra.cardAmount, card.ability.extra.multAmount },
        }
    end,
    rarity = 2,
    atlas = 'BentismCreature',
    pos = { x = 0, y = 0 },
    cost = 8,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_UNCOMMON"] = true, ["BTTI_modAddition_INTERNET"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.joker_main then
            local rets = {}
            card.ability.extra.cardAmount = 0
            if G.playing_cards then
                for _, pc in ipairs(G.playing_cards) do
                    if pc.seal ~= nil then
                        --sendInfoMessage("context.scoring_hand " .. pc.seal .. "", "BTTI")
                        if pc.seal == "btti_autismSeal" then
                            card.ability.extra.cardAmount = (card.ability.extra.cardAmount or 0) + 1
                            --sendInfoMessage("AUTISTIC CARD AMOUNT " .. card.ability.extra.cardAmount, "BTTI")
                        end
                    else
                        --sendInfoMessage("context.scoring_hand NONE", "BTTI")
                    end
                end
            end
            card.ability.extra.multAmount = 0
            for _, jk in ipairs(G.jokers.cards) do
                local key = jk and jk.config and jk.config.center and jk.config.center.key
                if key then
                    if key == "j_btti_LightShine" then
                        card.ability.extra.multAmount = (card.ability.extra.multAmount or 0) + 1
                    end
                    if key == "j_btti_AutismCreature" then
                        card.ability.extra.multAmount = (card.ability.extra.multAmount or 0) + 1
                    end
                    if key == "j_btti_BlueBen8" then
                        card.ability.extra.multAmount = (card.ability.extra.multAmount or 0) + 1
                    end
                end
            end
            
            if card.ability.extra.cardAmount > 0 then
                table.insert(rets, {
                    message = "Yippe! +" .. card.ability.extra.cardAmount * 143 .. " Chips",
                    colour = G.C.DARK_EDITION,
                    chip_mod = card.ability.extra.cardAmount * 143
                })
            end
            if card.ability.extra.multAmount > 0 then
                table.insert(rets, {
                    message = "Yippe! X" .. card.ability.extra.multAmount * 8 .. " Chips",
                    colour = G.C.DARK_EDITION,
                    Xchip_mod = (card.ability.extra.multAmount * 8),
                })
            end
            if pseudorandom('BentismCreature') < G.GAME.probabilities.normal / card.ability.extra.odds then
                if G.play.cards then
                    table.insert(rets, {
                        G.E_MANAGER:add_event(Event({
                            trigger = 'immediate',
                            blocking = false,
                            delay = 0,
                            func = function()
                                card_eval_status_text(card, 'extra', nil, nil, nil, {
                                    message = "Yay!",
                                    colour = G.C.DARK_EDITION,
                                })
                                local idx = pseudorandom("btti_" .. card.ability.name, 1, #G.play.cards)
                                sendInfoMessage("Making that shitty ass card polychrome...", "BTTI")
                                G.play.cards[idx]:juice_up()
                                G.play.cards[idx]:set_edition('e_polychrome', false, true)
                                play_sound('polychrome1', 1.2, 0.7)
                                return true
                            end
                        }))
                    })
                end
            else
                table.insert(rets, {
                    message = "Nope!",
                    colour = G.C.DARK_EDITION,
                })
            end
            return SMODS.merge_effects(rets)
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

-- Jokelinear
SMODS.Atlas {
    key = "jokelinear",
    path = "bttiJokelinear.png", -- placeholder
    px = 71,
    py = 95

}
SMODS.Joker {
    key = 'jokelinear',
    loc_txt = {
        name = 'Jokelinear',
        text = {
            "All cards act as {C:attention}Aces{}"
        }
    },

    config = { extra= {}},
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "charlinear's Beautiful Mind", "charlinear", "BlueBen8" } }
        return {
            vars = {}
        }
    end,
    rarity = 3,
    atlas = 'jokelinear',
    pos = {x = 0, y = 0},
    cost = 6,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_RARE"] = true },

    unlocked = true,
    discovered = false, 
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,

    calculate = function(self, card, context)
    end,

    add_to_deck = function(self, card, from_debuff)
        --Combines ranks
    end,

    remove_from_deck = function(self, card, from_debuff)
        -- Decombines ranks
    end
} 
      
local card_get_id_ref = Card.get_id
function Card:get_id()
    local original_id = card_get_id_ref(self)
    if not original_id then return original_id end

    if next(SMODS.find_card("j_btti_jokelinear")) then
        return 14
    end
    return original_id
end

-- LeBron James
SMODS.Atlas {
    key = "LeBron",
    path = "bttiLeBron.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'LeBron',
    loc_txt = {
        name = 'LeBron James',
        text = {
            "When {C:attention}Blind{} is selected, {C:red}self-destruct{}",
            "and create a random {C:balinsanity}Balinsanity Joker{}",
            "{C:inactive}(Must have room){}"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "The Lakers", "LeBron James", "hatoving" } }
        return {
            vars = {},
        }
    end,
    rarity = 1,
    atlas = 'LeBron',
    pos = { x = 0, y = 0 },
    cost = 5,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_COMMON"] = true, ["BTTI_modAddition_INTERNET"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.setting_blind then
            local chosen = nil
            if pseudorandom('LeBron') < G.GAME.probabilities.normal / 2 then
                chosen = 'BTTI_modAddition_COMMON'
            end
            if pseudorandom('LeBron') < G.GAME.probabilities.normal / 6 then
                chosen = 'BTTI_modAddition_UNCOMMON'
            end
            if pseudorandom('LeBron') < G.GAME.probabilities.normal / 10 then
                chosen = 'BTTI_modAddition_RARE'
            end
            if pseudorandom('LeBron') < G.GAME.probabilities.normal / 100 then
                chosen = 'BTTI_modAddition_LEGENDARY'
            end
            if chosen == nil then
                chosen = 'BTTI_modAddition_COMMON'
            end

            sendInfoMessage("Chosen rarity=" .. chosen, "BTTI")

            local c = SMODS.add_card {
                set = 'BTTI_modAddition',
            }
            SMODS.destroy_cards(card)
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

-- Kendrick Lamar
SMODS.Sound({ key = "Kendrick0", path = "bttiKendrick0.ogg" })
SMODS.Sound({ key = "Kendrick1", path = "bttiKendrick1.ogg" })
SMODS.Atlas {
    key = "Kendrick",
    path = "bttiKendrick.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Kendrick',
    loc_txt = {
        name = 'Kendrick Lamar',
        text = {
            "When {C:attention}Blind{} is selected, create a",
            "random {C:blue}Common{} or {C:red}Rare",
            "{C:balinsanity}Balinsanity Joker{}",
            "{C:inactive}(Must have room)"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Real Life", "Kendrick Lamar", "hatoving" } }
        return {
            vars = {},
        }
    end,
    rarity = 2,
    atlas = 'Kendrick',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_UNCOMMON"] = true, ["BTTI_modAddition_INTERNET"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.setting_blind and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
            local chosen = 'BTTI_modAddition_COMMON'
            if pseudorandom('Kendrick') < G.GAME.probabilities.normal / 2 then
                chosen = 'BTTI_modAddition_COMMON'
            end
            if pseudorandom('Kendrick') < G.GAME.probabilities.normal / 4 then
                chosen = 'BTTI_modAddition_RARE'
            end

            sendInfoMessage("Chosen rarity=" .. chosen, "BTTI")

            if pseudorandom("btti_" .. card.ability.name, 0, 1) == 1 then   
                return {
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        blocking = false,
                        delay = 0,
                        func = function()
                            SMODS.add_card {
                                set = chosen,
								area = G.jokers,
                            }
                            play_sound("btti_Kendrick0")
                            card_eval_status_text(card, 'extra', nil, nil, nil,
                                { message = "It's not enough", colour = G.C.WHITE })
                            return true
                        end
                    }))
                }
            else
                return {
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        blocking = false,
                        delay = 0,
                        func = function()
                            SMODS.add_card {
                                set = chosen,
								area = G.jokers,
                            }
                            play_sound("btti_Kendrick1")
                            card_eval_status_text(card, 'extra', nil, nil, nil,
                                { message = "MUSTAAAAARRDDD!!", colour = G.C.YELLOW })
                            return true
                        end
                    }))
                }
            end
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}


-- Mimic
SMODS.Atlas {
    key = "Mimic",
    path = "bttiMimic.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Mimic',
    loc_txt = {
        name = 'Mimic Joker',
        text = {
            "Debuffs any {C:attention}Flushes{}, {C:attention}Pairs{},",
            "{C:attention}Two Pairs{} and {C:deets}Two Horses{}",
            "{C:green}1 in 40{} chance to {C:red}self-destruct{}",
            "at the end of {C:attention}round{}",
            "Cannot be sold or destroyed otherwise"
        }
    },

    config = { extra = { cards = {} } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "The Evil of Humanity", "Gary Gygax", "BlueBen8" } }
        return {
            vars = {},
        }
    end,
    rarity = 1,
    atlas = 'Mimic',
    pos = { x = 0, y = 0 },
    cost = 2,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_COMMON"] = true, },

    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,

    update = function (self, card, dt)
       card.ability.eternal = true 
    end,

    calculate = function(self, card, context)
        if context.initial_scoring_step then
            if pseudorandom('Mimic') < G.GAME.probabilities.normal / 40 then
                sendInfoMessage("Destroying", "BTTI")
                SMODS.destroy_cards(card, true)
            end
            if context.scoring_name == "Flush" or context.scoring_name == "Straight Flush" or
                context.scoring_name == "Pair" or context.scoring_name == 'Two Pair' or
                    context.scoring_name == "TwoHorse" then
                return {
                    message = "Nuh-uh!",
                    colour = G.C.GREEN,
                    func = function ()
                        for i, c in ipairs(context.scoring_hand) do
                            table.insert(card.ability.extra.cards, c)
                            SMODS.debuff_card(c, true, 'Mimic')
                            c:juice_up()
                        end
                    end
                }
            end
        end

        if context.final_scoring_step then
            if #card.ability.extra.cards > 0 then
                for i, c in ipairs(card.ability.extra.cards) do
                    SMODS.debuff_card(c, false, 'Mimic')
                    c:juice_up()
                end
                card.ability.extra.cards = {}
            end
        end
    end,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end
}

-- The Rock
SMODS.Atlas {
    key = "Rock",
    path = "bttiRock.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Rock',
    loc_txt = {
        name = 'Dwayne "The Rock" Johnson',
        text = {
           "{X:mult,C:white}X4{} Mult per {C:attention}Stone Card{} in hand",
           "He will briefly {C:attention}appear{} when this card is",
           "triggered"
        }
    },

    config = { extra = { xmult = 4.0, cur = 0 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Real Life", "Dwayne Johnson", "BlueBen8" } }
        return {
            vars = { },
        }
    end,
    rarity = 2,
    atlas = 'Rock',
    pos = { x = 0, y = 0 },
    cost = 5,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_UNCOMMON"] = true, ["BTTI_modAddition_INTERNET"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.joker_main then
            local cardAmount = 0

            for _, pc in ipairs(G.hand.cards) do
                if pc.config.center.key == "m_stone" then
                    cardAmount = cardAmount + 1
                end
            end
            for _, pc in ipairs(G.play.cards) do
                if pc.config.center.key == "m_stone" then
                    cardAmount = cardAmount + 1
                end
            end
            
            card.ability.extra.cur = card.ability.extra.xmult * cardAmount
            sendInfoMessage("Found " .. cardAmount .. " cards = x" .. card.ability.extra.xmult * cardAmount .. " Mult", "BTTI")
            if card.ability.extra.xmult * cardAmount > 0 then
                G.BTTI.dwayneTheRockAlpha = 1.0
                local rets = {
                    {
                        message = "It's about drive,",
                        colour = G.C.GREY
                    },
                    {
                        Xmult_mod = card.ability.extra.xmult * cardAmount,
                        message = "it's about POWER!",
                        colour = G.C.GREY
                    }
                }
                return SMODS.merge_effects(rets)
            end
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

-- hatoving country
SMODS.Atlas {
    key = "hatovingCountry",
    path = "bttiHatovingCountry.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'hatovingCountry',
    loc_txt = {
        name = 'hatoving country',
        text = {
            "{C:green}1 in 40{} chance to {C:red}disable{} upcoming",
            "{C:attention}Boss Blind{}"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "hatoving", "hatoving", "BlueBen8" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 1,
    atlas = 'hatovingCountry',
    pos = { x = 0, y = 0 },
    cost = 4,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_COMMON"] = true, },

    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.setting_blind then
            if G.GAME.blind and not G.GAME.blind.disabled and G.GAME.blind.boss then
                if pseudorandom('hatovingCountry') < G.GAME.probabilities.normal / 40 then
                    return {
                        message = "hatoving country",
                        colour = G.C.BTTIPINK,
                        G.E_MANAGER:add_event(Event({
                            trigger = 'immediate',
                            blocking = false,
                            delay = 0,
                            func = function()
                                G.GAME.blind:disable()
                                return true
                            end,
                        }))
                    }
                else
                    return {
                        message = "Nope...",
                        colour = G.C.BTTIPINK
                    }
                end
            end
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

-- Pancakes
SMODS.Sound({ key = "pancakes", path = "bttiPancakes.ogg" })
SMODS.Atlas {
    key="pancakes",
    path="bttiPancakes.png", --placeholder
    px = 71,
    py = 95

}
SMODS.Joker {
    key = 'pancakes',
    loc_txt = {
        name= 'Pancakes',
        text = {
            "{X:chips,C:white}X10{} Chips",
            "{X:chips,C:white}-X1{} Chips per hand played",
            "Gets {C:red}blown up with mind{} when",
            "at {X:chips,C:white}X1{} Chips",
            "{C:inactive}Good with syrup{}",
            "{C:inactive}(Currently{} {X:chips,C:white}X#1#{} {C:inactive}Chips){}"
        }
    },

    config = {extra = { mult = 10 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Real Life", "Humanity", "BlueBen8" } }
        return {
            vars = {card.ability.extra.mult},
        }
    end,
    rarity = 1,
    atlas = 'pancakes',
    pos = { x = 0, y = 0},
    cost = 6,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_COMMON"] = true, },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
         if context.joker_main then
            return {
                message = "X" .. card.ability.extra.mult .. " Chips",
                colour = G.C.CHIPS,
                Xchip_mod = card.ability.extra.mult
            }
        end
        if context.final_scoring_step then
            card.ability.extra.mult = card.ability.extra.mult - 1
            if card.ability.extra.mult <= 1 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card:juice_up()
                        play_sound('btti_pancakes')
                        return true
                    end,
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 1.3 * G.SETTINGS.GAMESPEED,
                    func = function()
                        play_sound('btti_explosion')
                        bttiEffectManagerPlay('explosion', card.tilt_var.mx, card.tilt_var.my)
                        SMODS.destroy_cards(card, true, true)
                        return true
                    end,
                }))
            else
                return {
                    message = "-X1 Chips",
                    colour = G.C.CHIPS,
                }
            end
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

-- BananaFarm
SMODS.Atlas {
    key = "BananaFarm",
    path = "bttiBananaFarm.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'BananaFarm',
    loc_txt = {
        name = 'Banana Farm',
        text = {
            "{C:green}1 in 8{} chance to spawn {C:attention}Gros Michel",
            "{C:green}1 in 20{} chance to spawn {C:attention}Cavendish",
            "{C:green}1 in 10{} chance to {C:red}self destruct{}",
            "at end of {C:attention}round{}",
            "{C:inactive}Won't spawn{} {C:attention}Jokers{} {C:inactive}that are already in hand{}"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Bloons TD", "aikoyori", "hatoving" } }
        return {
            vars = { },
        }
    end,
    rarity = 2,
    atlas = 'BananaFarm',
    pos = { x = 0, y = 0 },
    cost = 5,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_UNCOMMON"] = true, ["BTTI_modAddition_INTERNET"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.end_of_round and context.cardarea == G.jokers then
            sendInfoMessage("checkiing for banaba", "BTTI")
            if pseudorandom('Banana') < G.GAME.probabilities.normal / 8 then
                if not jokerExists('j_gros_michel') then
                    SMODS.add_card { key = 'j_gros_michel' }
                    return {
                        message = "banabna",
                        colour = G.C.YELLOW
                    }
                end
            elseif pseudorandom('Banana') < G.GAME.probabilities.normal / 20 then
                if not jokerExists('j_cavendish') then
                    SMODS.add_card { key = 'j_cavendish' }
                    return {
                        message = "banaba",
                        colour = G.C.YELLOW
                    }
                end
            elseif pseudorandom('Banana') < G.GAME.probabilities.normal / 10 then
                return {
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        blocking = false,
                        delay = 0,
                        func = function()
                            card_eval_status_text(card, 'extra', nil, nil, nil,
                                { message = "bye-bye", colour = G.C.YELLOW })
                            SMODS.destroy_cards(card)
                            return true
                        end,
                    }))
                }
            end
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

-- PFP Bird
SMODS.Atlas {
    key = "PFPBird",
    path = "bttiPFPBird.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'PFPBird',
    loc_txt = {
        name = 'PFP Bird',
        text = {
            "Reduces shop prices by {C:attenion}5%{}",
            "for each {C:attention}Blind{} skipped",
            "{C:inactive}(Currently {C:attention}#1#%{})",
            "{C:inactive}Fly high, little budgie"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Real Life", "BlueOps", "BlueBen8" } }
        return {
            vars = { G.GAME.btti_pfpBirdBudgie or 0 },
        }
    end,
    rarity = 2,
    atlas = 'PFPBird',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_UNCOMMON"] = true, },

    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.skip_blind then
            if G.GAME.btti_pfpBirdBudgie == nil then
                G.GAME.btti_pfpBirdBudgie = 0
            end
            G.GAME.btti_pfpBirdBudgie = G.GAME.btti_pfpBirdBudgie + 5
            G.GAME.btti_pfpBirdBudgie = math.clamp(G.GAME.btti_pfpBirdBudgie, 0, 50)
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.GAME.discount_percent = G.GAME.discount_percent + 5
                    for _, v in pairs(G.I.CARD) do
                        if v.set_cost then v:set_cost() end
                    end
                    card_eval_status_text(card, 'extra', nil, nil, nil,
                        { message = "*tweet*", colour = G.C.YELLOW })
                    return true
                end
            }))
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

-- Say That Again
SMODS.Atlas {
    key = "SayThatAgain",
    path = "bttiSayThatAgain.png",
    px = 71,
    py = 95,
}
SMODS.Joker {
    key = 'SayThatAgain',
    loc_txt = {
        name = '...Say that again?',
        text = {
            "Retriggers played hand {C:blue}4{} times",
            "if played hand has exactly {C:blue}4{} cards"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Fant4stic", "Miles Teller", "Juicimated" } }
        return {
            vars = { },
        }
    end,
    rarity = 2,
    atlas = 'SayThatAgain',
    pos = { x = 0, y = 0 },
    cost = 4,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_UNCOMMON"] = true, ["BTTI_modAddition_INTERNET"] = true },

    pixel_size = { w = 71 , h = 95 },
    frame = 0,
    maxFrame = 32,
    frameDur = 0.085,
    ticks = 0,

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            if #G.play.cards == 4 then
                return {
                    repetitions = 4
                }
            end
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

-- Steam
SMODS.Atlas {
    key = "Steam",
    path = "bttiSteam.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Steam',
    loc_txt = {
        name = 'Steam',
        text = {
            "{X:mult,C:white}X0.1{} Mult for every {C:attention}game{}",
            "you have installed on {C:blue}Steam{}, otherwise",
            "{X:mult,C:white}X0.1{} Mult for every {C:attention}game{}",
            "in the {C:default}Valve Complete Pack{} on {C:blue}Steam{}",
            "{C:inactive}Checks every 2 minutes",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)"
        }
    },

    config = { extra = { xmult = 1 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Valve", "Gabe Newell", "hatoving" } }
        if G.BTTI.foundSteamApps and G.BTTI.installedSteamApps ~= nil then
            card.ability.extra.xmult = 1.0 + (G.BTTI.installedSteamApps / 10)
        else
            card.ability.extra.xmult = 3.0
        end
        return {
            vars = { card.ability.extra.xmult },
        }
    end,
    rarity = 'btti_dynamic',
    atlas = 'Steam',
    pos = { x = 0, y = 0 },
    cost = 10,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_RARE"] = true, ["BTTI_modAddition_INTERNET"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.joker_main then
            if G.BTTI.foundSteamApps and G.BTTI.installedSteamApps ~= nil then
                card.ability.extra.xmult = 1.0 + (G.BTTI.installedSteamApps / 10)
            else
                card.ability.extra.xmult = 3.0
            end
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

-- Subscribe

function G.FUNCS.joker_can_subscribe(e)
    e.config.colour = G.C.RED
    e.config.button = "joker_subscribe"
end
function G.FUNCS.joker_subscribe(e)
    local card = e.config.ref_table
    love.system.openURL("https://www.youtube.com/@Bennoh01")
    love.system.openURL("https://www.youtube.com/hatoving")
    love.system.openURL("https://www.youtube.com/juicimated")

    card.children.center.atlas = G.ASSET_ATLAS['btti_Subscribed']
    card.children.center:set_sprite_pos({ x = 0, y = 0 })
    card.ability.extra.clicks = {}
    card:juice_up()
end

SMODS.Atlas {
    key = "Subscribe",
    path = "bttiSubscribe1.png",
    px = 71,
    py = 95
}
SMODS.Atlas {
    key = "Subscribed",
    path = "bttiSubscribe2.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'Subscribe',
	loc_txt = {
		name = 'Subscribe Button',
		text = {
			"{C:chips}+5{} Chips for every 50 subscribers {C:chips}BlueBen8{} has",
            "{C:mult}+1{} Mult for every 50 subscribers {C:mult}hatoving{} has",
            "{C:attention}$2{} for every 50 subscribers {C:attention}Juicimated{} has",
            "Press the button to {C:red}subscribe{}",
            "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips, {C:mult}+#2#{C:inactive} Mult, {C:attention}$#3#{C:inactive})"
		}
	},

	config = { extra = { chips = 0, mult = 0, dollars = 0, activate = false, clicks = {} } },
	loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "The Internet", "YouTube", "BlueBen8" } }

		return {
            vars = { card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.dollars },
        }
	end,
	rarity = 'btti_dynamic',
	atlas = 'Subscribe',
	pos = { x = 0, y = 0 },
	cost = 6,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_COMMON"] = true, ["BTTI_modAddition_INTERNET"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    update = function (self, card, dt)
        card.ability.extra.chips = math.floor(G.BTTI.HTTPS.YOUTUBE_DATA.BLUEBEN8_SUBS / 50) * 5
        card.ability.extra.mult = math.floor(G.BTTI.HTTPS.YOUTUBE_DATA.HATOVING_SUBS / 50)
        card.ability.extra.dollars = math.floor(G.BTTI.HTTPS.YOUTUBE_DATA.JUICIMATED_SUBS / 50) * 2
    end,

	calculate = function(self, card, context)
		if context.joker_main then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult,
                dollars = card.ability.extra.dollars
            }
		end
	end,
    in_pool = function(self, args)
		return true, { allow_duplicates = false }
	end
}

-- Number Go Up
SMODS.Atlas {
    key = "NumberGoUp",
    path = "bttiNumberGoUp.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'NumberGoUp',
    loc_txt = {
        name = 'Number Go Up',
        text = {
            "{C:chips}+5{} Chips, {X:chips,C:white}X0.1{} Chips, {C:mult}+1{} Mult",
            "{X:mult,C:white}X0.1{} Mult, and {C:attention}+$1{} for every",
            "{X:red,C:white}50K{} views on {X:black,C:attention}The Stupendium{}'s",
            "Balatro song, {C:dark_edition}\"Number Go Up\"",
            "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips, {X:chips,C:white}X#2#{C:inactive} Chips,",
            "{C:mult}+#3#{C:inactive} Mult, {X:mult,C:white}X#4#{C:inactive} Mult, {C:attention}+$#5#{C:inactive})"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "The Internet", "The Stupendium", "BlueBen8" } }

        local times = math.floor(G.BTTI.HTTPS.YOUTUBE_DATA.NUMBER_GO_UP / 50000)
        local chips = times * 5
        local Xchips = times * 0.1
        local mult = times
        local Xmult = times * 0.1
        local dollars = times

        return {
            vars = { chips, Xchips, mult, Xmult, dollars },
        }
    end,
    rarity = 'btti_dynamic',
    atlas = 'NumberGoUp',
    pos = { x = 0, y = 0 },
    cost = 7,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_DYNAMIC"] = true, ["BTTI_modAddition_INTERNET"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.joker_main then
            local times = math.floor(G.BTTI.HTTPS.YOUTUBE_DATA.NUMBER_GO_UP / 50000)
            local c = times * 5
            local Xc = times * 0.1
            local m = times
            local Xm = times * 0.1
            local d = times

            return {
                chips = c,
                xchips = Xc,
                mult = m,
                xmult = Xm,
                dollars = d
            }
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

-- Woker
SMODS.Atlas {
    key = "Woker",
    path = "bttiWoker.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'Woker',
	loc_txt = {
		name = 'Woker',
		text = {
			"When {C:attention}Boss Blind{} is selected,",
            "apply {C:dark_edition}Polychrome{} to all cards",
            "in {C:attention}full hand{}"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "The Internet", "Reddit, probably", "BlueBen8" } }
		return {
            vars = { },
        }
	end,
	rarity = 3,
	atlas = 'Woker',
	pos = { x = 0, y = 0 },
	cost = 10,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_RARE"] = true, ["BTTI_modAddition_INTERNET"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

	calculate = function(self, card, context)
		if context.setting_blind and G.GAME.blind.boss then
            if G.hand.cards then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    blocking = false,
                    delay = 1.3 * G.SETTINGS.GAMESPEED,
                    func = function ()
                        card_eval_status_text(card, 'extra', nil, nil, nil,
                            { message = "Queerious!", colour = G.C.DARK_EDITION })
                        for i = 1, #G.hand.cards do
                            G.hand.cards[i]:set_edition('e_polychrome')
                            G.hand.cards[i]:juice_up()
                        end
                        return true
                    end
                }))
            end
        end
	end,
    in_pool = function(self, args)
		return true, { allow_duplicates = false }
	end
}

-- Milk
SMODS.Atlas {
    key = "Milk1",
    path = "bttiMilk1.png",
    px = 71,
    py = 95
}
SMODS.Atlas {
    key = "Milk2",
    path = "bttiMilk2.png",
    px = 71,
    py = 95
}
SMODS.Atlas {
    key = "Milk3",
    path = "bttiMilk3.png",
    px = 71,
    py = 95
}
SMODS.Atlas {
    key = "Milk4",
    path = "bttiMilk4.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'Milk',
	loc_txt = {
		name = 'Milk',
		text = {
			"{C:chips}+20{} Chips every hand",
            "{C:mult}Expires{} when {C:chips}Chips{} is greater",
            "than or equal to the {C:attention}current date{}",
            "{C:inactive}(#3# -> #2#){}",
            "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Real Life", "Cows", "Juicimated" } }

        local month = tonumber(os.date("%m"))
        local day = tonumber(os.date("%d"))
        local month_name = os.date("%B")

        local date = tonumber(string.format("%02d%02d", month, day))

        return {
            vars = { card.ability.extra.chips or 0, date, string.format("%s %d", month_name, day) }
        }
    end,
	rarity = 'btti_dynamic',
	atlas = 'Milk1',
	pos = { x = 0, y = 0 },
	cost = 7,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_DYNAMIC"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    update = function (self, card, dt)
        local month = tonumber(os.date("%m"))
        local day = tonumber(os.date("%d"))
        local date = tonumber(string.format("%02d%02d", month, day))
        local percent = 100 - (((card.ability.extra.chips or 0) / date) * 100)
        if percent > 75 then
            card.children.center.atlas = G.ASSET_ATLAS['btti_Milk1']
            card.children.center:set_sprite_pos({ x = 0, y = 0 })
        elseif percent > 50 then
            card.children.center.atlas = G.ASSET_ATLAS['btti_Milk2']
            card.children.center:set_sprite_pos({ x = 0, y = 0 })
        elseif percent > 25 then
            card.children.center.atlas = G.ASSET_ATLAS['btti_Milk3']
            card.children.center:set_sprite_pos({ x = 0, y = 0 })
        else
            card.children.center.atlas = G.ASSET_ATLAS['btti_Milk4']
            card.children.center:set_sprite_pos({ x = 0, y = 0 })
        end
    end,

	calculate = function(self, card, context)
        if context.joker_main then
            card.ability.extra.chips = (card.ability.extra.chips or 0) + 20
            return {
                message = "Mmm!",
                colour = G.C.CHIPS,
                chips = card.ability.extra.chips
            }
        end

        if (context.final_scoring_step == true and context.cardarea == G.jokers) then
            local date = tonumber(os.date("%m%d"))
            local chips = card.ability.extra.chips or 0
            if chips >= date then
                return {
                    message = "Expired!",
                    colour = G.C.MULT,
                    G.E_MANAGER:add_event(Event({
                        func = function ()
                            card:start_dissolve()
                            return true
                        end
                    }))
                }
            end
        end
	end,
    in_pool = function(self, args)
		return true, { allow_duplicates = false }
	end
}

-- KFC Bucket
function G.FUNCS.joker_can_eat_kfc(e)
    local card = e.config.ref_table
    if not card.ability.extra.activated and not card.ability.extra.eaten then
        e.config.colour = G.C.RED
        e.config.button = "joker_eat_kfc"
    else
      e.config.colour = G.C.UI.BACKGROUND_INACTIVE
      e.config.button = nil
    end
end
function G.FUNCS.joker_eat_kfc(e)
    local card = e.config.ref_table
    if not card.ability.extra.activated then
        card_eval_status_text(card, 'extra', nil, nil, nil,
            { message = "Yum!", colour = G.C.RED })
        card.ability.extra.activated = true
        card.ability.extra.time = 0
        card.ability.extra.clicks = {}
    end
end
SMODS.Atlas {
    key = "KFCBucket",
    path = "bttiKFCBucket.png",
    px = 71,
    py = 95
}
SMODS.Atlas {
    key = "KFCBucketEmpty",
    path = "bttiKFCBucketEmpty.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'KFCBucket',
	loc_txt = {
		name = 'KFC Bucket',
		text = {
			"Press the button to",
            "consume the bucket",
            "Gives {X:mult,C:white}X11{} Mult that drains",
            "by {X:mult,C:white}X0.1{} Mult every second",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)"
		}
	},

	config = { extra = { xmult = 1.0, timer = 1.0, activate = false, eaten = false } },
	loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Kentucky Fried Chicken", "Colonel Sanders", "hatoving" } }
		return {
            vars = { card.ability.extra.xmult },
        }
	end,
	rarity = 1,
	atlas = 'KFCBucket',
	pos = { x = 0, y = 0 },
	cost = 4,
    pools = { ["BTTI_modAddition"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    update = function(self, card, dt)
        if card.ability.extra.activated then
            card.ability.extra.timer = (card.ability.extra.timer or 0) + dt
            local xmult = math.max(1, 11 - (card.ability.extra.timer * 0.1))
            card.ability.extra.xmult = xmult
            if card.ability.extra.xmult <= 1 then
                card.ability.extra.activated = false
                card.ability.extra.eaten = true
                card.ability.extra.timer = 0
                card.children.center.atlas = G.ASSET_ATLAS['btti_KFCBucketEmpty']
                card.children.center:set_sprite_pos({ x = 0, y = 0 })
                card:juice_up()
            end
        else
            card.ability.extra.xmult = 1.0
        end
    end,

	calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.activated then
            return {
                colour = G.C.MULT,
                xmult = card.ability.extra.xmult
            }
        end
    end,
    in_pool = function(self, args)
		return true, { allow_duplicates = false }
	end
}

-- Volume
SMODS.Atlas {
    key = "Volume1", path = "bttiVolume1.png", px = 71, py = 95
}
SMODS.Atlas {
    key = "Volume2", path = "bttiVolume2.png", px = 71, py = 95
}
SMODS.Atlas {
    key = "Volume3", path = "bttiVolume3.png", px = 71, py = 95
}
SMODS.Atlas {
    key = "Volume4", path = "bttiVolume4.png", px = 71, py = 95
}
SMODS.Atlas {
    key = "Volume5", path = "bttiVolume5.png", px = 71, py = 95
}
SMODS.Atlas {
    key = "Volume6", path = "bttiVolume6.png", px = 71, py = 95
}
SMODS.Atlas {
    key = "Volume7", path = "bttiVolume7.png", px = 71, py = 95
}
SMODS.Joker {
	key = 'Volume',
	loc_txt = {
		name = 'Volume',
		text = {
			"Records your {C:attention}voice{} and gives",
            "{C:mult}Mult{} based on how loud",
            "you {C:mult}screamed{} on {c:attention}next hand{}",
            "{C:inactive}Switch device in config{}",
            "{C:inactive}(Currently {C:attention}#1#{} -> {C:mult}+#2#{} Mult)"
		}
	},

	config = { extra = { mic_result = nil, peak = 0.0 } },
	loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Real Life", "Sound", "hatoving" } }
		return {
            vars = { card.ability.extra.peak, math.floor(card.ability.extra.peak * 100) },
        }
	end,
	rarity = 'btti_dynamic',
	atlas = 'Volume1',
	pos = { x = 0, y = 0 },
	cost = 7,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_COMMON"] = true, ["BTTI_modAddition_INTERNET"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    update = function (self, card, dt)
        if G.BTTI.MICROPHONE:isRecording() and G.BTTI.MICROPHONE:getSampleCount() > 0 then
            local sd = G.BTTI.MICROPHONE:getData()

            local channels = sd:getChannels()
            local count = sd:getSampleCount()
            for i = 0, count-1 do
                local v = sd:getSample(i)
                local a = math.abs(v)

                local aa = math.floor(a * 100)

                if aa <= 0 then
                    card.children.center.atlas = G.ASSET_ATLAS['btti_Volume1']
                elseif aa <= 25 then
                    card.children.center.atlas = G.ASSET_ATLAS['btti_Volume2']
                elseif aa <= 50 then
                    card.children.center.atlas = G.ASSET_ATLAS['btti_Volume3']
                elseif aa <= 60 then
                    card.children.center.atlas = G.ASSET_ATLAS['btti_Volume4']
                elseif aa <= 75 then
                    card.children.center.atlas = G.ASSET_ATLAS['btti_Volume5']
                elseif aa <= 99 then
                    card.children.center.atlas = G.ASSET_ATLAS['btti_Volume6']
                else
                    card.children.center.atlas = G.ASSET_ATLAS['btti_Volume7']
                end

                card.children.center:set_sprite_pos({ x = 0, y = 0 })

                if a > card.ability.extra.peak then
                    card.ability.extra.peak = math.clamp(a, 0, math.huge)
                end
            end
        end
    end,

	calculate = function(self, card, context)
        if context.before and context.cardarea == G.jokers then
            return {
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    blocking = false,
                    delay = 0,
                    func = function()
                        card.ability.extra.peak = 0
                        card.ability.extra.mic_result = G.BTTI.MICROPHONE:start(4096, 44100, 16, 1)
                        return true
                    end,
                }))
            }
        end
		if context.pre_joker and context.cardarea == G.jokers then
            return {
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    blocking = false,
                    delay = 0,
                    func = function()
                        G.BTTI.MICROPHONE:stop()
                        local aa = math.floor(card.ability.extra.peak * 100)

                        if aa <= 0 then
                            card.children.center.atlas = G.ASSET_ATLAS['btti_Volume1']
                        elseif aa <= 25 then
                            card.children.center.atlas = G.ASSET_ATLAS['btti_Volume2']
                        elseif aa <= 50 then
                            card.children.center.atlas = G.ASSET_ATLAS['btti_Volume3']
                        elseif aa <= 60 then
                            card.children.center.atlas = G.ASSET_ATLAS['btti_Volume4']
                        elseif aa <= 75 then
                            card.children.center.atlas = G.ASSET_ATLAS['btti_Volume5']
                        elseif aa <= 99 then
                            card.children.center.atlas = G.ASSET_ATLAS['btti_Volume6']
                        else
                            card.children.center.atlas = G.ASSET_ATLAS['btti_Volume7']
                        end

                        card.children.center:set_sprite_pos({ x = 0, y = 0 })
                        return true
                    end,
                }))
            }
		end

        if context.joker_main then
            return {
                mult = math.floor(card.ability.extra.peak * 100)
            }
        end
	end,
    in_pool = function(self, args)
		return true, { allow_duplicates = false }
	end
}

SMODS.Atlas {
    key = "NyanCat",
    path = "bttiNyanCat.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'NyanCat',
    loc_txt = {
        name = 'Nyan Cat',
        text = {
            "{C:chips}+25{} Chips for each",
            "remaining {C:attention}hand{}",
            "Turns one card",
            "{C:dark_edition}Polychrome{} at",
            "end of {C:attention}round"
        }
    },

    config = { extra = { chips = 25 } },
	loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "The Internet", "Chris Torres", "Juicimated" } }
		return {
            vars = { },
        }
	end,
	rarity = 1,
	atlas = 'NyanCat',
	pos = { x = 0, y = 0 },
	cost = 6,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_COMMON"] = true, ["BTTI_modAddition_INTERNET"] = true },

    pixel_size = { w = 71 , h = 95 },
    frame = 0,
    maxFrame = 11,
    frameDur = 0.085,
    ticks = 0,
    
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

	calculate = function(self, card, context)
		if context.joker_main then
            local hands = G.GAME.current_round.hands_left or 0
            local c = card.ability.extra.chips * hands
            return {
                chips = c,
                colour = G.C.CHIPS
            }
        end

        if context.end_of_round and context.cardarea == G.jokers then
            local could = {}
            for _, pc in ipairs(G.playing_cards) do
                if not pc.edition or pc.edition.key ~= "e_polychrome" then
                    could[#could+1] = pc
                end
            end

            if #could > 0 then
                local picked = could[math.random(#could)]
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            colour = G.C.CHIPS, message = "Nyan~!"
                        })
                        picked:set_edition('e_polychrome', false, true)
                        return true
                    end
                }))
            end
        end
	end,
    in_pool = function(self, args)
		return true, { allow_duplicates = false }
	end
}

SMODS.Atlas {
    key = "TacNayn",
    path = "bttiTacNayn.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'TacNayn',
    loc_txt = {
        name = 'Tac Nayn',
        text = {
            "{X:mult,C:white}X0.25{} Mult for each",
            "remaining {C:attention}discard{}",
            "Turns one card {C:chips}Digital{}",
            "every played hand"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "The Internet", "FrankieDudeUltimate", "Juicimated" } }
		return {
            vars = { },
        }
	end,
	rarity = 2,
	atlas = 'TacNayn',
	pos = { x = 0, y = 0 },
	cost = 5,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_UNCOMMON"] = true, ["BTTI_modAddition_INTERNET"] = true },

    pixel_size = { w = 71 , h = 95 },
    frame = 0,
    maxFrame = 11,
    frameDur = 0.085,
    ticks = 0,
    
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

	calculate = function(self, card, context)
		if context.joker_main then
            local discards = G.GAME.current_round.discards_left or 0
            local m = discards * 0.25
            return {
                xmult = 1 + m,
                colour = G.C.MULT
            }
        end

        if context.after then
            local could = {}
            for _, pc in ipairs(G.playing_cards) do
                if not pc.edition or pc.edition.key ~= "e_btti_digital" then
                    could[#could+1] = pc
                end
            end

            if #could > 0 then
                local picked = could[math.random(#could)]
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            colour = G.C.MULT, message = "Grr..."
                        })
                        picked:set_edition('e_btti_digital', false, true)
                        return true
                    end
                }))
            end
        end
	end,
    in_pool = function(self, args)
		return true, { allow_duplicates = false }
	end
}

SMODS.Atlas {
    key = "MatPat",
    path = "bttiJonker.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'MatPat',
    loc_txt = {
        name = 'Matthew Patrick',
        text = {
            "Theorizes played hand\'s base",
            "{C:chips}Chips{} and {C:mult}Mult{} and adds it to {C:attention}score"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Real Life", "MatPat", "hatoving" } }
		return {
            vars = { },
        }
	end,
	rarity = 1,
	atlas = 'MatPat',
	pos = { x = 0, y = 0 },
	cost = 4,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_COMMON"] = true, ["BTTI_modAddition_INTERNET"] = true },

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

SMODS.Atlas {
    key = "BadApple",
    path = "bttiJonker.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'BadApple',
    loc_txt = {
        name = 'Bad Apple!!',
        text = {
            "Gives {C:chips}Chips{} based on",
            "how many {c:attention}pixels{} of this",
            "card are black on {C:attention}score"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Touhou Project", "ZUN", "Juicimated" } }
		return {
            vars = { },
        }
	end,
	rarity = 'btti_dynamic',
	atlas = 'BadApple',
	pos = { x = 0, y = 0 },
	cost = 7,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_DYNAMIC"] = true, ["BTTI_modAddition_INTERNET"] = true },

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

SMODS.Atlas {
    key = "Rhett",
    path = "bttiJonker.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Rhett',
    loc_txt = {
        name = 'Rhett McLaughlin',
        text = {
            "{c:attention}Duplicates{} the first",
            "{c:attention}played card{} in your hand",
            "if the rank is a number"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Real Life", "Mythical", "Juicimated" } }
		return {
            vars = { },
        }
	end,
	rarity = 1,
	atlas = 'Rhett',
	pos = { x = 0, y = 0 },
	cost = 4,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_COMMON"] = true, ["BTTI_modAddition_INTERNET"] = true },

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

SMODS.Atlas {
    key = "Link",
    path = "bttiJonker.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Link',
    loc_txt = {
        name = 'Link Neal',
        text = {
            "{c:attention}Duplicates{} the last",
            "{c:attention}played card{} in your hand",
            "if the rank is a number"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Real Life", "Mythical", "Juicimated" } }
		return {
            vars = { },
        }
	end,
	rarity = 1,
	atlas = 'Link',
	pos = { x = 0, y = 0 },
	cost = 4,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_COMMON"] = true, ["BTTI_modAddition_INTERNET"] = true },

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

SMODS.Atlas {
    key = "Bibinos",
    path = "bttiJonker.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Bibinos',
    loc_txt = {
        name = 'bbno$',
        text = {
            "{c:attention}"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Real Life", "Alexander Leon Gumuchian", "Juicimated" } }
		return {
            vars = { },
        }
	end,
	rarity = 2,
	atlas = 'Bibinos',
	pos = { x = 0, y = 0 },
	cost = 6,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_COMMON"] = true, ["BTTI_modAddition_INTERNET"] = true },

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

SMODS.Atlas {
    key = "Halloween",
    path = "bttiJonker.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Halloween',
    loc_txt = {
        name = 'This is Halloween',
        text = {
            "If before or after",
            "October 31, gives $1",
            "If during October 31, adds",
            "+31 Chips and +10 Mult",
            "(Currently +0 Chips",
            "and +0 Mult)"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Touchstone Pictures", "Tim Burton", "Juicimated" } }
		return {
            vars = { },
        }
	end,
	rarity = 'btti_dynamic',
	atlas = 'Halloween',
	pos = { x = 0, y = 0 },
	cost = 8,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_DYNAMIC"] = true, ["BTTI_modAddition_INTERNET"] = true },

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