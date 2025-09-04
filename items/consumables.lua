--#region Planet Cards

--#region DEETS Planets

-- Mysticalia
SMODS.Atlas {
    key = "mysticalia",
    path = "bttiMysticalia.png", -- placeholder
    px = 65,
    py = 95
}
SMODS.Consumable {
    key = "mysticalia",
    set = "Planet",
    cost = 10,
    pos = { x = 0, y = 0 },
    config = { hand_type = 'HighHorse' },
    loc_txt = {
        name = "Mysticalia",
        text = {
            "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
            "{C:attention}#2#",
            "{C:mult}+#3#{} Mult and",
            "{C:chips}+#4#{} chips", --idk how to change the values but it oughta be +2 mult and +20 chips
        },
    },
    pools = { ["BTTI_modAddition_planets"] = true, ["BTTI_modAddition_DEETSPlanets"] = true },
    atlas = 'mysticalia',
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                G.GAME.hands[card.ability.hand_type].level,
                localize(card.ability.hand_type, 'poker_hands'),
                G.GAME.hands[card.ability.hand_type].l_mult,
                G.GAME.hands[card.ability.hand_type].l_chips,
                colours = { (G.GAME.hands[card.ability.hand_type].level == 1 and G.C.UI.TEXT_DARK or G.C.HAND_LEVELS[math.min(7, G.GAME.hands[card.ability.hand_type].level)]) }
            }
        }
    end,
    in_pool = function (self, args)
        return G.GAME.hands[card.ability.hand_type].visible
    end
}

-- Pedast
SMODS.Atlas {
    key = "pedast",
    path = "bttiPedast.png", -- placeholder
    px = 65,
    py = 95
}
SMODS.Consumable {
    key = "pedast",
    set = "Planet",
    cost = 10,
    pos = { x = 0, y = 0 },
    config = { hand_type = 'TwoHorse' },
    loc_txt = {
        name = "Pedast",
        text = {
            "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
            "{C:attention}#2#",
            "{C:mult}+#3#{} Mult and",
            "{C:chips}+#4#{} chips", --idk how to change the values but it oughta be +2 mult and +20 chips
        },
    },
    pools = { ["BTTI_modAddition_planets"] = true, ["BTTI_modAddition_DEETSPlanets"] = true },
    atlas = 'pedast',
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                G.GAME.hands[card.ability.hand_type].level,
                localize(card.ability.hand_type, 'poker_hands'),
                G.GAME.hands[card.ability.hand_type].l_mult,
                G.GAME.hands[card.ability.hand_type].l_chips,
                colours = { (G.GAME.hands[card.ability.hand_type].level == 1 and G.C.UI.TEXT_DARK or G.C.HAND_LEVELS[math.min(7, G.GAME.hands[card.ability.hand_type].level)]) }
            }
        }
    end,
    in_pool = function(self, args)
        return G.GAME.hands[card.ability.hand_type].visible
    end
}

-- Trihooft
SMODS.Atlas {
    key = "trihooft",
    path = "bttiTrihooft.png", -- placeholder
    px = 65,
    py = 95
}
SMODS.Consumable {
    key = "trihooft",
    set = "Planet",
    cost = 3,
    pos = { x = 0, y = 0 },
    config = { hand_type = 'ThreeHorse' },
    loc_txt = {
        name = "Trihooft",
        text = {
            "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
            "{C:attention}#2#",
            "{C:mult}+#3#{} Mult and",
            "{C:chips}+#4#{} chips", --idk how to change the values but it oughta be +2 mult and +20 chips
        },
    },
    pools = { ["BTTI_modAddition_planets"] = true, ["BTTI_modAddition_DEETSPlanets"] = true },
    atlas = 'trihooft',
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                G.GAME.hands[card.ability.hand_type].level,
                localize(card.ability.hand_type, 'poker_hands'),
                G.GAME.hands[card.ability.hand_type].l_mult,
                G.GAME.hands[card.ability.hand_type].l_chips,
                colours = { (G.GAME.hands[card.ability.hand_type].level == 1 and G.C.UI.TEXT_DARK or G.C.HAND_LEVELS[math.min(7, G.GAME.hands[card.ability.hand_type].level)]) }
            }
        }
    end,
    in_pool = function(self, args)
        return G.GAME.hands[card.ability.hand_type].visible
    end
}

