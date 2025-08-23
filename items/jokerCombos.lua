-- Avariocious
SMODS.Atlas {
    key = "avariciousJoker",
    path = "bttiAvariciousJoker.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'avariciousJoker',
    loc_txt = {
        name = 'Avaricious Joker',
        text = {
            "Played cards with {C:diamonds}Diamond",
            "or {C:hearts}Heart{} suits give {C:mult}+3{} Mult",
            "when scored",
            "{C:inactive}(Lusty Joker + Greedy Joker)"
        }
    },

    config = { extra = { } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "Combo!!" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 2,
    atlas = 'avariciousJoker',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTImodadditionCOMBO"] = true },

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and
            (context.other_card:is_suit('Diamonds') or context.other_card:is_suit('Hearts')) then
            return {
                mult = 3
            }
        end
    end,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end
}

-- Sullen Joker
SMODS.Atlas {
    key = "sullenJoker",
    path = "bttiSullenJoker.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'sullenJoker',
    loc_txt = {
        name = 'Sullen Joker',
        text = {
            "Played cards with {C:spades}Spade",
            "or {C:clubs}Clubs{} suits give {C:mult}+3{} Mult",
            "when scored",
            "{C:inactive}(Wrathful Joker + Gluttonous Joker)"
        }
    },

    config = { extra = {} },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "Combo!!" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 1,
    atlas = 'sullenJoker',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTImodadditionCOMBO"] = true },

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and
            (context.other_card:is_suit('Spades') or context.other_card:is_suit('Clubs')) then
            return {
                mult = 3
            }
        end
    end,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end
}

SMODS.Atlas {
    key = "sinfulJoker",
    path = "bttiSinfulJoker.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'sinfulJoker',
    loc_txt = {
        name = 'Sinful Joker',
        text = {
            "Played cards with give",
            "{C:mult}+5{} when scored",
            "{C:inactive}(Avaricious Joker + Sullen Joker)"
        }
    },

    config = { extra = {} },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "Combo!!" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 1,
    atlas = 'sinfulJoker',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTImodadditionCOMBO"] = true },

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            return {
                mult = 5
            }
        end
    end,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end
}

SMODS.Atlas {
    key = "bonkersJoker",
    path = "bttiBonkersJoker.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'bonkersJoker',
    loc_txt = {
        name = 'Bonkers Joker',
        text = {
            "{C:mult}+12{} Mult and {C:chips}+100{} Chips",
            "if played hand contains a",
            "{C:attention}Straight",
            "{C:inactive}(Crazy Joker + Devious Joker)"
        }
    },

    config = { extra = {} },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "Combo!!" } }
        return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
    end,
    rarity = 3,
    atlas = 'bonkersJoker',
    pos = { x = 0, y = 0 },
    cost = 6,
    pools = { ["BTTImodadditionCOMBO"] = true },

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands['Straight']) then
            return {
                mult = 12,
                chips = 100
            }
        end
    end,
    in_pool = function(self, args)
        return false, { allow_duplicates = false }
    end
}
