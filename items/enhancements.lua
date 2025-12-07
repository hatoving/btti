-- Stained Card
SMODS.Atlas {
    key = "stainedCard",
    path = "bttistainedCard.png",
    px = 71,
    py = 95
}
SMODS.Enhancement {
    key = 'stainedCard',
    loc_txt = {
        name = 'Stained Card',
        text = {
            "{C:green}1 in 2{} chance to {C:deets}leak{} into the",
            "card to its right, triggering it",
            "once before that card is triggered"
        }
    },
    atlas = 'stainedCard',
    pos = { x = 0, y = 0 },
    config = { },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "You're My Favorite Person", "Juicimated" } }
        return { vars = { } }
    end,
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            if pseudorandom('MsBreward') < G.GAME.probabilities.normal / 2 then
                local selfID = 0
                local rets = {
                    
                }
                for i = 1, #context.scoring_hand do
                    if context.scoring_hand[i] == card then
                        selfID = i
                        break
                    end
                end
                sendInfoMessage("checking... (" .. selfID .. ", " .. selfID + 1 .. ")", "BTTI")
                if context.scoring_hand[selfID + 1] ~= nil then
                    local pc = context.scoring_hand[selfID + 1]
                    table.insert(rets, {
                        message = "Leak!",
                        colour = G.C.DEETS,
                        func = function()
                            SMODS.calculate_context { card_leaked = pc }
                        end
                    })
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
                    sendInfoMessage("found card!", "BTTI")
                    if pc.seal ~= nil then         
                        sendInfoMessage("stained: " .. pc.seal .. "", "BTTI")
                        table.insert(rets, {
                            message = "Leak!",
                            colour = G.C.DEETS,
                            func = function()
                                pc:juice_up(0.3, 0.5)
                                SMODS.calculate_context { card_leaked = pc }
                            end
                        })
                        if pc.seal == "Gold" then
                            table.insert(rets, {
                                dollars = 3,
                                colour = G.C.MONEY
                            })
                        end
                    end
                    if SMODS.has_enhancement(pc, 'm_lucky') then
                        local ret = {}
                        if pseudorandom('MsBreward') < G.GAME.probabilities.normal / 5 then
                            pc.lucky_trigger = true
                            ret.mult = pc.ability.extra.mult
                        end
                        if pseudorandom('MsBreward') < G.GAME.probabilities.normal / 15 then
                            pc.lucky_trigger = true
                            ret.dollars = pc.ability.extra.dollars
                        end
                        table.insert(rets, ret)
                    end
                    return SMODS.merge_effects(rets)
                end
            else
                return {}
            end
        end
    end
}

-- Horse Card
SMODS.Atlas {
    key = "horseCard",
    path = "bttiHorseCard.png",
    px = 71,
    py = 95
}
SMODS.Enhancement {
    key = 'horseCard',
    loc_txt = {
        name = 'Horse Card',
        text = {
            "Has no Suit or Rank",
            "{C:chips}+#1#{} Chips",
        }
    },
    atlas = 'horseCard',
    pos = { x = 0, y = 0 },
    config = { bonus = 75 },
    replace_base_card = true,
    no_rank = true,
    no_suit = true,
    always_scores = true,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "DEETS", "BlueBen8" } }
        return { vars = { card.ability.bonus } }
    end,
}
