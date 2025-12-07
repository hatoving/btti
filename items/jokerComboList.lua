G.BTTI.JOKER_COMBOS = {
    ['j_btti_avariciousJoker'] = {
        rarity = 2,
        jokers = {
            'Lusty Joker',
            'Greedy Joker'
        }
    },
    ['j_btti_sullenJoker'] = {
        rarity = 2,
        jokers = {
            'Wrathful Joker',
            'Gluttonous Joker'
        }
    },
    ['j_btti_sinfulJoker'] = {
        rarity = 3,
        jokers = {
            'j_btti_avariciousJoker',
            'j_btti_sullenJoker'
        }
    },
    ['j_btti_jovialJoker'] = {
        rarity = 1,
        jokers = {
            'Jolly Joker',
            'Sly Joker'
        }
    },
    ['j_btti_confusedJoker'] = {
        rarity = 1,
        jokers = {
            'Zany Joker',
            'Wily Joker'
        }
    },
    ['j_btti_geniusJoker'] = {
        rarity = 2,
        jokers = {
            'Mad Joker',
            'Clever Joker'
        }
    },
    ['j_btti_bonkersJoker'] = {
        rarity = 3,
        jokers = {
            'Crazy Joker',
            'Devious Joker'
        }
    },
    ['j_btti_deliberateJoker'] = {
        rarity = 3,
        jokers = {
            'Droll Joker',
            'Crafty Joker'
        }
    },
    ['j_btti_ultimateJoker'] = {
        rarity = 4,
        jokers = {
            'j_btti_Universe'
        },
        allowed = {
            'j_btti_jovialJoker',
            'j_btti_confusedJoker',
            'j_btti_geniusJoker',
            'j_btti_bonkersJoker',
            'j_btti_deliberateJoker'
        }
    },
    ['j_btti_splitJovialJoker'] = {
        rarity = 2,
        jokers = {
            'j_btti_jovialJoker',
            'Half Joker'
        }
    },
    ['j_btti_splitConfusedJoker'] = {
        rarity = 2,
        jokers = {
            'j_btti_confusedJoker',
            'Half Joker'
        }
    },
    ['j_btti_zeroTheo'] = {
        rarity = 2,
        jokers = {
            'Even Steven',
            'Odd Todd',
        }
    },
    ['j_btti_trueBanana'] = {
        rarity = 3,
        jokers = {
            'Gros Michel',
            'Cavendish',
        }
    },
    ['j_btti_royalMoon'] = {
        rarity = 2,
        jokers = {
            'Baron',
            'Shoot the Moon',
        }
    },
    ['j_btti_shortScholar'] = {
        rarity = 2,
        jokers = {
            'Scholar',
            'Wee',
        }
    },
    ['j_btti_chanceOfClouds'] = {
        rarity = 2,
        jokers = {
            '8 Ball',
            'Cloud 9',
        }
    },
    ['j_btti_celestius'] = {
        rarity = 4,
        jokers = {
            'j_btti_royalMoon',
            'j_btti_shortScholar',
            'j_btti_chanceOfClouds'
        }
    },
    ['j_btti_mineralJoker'] = {
        rarity = 3,
        jokers = {
            'Steel Joker',
            'Stone Joker'
        }
    },
    ['j_btti_abstractbuckler'] = {
        rarity = 2,
        jokers = {
            'Abstract Joker',
            'Swashbuckler'
        }
    },
    ['j_btti_resume'] = {
        rarity = 3,
        jokers = {
            'Marble Joker',
            'Certificate'
        }
    },
    ['j_btti_bat'] = {
        rarity = 3,
        jokers = {
            'Dusk',
            'Acrobat'
        }
    },
    ['j_btti_mountainBurglar'] = {
        rarity = 2,
        jokers = {
            'Mystic Summit',
            'Burglar'
        }
    },
    ['j_btti_holoResume'] = {
        rarity = 3,
        jokers = {
            'j_btti_resume',
            'Hologram'
        }
    },
    ['j_btti_lunatic'] = {
        rarity = 3,
        jokers = {
            'Cartomancer',
            'Fortune Teller'
        }
    },
    ['j_btti_wineJuggler'] = {
        rarity = 3,
        jokers = {
            'Juggler',
            'Drunkard'
        }
    },
    ['j_btti_photoChad'] = {
        rarity = 3,
        jokers = {
            'Photograph',
            'Hanging Chad'
        }
    },
    ['j_btti_TripleBaka'] = {
        rarity = 4,
        jokers = {
            'j_btti_Neru',
            'j_btti_Miku',
            'j_btti_Teto',
        }
    },
    ['j_btti_Skelebros'] = {
        rarity = 2,
        jokers = {
            'j_btti_Sans',
            'j_btti_Papyrus',
        }
    },
    ['j_btti_GIFCompression'] = {
        rarity = 2,
        jokers = {
            'Square Joker',
            'j_btti_SayThatAgain',
        }
    },
}

