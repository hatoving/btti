-- Restart Deck
SMODS.Atlas {
    key = 'RestartDeck',
    path = 'bttiRestartDeck.png',
    px = 71,
    py = 95,
}

SMODS.Back({
    key = "restartDeck",
    loc_txt = {
        name = "Restart Deck",
        text = {
            "Starting an ante turns",
            "1 in 4 of your cards {C:blue}Digital{}"
        },
    },

    config = { },
    pos = { x = 0, y = 0 },
    order = 1,
    atlas = "RestartDeck",
    unlocked = true,

    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                if G.playing_cards and #G.playing_cards >= (math.floor(#G.playing_cards / 4)) then
                    local indices = {}
                    for i = 1, #G.playing_cards do
                        table.insert(indices, i)
                    end

                    for i = #indices, 2, -1 do
                        local j = math.random(i)
                        indices[i], indices[j] = indices[j], indices[i]
                    end

                    for k = 1, (math.floor(#G.playing_cards / 4)) do
                        local card = G.playing_cards[indices[k]]
                        card:set_edition('e_btti_digital', true, true)
                    end
                    return true
                end
            end,
        }))
    end,

    calculate = function (self, back, context)
        if context.ante_change then
            G.E_MANAGER:add_event(Event({
                func = function()
                    if G.playing_cards and #G.playing_cards >= (math.floor(#G.playing_cards / 4)) then
                        local indices = {}
                        for i = 1, #G.playing_cards do
                            table.insert(indices, i)
                        end

                        for i = #indices, 2, -1 do
                            local j = math.random(i)
                            indices[i], indices[j] = indices[j], indices[i]
                        end

                        for k = 1, (math.floor(#G.playing_cards / 4)) do
                            local card = G.playing_cards[indices[k]]
                            card:set_edition('e_btti_digital', true, true)
                        end
                        return true
                    end
                end,
            }))
        end
    end,

    check_for_unlock = function(self, args)
        if args.type == "win_deck" then
            unlock_card(self)
        else
            unlock_card(self)
        end
    end,
})
