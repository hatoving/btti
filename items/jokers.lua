require("nativefs")

--#region MUSIC

--#region LeBron

SMODS.Sound {
    key = "music_LeBron",
    path = "music_bttiLebron.ogg",
    pitch = 1,
    volume = 1.0,
    select_music_track = function(self)
        return (not jokerExists("j_btti_Ca850") and jokerExists("j_btti_LeBron")) and not G.GAME.blind.in_blind
    end
}
SMODS.Sound {
    key = "music_LeBronCA",
    path = "music_bttiLebronCA.ogg",
    pitch = 1,
    volume = 1.0,
    select_music_track = function(self)
        return (jokerExists("j_btti_Ca850") and jokerExists("j_btti_LeBron")) and not G.GAME.blind.in_blind
    end
}

--#endregion

--#region Tenna
SMODS.Sound {
    key = "music_TennaNormal",
    path = "music_bttiTenna.ogg",
    pitch = 1,
    volume = 1.0,
    select_music_track = function(self)
        return jokerExists("j_btti_Tenna")
            and G.GAME and G.GAME.blind and #G.GAME.blind.name > 0 and (G.GAME.blind:get_type() ~= 'Boss')
            and G.GAME.btti_selectedMusicIdx == self.key -- look in hooks.lua
    end
}
SMODS.Sound {
    key = "music_TennaBoss",
    path = "music_bttiTennaBoss.ogg",
    pitch = 1,
    volume = 1.0,
    select_music_track = function(self)
        return jokerExists("j_btti_Tenna")
            and G.GAME and G.GAME.blind and #G.GAME.blind.name > 0 and (G.GAME.blind:get_type() == 'Boss')
            and G.GAME.btti_selectedMusicIdx == self.key -- look in hooks.lua
    end
}
--#endregion

--#endregion

-- MISC JOKERS
--#region MISC JOKERS

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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "The Internet", "BlueBen8" } }
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
            "{C:inactive}Currently{} {X:mult,C:white}X#3#{}{C:inactive} Mult"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Real Life", "William Murdock" } }
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "The Internet", "BlueBen8" } }
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "The Internet", "@acmeiku" } }
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "BlueHQ", "lavendarbunny_creations, BlueBen8" } }
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "charlinear's Beautiful Mind", "charlinear" } }
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "The Lakers", "hatoving" } }
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Real Life", "hatoving" } }
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "The Evil of Humanity", "BlueBen8" } }
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Real Life", "BlueBen8" } }
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "hatoving", "hatoving" } }
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
            "{C:inactive}Currently{} {X:chips,C:white}X#1#{} {C:inactive}Chips{}"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Real Life", "BlueBen8" } }
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
                    trigger = 'immediate',
                    blocking = false,
                    delay = 0,
                    func = function()
                        SMODS.destroy_cards(card)
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = "Exploded with mind",
                            colour = G.C.RED,
                        })
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Brain", "aikoyori" } }
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
            "{C:inactive}Currently {C:attention}#1#%{}",
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Real Life", "BlueBen8" } }
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
                    G.GAME.discount_percent = G.GAME.btti_pfpBirdBudgie
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
            "{C:inactive}Currently {X:mult,C:white}X#1#{C:inactive} Mult"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Valve", "Gabe Newell" } }
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
        name = '... Say that again.',
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Fant4stic", "Miles Teller" } }
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
            "{C:inactive}Currently {C:chips}+#1#{C:inactive} Chips, {X:chips,C:white}X#2#{C:inactive} Chips,",
            "{C:mult}+#3#{C:inactive} Mult, {X:mult,C:white}X#4#{C:inactive} Mult, {C:attention}+$#5#{C:inactive}"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "The Stupendium", "BlueBen8" } }

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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "The Internet", "BlueBen8" } }
		return {
            vars = { },
        }
	end,
	rarity = 1,
	atlas = 'Woker',
	pos = { x = 0, y = 0 },
	cost = 4,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_COMMON"] = true, ["BTTI_modAddition_INTERNET"] = true },

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

--#endregion

-- FAMILY GUY JOKERS
--#region FAMILY GUY JOKERS

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
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Family Guy", "Seth McFarlane" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.rep },
        }
    end,
    rarity = 1,
    atlas = 'GoodMorning',
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
        return true, { allow_duplicates = false }
    end
}

-- Did Somebody Say Pie?
SMODS.Sound({ key = "famGuyPie", path = "bttiDidSomebodySayPie.ogg", })
SMODS.Sound({ key = "famGuyPieOp", path = "bttiDidSomebodySayPieOp.ogg", })

