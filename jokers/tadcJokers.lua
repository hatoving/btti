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
            "{C:chips}+15{} Chips and {C:mult}+4{} Mult",
            "Gains {C:chips}+15{} Chips and {C:mult}+4{} Mult",
            "at the end of each {C:attention}Ante",
            "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips, {C:mult}+#2#{C:inactive} Mult)"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "The Amazing Digital Circus", "Gooseworx, GLITCH", "Juicimated" } }
        return {
            vars = { card.ability.extra.chips, card.ability.extra.mult },
        }
    end,
    rarity = 3,
    atlas = 'Pomni',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_RARE"] = true, ["BTTI_modAddition_MEDIA"] = true },

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
            "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "The Amazing Digital Circus", "Gooseworx, GLITCH", "Juicimated" } }
        return {
            vars = { card.ability.extra.mult },
        }
    end,
    rarity = 2,
    atlas = 'Jax',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_UNCOMMON"] = true, ["BTTI_modAddition_MEDIA"] = true },

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
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "The Amazing Digital Circus", "Gooseworx, GLITCH", "Juicimated" } }
        return {
            vars = { },
        }
    end,
    rarity = 3,
    atlas = 'Caine',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_RARE"] = true, ["BTTI_modAddition_MEDIA"] = true },

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