-- Apocalypt
SMODS.Atlas {
    key = "apocalypt",
    path = "bttiApocalypt.png", -- placeholder
    px = 65,
    py = 95
}
SMODS.Consumable {
    key = "apocalypt",
    set = "Planet",
    cost = 20,
    pos = { x = 0, y = 0 },
    config = { hand_type = 'FourHorsemen' },
    loc_txt = {
        name = "Apocalypt",
        text = {
            "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
            "{C:attention}#2#",
            "{C:mult}+#3#{} Mult and",
            "{C:chips}+#4#{} chips", --idk how to change the values but it oughta be +2 mult and +20 chips
        },
    },
    pools = { ["BTTI_modAddition_planets"] = true, ["BTTI_modAddition_DEETSPlanets"] = true },
    atlas = 'apocalypt',
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                G.GAME.hands[card.ability.hand_type].level,
                localize(card.ability.hand_type, 'poker_hands'),
                G.GAME.hands[card.ability.hand_type].l_mult,
                G.GAME.hands[card.ability.hand_type].l_chips,
                colours = { (G.GAME.hands[card.ability.hand_type].level == 1 and G.C.UI.TEXT_DARK or G.C.HAND_LEVELS[math.min(7, G.GAME.hands[card.ability.hand_type].level)]) }
            }
        }
    end,
    in_pool = function(self, args)
        return G.GAME.hands[card.ability.hand_type].visible
    end
}

-- DEETS hb.117ca
SMODS.Atlas {
    key = "deets",
    path = "bttiDEETS.png", -- placeholder
    px = 65,
    py = 95
}
SMODS.Consumable {
    key = "deets",
    set = "Planet",
    cost = 30,
    pos = { x = 0, y = 0 },
    config = { hand_type = 'FullHorse' },
    loc_txt = {
        name = "DEETS hb.117ca",
        text = {
            "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
            "{C:attention}#2#",
            "{C:mult}+#3#{} Mult and",
            "{C:chips}+#4#{} chips", --idk how to change the values but it oughta be +2 mult and +20 chips
        },
    },
    pools = { ["BTTI_modAddition_planets"] = true, ["BTTI_modAddition_DEETSPlanets"] = true },
    atlas = 'deets',
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                G.GAME.hands[card.ability.hand_type].level,
                localize(card.ability.hand_type, 'poker_hands'),
                G.GAME.hands[card.ability.hand_type].l_mult,
                G.GAME.hands[card.ability.hand_type].l_chips,
                colours = { (G.GAME.hands[card.ability.hand_type].level == 1 and G.C.UI.TEXT_DARK or G.C.HAND_LEVELS[math.min(7, G.GAME.hands[card.ability.hand_type].level)]) }
            }
        }
    end,
    in_pool = function(self, args)
        return G.GAME.hands[card.ability.hand_type].visible
    end
}

--#endregion

--#region Bisexual Planets

-- Kepler
SMODS.Atlas {
    key = "kepler",
    path = "bttiKepler.png", -- placeholder
    px = 65,
    py = 95
}
SMODS.Consumable {
    key = "kepler",
    set = "Planet",
    cost = 3,
    pos = { x = 0, y = 0 },
    config = { hand_type = 'Bisexual' },
    loc_txt = {
        name = "Kepler",
        text = {
            "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
            "{C:attention}#2#",
            "{C:mult}+#3#{} Mult and",
            "{C:chips}+#4#{} chips",
        },
    },
    pools = { ["BTTI_modAddition_planets"] = true},
    atlas = 'kepler',
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                G.GAME.hands[card.ability.hand_type].level,
                localize(card.ability.hand_type, 'poker_hands'),
                G.GAME.hands[card.ability.hand_type].l_mult,
                G.GAME.hands[card.ability.hand_type].l_chips,
                colours = { (G.GAME.hands[card.ability.hand_type].level == 1 and G.C.UI.TEXT_DARK or G.C.HAND_LEVELS[math.min(7, G.GAME.hands[card.ability.hand_type].level)]) }
            }
        }
    end,
    in_pool = function (self, args)
        if G.jokers then
            if next (SMODS.find_card("j_btti_BlueBen8")) then
                return true
            end
            return false
        end
    end
}

