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
            "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
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