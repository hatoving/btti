local playSoundRef = play_sound
function play_sound(sound_code, per, vol)
    if string.find(sound_code, 'multhit') ~= nil then
        if G.jokers then
            for i, jk in ipairs(G.jokers.cards) do
                if jk.config.center.key == "j_btti_MetalPipe" then
                    sendInfoMessage("playing metal pipe instead", "BTTI")
                    return playSoundRef('btti_metalPipeMult', per, vol)
                end
            end
        end
    end
    return playSoundRef(sound_code, per, vol)
end
