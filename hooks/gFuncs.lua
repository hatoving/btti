local gFuncsSetBlindRef = G.FUNCS.select_blind
function G.FUNCS.select_blind(e)
    if jokerExists('j_btti_Spoingus') and G.jokers.cards[getJoker('j_btti_Spoingus')] then
        G.jokers.cards[getJoker('j_btti_Spoingus')].ability.extra.effect = 8
        sendInfoMessage("spoingus effect " .. G.jokers.cards[getJoker('j_btti_Spoingus')].ability.extra.effect .. "",
            "BTTI")
        if G.jokers.cards[getJoker('j_btti_Spoingus')].ability.extra.effect == 7 then
            e = G.blind_select_opts.boss:get_UIE_by_ID('select_blind_button')
        end
    end
    return gFuncsSetBlindRef(e)
end