function G.BTTI.getCombinableJokers(joker_id)
    local result = {}

    for _, combo in pairs(G.BTTI.JOKER_COMBOS) do
        if combo.jokers then
            local in_jokers = table_contains(combo.jokers, joker_id)
            local in_allowed = combo.allowed and table_contains(combo.allowed, joker_id)
            local names = {}

            if in_jokers then
                if #combo.jokers > 1 and not combo.allowed then
                    for _, j in ipairs(combo.jokers) do
                        if j ~= joker_id then
                            table.insert(names, localize { type = "name_text", set = "Joker", key = j } or j)
                        end
                    end
                    if #names > 0 then
                        table.insert(result, table.concat(names, " + "))
                    end
                end
                if combo.allowed then
                    for _, j in ipairs(combo.allowed) do
                        table.insert(result, localize { type = "name_text", set = "Joker", key = j } or j)
                    end
                end
            elseif in_allowed and #combo.jokers == 1 then
                table.insert(result, localize { type = "name_text", set = "Joker", key = combo.jokers[1] } or combo.jokers[1])
            end
        end
    end

    return result
end

function G.BTTI.getCombinableJokerKeys(joker_id)
    local result = {}

    for _, combo in pairs(G.BTTI.JOKER_COMBOS) do
        if combo.jokers then
            local in_jokers = table_contains(combo.jokers, joker_id)
            local in_allowed = combo.allowed and table_contains(combo.allowed, joker_id)

            if in_jokers then
                -- Combo with multiple jokers and no allowed list
                if #combo.jokers > 1 and not combo.allowed then
                    for _, j in ipairs(combo.jokers) do
                        if j ~= joker_id then
                            table.insert(result, j)
                        end
                    end
                end
                if combo.allowed then
                    for _, j in ipairs(combo.allowed) do
                        table.insert(result, j)
                    end
                end
            elseif in_allowed and #combo.jokers == 1 then
                table.insert(result, combo.jokers[1])
            end
        end
    end

    return result
end

function G.BTTI.initJokerCombos()
    local function processComboList(combo_name, list, list2, listType)
        sendInfoMessage("COMBO:  " .. combo_name .. " ---", "BTTI")

        for j = 1, #list do
            local joker_id = list[j]

            -- Skip jokers starting with "j_btti"
            if not joker_id:find("_btti") then
                local idx = j
                SMODS.Joker:take_ownership(joker_id, {
                    loc_vars = function(self, info_queue, card)
                        for x = 1, #list2 do
                            if x ~= idx then
                                info_queue[#info_queue + 1] = {
                                    key = 'bttiPossibleCombo',
                                    set = 'Other',
                                    vars = { localize {
                                        type = "name_text",
                                        set = "Joker",
                                        key = list2[x]
                                    } }
                                }
                            end
                        end
                    end
                }, true)
            end
        end
    end

    for combo_name, combo in pairs(G.BTTI.JOKER_COMBOS) do
        if combo.jokers then
            processComboList(combo_name, combo.jokers, combo.jokers, "jokers")
        end
        if combo.allowed then
            processComboList(combo_name, combo.jokers, combo.allowed, "allowed")
        end
    end
end
