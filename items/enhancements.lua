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
            "Has no Suit or Rank.",
            "{C:chips}+#1#{} Chips",
        }
    },
    atlas = 'horseCard',
    pos = { x = 0, y = 0 },
    config = { bonus = 75 },
    replace_base_card = true,
    no_rank = true,
    no_suit = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.bonus } }
    end,
}

-- Spilled Card
SMODS.Atlas {
    key = "spilledCard",
    path = "bttiSpilledCard.png",
    px = 71,
    py = 95
}
SMODS.Enhancement {
    key = 'spilledCard',
    loc_txt = {
        name = 'Spilled Card',
        text = {
            "{C:green}1 in 2{} to leak into the",
            "card to its right, triggering it",
            "once before that card is triggered"
        }
    },
    atlas = 'spilledCard',
    pos = { x = 0, y = 0 },
    config = { },
    replace_base_card = false,
    no_rank = true,
    no_suit = true,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "You're My Favorite Person" } }
        return { vars = { } }
    end,
}