SMODS.Atlas {
    key = "DidSomebodySayPie",
    path = "bttiDidSomebodySayPie.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'DidSomebodySayPie',
    loc_txt = {
        name = 'Did Somebody Say Pie?',
        text = {
            "Gains {X:chips,C:white}X#1#{}",
            "for every {C:attention}3{} scored",
            "{C:inactive}Currently {X:chips,C:white}X#2#{C:inactive} Chips"
        }
    },

    config = { extra = { xchips = 1 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Family Guy", "Seth McFarlane" } }
        return {
            vars = { math.pi / 10, card.ability.extra.xchips },
        }
    end,
    rarity = 1,
    atlas = 'DidSomebodySayPie',
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
            return {
                xchips_mod = card.ability.extra.xchips,
                message = "*Family Guy Funny Moment*",
                sound = "btti_famGuyPieOp",
                pitch = pseudorandom("btti_" .. card.ability.name, .9, 1.1),
            }
        end
        if context.cardarea == G.play and context.individual and context.other_card then
            local _trigger = false
            if context.other_card:get_id() == 3 then _trigger = true end
            if _trigger then
                card.ability.extra.xchips = card.ability.extra.xchips + (math.pi / 10)
                context.other_card:juice_up()
                return {
                    message = "Did somebody say pie?",
                    sound = "btti_famGuyPie",
                    pitch = pseudorandom("btti_" .. card.ability.name, .9, 1.1),
                }
            end
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}
--#endregion

-- VOCALOID JOKERS
--#region VOCALOID JOKERS

-- Miku
SMODS.Atlas {
    key = "Miku",
    path = "bttiHatsuneMiku.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Miku',
    loc_txt = {
        name = 'Hatsune Miku',
        text = {
            "{C:chips}+5{} Chips for every",
            "{C:clubs}Club{} currently in {C:attention}full deck",
            "{C:inactive}Currently +{C:chips}#1#{C:inactive} Chips"
        }
    },

    config = { extra = { chips = 2 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "VOCALOID", "Crypton Future Media, INC." } }
        local cardCount = 0
        if G.deck and G.deck.cards then
            for i, pc in ipairs(G.deck.cards) do
                if pc:is_suit('Clubs') then
                    cardCount = cardCount + 1
                end
            end
        end
        return {
            vars = { card.ability.extra.chips * cardCount },
        }
    end,
    rarity = 2,
    atlas = 'Miku',
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
            local cardCount = 0
            for i, pc in ipairs(G.deck.cards) do
                if pc:is_suit('Clubs') then
                    cardCount = cardCount + 1
                end
            end
            return {
                chips = cardCount * card.ability.extra.chips
            }
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

SMODS.Atlas {
    key = "Teto",
    path = "bttiKasaneTeto.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Teto',
    loc_txt = {
        name = 'Kasane Teto',
        text = {
            "{C:mult}+1{} Mult for every",
            "{C:hearts}Heart{} currently in {C:attention}full deck",
            "{C:inactive}Currently +{C:mult}#1#{C:inactive} Mult"
        }
    },

    config = { extra = { mult = 1 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "UTAU", "Smith Hioka" } }
        local cardCount = 0
        if G.deck and G.deck.cards then
            for i, pc in ipairs(G.deck.cards) do
                if pc:is_suit('Hearts') then
                    cardCount = cardCount + 1
                end
            end
        end
        return {
            vars = { card.ability.extra.mult * cardCount },
        }
    end,
    rarity = 2,
    atlas = 'Teto',
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
            local cardCount = 0
            for i, pc in ipairs(G.deck.cards) do
                if pc:is_suit('Hearts') then
                    cardCount = cardCount + 1
                end
            end
            return {
                mult = cardCount * card.ability.extra.mult
            }
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

SMODS.Atlas {
    key = "Neru",
    path = "bttiAkitaNeru.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Neru',
    loc_txt = {
        name = 'Akita Neru',
        text = {
            "Gain {C:attention}$0.5{} for every",
            "{C:diamonds}Diamond{} currently in {C:attention}Deck",
            "{C:inactive}Currently {C:attention}$#1#{C:inactive}"
        }
    },

    config = { extra = { dollars = .5 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "VOCALOID (Derivative)", "Smith Hioka" } }
        local cardCount = 0
        if G.deck and G.deck.cards then
            for i, pc in ipairs(G.deck.cards) do
                if pc:is_suit('Diamonds') then
                    cardCount = cardCount + 1
                end
            end
        end
        return {
            vars = { card.ability.extra.dollars * cardCount },
        }
    end,
    rarity = 2,
    atlas = 'Neru',
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
            local cardCount = 0
            for i, pc in ipairs(G.deck.cards) do
                if pc:is_suit('Diamonds') then
                    cardCount = cardCount + 1
                end
            end
            return {
                dollars = cardCount * card.ability.extra.dollars
            }
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

--#endregion

-- ETG JOKRES
--#region ETG JOKERS

SMODS.Atlas {
    key = "Dragun",
    path = "bttiDragun.png",
    px = 71,
    py = 95,
}
SMODS.Joker {
    key = 'Dragun',
    loc_txt = {
        name = 'The Dragun',
        text = {
            "{X:mult,C:white}X5{} Mult if played hand",
            "has exactly {C:blue}5{} cards"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Enter the Gungeon", "Dodge Roll Games, Devolver Digital" } }
        return {
            vars = {},
        }
    end,
    rarity = 3,
    atlas = 'Dragun',
    pos = { x = 0, y = 0 },
    cost = 5,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_RARE"] = true, },

    pixel_size = { w = 71, h = 95 },
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
        if context.joker_main then
            if #G.play.cards == 5 then
                return {
                    xmult = 5
                }
            end
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}


--#endregion

-- ULTRAKILL JOKERS
--#region ULTRAKILL JOKERS

SMODS.Atlas {
    key = "Mindflayer",
    path = "bttiMindflayer.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Mindflayer',
    loc_txt = {
        name = 'Mindflayer',
        text = {
            "{C:chips}+15{} Chips",
            "{C:chips}+10{} Chips for every {C:attention}card",
            "played this {C:attention}round",
            "Resets at end of {C:attention}round",
            "{C:inactive}Currently {C:chips}+#1#{C:inactive} Chips"
        }
    },

    config = { extra = { chips = 15 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "ULTRAKILL", "Hakita, New Blood Interactive" } }
        return {
            vars = { card.ability.extra.chips },
        }
    end,
    rarity = 1,
    atlas = 'Mindflayer',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_COMMON"] = true, },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            card.ability.extra.chips = card.ability.extra.chips + 10
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
        if context.end_of_round and context.cardarea == G.jokers then
            card.ability.extra.chips = 15
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

--#endregion

-- ISAAC JOKERS
--#region ISAAC JOKERS

SMODS.Atlas {
    key = "Brimstone",
    path = "bttiBrimstone.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Brimstone',
    loc_txt = {
        name = 'Brimstone',
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "The Binding of Isaac", "Edmund McMillen, Nicalis" } }
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
                    colour = G.C.RED
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

--#endregion

-- FNAF JOKERS
--#region FNAF JOKERS

SMODS.Sound({ key = "Springtrap", path = "bttiSpringtrap.ogg" })
-- Springtrap
SMODS.Atlas {
    key = "Springtrap",
    path = "bttiSpringtrap.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Springtrap',
    loc_txt = {
        name = 'Springtrap',
        text = {
            "Gains {C:attention}$0.5{} of {C:attention}sell value{}",
            "per card {C:red}discarded",
            "Once removed from deck,",
            "has a {C:green}1 in 4{} chance to",
            "respawn at the end of {C:attention}round{}",
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Five Nights at Freddy's", "Scott Cawthon" } }
        return {
            vars = {},
        }
    end,
    rarity = 2,
    atlas = 'Springtrap',
    pos = { x = 0, y = 0 },
    cost = 5,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_UNCOMMON"] = true, },

    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.discard and context.full_hand and not context.blueprint then
            card.sell_cost = card.sell_cost + 0.5
            if context.other_card == context.full_hand[#context.full_hand] then
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    blocking = false,
                    delay = 0,
                    func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil,
                            { message = "...", colour = G.C.PURPLE })
                        return true
                    end,
                }))
            end
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

SMODS.Sound({ key = "bo87", path = "bttiBiteOf87.ogg" })
SMODS.Atlas {
    key = "BiteOf87",
    path = "bttiBiteOf87.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'BiteOf87',
    loc_txt = {
        name = 'WAS THAT THE...?!',
        text = {
            "{C:chips}+87{} Chips",
            "{X:mult,C:white}X3{} Mult every 3 hands",
            "{C:inactive}A guardian angel watches over you{}"
        }
    },

    config = { extra = { mult = 0, chips = 0, hands = 3 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Five Nights at Freddy's", "Markiplier" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.chips },
        }
    end,
    rarity = 1,
    atlas = 'BiteOf87',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_COMMON"] = true, },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.before and context.cardarea == G.jokers then
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                blocking = false,
                delay = 0,
                func = function()
                    G.BTTI.biteOf87Change(G.BTTI.biteOf87_SHOCK[1], G.BTTI.biteOf87_SHOCK)
                    return true
                end,
            }))
        end
        if context.joker_main then
            local rets = {}
            card.ability.extra.hands = card.ability.extra.hands - 1
            table.insert(rets, {
                chips = 87,
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    blocking = false,
                    delay = 0,
                    func = function()
                        play_sound('btti_bo87')
                        G.BTTI.biteOf87Change(G.BTTI.biteOf87_BITE[1], G.BTTI.biteOf87_BITE)
                        return true
                    end,
                }))
            })
            if card.ability.extra.hands <= 0 then
                table.insert(rets, {
                    xmult = 3,
                })
                card.ability.extra.hands = 3
            end
            return SMODS.merge_effects(rets)
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

--#endregion

-- UTDR JOKERS
--#region UTDR JOKERS

-- Sans
SMODS.Sound({ key = "Sans", path = "bttiSans.ogg" })
SMODS.Atlas {
    key = "Sans",
    path = "bttiSans.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Sans',
    loc_txt = {
        name = 'sans.',
        text = {
            "This {C:attention}Joker{} is assigned",
            "the effect of a random {C:common}Common {C:joker}Joker{}",
            "at the beginning of each {C:attention}round",
            "Resets at the end of each {C:attention}round"
        }
    },

    config = { extra = { currentJoker = nil } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "UNDERTALE / DELTARUNE", "Toby Fox" } }
        return {
            vars = { },
        }
    end,
    rarity = 1,
    atlas = 'Sans',
    pos = { x = 0, y = 0 },
    cost = 4,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_COMMON"] = true, },

    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,

    -- We need this because Sans decided it'd be funny to cosplay as a pink furry
    update = function (self, card, dt)
        card.children.center.atlas = G.ASSET_ATLAS['btti_Sans']
        card.children.center:set_sprite_pos({ x = 0, y = 0 })
    end,

    -- Thank you to Somthingcom515 for the help with implementing this!!
    calculate = function(self, card, context)
        if context.setting_blind and context.cardarea == G.jokers then
            card.ability.extra.currentJoker = pseudorandom_element(G.P_JOKER_RARITY_POOLS[1], 'seed').key
            sendInfoMessage("sans chose: " .. card.ability.extra.currentJoker .. "", "BTTI")
            return {
                message = '\'sup.',
                colour = G.C.BLUE,
                sound = 'btti_Sans'
            }
        end
        if card.ability.extra.currentJoker then
            local key = card.ability.extra.currentJoker
            G.btti_savedJokerCards = G.btti_savedJokerCards or {}
            G.btti_savedJokerCards[card.sort_id] = G.btti_savedJokerCards[card.sort_id] or {}
            if not G.btti_savedJokerCards[card.sort_id][key] then
                local old_ability = copy_table(card.ability)
                local old_center = card.config.center
                local old_center_key = card.config.center_key
                card:set_ability(key, nil, 'quantum')
                card:update(0.016)
                G.btti_savedJokerCards[card.sort_id][key] = SMODS.shallow_copy(card)
                G.btti_savedJokerCards[card.sort_id][key].ability = copy_table(G.btti_savedJokerCards
                    [card.sort_id][key].ability)
                for i, v in ipairs({ "T", "VT", "CT" }) do
                    G.btti_savedJokerCards[card.sort_id][key][v] = copy_table(G.btti_savedJokerCards[card.sort_id]
                        [key][v])
                end
                G.btti_savedJokerCards[card.sort_id][key].config = SMODS.shallow_copy(G.btti_savedJokerCards
                    [card.sort_id][key].config)
                card.ability = old_ability
                card.config.center = old_center
                card.config.center_key = old_center_key
                for i, v in ipairs({ 'juice_up', 'start_dissolve', 'remove', 'flip' }) do
                    G.btti_savedJokerCards[card.sort_id][key][v] = function(_, ...)
                        return Card[v](card, ...)
                    end
                end
            end
            return G.btti_savedJokerCards[card.sort_id][key]:calculate_joker(context)
        end
    end
}

SMODS.Sound({ key = "Papyrus0", path = "bttiPapyrus0.ogg" })
SMODS.Sound({ key = "Papyrus1", path = "bttiPapyrus1.ogg" })
SMODS.Sound({ key = "Papyrus2", path = "bttiPapyrus2.ogg" })
SMODS.Sound({ key = "PapyrusBlue", path = "bttiPapyrusBlue.ogg" })
-- Papyrus
SMODS.Atlas {
    key = "Papyrus",
    path = "bttiPapyrus.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Papyrus',
    loc_txt = {
        name = 'THE GREAT PAPYRUS!',
        text = {
            "{C:mult}+4{} Mult per {C:attention}card{} played",
            "without an enhancement",
            "{C:green}1 in 10{} chance to apply a {C:blue}Blue Seal{}",
            "to a played {C:hearts}Heart{} card"
        }
    },

    config = { extra = { mult = 4, sfx = -1 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "UNDERTALE / DELTARUNE", "Toby Fox" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.chips },
        }
    end,
    rarity = 1,
    atlas = 'Papyrus',
    pos = { x = 0, y = 0 },
    cost = 4,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_COMMON"] = true, },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local pc = context.other_card
            if pc and (not SMODS.get_enhancements(pc) or next(SMODS.get_enhancements(pc)) == nil) then
                return {
                    mult = card.ability.extra.mult,
                    colour = G.C.MULT,
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        blocking = false,
                        delay = 0,
                        func = function()
                            if card.ability.extra.sfx == nil then
                                card.ability.extra.sfx = 0
                                card.ability.extra.second = false
                            end

                            if card.ability.extra.sfx == 0 then
                                if card.ability.extra.second then
                                    card.ability.extra.sfx = 2
                                else
                                    card.ability.extra.sfx = 1
                                end
                                card.ability.extra.second = not card.ability.extra.second
                            else
                                card.ability.extra.sfx = 0
                            end

                            play_sound('btti_Papyrus' .. card.ability.extra.sfx)
                            return true
                        end,
                    }))
                }
            end
        end

        if context.joker_main then
            if pseudorandom("Papyrus") < 0.1 then
                local hearts = {}
                if G.play.cards then
                    for _, c in ipairs(G.play.cards) do
                        if c:is_suit("Hearts") then
                            table.insert(hearts, c)
                        end
                    end
                end

                if #hearts > 0 then
                    local c = pseudorandom_element(hearts, "Papyrus")
                    c:set_seal("Blue")
                    return {
                        message = "YOU'RE BLUE NOW!",
                        colour = G.C.BLUE,
                        sound = 'btti_PapyrusBlue'
                    }
                end
            end
        end
    end
}

