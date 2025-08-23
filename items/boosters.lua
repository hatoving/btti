-- Buffoon Packs

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
    cost = 100,
    pos = { x = 0, y = 0 },
    atlas = 'legendaryBP',
    config = { extra = 2, choose = 1 },
    group_key = "k_buffoon_pack",
    loc_txt = {
        name = "Legendary Buffoon Pack",
        text = {
            "Choose 1 of up to 2",
            "{C:attention}Legendary Jokers"
        },
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
    cost = 30,
    pos = { x = 0, y = 0 },
    atlas = 'fortuneBP',
    config = { extra = 2, choose = 1 },
    group_key = "k_buffoon_pack",
    rarity = 4,
    loc_txt = {
        name = "Fortune Buffoon Pack",
        text = {
            "Choose 1 of up to 2",
            "{C:attention}Common/Uncommon Jokers{}",
            "with a random {C:dark_edition}Edition{}."
        },
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
        local c = SMODS.create_card({ key = pseudorandom_element(G.P_JOKER_RARITY_POOLS[math.random(1, 2)],
                pseudoseed('btti')).key,
            area = G.pack_cards
        })
        c:set_edition(randomEdition)
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
    cost = 30,
    pos = { x = 0, y = 0 },
    atlas = 'fortuneBPJumbo',
    config = { extra = 4, choose = 1 },
    group_key = "k_buffoon_pack",
    rarity = 4,
    loc_txt = {
        name = "Jumbo Fortune Buffoon Pack",
        text = {
            "Choose 1 of up to 4",
            "{C:attention}Common/Uncommon Jokers{}",
            "with a random {C:dark_edition}Edition{}."
        },
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
        c:set_edition(randomEdition)
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
    cost = 30,
    pos = { x = 0, y = 0 },
    atlas = 'fortuneBPMega',
    config = { extra = 6, choose = 1 },
    group_key = "k_buffoon_pack",
    rarity = 4,
    loc_txt = {
        name = "Mega Fortune Buffoon Pack",
        text = {
            "Choose 1 of up to 6",
            "{C:attention}Common/Uncommon Jokers{}",
            "with a random {C:dark_edition}Edition{}."
        },
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
        c:set_edition(randomEdition)
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
    cost = 30,
    pos = { x = 0, y = 0 },
    atlas = 'ittiBP',
    config = { extra = 2, choose = 1 },
    group_key = "k_buffoon_pack",
    loc_txt = {
        name = "Insanity Buffoon Pack",
        text = {
            "Choose 1 of up to 2",
            "{C:purple}Inn-to the Insanity{} {C:attention}Jokers",
        },
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
            set = "BTTImodadditionITTI",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
        })
    end,
}
