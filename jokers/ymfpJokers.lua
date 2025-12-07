SMODS.Font({ 
    key = "w95",
    path = "bttiW95.ttf"
})

-- Y/N
function G.FUNCS.joker_can_activate_yin(e)
    local card = e.config.ref_table
    if card.ability.extra.allow and G.STATE == G.STATES.BLIND_SELECT and not G.SETTINGS.paused then
        e.config.colour = G.C.BLUE
        e.config.button = "joker_activate_yin"
    else
      e.config.colour = G.C.UI.BACKGROUND_INACTIVE
      e.config.button = nil
    end
end
function G.FUNCS.joker_activate_yin(e)
    local card = e.config.ref_table
    if card.ability.extra.allow and G.STATE == G.STATES.BLIND_SELECT and not G.SETTINGS.paused then
        card.ability.extra.active = not card.ability.extra.active
        card:juice_up()
        local msg = (card.ability.extra.active and 'Active.') or 'Inactive.'
        card_eval_status_text(card, 'extra', nil, nil, nil,
            { message = msg, colour = G.C.JOKER_GREY })
    end
end
SMODS.Atlas {
    key = "YIN",
    path = "bttiYIN.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'YIN',
	loc_txt = {
		name = '{f:btti_w95}Y/N',
		text = {
			"Press {C:blue}ENTER{} while this {C:attention}Joker{} is",
            "highlighted and activated to select a new",
            "{C:attention}Boss Blind{} from your collection",
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "You're My Favorite Person", "Juicimated", "Juicimated" } }
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

-- Friend
SMODS.Atlas {
    key = "Friend",
    path = "bttiFriend1.png",
    px = 71,
    py = 95
}
SMODS.Atlas {
    key = "FriendReal",
    path = "bttiFriend2.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Friend',
    loc_txt = {
        name = '{f:btti_w95}Friend...?',
        text = {
            "Gains +{C:chips}21{} Chips when triggered",
            "{C:green}1 in 5{} chance to glitch, resetting",
            "{C:chips}Chips{} and turning every card in",
            "{C:attention}played hand{} {C:blue}Digital{}",
            "{C:inactive}(Currently +{C:chips}#1#{C:inactive})"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "You're My Favorite Person", "Juicimated", "Juicimated" } }
        if card.ability.extra.keyState == 1 then
            return {
                key = 'bttiJokerFriend_alt',
                set = 'Jokers',
                vars = { card.ability.extra.chips },
            }
        elseif card.ability.extra.keyState == 2 then
            return {
                key = 'bttiJokerFriend_keepName',
                set = 'Jokers',
                vars = { card.ability.extra.chips },
            }
        else
            return {
                key = 'bttiJokerFriend',
                set = 'Jokers',
                vars = { card.ability.extra.chips },
            }
        end
    end,
    rarity = 1,
    atlas = 'Friend',
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
                card.children.center.atlas = G.ASSET_ATLAS['btti_FriendReal']
                card.children.center:set_sprite_pos({ x = 0, y = 0 })
            else
                card.children.center.atlas = G.ASSET_ATLAS['btti_Friend']
                card.children.center:set_sprite_pos({ x = 0, y = 0 })
            end
        end
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            if pseudorandom('Friend') < G.GAME.probabilities.normal / 5 then
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
                        card.children.center.atlas = G.ASSET_ATLAS['btti_FriendReal']
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
                            card.children.center.atlas = G.ASSET_ATLAS['btti_Friend']
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
        name = '{f:btti_w95}Miss Breward',
        text = {
            "Gains {X:mult,C:white}X0.25{} Mult",
            "per {C:deets}Stained Card{} leak",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive})"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "You're My Favorite Person", "Juicimated", "Juicimated" } }
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
        name = '{f:btti_w95}Frickin\' Fun Band',
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "You're My Favorite Person", "Juicimated", "Juicimated" } }
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
        name = '{f:btti_w95}Spoingus',
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "You're My Favorite Person", "Juicimated, BlueBen8", "Juicimated" } }
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