SMODS.Atlas {
    key = "WeirdRoute",
    path = "bttiWeirdRoute.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'WeirdRoute',
    loc_txt = {
        name = 'Weird Route',
        text = {
            "Sell this {C:joker}Joker{} to {C:blue}freeze{} the",
            "current Blind, winning the {C:attention}round",
            "{C:inactive}(Doesn't work on{} {C:attention}Boss Blinds{}{C:inactive}){}"
        }
    },

    config = { extra = { mult = 0, chips = 0 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "UNDERTALE / DELTARUNE", "Toby Fox" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.chips },
        }
    end,
    rarity = 1,
    atlas = 'WeirdRoute',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_COMMON"] = true, },

    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.selling_card and context.card == card then
            if G.GAME.blind.in_blind and not G.GAME.blind.boss then
                WIN_ROUND_NOW()
            end
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

-- Tenna

SMODS.Sound({ key = "tennaT", path = "bttiTennaT.ogg" })
SMODS.Sound({ key = "tennaV", path = "bttiTennaV.ogg" })
SMODS.Sound({ key = "tennaTime", path = "bttiTennaTime.ogg" })

SMODS.Atlas {
    key = "Tenna",
    path = "bttiTenna.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Tenna',
    loc_txt = {
        name = 'Mr. (Ant) Tenna',
        text = {
            "Gains {C:mult}+10{} Mult per {C:purple}Combination{} {C:attention}Joker{} created",
            "Gains {C:chips}+20{} Chips per {C:purple}Combination{} {C:attention}Joker{} created",
            "{C:inactive}Currently {C:mult}+#1#{C:inactive} Mult, {C:chips}+#2#{C:inactive} Chips"
        }
    },

    config = { extra = { mult = 0, chips = 0 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "UNDERTALE / DELTARUNE", "Toby Fox" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.chips },
        }
    end,
    rarity = 1,
    atlas = 'Tenna',
    pos = { x = 0, y = 0 },
    cost = 4,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_COMMON"] = true, },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.joker_main then
            local rets = {}
            if card.ability.extra.mult > 0 then
                table.insert(rets, {
                    message = "T...",
                    colour = G.C.MULT,
                    sound = 'btti_tennaT',
                })
                table.insert(rets, {
                    message = "V... +" .. card.ability.extra.mult .. "",
                    colour = G.C.MULT,
                    mult_mod = card.ability.extra.mult,
                    sound = 'btti_tennaV',
                })
            end
            if card.ability.extra.chips > 0 then
                table.insert(rets, {
                    message = "TIME!! +" .. card.ability.extra.chips .. "",
                    colour = G.C.CHIPS,
                    chip_mod = card.ability.extra.chips,
                    sound = 'btti_tennaTime',
                })
            end
            return SMODS.merge_effects(rets)
        end
        if context.combined_joker then
            card.ability.extra.mult = card.ability.extra.mult + 10
            card.ability.extra.chips = card.ability.extra.chips + 20
            return {
                message = "Glooby!",
                colour = G.C.MULT
            }
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

--#endregion

-- TADC JOKERS 
--#region TADC JOKERS

-- Jax
SMODS.Atlas {
    key = "Jax",
    path = "bttiJax.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Jax',
    loc_txt = {
        name = 'The Funny One',
        text = {
            "{C:mult}+5{} Mult for every {C:attention}Joker{}",
            "you've held this run after purchase",
            "{C:inactive}Currently {C:mult}+#1#{C:inactive} Mult"
        }
    },

    config = { extra = { mult = 5 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "The Amazing Digital Circus", "Gooseworx, GLITCH" } }
        return {
            vars = { card.ability.extra.mult },
        }
    end,
    rarity = 2,
    atlas = 'Jax',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_UNCOMMON"] = true, },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.card_added and context.card.ability.set == "Joker" then
            if G.GAME.jokersAlreadySeen == nil then
                G.GAME.jokersAlreadySeen = {}
            end
            if not findInTable(G.GAME.jokersAlreadySeen, context.card.ability.name) then
                G.GAME.jokersAlreadySeen[context.card.ability.name] = true
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    blocking = false,
                    delay = 0,
                    func = function()
                        if not card.ability.extra.mult then
                            card.ability.extra.mult = 0
                        end
                        card.ability.extra.mult = card.ability.extra.mult + 5
                        card_eval_status_text(card, 'extra', nil, nil, nil,
                            { message = "Whatever.", colour = G.C.PURPLE })
                        return true
                    end,
                }))
            end
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

