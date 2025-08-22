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

function lerp(a, b, t)
    local result = a + t * (b - a)
    return result
end

local whorseFlashbang = 0.0

local updateReal = love.update
function love.update(dt)
    updateReal(dt)
    whorseFlashbang = lerp(whorseFlashbang, 0.0, dt / 4.0)
end

local drawReal = love.draw
function love.draw()
    drawReal()

    love.graphics.setColor(1, 1, 1, whorseFlashbang)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
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
            "{C:green}1 in 10{} chance to steal {C:attention}$2-7{}"
		}
	},

	config = { extra = { mult = 10, odds = 10 } },
	loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "Brain" } }
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
            "{X:mult,C:white}x2.75{} Mult per {C:attention}Steel Card{} in {C:attention}Full Deck",
            "{C:green}1 in 20{} Chance to turn {C:attention}played",
            "{C:attention}Cards{} into {C:attention}Steel Cards{}",
            "{C:inactive}Soothens your ears",
            "{C:inactive}Currently {X:Mult,C:white}X#3#{C:inactive} Mult"
        }
    },

    config = { extra = { xmult = 2.75, odds = 20, cur = 0 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "Real Life" } }
        return {
            vars = { card.ability.extra.xmult, card.ability.extra.odds, card.ability.extra.cur },
        }
    end,
    rarity = 2,
    atlas = 'MetalPipe',
    pos = { x = 0, y = 0 },
    cost = 5,

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
            "Repeats itself each round",
            "{C:inactive}Blesses your ears when triggered",
            "{C:inactive]Currently {C:mult}+#2#{} Mult"
        }
    },

    config = { extra = { mult = 1, rep = 0 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "Family Guy" } }
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
			"{C:red}Lose{} 75% of your {C:attention}money{}",
            "OR",
            "{C:green}Win{} 110% of your {C:attention}money{}",
            "{C:inactive}He's all in{}"
		}
	},

	config = { extra = { mult = 10, odds = 10 } },
	loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "Brain" } }
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
		return true, { allow_duplicates = true }
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
            "{X:mult,C:white}x3{} Mult per card with {C:gay}Autism Seal{} in hand",
            "{C:green}1 in 10{} chance to add {C:gay}Autism Seal{} to Random Card",
            "{C:mult}+20{} Mult per other {C:gay}Autism{} {C:attention}Jokers{}"
        }
    },

    config = { extra = { odds = 10, cardAmount = 0, multAmount = 0 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "Brain" } }
        return {
            vars = { card.ability.extra.odds, card.ability.extra.cardAmount, card.ability.extra.multAmount },
        }
    end,
    rarity = 2,
    atlas = 'AutismCreature',
    pos = { x = 0, y = 0 },
    cost = 5,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
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
                                local idx = math.random(1, #G.play.cards)
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
        return true, { allow_duplicates = true }
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
            "{C:chips}+143{} Chips per card with {C:gay}Autism Seal{} in {C:attention}Full Deck{}",
            "{C:green}1 in 40{} chance to add {C:dark_edition}Polychrome{} to Random Card",
            "{X:chips,C:white}x8{} Chips per other {C:gay}Autism{} {C:attention}Jokers{}"
        }
    },

    config = { extra = { odds = 40, cardAmount = 0, multAmount = 0 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "Brain" } }
        return {
            vars = { card.ability.extra.odds, card.ability.extra.cardAmount, card.ability.extra.multAmount },
        }
    end,
    rarity = 2,
    atlas = 'BentismCreature',
    pos = { x = 0, y = 0 },
    cost = 5,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
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
                    func = function() 
                        ease_chips(hand_chips * (card.ability.extra.multAmount * 8))
                    end
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
                                local idx = math.random(1, #G.play.cards)
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
        return true, { allow_duplicates = true }
    end
}

-- JokeLinear
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
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "Charlinear's Beautiful Mind" } }
        return {
            vars = {}
        }
    end,
    rarity = 2,
    atlas = 'jokelinear',
    pos = {x = 0, y = 0},
    cost = 5,

    unlocked = true,
    discovered = true, 
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

