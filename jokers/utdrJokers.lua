SMODS.Font({ 
    key = "sans", 
    path = "bttiSans.ttf" 
})
SMODS.Font({ 
    key = "papyrus", 
    path = "bttiPapyrus.ttf" 
})

SMODS.Sound {
    key = "music_TennaNormal",
    path = "music_bttiTenna.ogg",
    pitch = 1,
    volume = 1.0,
    select_music_track = function(self)
        return jokerExists("j_btti_Tenna")
            and G.GAME and G.GAME.blind and #G.GAME.blind.name > 0 and (G.GAME.blind:get_type() ~= 'Boss')
            and G.GAME.btti_selectedMusicIdx == self.key -- look in hooks.lua
    end
}
SMODS.Sound {
    key = "music_TennaBoss",
    path = "music_bttiTennaBoss.ogg",
    pitch = 1,
    volume = 1.0,
    select_music_track = function(self)
        return jokerExists("j_btti_Tenna")
            and G.GAME and G.GAME.blind and #G.GAME.blind.name > 0 and (G.GAME.blind:get_type() == 'Boss')
            and G.GAME.btti_selectedMusicIdx == self.key -- look in hooks.lua
    end
}

SMODS.Sound({ key = "Sans", path = "bttiSans.ogg" })
SMODS.Atlas {
    key = "Sans",
    path = "bttiSans.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Sans',
    loc_txt = {
        name = '{f:btti_sans}sans.',
        text = {
            "This {C:attention}Joker{} is assigned",
            "the effect of a random {C:common}Common {C:joker}Joker{}",
            "at the beginning of each {C:attention}round",
            "Resets at the end of each {C:attention}round"
        }
    },

    config = { extra = { currentJoker = nil } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "UNDERTALE", "Toby Fox", "BlueBen8" } }
        return {
            vars = { },
        }
    end,
    rarity = 1,
    atlas = 'Sans',
    pos = { x = 0, y = 0 },
    cost = 4,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_COMMON"] = true, ["BTTI_modAddition_GAME"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,

    -- We need this because Sans decided it'd be funny to cosplay as a pink furry
    update = function (self, card, dt)
        if card.discovered then
            card.children.center.atlas = G.ASSET_ATLAS['btti_Sans']
            card.children.center:set_sprite_pos({ x = 0, y = 0 })
        end
    end,

    -- Thank you to Somthingcom515 for the help with implementing this!!
    calculate = function(self, card, context)
        if context.setting_blind and context.cardarea == G.jokers then
            local jkr
            repeat
                jkr = pseudorandom_element(G.P_JOKER_RARITY_POOLS[1], 'seed')
            until jkr.discovered
            card.ability.extra.currentJoker = jkr.key
            sendInfoMessage("sans chose: " .. card.ability.extra.currentJoker .. "", "BTTI")
            return {
                message = '\'sup.',
                colour = G.C.BLUE,
                sound = 'btti_Sans'
            }
        end
        if card.ability.extra.currentJoker then
            local key = card.ability.extra.currentJoker
            G.btti_savedJokerCards = G.btti_savedJokerCards or {}
            G.btti_savedJokerCards[card.sort_id] = G.btti_savedJokerCards[card.sort_id] or {}
            if not G.btti_savedJokerCards[card.sort_id][key] then
                local old_ability = copy_table(card.ability)
                local old_center = card.config.center
                local old_center_key = card.config.center_key
                card:set_ability(key, nil, 'quantum')
                card:update(0.016)
                G.btti_savedJokerCards[card.sort_id][key] = SMODS.shallow_copy(card)
                G.btti_savedJokerCards[card.sort_id][key].ability = copy_table(G.btti_savedJokerCards
                    [card.sort_id][key].ability)
                for i, v in ipairs({ "T", "VT", "CT" }) do
                    G.btti_savedJokerCards[card.sort_id][key][v] = copy_table(G.btti_savedJokerCards[card.sort_id]
                        [key][v])
                end
                G.btti_savedJokerCards[card.sort_id][key].config = SMODS.shallow_copy(G.btti_savedJokerCards
                    [card.sort_id][key].config)
                card.ability = old_ability
                card.config.center = old_center
                card.config.center_key = old_center_key
                for i, v in ipairs({ 'juice_up', 'start_dissolve', 'remove', 'flip' }) do
                    G.btti_savedJokerCards[card.sort_id][key][v] = function(_, ...)
                        return Card[v](card, ...)
                    end
                end
            end
            return G.btti_savedJokerCards[card.sort_id][key]:calculate_joker(context)
        end
    end
}