-- Pomni
SMODS.Atlas {
    key = "Pomni",
    path = "bttiPomni.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Pomni',
    loc_txt = {
        name = 'XDDCC',
        text = {
            "{C:mult}+4{} Mult and {C:chips}+15{} Chips",
            "Gains {C:mult}+4{} Mult and {C:chips}+15{} Chips",
            "at the end of each {C:attention}Ante",
            "{C:inactive}Currently {C:chips}+#1#{C:inactive} Chips, {C:mult}+#2#{C:inactive} Mult"
        }
    },

    config = { extra = { chips = 15, mult = 4 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "The Amazing Digital Circus", "Gooseworx, GLITCH" } }
        return {
            vars = { card.ability.extra.chips, card.ability.extra.mult },
        }
    end,
    rarity = 3,
    atlas = 'Pomni',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_RARE"] = true, },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.ante_change and context.ante_end then
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                blocking = false,
                delay = 0,
                func = function()
                    card.ability.extra.chips = card.ability.extra.chips + 15
                    card.ability.extra.mult = card.ability.extra.mult + 4
                    card_eval_status_text(card, 'extra', nil, nil, nil,
                        { message = "Phew...", colour = G.C.RED })
                    return true
                end,
            }))
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult
            }
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

--Caine
SMODS.Sound({ key = "caineRingmaster", path = "bttiCaineRingmaster.ogg" })
SMODS.Sound({ key = "caineBitch", path = "bttiCaineBitch.ogg" })

SMODS.Atlas {
    key = "Caine",
    path = "bttiCaine.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Caine',
    loc_txt = {
        name = 'My Name is Caine!',
        text = {
            "Adds a {C:blue}Digital{} Card to {C:attention}hand{}",
            "{C:green}9 in 10{} chance to give {C:chips}+1-404{} Chips",
            "{C:green}1 in 10{} chance to {C:red}abstract{} a random {C:attention}Joker{}",
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "The Amazing Digital Circus", "Gooseworx, GLITCH" } }
        return {
            vars = { },
        }
    end,
    rarity = 3,
    atlas = 'Caine',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_RARE"] = true, },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.joker_main then
            local rets = {}
            table.insert(rets, {
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    blocking = false,
                    delay = 0,
                    func = function()
                        SMODS.add_card {
                            set = 'Playing Card',
                            edition = 'e_btti_digital'
                        }
                        return true
                    end,
                }))
            })
            local random = pseudorandom('Caine')
            if random < 0.9 then
                table.insert(rets, {
                    chips = pseudorandom("btti_" .. card.ability.name, 1, 404),
                    message = "I'm your ringmaster!",
                    sound = 'btti_caineRingmaster',
                })
            else
                table.insert(rets, {
                    message = "I am your bitch!",
                    sound = 'btti_caineBitch',
                    func = function()
                        if #G.jokers.cards > 1 then
                            local idx
                            repeat
                                idx = pseudorandom("btti_" .. card.ability.name, 1, #G.jokers.cards)
                            until G.jokers.cards[idx] ~= card
                            SMODS.destroy_cards(G.jokers.cards[idx])
                        end
                    end
                })
            end
            return SMODS.merge_effects(rets)
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

--#endregion

--SPONGEBOB JOKERS
--#region SPONGEBOB JOKERS

--SpongeBob
SMODS.Atlas {
    key = "SpongeBob",
    path = "bttiSpongeBob.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'SpongeBob',
    loc_txt = {
        name = 'SpongeBob',
        text = {
            "All {C:attention}played cards{} count in scoring",
            "and get retriggered {C:blue}1-2{} times"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "SpongeBob SquarePants", "Stephen Hillenburg" } }
        return {
            vars = {},
        }
    end,
    rarity = 3,
    atlas = 'SpongeBob',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_RARE"] = true, },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.modify_scoring_hand and not context.blueprint then
            return {
                add_to_hand = true
            }
        end
        if context.repetition and context.cardarea == G.play then
            return {
                repetitions = pseudorandom("btti_" .. card.ability.name, 1, 2)
            }
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

--#endregion

-- KPDH JOKERS
--#region KPDH JOKERS

-- Huntrix
SMODS.Atlas {
    key = "Huntrix",
    path = "bttiHuntrix.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Huntrix',
    loc_txt = {
        name = 'HUNTR/X',
        text = {
            "Makes other {C:joker}Jokers",
            "eternal but still {C:attention}sellable",
            "while in hand"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "KPop Demon Hunters", "Netflix" } }
        return {
            vars = {},
        }
    end,
    rarity = 3,
    atlas = 'Huntrix',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_RARE"] = true, },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    update = function(self, card, dt)
        if (G and G.jokers and G.jokers.cards) and (jokerExists('j_btti_Huntrix')) then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.name ~= 'j_btti_Huntrix' and not G.jokers.cards[i].ability.eternal then
                    G.jokers.cards[i]:set_eternal(true)
                    G.jokers.cards[i].ability.huntrix = true
                end
            end
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

--#endregion

--if pseudorandom('RegBen') < G.GAME.probabilities.normal / (9/10) then


-- BFDI JOKERS
--#region BFDI JOKERS

-- One
SMODS.Atlas {
    key = "One",
    path = "bttiOne.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'One',
    loc_txt = {
        name = 'One',
        text = {
            "{C:green}1 in 4{} chance to drain {C:dark_edition}editions{} of",
            "other {C:joker}Jokers",
            "{C:inactive}Currently {C:chips}+#1#{C:inactive} Chips, {X:mult,C:white}X#2#{C:inactive} Mult, {C:mult}+#3#{} Mult"
        }
    },

    config = { extra = { chips = 0, mult = 0, Xmult = 0.0 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Battle for Dream Island", "jacknjellify" } }
        return {
            vars = { card.ability.extra.chips, card.ability.extra.Xmult, card.ability.extra.mult },
        }
    end,
    rarity = 3,
    atlas = 'One',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_RARE"] = true, },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.setting_blind or context.before or (context.end_of_round and context.cardarea == G.jokers) or context.final_scoring_step then
            if pseudorandom('One') < G.GAME.probabilities.normal / 4 then
                local idx = pseudorandom("btti_" .. card.ability.name, 1, #G.jokers.cards)
                local ed = G.jokers.cards[idx].edition or nil

                sendInfoMessage("one chose " .. idx .. "", "BTTI")

                -- only drain powers if the selected card ain't herself + if the selected card has an edition to drain
                if ed ~= nil and idx ~= getJokerID(card) then
                    return {
                        message = "Ahahaha!!",
                        colour = G.C.BLUE,
                        G.E_MANAGER:add_event(Event({
                            trigger = 'immediate',
                            blocking = false,
                            delay = 0,
                            func = function()
                                G.jokers.cards[idx]:set_edition()
                                G.jokers.cards[idx]:juice_up()

                                sendInfoMessage("one chose " .. ed.key .. "", "BTTI")

                                if ed.key == 'e_foil' then
                                    card.ability.extra.chips = card.ability.extra.chips + 50
                                elseif ed.key == 'e_polychrome' then
                                    card.ability.extra.Xmult = card.ability.extra.Xmult + 1.5
                                elseif ed.key == 'e_holo' then
                                    card.ability.extra.mult = card.ability.extra.mult + 10
                                elseif ed.key == 'e_negative' then
                                    card:set_edition('e_negative')
                                end

                                card:juice_up()
                                return true
                            end,
                        }))
                    }
                end
            else
                return {
                    message = "Nope...",
                    colour = G.C.BLUE,
                }
            end
        end
        if context.joker_main then
            local rets = {}
            if card.ability.extra.chips > 0 then
                table.insert(rets, {
                    chips = card.ability.extra.chips
                })
            end
            if card.ability.extra.mult > 0 then
                table.insert(rets, {
                    mult = card.ability.extra.mult
                })
            end
            if card.ability.extra.Xmult > 0 then
                table.insert(rets, {
                    Xmult = card.ability.extra.Xmult
                })
            end
            return SMODS.merge_effects(rets)
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

--#endregion

-- HANAKO JOKERS
--#region HANAKO JOKERS
SMODS.Atlas {
    key = "Hanako",
    path = "bttiHanako.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Hanako',
    loc_txt = {
        name = 'Hanako Takeuchi',
        text = {
            "Adds the {C:attention}sell value{} of",
            "{C:joker}Jokers{} sold to {C:chips}Chips{} and {C:mult}Mult{}",
            "Does not count previously",
            "sold {C:joker}Jokers{}",
            "{C:inactive}Currently {C:chips}+#2#{} Chips, {C:mult}+#1#{} Mult"
        }
    },

    config = { extra = { smult = 0, schips = 0} },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "YOURS TRULY, HANAKO", "hatoving" } }
        return {
            vars = { card.ability.extra.smult, card.ability.extra.schips },
        }
    end,
    rarity = 1,
    atlas = 'Hanako',
    pos = { x = 0, y = 0 },
    cost = 4,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_COMMON"] = true, },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.schips,
                mult = card.ability.extra.smult
            }
        end

        if context.selling_card and context.card.ability.set == 'Joker' then
            if context.card ~= card then
                card.ability.extra.schips = card.ability.extra.schips + context.card.cost
                card.ability.extra.smult = card.ability.extra.smult + context.card.sell_cost
                return {
                    message = "... oh ._.",
                    colour = G.C.YELLOW
                }
            end
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

SMODS.Atlas {
    key = "Cassidy",
    path = "bttiCassidy.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Cassidy',
    loc_txt = {
        name = 'Cassidy Kairi Mari',
        text = {
            "Uses {C:attention}${} to gain {C:chips}Chips{} and {C:mult}Mult",
            "{C:green}1 in 10{} chance to waste {C:attention}$",
            "and {C:red}destroy{} itself at end of {C:attention}round{}",
            "{C:inactive}Currently {C:chips}+#2#{C:inactive} Chips, {C:mult}+#1#{C:inactive} Mult"
        }
    },

    config = { extra = { mult = 0, chips = 0} },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "YOURS TRULY, HANAKO", "hatoving" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.chips },
        }
    end,
    rarity = 1,
    atlas = 'Cassidy',
    pos = { x = 0, y = 0 },
    cost = 4,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_COMMON"] = true, },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.joker_main then
            local steal = pseudorandom("btti_" .. card.ability.name, 1, math.clamp(G.GAME.dollars, 1, 10))
            if steal > G.GAME.dollars then
                steal = G.GAME.dollars
            end
            card.ability.extra.chips = card.ability.extra.chips + steal * 2
            card.ability.extra.mult = card.ability.extra.mult + math.floor(steal / 2)
            return SMODS.merge_effects {
                {
                    message = "Thanks!",
                    dollars = -steal,
                    colour = G.C.YELLOW
                },
                {
                    chips = card.ability.extra.chips,
                    mult = card.ability.extra.mult
                }
            }
        end
        if context.end_of_round and context.cardarea == G.jokers then
            if pseudorandom('Cassidy') < G.GAME.probabilities.normal / 10 then
                local steal = pseudorandom("btti_" .. card.ability.name, 1, math.clamp(G.GAME.dollars, 1, 15))
                if steal > G.GAME.dollars then
                    steal = G.GAME.dollars
                end
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound("tarot1")
                        card:start_dissolve()
                        return true
                    end
                }))
                return {
                    message = "Gotta dip!",
                    dollars = -steal,
                    colour = G.C.YELLOW,
                }
            end
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

--#endregion

-- DEETS JOKERS
--#region DEETS JOKERS

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
            "Gives you {C:attention}$1{} at the end of the {C:attention}round{}",
            "{C:mult}+5{} Mult per {C:deets}DEETS Joker{}",
            "{C:chips}+20{} Chips per {C:deets}Horse Card{} in {C:attention}full deck",
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "DEETS", "hatoving" } }
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "DEETS", "hatoving" } }
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "DEETS", "hatoving, BlueBen8" } }
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "DEETS", "hatoving" } }
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "DEETS", "BlueBen8, ca850" } }
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
            "{C:mult}+0-100{} Mult",
            "{C:chips}+0-50{} Chips",
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "DEETS", "Juicimated" } }
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
            "{C:inactive}Currently {C:chips}+#1#{C:inactive} Chips{}, {C:mult}+#2#{} Mult, {X:mult,C:white}X#3#{} Mult"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "DEETS", "Juicimated" } }
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
--#endregion