-- DEETS JOKERS
-- DEETS JOKERS
-- DEETS JOKERS
-- DEETS JOKERS

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
            "Gives you {C:attention}$1{} at the end of the round",
            "{C:mult}+5{} Mult per {C:deets}DEETS{} {C:attention}Joker{}",
            "{C:chips}+20{} Chips per {C:deets}Horse Card{} in {C:attention}Full Deck",
            "Selling this card may result in consequnces"
        }
    },

    config = { extra = {} },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "DEETS" } }
        return {
            vars = {},
        }
    end,
    rarity = 2,
    atlas = 'Honse',
    pos = { x = 0, y = 0 },
    cost = 4,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.selling_card then
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

            for _, c in ipairs(G.playing_cards) do
                if SMODS.has_enhancement(c, "m_btti_horseCard") then
                    table.insert(rets, {
                        chip_mod = 20,
                        message = "+20 Chips",
                        colour = G.C.BTTIDEETS,
                    })
                end
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
        return true, { allow_duplicates = true }
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
            "{C:chips}+80{} Chips per {C:deets}Horse Card{} in {C:attention}Deck",
            "{X:mult,C:white}x3{} Mult if {C:attention}Played Hand{} is a {C:deets}Horse Hand{}",
            "{C:green}1 in 100{} chance to turn random card",
            "in hand into {C:deets}Horse Card"
        }
    },

    config = { extra = {} },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "DEETS" } }
        return {
            vars = {},
        }
    end,
    rarity = 1,
    atlas = 'Horse',
    pos = { x = 0, y = 0 },
    cost = 4,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
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
            if pseudorandom('Horse') < G.GAME.probabilities.normal / 100 then
                if context.scoring_hand then
                    local idx = math.random(0, #context.scoring_hand)
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
        return true, { allow_duplicates = true }
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
            "Once triggered, it will start a cooldown-- if this",
            "{C:attention}Joker{} gets played again during",
            "this cooldown, it will instead add 1/8th of",
            "owned {C:attention}${} to {C:mult}Mult{} until the",
            "cooldown is over.",
            "{C:inactive}Cooldown: #2#s"
        }
    },

    config = { extra = { cooldown = 0.0, angry = false } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "DEETS" } }
        return {
            vars = { card.ability.extra.cooldown, card.ability.extra.cooldownFloored },
        }
    end,
    rarity = 2,
    atlas = 'Haykeeper',
    pos = { x = 0, y = 0 },
    cost = 4,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
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
                            card.ability.extra.cooldown = math.random(5, 10)
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
        return true, { allow_duplicates = true }
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
            "Temporarily kicks a {C:attention}Joker{} out of a played Hand",
            "and adds 10 times its {C:attention}sell value{} to {C:mult}Mult{}",
            "Resets once the hand has ended"
        }
    },

    config = { extra = { mult = 0, kickedJoker = '' } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "DEETS" } }
        return {
            vars = { card.ability.extra.mult },
        }
    end,
    rarity = 2,
    atlas = 'Chicken',
    pos = { x = 0, y = 0 },
    cost = 4,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.before then
            if #G.jokers.cards ~= 1 then
                local idx
                repeat
                    idx = math.random(1, #G.jokers.cards)
                until idx ~= getJokerID(card)
                if idx ~= getJokerID(card) then
                    card.ability.extra.kickedJoker = G.jokers.cards[idx].config.center.key
                    card.ability.extra.mult = G.jokers.cards[idx].sell_cost * 10
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
        return true, { allow_duplicates = true }
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
            "{X:mult,C:white}x2{} Mult for each",
            "{C:attention}non-Enhanced{} Card in {C:attention}played hand",
            "{C:green}1 in 20{} chance to flashbang you"
        }
    },

    config = { extra = { xmult = 0 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "DEETS" } }
        return {
            vars = { card.ability.extra.xmult },
        }
    end,
    rarity = 3,
    atlas = 'Whorse',
    pos = { x = 0, y = 0 },
    cost = 4,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
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
            if pseudorandom('Whorse') < G.GAME.probabilities.normal / 20 then                
                return {
                    message = "Whorse",
                    colour = G.C.WHITE,
                    func = function ()
                        whorseFlashbang = 1.0
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
        return true, { allow_duplicates = true }
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
            "{C:mult}+0-100{} Mult",
            "{C:chips}+0-50{} Chips",
            "{C:mult}+5{} Mult for every",
            "{C:deets}DEETS{} {C:attention}Joker{}"
        }
    },

    config = { extra = { } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "DEETS" } }
        return {
            vars = { },
        }
    end,
    rarity = 2,
    atlas = 'Emma',
    pos = { x = 0, y = 0 },
    cost = 4,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.joker_main then
            local rets = {}
            local m = math.random(0, 100)
            local ch = math.random(0, 50)

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
        return true, { allow_duplicates = true }
    end
}

