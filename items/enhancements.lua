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

-- stained Card
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
            "{C:green}1 in 2{} chance to leak into the",
            "card to its right, triggering it",
            "once before that card is triggered"
        }
    },
    atlas = 'stainedCard',
    pos = { x = 0, y = 0 },
    config = { },
    replace_base_card = false,
    no_rank = true,
    no_suit = true,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'bttiFromWhere', set = 'Other', vars = { "You're My Favorite Person" } }
        return { vars = { } }
    end,
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            if pseudorandom('MsBreward') < G.GAME.probabilities.normal / 2 then
                
            end
        end
    end
}