-- ITTI JOKERS
--#region ITTI JOKERS

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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Inn-to the Insanity", "LightShine, Juicimated" } }
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Inn-to the Insanity", "LightShine, Juicimated" } }
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
            "{C:inactive}Currently{} {C:mult}+#1#{}{C:inactive} Mult{}"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Inn-to the Insanity", "Lightshine, Juicimated" } }
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
            "{C:chips}Chips{} and {C:mult}Mult{}"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Inn-to the Insanity", "LightShine, Juicimated" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Inn-to the Insanity", "beanrollup" } }
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

--#endregion

-- DRAMATIZED JOKERS
--#region DRAMATIZED JOKERS

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
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "DRAMATIZED", "Juicimated" } }
		return {
            vars = { card.ability.extra.mult, card.ability.extra.howMuch },
        }
	end,
	rarity = 1,
	atlas = 'Teeriffic',
	pos = { x = 0, y = 0 },
	cost = 4,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_COMMON"] = true, },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

	calculate = function(self, card, context)
		if context.before then
            local rand = pseudorandom("btti_" .. card.ability.name, 1, 2)
            if #context.scoring_hand > rand then
                for i=1,rand,1 do
                    local rand2 = pseudorandom("btti_" .. card.ability.name, 1, #context.scoring_hand)
                    context.scoring_hand[rand2]:set_debuff(true)
                end
            elseif #context.scoring_hand == 2 then
                local rand2 = pseudorandom("btti_" .. card.ability.name, 1, #context.scoring_hand)
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
		return true, { allow_duplicates = false }
	end
}

--#endregion

-- YMFP JOKERS
--#region YMFP JOKERS

SMODS.Atlas {
    key = "YIN",
    path = "bttiYIN.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'YIN',
	loc_txt = {
		name = 'Y/N',
		text = {
			"Press {C:blue}ENTER{} while this {C:attention}Joker{} is",
            "highlighted to select a new {C:attention}Boss Blind{}",
            "from your collection",
            "Cannot select the same {C:attention}Boss Blind{} twice in a row",
            "Becomes {C:inactive}inactive{} until {C:attention}Boss Blind{} is defeated"
		}
	},

	config = { extra = { allow = true, active = false, lastEnter = false, lastBlindChose = '', activeText = '' } },
	loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "You're My Favorite Person", "Juicimated" } }
        main_start = {
            { n = G.UIT.T, config = { ref_table = card.ability.extra, ref_value = "activeText", colour = G.C.JOKER_GREY, scale = 0.35 } },
        }
        return {
            main_start = main_start
        }
	end,
	rarity = 3,
	atlas = 'YIN',
	pos = { x = 0, y = 0 },
	cost = 8,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_RARE"] = true, ["BTTI_modAddition_YMFP"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    update = function (self, card, dt)
        card.ability.extra.activeText = (card.ability.extra.active and 'Active') or 'Inactive'
        if card.ability.extra.allow then
            if (card.highlighted and (love.keyboard.isDown('return') and not card.ability.extra.lastEnter)) and G.STATE == G.STATES.BLIND_SELECT and not G.SETTINGS.paused then
                card.ability.extra.active = not card.ability.extra.active
                card:juice_up()
                local msg = (card.ability.extra.active and 'Active.') or 'Inactive'
                card_eval_status_text(card, 'extra', nil, nil, nil,
                    { message = msg, colour = G.C.JOKER_GREY })
            end
            if card.ability.extra.active then
                if love.keyboard.isDown('return') then
                    local _element = G.CONTROLLER.hovering.target
                    if _element and _element.config and _element.config.blind then
                        if G.GAME.round_resets.blind_choices.Boss ~= _element.config.blind.key and _element.config.blind.key ~= card.ability.extra.lastBlindChose then
                            card_eval_status_text(card, 'extra', nil, nil, nil,
                                { message = "Done.", colour = G.C.JOKER_GREY })

                            local _blind = _element.config.blind

                            local par = G.blind_select_opts.boss.parent
                            G.GAME.round_resets.blind_choices.Boss = _blind.key

                            G.blind_select_opts.boss:remove()
                            G.blind_select_opts.boss = UIBox {
                                T = { par.T.x, 0, 0, 0 },
                                definition = {
                                    n = G.UIT.ROOT,
                                    config = {
                                        align = "cm",
                                        colour = G.C.CLEAR
                                    },
                                    nodes = { UIBox_dyn_container({ create_UIBox_blind_choice('Boss') }, false,
                                        get_blind_main_colour('Boss'), mix_colours(G.C.BLACK, get_blind_main_colour('Boss'), 0.8)) }
                                },
                                config = {
                                    align = "bmi",
                                    offset = {
                                        x = 0,
                                        y = G.ROOM.T.y + 9
                                    },
                                    major = par,
                                    xy_bond = 'Weak'
                                }
                            }
                            par.config.object = G.blind_select_opts.boss
                            par.config.object:recalculate()
                            G.blind_select_opts.boss.parent = par
                            G.blind_select_opts.boss.alignment.offset.y = 0

                            for i = 1, #G.GAME.tags do
                                if G.GAME.tags[i]:apply_to_run({
                                        type = 'new_blind_choice'
                                    }) then
                                    break
                                end
                            end

                            card.ability.extra.lastBlindChose = _element.config.blind.key
                            card.ability.extra.allow = false
                            card.ability.extra.active = false
                        end
                    end
                end
            end
        end

        if card.ability.extra.lastEnter ~= love.keyboard.isDown('return') then
            card.ability.extra.lastEnter = love.keyboard.isDown('return')
        end
    end,
	calculate = function(self, card, context)
        if context.end_of_round and context.cardarea == G.jokers then
            if G.GAME.blind.boss then
                card.ability.extra.allow = true
                card.ability.extra.active = false
                return {
                    message = "Back.",
                    colour = G.C.JOKER_GREY
                }
            end
        end
	end,
    in_pool = function(self, args)
		return true, { allow_duplicates = false }
	end
}