SMODS.Sound({ key = "Papyrus0", path = "bttiPapyrus0.ogg" })
SMODS.Sound({ key = "Papyrus1", path = "bttiPapyrus1.ogg" })
SMODS.Sound({ key = "Papyrus2", path = "bttiPapyrus2.ogg" })
SMODS.Sound({ key = "PapyrusBlue", path = "bttiPapyrusBlue.ogg" })
-- Papyrus
SMODS.Atlas {
    key = "Papyrus",
    path = "bttiPapyrus.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Papyrus',
    loc_txt = {
        name = '{f:btti_papyrus}THE GREAT PAPYRUS!',
        text = {
            "{C:mult}+4{} Mult per {C:attention}card{} played",
            "without an enhancement",
            "{C:green}1 in 10{} chance to apply a {C:blue}Blue Seal{}",
            "to a played {C:hearts}Heart{} card"
        }
    },

    config = { extra = { mult = 4, sfx = -1 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "UNDERTALE", "Toby Fox", "BlueBen8" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.chips },
        }
    end,
    rarity = 1,
    atlas = 'Papyrus',
    pos = { x = 0, y = 0 },
    cost = 4,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_COMMON"] = true, ["BTTI_modAddition_GAME"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local pc = context.other_card
            if pc and (not SMODS.get_enhancements(pc) or next(SMODS.get_enhancements(pc)) == nil) then
                return {
                    mult = card.ability.extra.mult,
                    colour = G.C.MULT,
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        blocking = false,
                        delay = 0,
                        func = function()
                            if card.ability.extra.sfx == nil then
                                card.ability.extra.sfx = 0
                                card.ability.extra.second = false
                            end

                            if card.ability.extra.sfx == 0 then
                                if card.ability.extra.second then
                                    card.ability.extra.sfx = 2
                                else
                                    card.ability.extra.sfx = 1
                                end
                                card.ability.extra.second = not card.ability.extra.second
                            else
                                card.ability.extra.sfx = 0
                            end

                            play_sound('btti_Papyrus' .. card.ability.extra.sfx)
                            return true
                        end,
                    }))
                }
            end
        end

        if context.joker_main then
            if pseudorandom("Papyrus") < 0.1 then
                local hearts = {}
                if G.play.cards then
                    for _, c in ipairs(G.play.cards) do
                        if c:is_suit("Hearts") then
                            table.insert(hearts, c)
                        end
                    end
                end

                if #hearts > 0 then
                    local c = pseudorandom_element(hearts, "Papyrus")
                    c:set_seal("Blue")
                    return {
                        message = "YOU'RE BLUE NOW!",
                        colour = G.C.BLUE,
                        sound = 'btti_PapyrusBlue'
                    }
                end
            end
        end
    end
}

-- Weird Route
SMODS.Atlas {
    key = "WeirdRoute",
    path = "bttiWeirdRoute.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'WeirdRoute',
    loc_txt = {
        name = '{f:btti_dt}Weird Route',
        text = {
            "Sell this {C:joker}Joker{} to {C:blue}freeze{} the",
            "current Blind, winning the {C:attention}round",
            "{C:inactive}(Doesn't work on{} {C:attention}Boss Blinds{}{C:inactive}){}"
        }
    },

    config = { extra = { mult = 0, chips = 0 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "DELTARUNE", "Toby Fox", "Juicimated" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.chips },
        }
    end,
    rarity = 1,
    atlas = 'WeirdRoute',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_COMMON"] = true, ["BTTI_modAddition_GAME"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.selling_card and context.card == card then
            if G.GAME.blind.in_blind and not G.GAME.blind.boss then
                WIN_ROUND_NOW()
            end
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

-- Tenna

SMODS.Sound({ key = "tennaT", path = "bttiTennaT.ogg" })
SMODS.Sound({ key = "tennaV", path = "bttiTennaV.ogg" })
SMODS.Sound({ key = "tennaTime", path = "bttiTennaTime.ogg" })

SMODS.Atlas {
    key = "Tenna",
    path = "bttiTenna.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Tenna',
    loc_txt = {
        name = '{f:btti_dt}Mr. (Ant) Tenna',
        text = {
            "Gains {C:chips}+20{} Chips per {C:purple}Combination{} {C:attention}Joker{} created",
            "Gains {C:mult}+10{} Mult per {C:purple}Combination{} {C:attention}Joker{} created",
            "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips, {C:mult}+#1#{C:inactive} Mult)"
        }
    },

    config = { extra = { mult = 0, chips = 0 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "DELTARUNE", "Toby Fox", "BlueBen8" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.chips },
        }
    end,
    rarity = 1,
    atlas = 'Tenna',
    pos = { x = 0, y = 0 },
    cost = 4,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_COMMON"] = true, ["BTTI_modAddition_GAME"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.joker_main then
            local rets = {}
            if card.ability.extra.mult > 0 then
                table.insert(rets, {
                    message = "T...",
                    colour = G.C.MULT,
                    sound = 'btti_tennaT',
                })
                table.insert(rets, {
                    message = "V... +" .. card.ability.extra.mult .. "",
                    colour = G.C.MULT,
                    mult_mod = card.ability.extra.mult,
                    sound = 'btti_tennaV',
                })
            end
            if card.ability.extra.chips > 0 then
                table.insert(rets, {
                    message = "TIME!! +" .. card.ability.extra.chips .. "",
                    colour = G.C.CHIPS,
                    chip_mod = card.ability.extra.chips,
                    sound = 'btti_tennaTime',
                })
            end
            return SMODS.merge_effects(rets)
        end
        if context.combined_joker then
            card.ability.extra.mult = card.ability.extra.mult + 10
            card.ability.extra.chips = card.ability.extra.chips + 20
            return {
                message = "Glooby!",
                colour = G.C.MULT
            }
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}