-- Pegasi
SMODS.Atlas {
    key = "pegasi",
    path = "bttiPegasi.png", -- placeholder
    px = 65,
    py = 95
}
SMODS.Consumable {
    key = "pegasi",
    set = "Planet",
    cost = 3,
    pos = { x = 0, y = 0 },
    config = { hand_type = 'BisexualFlush' },
    loc_txt = {
        name = "Pegasi",
        text = {
            "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
            "{C:attention}#2#",
            "{C:mult}+#3#{} Mult and",
            "{C:chips}+#4#{} chips",
        },
    },
    pools = { ["BTTI_modAddition_planets"] = true },
    atlas = 'pegasi',
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                G.GAME.hands[card.ability.hand_type].level,
                localize(card.ability.hand_type, 'poker_hands'),
                G.GAME.hands[card.ability.hand_type].l_mult,
                G.GAME.hands[card.ability.hand_type].l_chips,
                colours = { (G.GAME.hands[card.ability.hand_type].level == 1 and G.C.UI.TEXT_DARK or G.C.HAND_LEVELS[math.min(7, G.GAME.hands[card.ability.hand_type].level)]) }
            }
        }
    end,
    in_pool = function(self, args)
        if G.jokers then
            if next(SMODS.find_card("j_btti_BlueBen8")) then
                return true
            end
            return false
        end
    end
}

--#endregion

--#endregion

--#region Tarot Cards

-- Tarots

-- The Maze
SMODS.Atlas {
    key = "maze",
    path = "bttiMaze.png", -- placeholder
    px = 65,
    py = 95
}
SMODS.Consumable {
    key = "maze",
    set = "Tarot",
    cost = 5,
    pos = { x = 0, y = 0 },
    config = { max_highlighted = 1, mod_conv = 'm_btti_horseCard' },
    loc_txt = {
        name = "The Maze",
        text = {
            "Enhances {C:attention}1{} selected card into",
            "a {C:deets}Horse Card{}"
        },
    },
    pools = { ["BTTI_modAddition_tarots"] = true, ["BTTI_modAddition_DEETSTarots"] = true },
    atlas = 'maze',
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
            }
        }
    end
}

-- The Purity
SMODS.Atlas {
    key = "purity",
    path = "bttiPurity.png", -- placeholder
    px = 65,
    py = 95
}
SMODS.Consumable {
    key = "purity",
    set = "Tarot",
    cost = 3,
    pos = { x = 0, y = 0 },
    config = { max_highlighted = 2 },
    loc_txt = {
        name = "The Purity",
        text = {
            "Removes {C:attention}Orange Seals{}",
            "from up to {C:attention}2{} selected cards"
        },
    },
    atlas = 'purity',
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
            }
        }
    end,
    pools = { ["BTTI_modAddition_tarots"] = true },
    use = function(self, card, area, copier)
        local conv_card = G.hand.highlighted[1]
        G.E_MANAGER:add_event(Event({
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                conv_card.seal = nil
                conv_card:set_seal()
                return true
            end
        }))

        delay(0.5)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
    end,
}

-- The Maze
SMODS.Atlas {
    key = "community",
    path = "bttiCommunity.png", -- placeholder
    px = 65,
    py = 95
}
SMODS.Consumable {
    key = "community",
    set = "Tarot",
    cost = 5,
    pos = { x = 0, y = 0 },
    config = { max_highlighted = 2, mod_conv = 'm_btti_stainedCard' },
    loc_txt = {
        name = "The Community",
        text = {
            "Enhances {C:attention}2{} selected cards",
            "into {C:deets}Stained Cards{}"
        },
    },
    pools = { ["BTTI_modAddition_tarots"] = true },
    atlas = 'community',
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
            }
        }
    end
}