-- Donor
SMODS.Atlas {
    key = "Donor",
    path = "bttiDonor1.png",
    px = 71,
    py = 95
}
SMODS.Atlas {
    key = "DonorReal",
    path = "bttiDonor2.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Donor',
    loc_txt = {
        name = 'Friend...?',
        text = {
            "Gains +{C:chips}21{} Chips when triggered",
            "{C:green}1 in 5{} chance to glitch, resetting",
            "{C:chips}Chips{} and turning every card in",
            "{C:attention}played hand{} {C:blue}Digital{}",
            "{C:inactive}Currently +{C:chips}#1#{C:inactive}"
        }
    },

    config = { extra = { chips = 0, keyState = 0 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "You're My Favorite Person", "Juicimated" } }
        if card.ability.extra.keyState == 1 then
            return {
                key = 'bttiJokerDonor_alt',
                set = 'Jokers',
                vars = { card.ability.extra.chips },
            }
        elseif card.ability.extra.keyState == 2 then
            return {
                key = 'bttiJokerDonor_keepName',
                set = 'Jokers',
                vars = { card.ability.extra.chips },
            }
        else
            return {
                key = 'bttiJokerDonor',
                set = 'Jokers',
                vars = { card.ability.extra.chips },
            }
        end
    end,
    rarity = 1,
    atlas = 'Donor',
    pos = { x = 0, y = 0 },
    cost = 4,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_COMMON"] = true, ["BTTI_modAddition_YMFP"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    set_sprites = function(self, card, front)
        if card.ability and card.ability.extra then
            if card.ability.extra.keyState == 1 then
                card.children.center.atlas = G.ASSET_ATLAS['btti_DonorReal']
                card.children.center:set_sprite_pos({ x = 0, y = 0 })
            else
                card.children.center.atlas = G.ASSET_ATLAS['btti_Donor']
                card.children.center:set_sprite_pos({ x = 0, y = 0 })
            end
        end
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            if pseudorandom('Donor') < G.GAME.probabilities.normal / 5 then
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    blocking = false,
                    delay = 0,
                    func = function()
                        sendInfoMessage("You're my favorite person.")
                        card.ability.extra.keyState = 1
                        if G.play and G.play.cards then
                            if #G.play.cards >= 2 then
                                for i = 1, #G.play.cards do
                                    G.play.cards[i]:set_edition()
                                    G.play.cards[i]:set_edition('e_btti_digital')
                                    G.play.cards[i]:juice_up()
                                end
                            end
                        end
                        card.ability.extra.chips = 0
                        card:juice_up()
                        card.children.center.atlas = G.ASSET_ATLAS['btti_DonorReal']
                        card.children.center:set_sprite_pos({ x = 0, y = 0 })
                        return true
                    end,
                }))
            else
                card.ability.extra.chips = card.ability.extra.chips + 21
                return {
                    chips = card.ability.extra.chips,
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        blocking = false,
                        delay = 0,
                        func = function()
                            --sendInfoMessage("Back!")
                            if card.ability.extra.keyState == 1 then
                                card.ability.extra.keyState = 2
                            end
                            card:juice_up()
                            card.children.center.atlas = G.ASSET_ATLAS['btti_Donor']
                            card.children.center:set_sprite_pos({ x = 0, y = 0 })
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

SMODS.Atlas {
    key = "MissBreward",
    path = "bttiMsBreward.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'MissBreward',
    loc_txt = {
        name = 'Miss Breward',
        text = {
            "Gains {X:mult,C:white}X0.25{} Mult",
            "per {C:deets}Stained Card{} leak",
            "{C:inactive}Currently {X:mult,C:white}X#1#{C:inactive}"
        }
    },

    config = { extra = { xmult = 1} },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "You're My Favorite Person", "Juicimated" } }
        return {
            vars = { card.ability.extra.xmult },
        }
    end,
    rarity = 2,
    atlas = 'MissBreward',
    pos = { x = 0, y = 0 },
    cost = 4,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_UNCOMMON"] = true, ["BTTI_modAddition_YMFP"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
        if context.card_leaked then
            card.ability.extra.xmult = card.ability.extra.xmult + 0.25
            return {
                message = "Upgrade!",
                colour = G.C.BTTIDEETS
            }
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

