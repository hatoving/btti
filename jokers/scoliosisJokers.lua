SMODS.Font({ 
    key = "vcr", 
    path = "bttiVcr.ttf"
})

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
        name = '{f:btti_vcr}Goop',
        text = {
            "{C:chips}+70{} Chips, {C:chips}-5{} Chips per {C:attention}hand played",
            "At {C:chips}0{} Chips, {C:mult}+30{} Mult. {C:mult}-1{} Mult per {C:attention}hand played",
            "{C:inactive}\"Please don't sell me when I am out of",
            "{C:mult}Mult{C:inactive}, I am just {C:green}Goop{C:inactive}\"",
            "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips, {C:mult}+#2#{C:inactive} Mult)"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Scoliosis Man", "BlueBen8", "BlueBen8" } }
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
		name = '{f:btti_vcr}Checkpoint',
		text = {
			"Saves the first {C:attention}played hand{} of round",
            "and adds triple its {C:attention}score{} to {C:attention}final hand{}",
            "{C:inactive}(Currently {C:mult}+#1#{} Mult, {C:chips}+#2#{} Chips)"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Scoliosis Man", "BlueBen8", "BlueBen8" } }
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