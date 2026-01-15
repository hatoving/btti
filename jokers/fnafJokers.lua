-- Springtrap
SMODS.Sound({ key = "Springtrap", path = "bttiSpringtrap.ogg" })
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Five Nights at Freddy's", "Scott Cawthon", "hatoving" } }
        return {
            vars = {},
        }
    end,
    rarity = 2,
    atlas = 'Springtrap',
    pos = { x = 0, y = 0 },
    cost = 5,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_UNCOMMON"] = true, ["BTTI_modAddition_GAME"] = true },

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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "Five Nights at Freddy's", "Markiplier", "Juicimated" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.chips },
        }
    end,
    rarity = 1,
    atlas = 'BiteOf87',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_COMMON"] = true, ["BTTI_modAddition_GAME"] = true },

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