-- Jonker's Workshop
SMODS.Atlas {
    key = "jonkersWorkshop",
    path = "bttiJonkersWorkshop.png", -- placeholder
    px = 65,
    py = 95
}
SMODS.Consumable {
    key = "jonkersWorkshop",
    set = "Tarot",
    cost = 6,
    pos = { x = 0, y = 0 },
    config = { extra = { } },
    loc_txt = {
        name = "Jonker's Workshop",
        text = {
            "Combines {C:joker}Jokers{} if any",
            "potential {C:purple}combinations{} are present",
            "Will prioritize {C:common}Common Jokers{} over",
            "{C:legendary}Legendary Jokers{}"
        },
    },
    atlas = 'jonkersWorkshop',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "Brain" } }

        -- I'm doing this check three times but idc leave me along ;-;
        if G.jokers ~= nil then
            local results = {}
            for combo_key, combo_data in pairs(G.BTTI.JOKER_COMBOS) do
                local needed = combo_data.jokers
                local allowed = combo_data.allowed or {}
                local found = {}

                local matched_needed = {}
                local matched_allowed = {}

                for _, player_card in ipairs(G.jokers.cards) do
                    for _, required in ipairs(needed) do
                        if player_card.config.center.key == required then
                            found[required] = true
                            table.insert(matched_needed, player_card)
                        end
                    end
                    for _, allowed_jk in ipairs(allowed) do
                        if player_card.config.center.key == allowed_jk then
                            found[allowed_jk] = true
                            table.insert(matched_allowed, player_card)
                            break
                        end
                    end
                end

                local all_found = true
                for _, required in ipairs(needed) do
                    if not found[required] then
                        all_found = false
                        break
                    end
                end

                if all_found and #needed < 2 and #allowed > 0 then
                    local any_allowed = false
                    for _, allowed_jk in ipairs(allowed) do
                        if found[allowed_jk] then
                            any_allowed = true
                            break
                        end
                    end
                    all_found = any_allowed
                end

                if all_found then
                    table.insert(results, {
                        key = combo_key,
                        neededToDiscard = matched_needed,
                        allowedToDiscard = matched_allowed,
                        rarity = combo_data.rarity or 1
                    })
                    sendInfoMessage("found " .. combo_key, "BTTI")
                end
            end

            table.sort(results, function(a, b)
                return a.rarity < b.rarity
            end)

            if #results > 0 then
                local combo = results[1]
                local str_parts = {}

                for _, card in ipairs(combo.neededToDiscard) do
                    table.insert(str_parts,
                        localize { type = "name_text", set = "Joker", key = card.config.center.key })
                end

                for _, card in ipairs(combo.allowedToDiscard) do
                    table.insert(str_parts,
                        localize { type = "name_text", set = "Joker", key = card.config.center.key })
                end

                local str = table.concat(str_parts, " + ")
                str = str .. " = " ..
                    localize { type = "name_text", set = "Joker", key = combo.key }

                sendInfoMessage(str, "BTTI")
                info_queue[#info_queue + 1] = { key = 'bttiPossibleCombo', set = 'Other', vars = { str } }
            else
                info_queue[#info_queue + 1] = { key = 'bttiPossibleCombo', set = 'Other', vars = { 'Nothing yet!' } }
            end
        else
            info_queue[#info_queue + 1] = { key = 'bttiPossibleCombo', set = 'Other', vars = { 'Nothing yet!' } }
        end

        return {
            vars = {
            }
        }
    end,
    pools = { ["BTTI_modAddition_tarots"] = true },
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))

        local results = {}
        for combo_key, combo_data in pairs(G.BTTI.JOKER_COMBOS) do
            local needed = combo_data.jokers
            local allowed = combo_data.allowed or {}
            local found = {}

            local matched_needed = {}
            local matched_allowed = {}

            for _, player_card in ipairs(G.jokers.cards) do
                for _, required in ipairs(needed) do
                    if player_card.config.center.key == required then
                        found[required] = true
                        table.insert(matched_needed, player_card)
                    end
                end
                for _, allowed_jk in ipairs(allowed) do
                    if player_card.config.center.key == allowed_jk then
                        found[allowed_jk] = true
                        table.insert(matched_allowed, player_card)
                        break
                    end
                end
            end

            local all_found = true
            for _, required in ipairs(needed) do
                if not found[required] then
                    all_found = false
                    break
                end
            end

            if all_found and #needed < 2 and #allowed > 0 then
                local any_allowed = false
                for _, allowed_jk in ipairs(allowed) do
                    if found[allowed_jk] then
                        any_allowed = true
                        break
                    end
                end
                all_found = any_allowed
            end

            if all_found then
                table.insert(results, {
                    key = combo_key,
                    neededToDiscard = matched_needed,
                    allowedToDiscard = matched_allowed,
                    rarity = combo_data.rarity or 1
                })
                --sendInfoMessage("found " .. combo_key, "BTTI")
            end
        end

        table.sort(results, function(a, b)
            return a.rarity < b.rarity
        end)

        if #results > 0 then
            local result = results[1]

            for _, c in ipairs(result.neededToDiscard) do
                c:remove()
            end

            if #result.allowedToDiscard > 0 then
                local idx = math.random(1, #result.allowedToDiscard)
                result.allowedToDiscard[idx]:remove()
            end

            local c = SMODS.add_card { key = result.key }
            c:juice_up()
            SMODS.calculate_context { combined_joker = c }
        end

        delay(0.5)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.jokers:unhighlight_all()
                return true
            end
        }))
        delay(0.5)
    end,
    can_use = function (self, card)
        for combo_key, combo_data in pairs(G.BTTI.JOKER_COMBOS) do
            local needed = combo_data.jokers
            local found = {}

            for _, player_card in ipairs(G.jokers.cards) do
                for _, required in ipairs(needed) do
                    if player_card.config.center.key == required then
                        found[required] = true
                    end
                end
            end

            local all_found = true
            for _, required in ipairs(needed) do
                if not found[required] then
                    all_found = false
                    break
                end
            end

            if all_found then
                return true
            end
        end

        return false
    end,
    in_pool = function (self, args)
        return true, {allow_duplicates = true}
    end
}

