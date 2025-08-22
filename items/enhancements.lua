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