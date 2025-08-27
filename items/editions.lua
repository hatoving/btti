
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
            "Destroys itself from the",
            "{C:attention}deck{} once the ante is over"
        }
    },
    in_shop = true,
    extra_cost = 3,
    apply_to_float = false,
    sound = { sound = "holo1", per = 1.2 * 1.58, vol = 0.4 },
    loc_vars = function(self, info_queue, card)
        return { vars = { currentAnte = nil } }
    end,
    config = { extra = { ante = 0 } },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    calculate = function(self, card, context)
        if self.config.extra.currentAnte == nil then
            self.config.extra.currentAnte = G.GAME.round_resets.ante
        end
        if G.GAME.round_resets.ante ~= self.config.extra.currentAnte then
            sendInfoMessage("glitchus deletus", "BTTI")
            local digitalCards = 0
            for i, pc in ipairs(G.deck.cards) do
                if pc.edition then
                    if pc.edition.key == 'e_btti_digital' then
                        digitalCards = digitalCards + 1
                        sendInfoMessage("glitchus deletus : " .. digitalCards, "BTTI")
                        pc:start_dissolve()
                    end
                end
            end
            card:start_dissolve()
        end
    end
}