--#endregion

-- Doubt
SMODS.Atlas {
    key = "doubt",
    path = "bttiDoubt.png", -- placeholder
    px = 65,
    py = 95
}
SMODS.Consumable {
    key = "doubt",
    set = "Spectral",
    cost = 5,
    pos = { x = 0, y = 0 },
    config = { max_highlighted = 3 },
    loc_txt = {
        name = "Doubt",
        text = {
            "Destroys up to {C:attention}3{} selected",
            "{C:deets}Horse Cards{}"
        },
    },
    pools = { ["BTTI_modAddition_spectrals"] = true },
    atlas = 'doubt',
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
            }
        }
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        for i = 1, #G.hand.highlighted do
            local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    play_sound('card1', percent)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        delay(0.2)
        for i = 1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    if G.hand.highlighted[i] == 'm_btti_horseCard' then
                        SMODS.destroy_cards(G.hand.highlighted[i])
                    end
                    return true
                end
            }))
        end
        for i = 1, #G.hand.highlighted do
            local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    play_sound('tarot2', percent, 0.6)
                    return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
        delay(0.5)
    end,
}

-- Joozin' It
SMODS.Atlas {
    key = "joozin",
    path = "bttiJoozin.png", -- placeholder
    px = 65,
    py = 95
}
SMODS.Consumable {
    key = "joozin",
    set = "Spectral",
    cost = 5,
    pos = { x = 0, y = 0 },
    config = { max_highlighted = 1 },
    loc_txt = {
        name = "Joozin' It",
        text = {
            "Adds an {C:attention}Orange Seal{} to",
            "{C:attention}1{} selected card in hand"
        },
    },
    pools = { ["BTTI_modAddition_spectrals"] = true },
    atlas = 'joozin',
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
            }
        }
    end,
    use = function(self, card, area, copier)
        local conv_card = G.hand.highlighted[1]
        G.E_MANAGER:add_event(Event({
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                conv_card:set_seal('btti_orangeSeal', nil, true)
                return true
            end
        }))

        delay(0.5)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
    end,
}

-- Infinity
SMODS.Atlas {
    key = "infinity",
    path = "bttiInfinity.png", -- placeholder
    px = 65,
    py = 95
}
SMODS.Consumable {
    key = "infinity",
    set = "Spectral",
    cost = 10,
    pos = { x = 0, y = 0 },
    config = { max_highlighted = 1 },
    loc_txt = {
        name = "Infinity",
        text = {
            "Adds an {C:gay}Autism Seal{} to",
            "{C:attention}1{} selected card in hand"
        },
    },
    pools = { ["BTTI_modAddition_spectrals"] = true },
    atlas = 'infinity',
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
            }
        }
    end,
    use = function(self, card, area, copier)
        local conv_card = G.hand.highlighted[1]
        G.E_MANAGER:add_event(Event({
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                conv_card:set_seal('btti_autismSeal', nil, true)
                return true
            end
        }))

        delay(0.5)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
    end,
}

-- Spawnkler
SMODS.Atlas {
    key = "spawnkler",
    path = "bttiSpawnkler.png", -- placeholder
    px = 65,
    py = 95
}
SMODS.Consumable {
    key = "spawnkler",
    set = "Spectral",
    cost = 4,
    pos = { x = 0, y = 0 },
    config = { },
    loc_txt = {
        name = "Spawnkler",
        text = {
            "Summons {C:attention}Jonker's Workshop{}"
        },
    },
    pools = { ["BTTI_modAddition_spectrals"] = true },
    atlas = 'spawnkler',
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
            }
        }
    end,
    can_use = function (self, card)
        return true
    end,
    use = function(self, card, area, copier)
        local conv_card = G.hand.highlighted[1]
        G.E_MANAGER:add_event(Event({
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                SMODS.add_card {
                    key = 'c_btti_jonkersWorkshop'
                }
                return true
            end
        }))

        delay(0.5)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
    end,
}