SMODS.Atlas {
    key = "FrickinFunBand",
    path = "bttiFrickinFunBand.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'FrickinFunBand',
    loc_txt = {
        name = 'Frickin\' Fun Band',
        text = {
            "Avoiding playing with a {V:1}#1#",
            "will grant you a {C:attention}card{} of that suit",
            "Suit changes at the start of {C:attention}round{}",
        }
    },

    config = { extra = { suit = "Spades", grant = true } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "You're My Favorite Person", "Juicimated" } }
        return {
            vars = { localize(card.ability.extra.suit, 'suits_singular'), colours = { G.C.SUITS[card.ability.extra.suit] } },
        }
    end,
    rarity = 1,
    atlas = 'FrickinFunBand',
    pos = { x = 0, y = 0 },
    cost = 4,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_COMMON"] = true, ["BTTI_modAddition_YMFP"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.before then
            for i = 1, #G.play.cards do
                if G.play.cards[i]:is_suit(card.ability.extra.suit) then
                    card.ability.extra.grant = false
                end
            end
        end
        if context.end_of_round and context.cardarea == G.jokers then
            if card.ability.extra.grant then
                return {
                    message = "Hooray!",
                    colour = G.C.RED,
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        blocking = false,
                        delay = 0,
                        func = function()
                            SMODS.add_card({ set = 'Playing Card', suit = card.ability.extra.suit, area = G.deck })
                            return true
                        end,
                    }))
                }
            else
                card.ability.extra.grant = true
            end
        end
        if context.setting_blind then
            local suits = {}
            for k, v in ipairs({ 'Spades', 'Hearts', 'Clubs', 'Diamonds' }) do
                if v ~= card.ability.extra.suit then suits[#suits + 1] = v end
            end
            local c = pseudorandom_element(suits, 'Tanner' .. G.GAME.round_resets.ante)
            card.ability.extra.suit = c
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

-- Spoingus
SMODS.Atlas {
    key = "Spoingus",
    path = "bttiSpoingus.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Spoingus',
    loc_txt = {
        name = 'Spoingus',
        text = {
            "Spoingus"
        }
    },

    config = { extra = { effect = 1 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "You're My Favorite Person", "Juicimated, BlueBen8" } }
        return {
            vars = { },
        }
    end,
    rarity = 'btti_spoingus',
    atlas = 'Spoingus',
    pos = { x = 0, y = 0 },
    cost = 4,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_YMFP"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.first_hand_drawn then
            if card.ability.extra.effect == nil then
                card.ability.extra.effect = 1
            end
			if card.ability.extra.effect == 1 then
                if #G.jokers.cards > 1 then
                    local rarities = {
                        [1] = 'Common',
                        [2] = 'Uncommon',
                        [3] = 'Rare',
                        [4] = 'Legendary'
                    }
                    local idx
                    repeat
                        idx = pseudorandom("btti_" .. card.ability.name, 1, #G.jokers.cards)
                    until idx ~= getJokerID(card)
                    local randJk  = G.jokers.cards[idx]
                    SMODS.add_card {
                        set = 'Joker',
                        rarity = rarities[pseudorandom("btti_" .. card.ability.name, 1, 4)],
                        edition = (randJk.edition and randJk.edition.key) or nil,
                        enhancement = nil
                    }
                    SMODS.destroy_cards(randJk)
                end
			elseif card.ability.extra.effect == 2 then
				for i = 1, #G.hand.cards do
					G.E_MANAGER:add_event(Event({
						trigger = 'immediate',
						blocking = false,
						delay = 0,
						func = function()
							local randomEnhancement = SMODS.poll_enhancement {key = "spoingus", guaranteed = true}
							G.hand.cards[i]:set_ability(randomEnhancement)
							G.hand.cards[i]:juice_up()
                            delay(0.1)
							return true
						end,
					}))
				end
			elseif card.ability.extra.effect == 3 then
				for i = 1, #G.hand.cards do
					G.E_MANAGER:add_event(Event({
						trigger = 'immediate',
						blocking = false,
						delay = 0,
						func = function()
							local reversed = {
								[2]  = 14, -- 2 -> Ace
								[3]  = 13, -- 3 -> King
								[4]  = 12, -- 4 -> Queen
								[5]  = 11, -- 5 -> Jack
								[6]  = 9,  -- 6 -> 9
								[7]  = 8,  -- 7 -> 8
								[8]  = 7,  -- 8 -> 7
								[9]  = 6,  -- 9 -> 6
								[10] = 10, -- 10 stays 10
								[11] = 5,  -- Jack -> 5
								[12] = 4,  -- Queen -> 4
								[13] = 3,  -- King -> 3
								[14] = 2,  -- Ace -> 2
							}
							local id = G.hand.cards[i]:get_id()
							local reversedId = reversed[id]

                            G.hand.cards[i]:set_rank(reversedId)
							G.hand.cards[i]:juice_up()
							return true
						end,
					}))
                end
            elseif card.ability.extra.effect == 4 then
                local randCard = G.deck.cards[pseudorandom("btti_" .. card.ability.name, 1, #G.deck.cards)]
                SMODS.add_card {
                    set = 'Playing Card',
                    edition = (randCard.edition and randCard.edition.key) or nil,
                    enhancement = next(SMODS.get_enhancements(randCard)),
                    area = G.deck,
                    seal = randCard.seal
                }
                SMODS.destroy_cards(randCard)
            elseif card.ability.extra.effect == 6 then
                G.GAME.btti_dvdLogoAlpha = 1.0
            elseif card.ability.extra.effect == 8 then
                G.BTTI.fakeCrash:turnOn()
            end
            return { message = "Spoingus" }
		end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}


--#endregion

-- REGALITY JOKERS
--#region REGALITY JOKRES

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
            "{C:inactive}Currently {X:mult,C:white}x#2#{C:inactive} Mult, {X:mult,C:white}#3#{} Mult"
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
            "{C:inactive}Currently {C:chips}+#2#{} Chips, {C:mult}+#3#{} Mult"
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

--#endregion

-- SCOLOISIS MAN JOKERS
--#region SCOLOISIS MAN JOKERS

-- Goop
SMODS.Atlas {
    key = "Goop",
    path = "bttiGoop.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Goop',
    loc_txt = {
        name = 'Goop',
        text = {
            "{C:chips}+70{} Chips, {C:chips}-5{} Chips per {C:attention}hand played",
            "At {C:chips}0{} Chips, {C:mult}+30{} Mult. {C:mult}-1{} Mult per {C:attention}hand played",
            "{C:inactive}\"Please don't sell me when I am out of",
            "{C:mult}Mult{C:inactive}, I am just {C:green}Goop{C:inactive}\"",
            "{C:inactive}Currently {C:chips}+#1#{C:inactive} Chips, {C:mult}+#2#{C:inactive} Mult"
        }
    },

    config = { extra = { chips = 70, mult = 30 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Scoliosis Man", "BlueBen8" } }
        return {
            vars = { card.ability.extra.chips, card.ability.extra.mult },
        }
    end,
    rarity = 2,
    atlas = 'Goop',
    pos = { x = 0, y = 0 },
    cost = 5,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_UNCOMMON"] = true, },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.clicked_card and context.clicked_card == card and context.card_highlighted == true then
            if card.ability.extra.chips <= 0 and card.ability.extra.mult <= 0 then
                local idx = pseudorandom("btti_" .. card.ability.name, 1, #G.jokers.cards)
                sendInfoMessage("GOOP CLICKED " .. idx .. "", "BTTI")
                if idx ~= getJokerID(card) then
                    card.area:remove_from_highlighted(card)
                    G.jokers:shuffle('aajk')
                    play_sound('cardSlide1', 0.85)
                    card_eval_status_text(card, 'extra', nil, nil, nil,
                        { message = "NOOO PLEASE", colour = G.C.GREEN })
                end
            end
        end

        if context.joker_main then
            if card.ability.extra.chips > 0 then
                return {
                    message = "+ " .. card.ability.extra.chips,
                    colour = G.C.CHIPS,
                    chip_mod = card.ability.extra.chips,
                }
            elseif card.ability.extra.chips <= 0 and card.ability.extra.mult > 0 then
                return {
                    message = "+ " .. card.ability.extra.mult,
                    colour = G.C.MULT,
                    mult_mod = card.ability.extra.mult,
                }
            end
        end

        if context.final_scoring_step and context.cardarea == G.jokers then
            if card.ability.extra.chips > 0 then
                card.ability.extra.chips = card.ability.extra.chips - 5
                return {
                    message = "-5 Chips",
                    colour = G.C.CHIPS,
                }
            elseif card.ability.extra.chips <= 0 and card.ability.extra.mult > 0 then
                card.ability.extra.mult = card.ability.extra.mult - 1
                return {
                    message = "-1 Mult",
                    colour = G.C.MULT,
                }
            end
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

SMODS.Atlas {
    key = "Checkpoint",
    path = "bttiCheckpoint.png",
    px = 71,
    py = 95
}
SMODS.Joker {
	key = 'Checkpoint',
	loc_txt = {
		name = 'Checkpoint',
		text = {
			"Saves the first {C:attention}played hand{} of round",
            "and adds triple its {C:attention}score{} to {C:attention}final hand{}",
            "{C:inactive}Currently {C:mult}+#1#{} Mult, {C:chips}+#2#{} Chips"
		}
	},

	config = { extra = { smult = 0, schips = 0, firstHand = false } },
	loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Scoliosis Man", "BlueBen8" } }
		return {
            vars = { card.ability.extra.smult, card.ability.extra.schips },
        }
	end,
	rarity = 1,
    atlas = 'Checkpoint',
	pos = { x = 0, y = 0 },
	cost = 5,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_COMMON"] = true, },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

	calculate = function(self, card, context)
		if context.final_scoring_step then
            if not card.ability.extra.firstHand then
                card.ability.extra.schips = hand_chips
                card.ability.extra.smult = mult
                card.ability.extra.firstHand = true
                return {
                    message = "Saved!",
                    colour = G.C.GREEN
                }
            end
		end

        if context.joker_main and G.GAME.current_round.hands_left == 0 then
            return {
                chips = card.ability.extra.schips,
                mult = card.ability.extra.smult
            }
        end

        if context.end_of_round then
             card.ability.extra.firstHand = false
        end
	end,
    in_pool = function(self, args)
		return true, { allow_duplicates = false }
	end
}

--#endregion

-- AOTA JOKERS
--#region AOTA JOKERS

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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "AOTA", "BlueBen8" } }
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
            "{C:inactive}Currently {X:mult,C:white}X#1#{C:inactive} Mult"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "AOTA", "BlueBen8" } }
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "AOTA", "BlueBen8" } }
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

--#endregion

-- CREATICA JOKERS
--#region CREATICA JOKERS

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
			"Upgrades played {C:attention}Kings{}",
            "and {C:attention}Queens{} by",
            "{C:chips}+0-117{} chips"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Creaticas", "Juicimated" } }
		return {
            vars = { },
        }
	end,
	rarity = 3,
	atlas = 'Joozie',
	pos = { x = 0, y = 0 },
	cost = 6,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_RARE"] = true, ["BTTI_modAddition_CREATICA"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    update = function(self, card, dt)
        card.ability.eternal = true
    end,

	calculate = function(self, card, context)
		if context.cardarea == G.play and context.individual and context.other_card then
            local _trigger = false
            if context.other_card:get_id() == 12 then _trigger = true end --Queens
            if context.other_card:get_id() == 13 then _trigger = true end --Kings
            if _trigger then
                context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus + pseudorandom("btti_" .. card.ability.name, 0, 117)
                context.other_card:juice_up()
                return {
                    message = "Upgrade!"
                }
            end
		end

	end,
    in_pool = function(self, args)
		return true, { allow_duplicates = false }
	end
}

-- Aubree
SMODS.Atlas {
    key = "Aubree",
    path = "bttiAubree.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Aubree',
    loc_txt = {
        name = 'Aubree',
        text = {
            "{C:attention}+1 Joker Slot{}",
            "every time you defeat a",
            "{C:attention}Boss Blind"
        }
    },

    config = { card_limit = 1, extra = {} },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Creaticas", "LightShine, Juicimated" } }
        return {
            vars = {},
        }
    end,
    rarity = 3,
    atlas = 'Aubree',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_RARE"] = true, ["BTTI_modAddition_CREATICA"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    update = function(self, card, dt)
        card.ability.eternal = true
    end,

    calculate = function(self, card, context)
        if context.ante_change and context.ante_end then
            return {
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    blocking = false,
                    delay = 0,
                    func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil,
                            { message = "Fine...", colour = G.C.RED })
                        card:juice_up()
                        card.ability.card_limit = card.ability.card_limit + 1
                        G.jokers:change_size(1)
                        return true
                    end,
                }))
            }
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

