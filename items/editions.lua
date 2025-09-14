-- Digital
SMODS.Shader ( {
    key = 'digital',
    path = 'digital.fs'
})

SMODS.Edition {
    key = 'digital',
    shader = 'digital',
    order = 0,
    loc_txt = {
        name = "Digital",
        label = "Digital",
        text = {
            "{C:red}Deletes{} itself once",
            "the {C:attention}ante{} is over"
        }
    },
    in_shop = true,
    extra_cost = 3,
    apply_to_float = false,
    sound = { sound = "holo1", per = 1.2 * 1.58, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = { } }
    end,
    config = { extra = { ante = 0 } },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    calculate = function(self, card, context)
        if context.ante_change and context.ante_end then
            sendInfoMessage("Ante change!", "BTTI")
            G.GAME.btti_isBlindBoss = false
        end
    end
}
