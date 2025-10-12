SMODS.current_mod.extra_tabs = function()
    return {
        {
            label = 'Credits',
            tab_definition_function = function()
                local modNodes = {}

                modNodes[#modNodes + 1] = {}
                local loc_vars = { background_colour = G.C.CLEAR, text_colour = G.C.WHITE, scale = 1.4 }
                localize { type = 'descriptions', key = "bttiCredits", set = 'Other', nodes = modNodes[#modNodes], vars = loc_vars.vars, scale = loc_vars.scale, text_colour = loc_vars.text_colour, shadow = loc_vars.shadow }
                modNodes[#modNodes] = desc_from_rows(modNodes[#modNodes])
                modNodes[#modNodes].config.colour = loc_vars.background_colour or modNodes[#modNodes].config.colour

                return {
                    n = G.UIT.ROOT,
                    config = {
                        emboss = 0.05,
                        minh = 6,
                        r = 0.1,
                        minw = 6,
                        align = "tm",
                        padding = 0.2,
                        colour = G.C.BLACK
                    },
                    nodes = modNodes
                }
            end,
        },
    }
end

SMODS.current_mod.config_tab = function ()
    return {
        n = G.UIT.ROOT,
        config = { align = 'cm', minw = 10, minh = 5, padding = 0.15, emboss = 0.05, r = 0.1, colour = G.C.BLACK },
        nodes = {
            {
                n = G.UIT.C,
                config = { align = 'cm', padding = 0.1 },
                nodes = {
                    {
                        n = G.UIT.R,
                        config = { align = 'cm', padding = 0.1 },
                        nodes = {
                            create_toggle {
                                label = localize("bttiStreamerMode"),
                                info = localize("bttiStreamerModeInfo"),
                                ref_table = G.BTTI.config,
                                ref_value = 'streamer_mode'
                            }
                        }
                    }
                }
            }
        }
    }
end

local create_UIBox_your_collection_combo_jokers = function() 
    return SMODS.card_collection_UIBox(G.P_CENTER_POOLS.BTTI_modAddition_COMBO, {5,5,5}, {
        no_materialize = true, 
        modify_card = function(card, center) card.sticker = get_joker_win_sticker(center) end,
        h_mod = 0.95,
    })
end

G.FUNCS.your_collection_combo_jokers = function()
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu {
        definition = create_UIBox_your_collection_combo_jokers()
    }
end

local function get_pool(pool)
    local jkrs = {}
    for _, jkr in pairs(pool) do
        jkrs[#jkrs+1] = jkr
    end
    return jkrs
end

local function get_tally_of_pool(pool)
    local tally, of = 0, 0
    for _, card in pairs(get_pool(pool)) do
        of = of + 1
        if card.discovered then
            tally = tally + 1
        end
    end
    return {tally = tally, of = of}
end

SMODS.current_mod.custom_collection_tabs = function()
    local comboCount = get_tally_of_pool(G.P_CENTER_POOLS.BTTI_modAddition_COMBO)
    return {
      UIBox_button({
        button = 'your_collection_combo_jokers',
        id = 'your_collection_combo_jokers',
        label = { "Combination Jokers" },
        count = { tally = comboCount.tally, of = comboCount.of },
        minw = 5,
        minh = 1
      }),
    }
end