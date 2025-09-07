-- Orange Seal
SMODS.Atlas {
    key = "orangeSeal",
    path = "bttiOrangeSeal.png",
    px = 71,
    py = 95
}
SMODS.Seal {
    name = "orangeSeal",
    key = "orangeSeal",
    badge_colour = G.C.ORANGE,
    config = { },
    loc_txt = {
        -- Badge name (displayed on card description when seal is applied)
        label = 'Orange Seal',
        -- Tooltip description
        name = '{C:attention}Orange Seal',
        text = {
            "Adds {C:green}50%{} of this card's",
            "{C:chips}Chips{} to score if hand",
            "contains only {C:attention}Orange Seals{},",
            "Otherwise {C:red}-50%{}"
        }
    },

    loc_vars = function(self, info_queue)
        return { vars = { } }
    end,
    atlas = "orangeSeal",
    pos = { x = 0, y = 0 },
    pools = { ["BTTI_modAddition_seals"] = true },

    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            local all_orange = true
            local half = card:get_chip_bonus() / 2

            for i, pc in ipairs(G.play.cards) do
                if pc.seal ~= "btti_orangeSeal" then
                    all_orange = false
                    break
                end
            end

            if all_orange then
                return {
                    chips = half
                }
            else
                return {
                    chips = -half
                }
            end
        end
    end
}

-- Autism Seal
SMODS.Atlas {
    key = "autismSeal",
    path = "bttiAutismSeal.png",
    px = 71,
    py = 95
}
SMODS.Seal {
    name = "autismSeal",
    key = "autismSeal",
    badge_colour = G.C.BTTIGAY,
    config = { },
    loc_txt = {
        -- Badge name (displayed on card description when seal is applied)
        label = 'Autism Seal',
        -- Tooltip description
        name = '{C:gay}Autism Seal',
        text = {
            "Copy seals of other cards in {C:attention}played hand{}",
            "Halve chips of cards without seals in",
            "{C:attention}played hand{}"
        }
    },
    pools = { ["BTTI_modAddition_seals"] = true },

    loc_vars = function(self, info_queue)
        return { vars = { } }
    end,
    atlas = "autismSeal",
    pos = { x = 0, y = 0 },


    calculate = function(self, card, context)
        if context.other_card and context.other_card.seal ~= nil then
        elseif context.other_card and context.other_card.seal == nil then
        end

        if context.main_scoring and context.cardarea == G.play then
            local rets = {
            }
            for i, pc in ipairs(G.play.cards) do
                if pc.seal ~= nil then         
                    sendInfoMessage("lol: " .. pc.seal .. "", "BTTI")
                    table.insert(rets, {
                        message = "Autism!",
                        colour = G.C.BLUE,
                        func = function()
                            pc:juice_up(0.3, 0.5)
                        end
                    })
                    if pc.seal == "Red" then
                        local ch = pc:get_chip_bonus()
                        local mult = pc:get_chip_mult()
                        local xMult = pc:get_chip_x_mult()
                        if ch > 0 then
                            table.insert(rets, {
                                chips = ch,
                                colour = G.C.CHIPS
                            })
                        end
                        if mult > 0 then
                            table.insert(rets, {
                                mult = mult,
                                colour = G.C.MULT
                            })
                        end
                        if xMult > 0 then
                            table.insert(rets, {
                                x_mult = xMult,
                                colour = G.C.MULT
                            })
                        end
                    elseif pc.seal == "Gold" then
                        table.insert(rets, {
                            dollars = 3,
                            colour = G.C.MONEY
                        })
                    elseif pc.seal == "Blue" then
                        table.insert(rets, {
                            func = function ()
                                SMODS.add_card {
                                    set = "Planet",
                                    key_append = "autismSeal"
                                }
                            end
                        })
                    elseif pc.seal == "Purple" then
                        table.insert(rets, {
                            func = function()
                                SMODS.add_card {
                                    set = "Tarot",
                                    key_append = "autismSeal"
                                }
                            end
                        })
                    end
                else
                    table.insert(rets, {
                        chips = math.ceil((pc:get_chip_bonus() / 2) * -1),
                        func = function()
                            pc:juice_up(0.3, 0.5)
                        end
                    })
                end
            end
            return SMODS.merge_effects(rets)
        end
    end,
}