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
            "{C:inactive}(Currently {C:mult}+#2#{} {C:inactive}Mult)"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Family Guy", "Seth McFarlane", "hatoving" } }
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
            "{C:inactive}(Currently {X:chips,C:white}X#2#{C:inactive} Chips)"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Family Guy", "Seth McFarlane", "hatoving" } }
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