-- Kyuu
SMODS.Atlas {
    key = "Kyuu",
    path = "bttiKyuu.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Kyuu',
    loc_txt = {
        name = 'Kyuu',
        text = {
            "Levels up your most played {C:attention}poker hand{}",
            "twice after beating a {C:attention}Boss Blind{}"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Creaticas", "hatoving, Juicimated" } }
        return {
            vars = {},
        }
    end,
    rarity = 3,
    atlas = 'Kyuu',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_RARE"] = true, ["BTTI_modAddition_CREATICA"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    update = function(self, card, dt)
        card.ability.eternal = true
    end,

    calculate = function(self, card, context)
        if context.ante_change and context.ante_end then
            return {
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    blocking = false,
                    delay = 0,
                    func = function()
                        local _handname, _played = 'High Card', -1
                        for hand_key, hand in pairs(G.GAME.hands) do
                            if hand.played > _played then
                                _played = hand.played
                                _handname = hand_key
                            end
                        end
                        local most_played = _handname
                        SMODS.smart_level_up_hand(card, most_played, nil, 2)
                        return true
                    end,
                }))
            }
        end

    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

-- Cacaa
SMODS.Atlas {
    key = "Cacaa",
    path = "bttiCacaa.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Cacaa',
    loc_txt = {
        name = 'Cacaa',
        text = {
            "Played {C:hearts}Hearts{}, {C:diamonds}Diamonds",
            "and {C:clubs}Clubs{} each give {C:attention}$2"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Creaticas", "ca850, Juicimated" } }
        return {
            vars = {},
        }
    end,
    rarity = 3,
    atlas = 'Cacaa',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_RARE"] = true, ["BTTI_modAddition_CREATICA"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    update = function(self, card, dt)
        card.ability.eternal = true
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.play and context.individual and context.other_card then
            local _trigger = false
            if context.other_card:is_suit('Hearts') then _trigger = true end
            if context.other_card:is_suit('Diamonds') then _trigger = true end
            if context.other_card:is_suit('Clubs') then _trigger = true end
            if _trigger then
                context.other_card:juice_up()
                return {
                    dollars = 2
                }
            end
        end

    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

-- Cosmyy
SMODS.Atlas {
    key = "Cosmyy",
    path = "bttiCosmyy.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Cosmyy',
    loc_txt = {
        name = 'Cosmyy',
        text = {
            "{C:mult}+2{} Mult per {C:diamonds}Diamond{} in {C:attention}full deck{}",
            "{C:green}1 in 3{} chance to clone {C:attention}played",
            "cards{} with a {C:diamonds}Diamond{} suit",
            "{C:inactive}Currently {C:mult}+#1#{C:inactive} Mult"
        }
    },

    config = { extra = { mult = 1 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Creaticas", "BlueBen8, Juicimated" } }
        local cardCount = 0
        if G.deck and G.deck.cards then
            for i, pc in ipairs(G.deck.cards) do
                if pc:is_suit('Diamonds') then
                    cardCount = cardCount + 1
                end
            end
        end
        return {
            vars = { card.ability.extra.mult * cardCount },
        }
    end,
    rarity = 3,
    atlas = 'Cosmyy',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_RARE"] = true, ["BTTI_modAddition_CREATICA"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    update = function(self, card, dt)
        card.ability.eternal = true
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.play and context.individual and context.other_card then
            local cardCount = 0
            if G.deck and G.deck.cards then
                for i, pc in ipairs(G.deck.cards) do
                    if pc:is_suit('Diamonds') then
                        cardCount = cardCount + 1
                    end
                end
            end
            if pseudorandom('Cosmyy') < G.GAME.probabilities.normal / 3 then
                return SMODS.merge_effects {
                    {
                        G.E_MANAGER:add_event(Event({
                            trigger = 'immediate',
                            blocking = false,
                            delay = 0,
                            func = function()
                                for i, pc in ipairs(G.play.cards) do
                                    if pc:is_suit('Diamonds') then
                                        local c = SMODS.add_card {
                                            key = 'Playing Card',
                                            suit = 'Diamonds',
                                            rank = pc.base.value,
                                            edition = (pc.edition and pc.edition.key) or nil,
                                            enhancement = pc.config.center.key,
                                            seal = pc.seal,
                                            area = G.deck
                                        }
										SMODS.calculate_context { playing_card_added = true, blueprint = false, cards = {c} }
                                    end
                                end
                                card:juice_up()
                                return true
                            end,
                        }))
                    },
                    {
                        mult = card.ability.extra.mult * cardCount
                    }
                }
            end
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

--#endregion

-- DIRECTOR JOKERS
--#region DIRECTOR JOKERS

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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Real Life", "BlueBen8" } }
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Real Life", "hatoving, BlueBen8" } }
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
            "{C:inactive}Currently {C:mult}+#1#{} Mult and {C:chips}+#2#{} Chips"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Real Life", "hatoving" } }
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Real Life", "BlueBen8" } }
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Real Life", "BlueBen8" } }
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

--#endregion
