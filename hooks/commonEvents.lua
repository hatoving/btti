local evalCardRef = eval_card
function eval_card(card, context)
    if context.ante_change and context.ante_end then
        sendInfoMessage("Ante change!", "BTTI")
        local digitalCards = 0
        for i, pc in ipairs(G.playing_cards) do
            if pc.edition then
                if pc.edition.key == 'e_btti_digital' then
                    digitalCards = digitalCards + 1
                    pc:start_dissolve()
                end
            end
        end
        sendInfoMessage("glitchus deletus : " .. digitalCards, "BTTI")
        G.GAME.btti_isBlindBoss = false
    end
    return evalCardRef(card, context)
end