-- ITTI JOKERS
-- ITTI JOKERS
-- ITTI JOKERS
-- ITTI JOKERS

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
            "{C:attention}Joker to the right",
		}
	},

	config = { extra = { gtTarget = 0 } },
	loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'bttiFromWhere', set = 'Other', vars = { "Inn-to the Insanity" }}
		return {
            vars = { },
        }
	end,
	rarity = 3,
	atlas = 'GT',
	pos = { x = 0, y = 0 },
	cost = 6,

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
            "Copies either a random {C:attention}Joker{}",
            "or a random {C:attention}Card{} in hand",
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
	rarity = 3,
	atlas = 'SL',
	pos = { x = 0, y = 0 },
	cost = 6,

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
                local idx = math.random(1, #context.scoring_hand)
                sendInfoMessage("SL idx: " .. idx, "BTTI")

                if next(SMODS.find_card("j_btti_GT")) then
                    local ret = {
                        message = 'Again! +' .. context.scoring_hand[idx]:get_id(),
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
                    if not context.scoring_hand[idx].debuff then
                        return {
                            message = 'Hooray! +' .. context.scoring_hand[idx]:get_id(),
                            chip_mod = context.scoring_hand[idx]:get_id(),
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
            "{C:mult}+#2#{} Mult to this {C:attention}Joker{} if {C:attention}played",
            "hand{} has more {C:mult}Mult{} than {C:chips}Chips{}",
            "{C:mult}-#2#{} Mult if played hand has more",
            "{C:chips}Chips{} than {C:mult}Mult{}",
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
    rarity = 2,
    atlas = 'Mug',
    pos = {x = 0, y = 0},
    cost = 5,

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
            "{C:chips}Chips{} and {C:mult}Mult{}"
        }
    },

    config = { extra = { mult = 10, odds = 10 } },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 2,
    atlas = 'Candle',
    pos = { x = 0, y = 0 },
    cost = 6,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.joker_main and context.other_joker == card then
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
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = true }
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
        name = 'Cubey',
        text = {
            "{C:chips}+100-1000{} Chips and {X:mult,C:white}x2-10{} Mult",
            "for each {C:purple}Inn-to the Insanity{} {C:attention}Joker{}",
            "in hand"
        }
    },

    config = { extra = { mult = 10, odds = 10 } },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 4,
    atlas = 'Cubey',
    pos = { x = 0, y = 0 },
    cost = 40,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.joker_main then
           local rets = {}
            for _, jk in ipairs(G.jokers.cards) do
                local key = jk and jk.config and jk.config.center and jk.config.center.key
                if key then
                    if key == "j_btti_GT" or key == "j_btti_SL" or key == "j_btti_Mug" or key == "j_btti_Candle" then
                        table.insert(rets, {
                            chip_mod = math.random(100, 1000),
                            Xmult_mod = math.random(2, 10),
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
        return true, { allow_duplicates = true }
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
            "Will debuff 1-2 {C:attention}played cards{}"
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
	rarity = 3,
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
            "are {C:attention}10%{} of required amount.",
            "{C:green}1 in 9{} chance of being destroyed"
		}
	},

	config = { extra = { odds = 9 } },
	loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'bttiFromWhere', set = 'Other', vars = { "RegalitySMP" }}
		return {
            vars = { },
        }
	end,
	rarity = 3,
	atlas = 'RegBen',
	pos = { x = 0, y = 0 },
	cost = 10,

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
            "{X:mult,C:white}x5{} Mult per {C:purple}Tarot Card{} sold",
            "Removes {C:mult}-15{} Mult from {C:attention}played hand{}",
            "per {C:purple}Tarot Card{} used",
            "{C:inactive}Currently {X:mult,C:white}x#2#{C:inactive} Mult, {X:mult,C:white}#3#{} Mult"
		}
	},

	config = { extra = { xmult = 0 } },
	loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'bttiFromWhere', set = 'Other', vars = { "RegalitySMP" }}
		return { vars = { card.ability.extra.xmult, card.ability.extra.xmultres, card.ability.extra.mult } }
	end,
	rarity = 2,
	atlas = 'RegVince',
	pos = { x = 0, y = 0 },
	cost = 6,

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
            "{C:mult}+#1#{} Mult for each Non-{C:attention}Stone{}/",
            "Non-{C:attention}Steel Card{} in {C:attention}Full Deck{}",
            "Debuffs {C:attention}Stone{} and {C:attention}Steel Cards{}",
            "{C:green}1 in 30{} chance to turn a",
            "random played {C:attention}Card{} into a {C:attention}Stone Card{}",
            "{C:green}1 in 30{} chance to turn",
            "a random {C:attention}Card{} into a {C:attention}Steel Card"
        }
    },

    config = { extra = { mult = 20, odds = 30 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "RegalitySMP & Beyond..." } }
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
            "If {C:attention}played hand{} is a {C:attention}Flush{}, this {C:attention}Joker{} will",
            "add the base {C:chips}Chips{} and {C:mult}Mult{} of {C:attention}Royal Flush{}",
            "(at the same level as {C:attention}Flush{}) to score",
            "{C:inactive}Currently {C:chips}+#2#{} Chips, {C:mult}+#3#{} Mult"
        }
    },

    config = { extra = { mult = 17, addChip = 0, addMult = 0,} },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "RegalitySMP" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.addChip, card.ability.extra.addMult },
        }
    end,
    rarity = 2,
    atlas = 'RoyalRegality',
    pos = { x = 0, y = 0 },
    cost = 5,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

    calculate = function(self, card, context)
        card.ability.extra.addChip = G.GAME.hands['Straight Flush'].s_chips +
            (G.GAME.hands['Straight Flush'].l_chips * (G.GAME.hands['Flush'].level - 1))
        card.ability.extra.addMult = G.GAME.hands['Straight Flush'].s_mult +
            (G.GAME.hands['Straight Flush'].l_mult * (G.GAME.hands['Flush'].level - 1))

        if context.joker_main then
            return SMODS.merge_effects {
                {
                    mult_mod = card.ability.extra.mult,
                    colour = G.C.MULT,
                    message = "+" .. card.ability.extra.mult .. " Mult",
                },
                {
                    mult_mod = card.ability.extra.addChip,
                    colour = G.C.CHIPS,
                    message = "+" .. card.ability.extra.addChip .. " Chips",
                },
                {
                    mult_mod = card.ability.extra.addMult,
                    colour = G.C.MULT,
                    message = "+" .. card.ability.extra.addMult .. " Mult",
                },
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
            "{C:green}1 in 10{} chance to sloppily",
            "backread {C:attention}Jokers{} to the left",
            "{C:mult}+10{} Mult per other {C:dark_edition}Autism{} {C:attention}Jokers{}",
            "{X:mult,C:white}x69{} Mult if an",
            "{C:purple}Inn-to the Insanity {C:attention}Joker{}",
            "is present"
        }
    },

    config = { extra = { mult = 10 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "Real Life" } }
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
                if math.random(0, 1) == 1 then
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
        return true, { allow_duplicates = true }
    end
}

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
            "{C:green}1 in 17{} chance to turn",
            "{C:attention}played hand orange{}"
        }
    },

    config = { extra = { mult = 117, odds = 17 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "Real Life" } }
        return {
            vars = { card.ability.extra.mult },
        }
    end,
    rarity = 4,
    atlas = 'Juicimated',
    pos = { x = 0, y = 0 },
    cost = 10,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
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
            if pseudorandom('Juicimated') < G.GAME.probabilities.normal / card.ability.extra.odds then
                if G.play.cards then
                    table.insert(rets, {
                        G.E_MANAGER:add_event(Event({
                            trigger = 'immediate',
                            blocking = false,
                            delay = 0,
                            func = function()
                                sendInfoMessage("Making that shity ass card orange 2...", "BTTI")
                                for i, c in ipairs(G.play.cards) do
                                    c:juice_up()
                                    c:set_seal("btti_orangeSeal", false, true)
                                    card_eval_status_text(card, 'extra', nil, nil, nil,
                                        { message = "I joozed", colour = G.C.ORANGE })
                                    delay(0.1)
                                end
                                return true
                            end,
                        }))
                    })
                end
            end
            return SMODS.merge_effects(rets)
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = true }
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
            "be played as a {C:bisexual}Bisexual{} hand",
            "{C:green}1 in 4{} chance to upgrade {C:attention}Flush{} when played",
            "{C:chips}+30{} Chips if an {C:gay}Autism{} {C:attention}Joker{} is present"
        }
    },

    config = { extra = { odds = 4 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "Real Life" } }
        return {
            vars = { card.ability.extra.odds },
        }
    end,
    rarity = 4,
    atlas = 'BlueBen8',
    pos = { x = 0, y = 0 },
    cost = 5,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
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
                            chip_mod = 30,
                            message = "+30 Chips",
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
        return true, { allow_duplicates = true }
    end
}

-- BlueBen8
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
            "{C:inactive}Currently {C:mult}+#1#{} Mult and {C:chips}+#2#{} Chips"
        }
    },

    config = { extra = { mult = 0, chips = 0, roundsLeft = 0 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "Real Life" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.chips, card.ability.extra.roundsLeft },
        }
    end,
    rarity = 4,
    atlas = 'Hatoving',
    pos = { x = 0, y = 0 },
    cost = 5,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
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
                card.ability.extra.roundsLeft = math.random(1, 5)
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
        return true, { allow_duplicates = true }
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
            "{C:attention}Juicimated{}, or {C:chips}BlueBen8{} aren't present",
            "{C:mult}Kills{} LightShine if she is present",
            "{C:inactive}He carries you{}"
		}
	},

	config = { extra = { mult = 100 } },
	loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "Real Life" } }
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
            if not next(SMODS.find_card("j_btti_Hatoving")) or not next(SMODS.find_card("j_btti_Juicimated")) or not next(SMODS.find_card("j_btti_BlueBen8")) then
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
		return true, { allow_duplicates = true }
	end
}