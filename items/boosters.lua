-- Buffoon Packs

SMODS.Atlas {
    key = "enhancedP",
    path = "bttiEnhancedPack.png",
    px = 71,
    py = 95
}
SMODS.Booster {
    key = "enhanced",
    weight = 0.6,
    kind = 'Standard', -- You can also use Buffoon if you want it to belong to the vanilla kind
    cost = 8,
    pos = { x = 0, y = 0 },
    atlas = 'enhancedP',
    config = { extra = 4, choose = 1 },
    loc_txt = {
        name = "Enhanced Pack",
        text = {
            "Choose 1 of up to 4",
            "{C:attention}Enhanced Cards"
        },
        group_name = 'Enhanced Pack'
    },
    loc_vars = function(self, info_queue, card)
        return {
        }
    end,
    particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 0, 0, {
            timer = 0.015,
            scale = 0.3,
            initialize = true,
            lifespan = 3,
            speed = 0.2,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = { G.C.BLACK, G.C.RED },
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
    ease_background_colour = function(self)
        ease_background_colour_blind(G.STATES.BUFFOON_PACK)
    end,
    create_card = function(self, card, i)
        local _edition = poll_edition('btti' .. G.GAME.round_resets.ante, 2, true)
        local _seal = SMODS.poll_seal({ mod = 10 })
        local _enhancement = SMODS.poll_enhancement {key = "btti", guaranteed = true}
        return {
            set = "Playing Card",
            edition = _edition,
            seal = _seal,
            enhancement = _enhancement,
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
            key_append = "btti"
        }
    end,
}

SMODS.Atlas {
    key = "jumboEnhancedP",
    path = "bttiJumboEnhancedPack.png",
    px = 71,
    py = 95
}
SMODS.Booster {
    key = "jumboEnhanced",
    weight = 0.6,
    kind = 'Standard', -- You can also use Buffoon if you want it to belong to the vanilla kind
    cost = 10,
    pos = { x = 0, y = 0 },
    atlas = 'jumboEnhancedP',
    config = { extra = 6, choose = 1 },
    loc_txt = {
        name = "Jumbo Enhanced Pack",
        text = {
            "Choose 1 of up to 6",
            "{C:attention}Enhanced Cards"
        },
        group_name = 'Jumbo Enhanced Pack'
    },
    loc_vars = function(self, info_queue, card)
        return {
        }
    end,
    particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 0, 0, {
            timer = 0.015,
            scale = 0.3,
            initialize = true,
            lifespan = 3,
            speed = 0.2,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = { G.C.BLACK, G.C.RED },
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
    ease_background_colour = function(self)
        ease_background_colour_blind(G.STATES.BUFFOON_PACK)
    end,
    create_card = function(self, card, i)
        local _edition = poll_edition('btti' .. G.GAME.round_resets.ante, 2, true)
        local _seal = SMODS.poll_seal({ mod = 10 })
        local _enhancement = SMODS.poll_enhancement { key = "btti", guaranteed = true }
        return {
            set = "Playing Card",
            edition = _edition,
            seal = _seal,
            enhancement = _enhancement,
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
            key_append = "btti"
        }
    end,
}
SMODS.Atlas {
    key = "megaEnhancedP",
    path = "bttiMegaEnhancedPack.png",
    px = 71,
    py = 95
}
SMODS.Booster {
    key = "megaEnhanced",
    weight = 0.6,
    kind = 'Standard', -- You can also use Buffoon if you want it to belong to the vanilla kind
    cost = 12,
    pos = { x = 0, y = 0 },
    atlas = 'megaEnhancedP',
    config = { extra = 8, choose = 2 },
    loc_txt = {
        name = "Mega Enhanced Pack",
        text = {
            "Choose 2 of up to 8",
            "{C:attention}Enhanced Cards"
        },
        group_name = 'Mega Enhanced Pack'
    },
    loc_vars = function(self, info_queue, card)
        return {
        }
    end,
    particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 0, 0, {
            timer = 0.015,
            scale = 0.3,
            initialize = true,
            lifespan = 3,
            speed = 0.2,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = { G.C.BLACK, G.C.RED },
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
    ease_background_colour = function(self)
        ease_background_colour_blind(G.STATES.BUFFOON_PACK)
    end,
    create_card = function(self, card, i)
        local _edition = poll_edition('btti' .. G.GAME.round_resets.ante, 2, true)
        local _seal = SMODS.poll_seal({ mod = 10 })
        local _enhancement = SMODS.poll_enhancement { key = "btti", guaranteed = true }
        return {
            set = "Playing Card",
            edition = _edition,
            seal = _seal,
            enhancement = _enhancement,
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
            key_append = "btti"
        }
    end,
}

SMODS.Atlas {
    key = "stoneP",
    path = "bttiStonePack.png",
    px = 71,
    py = 95
}
SMODS.Booster {
    key = "stonePack",
    weight = 0.6,
    kind = 'Standard', -- You can also use Buffoon if you want it to belong to the vanilla kind
    cost = 5,
    pos = { x = 0, y = 0 },
    atlas = 'stoneP',
    config = { extra = 2, choose = 1 },
    loc_txt = {
        name = "Stone Pack",
        text = {
            "Choose 1 of up to 2",
            "{C:attention}Stone Cards"
        },
        group_name = 'Stone Pack'
    },
    loc_vars = function(self, info_queue, card)
        return {
        }
    end,
    particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 0, 0, {
            timer = 0.015,
            scale = 0.3,
            initialize = true,
            lifespan = 3,
            speed = 0.2,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = { G.C.BLACK, G.C.RED },
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
    ease_background_colour = function(self)
        ease_background_colour_blind(G.STATES.BUFFOON_PACK)
    end,
    create_card = function(self, card, i)
        local _edition = poll_edition('btti' .. G.GAME.round_resets.ante, 2, true)
        local _seal = SMODS.poll_seal({ mod = 10 })
        return {
            set = "Playing Card",
            edition = _edition,
            seal = _seal,
            enhancement = 'm_stone',
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
            key_append = "btti"
        }
    end,
}

SMODS.Atlas {
    key = "horseP",
    path = "bttiHorsePack.png",
    px = 71,
    py = 95
}
SMODS.Booster {
    key = "horsePack",
    weight = 0.6,
    kind = 'Standard', -- You can also use Buffoon if you want it to belong to the vanilla kind
    cost = 8,
    pos = { x = 0, y = 0 },
    atlas = 'horseP',
    config = { extra = 2, choose = 1 },
    loc_txt = {
        name = "Horse Pack",
        text = {
            "Choose 1 of up to 2",
            "{C:deets}Horse Cards"
        },
        group_name = 'Horse Pack'
    },
    loc_vars = function(self, info_queue, card)
        return {
        }
    end,
    particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 0, 0, {
            timer = 0.015,
            scale = 0.3,
            initialize = true,
            lifespan = 3,
            speed = 0.2,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = { G.C.BLACK, G.C.RED },
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
    ease_background_colour = function(self)
        ease_background_colour_blind(G.STATES.BUFFOON_PACK)
    end,
    create_card = function(self, card, i)
        local _edition = poll_edition('btti' .. G.GAME.round_resets.ante, 2, true)
        local _seal = SMODS.poll_seal({ mod = 10 })
        return {
            set = "Playing Card",
            edition = _edition,
            seal = _seal,
            enhancement = 'm_btti_horseCard',
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
            key_append = "btti"
        }
    end,
}

-- Legendary Joker Pack
SMODS.Atlas {
    key = "legendaryBP",
    path = "bttiLegendaryBuffoonPack.png",
    px = 71,
    py = 95
}
SMODS.Booster {
    key = "buffoon_legendary",
    weight = 0.6,
    kind = 'Buffoon', -- You can also use Buffoon if you want it to belong to the vanilla kind
    cost = 65,
    pos = { x = 0, y = 0 },
    atlas = 'legendaryBP',
    config = { extra = 2, choose = 1 },
    loc_txt = {
        name = "Legendary Buffoon Pack",
        text = {
            "Choose 1 of up to 2",
            "{C:legendary}Legendary Jokers"
        },
        group_name = 'Legendary Buffoon Pack'
    },
    loc_vars = function(self, info_queue, card)
        return {
        }
    end,
    ease_background_colour = function(self)
        ease_background_colour_blind(G.STATES.BUFFOON_PACK)
    end,
    create_card = function(self, card, i)
        local c = create_card('Joker', G.pack_cards, true, 4, true, true, nil, 'BuffoonLen')
        return c
    end,
}

SMODS.Atlas {
    key = "fortuneBP",
    path = "bttiFortuneBuffoonPack.png",
    px = 71,
    py = 95
}
SMODS.Booster {
    key = "buffoon_fortune",
    weight = 0.6,
    kind = 'Buffoon', -- You can also use Buffoon if you want it to belong to the vanilla kind
    cost = 8,
    pos = { x = 0, y = 0 },
    atlas = 'fortuneBP',
    config = { extra = 2, choose = 1 },
    rarity = 4,
    loc_txt = {
        name = "Fortune Buffoon Pack",
        text = {
            "Choose 1 of up to 2",
            "{C:common}Common{}/{C:uncommon}Uncommon {C:joker}Jokers{}",
            "with a random {C:dark_edition}Edition{}"
        },
        group_name = 'Fortune Buffoon Pack'
    },
    loc_vars = function(self, info_queue, card)
        return {
        }
    end,
    ease_background_colour = function(self)
        ease_background_colour_blind(G.STATES.BUFFOON_PACK)
    end,
    create_card = function(self, card, i)
        local randomEdition = poll_edition("btti", nil, false, true)
        local c = SMODS.create_card({
            key = pseudorandom_element(G.P_JOKER_RARITY_POOLS[math.random(1, 2)],
                pseudoseed('btti')).key,
            area = G.pack_cards
        })
        if c.edition == nil then
            c:set_edition(randomEdition)
        end
        return c
    end,
}

SMODS.Atlas {
    key = "fortuneBPJumbo",
    path = "bttiJumboFortuneBuffoonPack.png",
    px = 71,
    py = 95
}
SMODS.Booster {
    key = "buffoon_fortune_jumbo",
    weight = 0.6,
    kind = 'Buffoon', -- You can also use Buffoon if you want it to belong to the vanilla kind
    cost = 12,
    pos = { x = 0, y = 0 },
    atlas = 'fortuneBPJumbo',
    config = { extra = 4, choose = 1 },
    rarity = 4,
    loc_txt = {
        name = "Jumbo Fortune Buffoon Pack",
        text = {
            "Choose 1 of up to 4",
            "{{C:common}Common{}/{C:uncommon}Uncommon {C:joker}Jokers{}",
            "with a random {C:dark_edition}Edition{}"
        },
        group_name = 'Jumbo Fortune Buffoon Pack'
    },
    loc_vars = function(self, info_queue, card)
        return {
        }
    end,
    ease_background_colour = function(self)
        ease_background_colour_blind(G.STATES.BUFFOON_PACK)
    end,
    create_card = function(self, card, i)
        local randomEdition = poll_edition("btti", nil, false, true)
        local c = SMODS.create_card({
            key = pseudorandom_element(G.P_JOKER_RARITY_POOLS[math.random(1, 2)],
                pseudoseed('btti')).key,
            area = G.pack_cards
        })
        if c.edition == nil then
            c:set_edition(randomEdition)
        end
        return c
    end,
}

SMODS.Atlas {
    key = "fortuneBPMega",
    path = "bttiMegaFortuneBuffoonPack.png",
    px = 71,
    py = 95
}
SMODS.Booster {
    key = "buffoon_fortune_mega",
    weight = 0.6,
    kind = 'Buffoon', -- You can also use Buffoon if you want it to belong to the vanilla kind
    cost = 20,
    pos = { x = 0, y = 0 },
    atlas = 'fortuneBPMega',
    config = { extra = 6, choose = 1 },
    rarity = 4,
    loc_txt = {
        name = "Mega Fortune Buffoon Pack",
        text = {
            "Choose 1 of up to 6",
            "{C:common}Common{}/{C:uncommon}Uncommon {C:joker}Jokers{}",
            "with a random {C:dark_edition}Edition{}."
        },
        group_name = 'Mega Fortune Buffoon Pack'
    },
    loc_vars = function(self, info_queue, card)
        return {
        }
    end,
    ease_background_colour = function(self)
        ease_background_colour_blind(G.STATES.BUFFOON_PACK)
    end,
    create_card = function(self, card, i)
        local randomEdition = poll_edition("btti", nil, false, true)
        local c = SMODS.create_card({
            key = pseudorandom_element(G.P_JOKER_RARITY_POOLS[math.random(1, 2)],
                pseudoseed('btti')).key,
            area = G.pack_cards
        })
        if c.edition == nil then
            c:set_edition(randomEdition)
        end
        return c
    end,
}

SMODS.Atlas {
    key = "ittiBP",
    path = "bttiInsanityBuffoonPack.png",
    px = 71,
    py = 95
}
SMODS.Booster {
    key = "buffoon_itti",
    weight = 0.6,
    kind = 'Buffoon', -- You can also use Buffoon if you want it to belong to the vanilla kind
    cost = 15,
    pos = { x = 0, y = 0 },
    atlas = 'ittiBP',
    config = { extra = 2, choose = 1 },
    loc_txt = {
        name = "Insanity Buffoon Pack",
        text = {
            "Choose 1 of up to 2",
            "{C:balinsanity}Inn-to the Insanity Jokers",
        },
        group_name = 'Insanity Buffoon Pack'
    },
    loc_vars = function(self, info_queue, card)
        return {
        }
    end,
    ease_background_colour = function(self)
        ease_background_colour_blind(G.STATES.BUFFOON_PACK)
    end,
    create_card = function(self, card, i)
        return SMODS.create_card({
            set = "BTTI_modAddition_ITTI",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
        })
    end,
}
SMODS.Atlas {
    key = "deetsBP",
    path = "bttiStablesBuffoonPack.png",
    px = 71,
    py = 95
}
SMODS.Booster {
    key = "buffoon_deets",
    weight = 0.6,
    kind = 'Buffoon', -- You can also use Buffoon if you want it to belong to the vanilla kind
    cost = 15,
    pos = { x = 0, y = 0 },
    atlas = 'deetsBP',
    config = { extra = 2, choose = 1 },
    loc_txt = {
        name = "Stables Buffoon Pack",
        text = {
            "Choose 1 of up to 2",
            "{C:deets}DEETS Jokers",
        },
        group_name = 'Stables Buffoon Pack'
    },
    loc_vars = function(self, info_queue, card)
        return {
        }
    end,
    ease_background_colour = function(self)
        ease_background_colour_blind(G.STATES.BUFFOON_PACK)
    end,
    create_card = function(self, card, i)
        return SMODS.create_card({
            set = "BTTI_modAddition_DEETS",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
        })
    end,
}

SMODS.Atlas {
    key = "smpBP",
    path = "bttiCrownedBuffoonPack.png",
    px = 71,
    py = 95
}
SMODS.Booster {
    key = "buffoon_smp",
    weight = 0.6,
    kind = 'Buffoon', -- You can also use Buffoon if you want it to belong to the vanilla kind
    cost = 25,
    pos = { x = 0, y = 0 },
    atlas = 'smpBP',
    config = { extra = 2, choose = 1 },
    loc_txt = {
        name = "Crowned Buffoon Pack",
        text = {
            "Choose 1 of up to 2",
            "{C:balinsanity}RegalitySMP Jokers",
        },
        group_name = 'Crowned Buffoon Pack'
    },
    loc_vars = function(self, info_queue, card)
        return {
        }
    end,
    ease_background_colour = function(self)
        ease_background_colour_blind(G.STATES.BUFFOON_PACK)
    end,
    create_card = function(self, card, i)
        return SMODS.create_card({
            set = "BTTI_modAddition_SMP",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
        })
    end,
}

SMODS.Atlas {
    key = "ymfpBP",
    path = "bttiFriendlyBuffoonPack.png",
    px = 71,
    py = 95
}
SMODS.Booster {
    key = "buffoon_ymfp",
    weight = 0.6,
    kind = 'Buffoon', -- You can also use Buffoon if you want it to belong to the vanilla kind
    cost = 12,
    pos = { x = 0, y = 0 },
    atlas = 'ymfpBP',
    config = { extra = 2, choose = 1 },
    loc_txt = {
        name = "Friendly Buffoon Pack",
        text = {
            "Choose 1 of up to 2",
            "{C:balinsanity}You're My Favorite Person",
            "{C:balinsanity}Jokers",
        },
        group_name = 'Friendly Buffoon Pack'
    },
    loc_vars = function(self, info_queue, card)
        return {
        }
    end,
    ease_background_colour = function(self)
        ease_background_colour_blind(G.STATES.BUFFOON_PACK)
    end,
    create_card = function(self, card, i)
        return SMODS.create_card({
            set = "BTTI_modAddition_YMFP",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
        })
    end,
}

SMODS.Atlas {
    key = "viralBP",
    path = "bttiViralBuffoonPack.png",
    px = 71,
    py = 95
}
SMODS.Booster {
    key = "buffoon_viral",
    weight = 0.6,
    kind = 'Buffoon', -- You can also use Buffoon if you want it to belong to the vanilla kind
    cost = 8,
    pos = { x = 0, y = 0 },
    atlas = 'viralBP',
    config = { extra = 2, choose = 1 },
    loc_txt = {
        name = "Viral Buffoon Pack",
        text = {
            "Choose 1 of up to 2",
            "{C:balinsanity}Internet Jokers",
        },
        group_name = 'Viral Buffoon Pack'
    },
    loc_vars = function(self, info_queue, card)
        return {
        }
    end,
    ease_background_colour = function(self)
        ease_background_colour_blind(G.STATES.BUFFOON_PACK)
    end,
    create_card = function(self, card, i)
        return SMODS.create_card({
            set = "BTTI_modAddition_INTERNET",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
        })
    end,
}

SMODS.Atlas {
    key = "celestialDeets",
    path = "bttiEquineCelestialPack.png",
    px = 71,
    py = 95
}
SMODS.Booster {
    key = "celestial_deets",
    weight = 1,
    kind = 'Celestial', -- You can also use Celestial if you want it to belong to the vanilla kind
    cost = 8,
    pos = { x = 0, y = 0 },
    config = { extra = 3, choose = 1 },
    atlas = 'celestialDeets',
    loc_txt = {
        name = "Equine Celestial Pack",
        text = {
            "Choose 1 of up to 3",
            "{C:deets}Horse Planet cards{}",
        },
        group_name = 'Equine Celestial Pack'
    },
    ease_background_colour = function(self)
        ease_background_colour_blind(G.STATES.PLANET_PACK)
    end,
    particles = function(self)
        G.booster_pack_stars = Particles(1, 1, 0, 0, {
            timer = 0.07,
            scale = 0.1,
            initialize = true,
            lifespan = 15,
            speed = 0.1,
            padding = -4,
            attach = G.ROOM_ATTACH,
            colours = { G.C.WHITE, HEX('a7d6e0'), HEX('fddca0') },
            fill = true
        })
        G.booster_pack_meteors = Particles(1, 1, 0, 0, {
            timer = 2,
            scale = 0.05,
            lifespan = 1.5,
            speed = 4,
            attach = G.ROOM_ATTACH,
            colours = { G.C.WHITE },
            fill = true
        })
    end,
    create_card = function(self, card, i)
        local _card
        if G.GAME.used_vouchers.v_telescope and i == 1 then
            local _planet, _hand, _tally = nil, nil, 0
            for _, handname in ipairs(G.handlist) do
                if SMODS.is_poker_hand_visible(handname) and G.GAME.hands[handname].played > _tally then
                    _hand = handname
                    _tally = G.GAME.hands[handname].played
                end
            end
            if _hand then
                for _, planet_center in pairs(G.P_CENTER_POOLS.Planet) do
                    if planet_center.config.hand_type == _hand then
                        _planet = planet_center.key
                    end
                end
            end
            _card = {
                set = "BTTI_modAddition_DEETSPlanets",
                area = G.pack_cards,
                skip_materialize = true,
                soulable = true,
                key = _planet,
                key_append =
                "btti"
            }
        else
            _card = {
                set = "BTTI_modAddition_DEETSPlanets",
                area = G.pack_cards,
                skip_materialize = true,
                soulable = true,
                key_append =
                "btti"
            }
        end
        return _card
    end,
    in_pool = function (self, args)
        if G.GAME.hands['HighHorse'].visible or G.GAME.hands['TwoHorse'].visible or G.GAME.hands['ThreeHorse'].visible or G.GAME.hands['FourHorsemen'].visible or G.GAME.hands['FullHorse'].visible then
            return true
        else
            return false
        end
    end
}
