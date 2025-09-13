SMODS.Atlas {
    key = 'VirusDeck',
    path = 'bttiDonor1.png',
    px = 71,
    py = 95,
}

SMODS.Back({
    key = "virusDeck",
    loc_txt = {
        name = "Virus Deck",
        text = {
            "Start with a Digital Deck"
        },
    },

    config = { hands = 0, discards = 0, consumeables = 'c_opentolan' },
    pos = { x = 0, y = 0 },
    order = 1,
    atlas = "VirusDeck",
    unlocked = true,

    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                if G.playing_cards then
                    for i=1,#G.playing_cards do
                        G.playing_cards[i]:set_edition('e_btti_digital', true, true)
                    end
                    return true
                end
            end,
        }))
    end,

    check_for_unlock = function(self, args)
        if args.type == "win_deck" then
            unlock_card(self)
        else
            unlock_card(self)
        end
    end,
})
