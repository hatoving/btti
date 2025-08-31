btti_whorseFlashbangAlpha = 0.0
btti_dwayneTheRockImage = loadImage('rock.png')
btti_dwayneTheRockAlpha = 0.0

local updateReal = love.update
function love.update(dt)
    updateReal(dt)

    if (G and G.jokers and G.jokers.cards) and (not jokerExists('j_btti_Huntrix')) then
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i].ability.extra and type(G.jokers.cards[i].ability.extra) ~= 'number' then
                if G.jokers.cards[i].ability.extra.huntrix then
                    G.jokers.cards[i].ability.extra.huntrix = false
                    G.jokers.cards[i].ability.eternal = false
                end
            end
        end
    end

    if G and G.GAME then
        if G.STATE == G.STATES.MENU then
            if btti_PONG_state ~= btti_PONG_STATES.GAME_OVER then
                btti_PONG_initByItself = true
                btti_PONG_kill()
            end
            if btti_JDASH_state ~= btti_JDASH_STATES.GAME_OVER then
                btti_JDASH_initByItself = true
                btti_JDASH_kill()
            end
        end
    end

    btti_PONG_update(dt)
    btti_JDASH_update(dt)

    for i = 1, #G.effectmanager do
        if G.effectmanager[i] and G.effectmanager[i][1] then
            if G.effectmanager[i][1].duration ~= nil and G.effectmanager[i][1].duration >= -1 then
                local _eff = G.effectmanager[i][1]

                _eff.tfps = _eff.tfps + 1
                _eff.duration = _eff.duration - 1

                if _eff.tfps > 100 / _eff.fps and _eff.fps ~= 0 then
                    _eff.frame = _eff.frame + 1
                    _eff.tfps = 0
                end
                if _eff.frame > _eff.maxframe then
                    _eff.frame = 1
                end
            elseif G.effectmanager[i][1].duration ~= nil and G.effectmanager[i][1].duration <= 0 then
                G.effectmanager[i] = nil
            end
        end
    end

    if G.GAME.blind then
        if G.GAME.blind.config.blind.key == 'bl_btti_truckBlind' or G.GAME.blind.config.blind.key == 'bl_btti_ticketBlind' then
            --G.GAME.blind.loc_debuff_lines = { math.random(1, 69), math.random(1, 69), G.GAME.blind.debuffedHand or 'Nothing mistah white...' }
            G.GAME.blind:set_text()
        end

        if G.GAME.blind.config.blind.key == 'bl_btti_levelBlind' then
            G.GAME.btti_levelBlindCountdown = G.GAME.btti_levelBlindCountdown - dt
            if G.GAME.btti_levelBlindCountdown <= 0.0 then
                G.GAME.btti_levelBlindCountdown = 5.0
                local emptyEditionIndices = {}
                for i, card in ipairs(G.hand.cards) do
                    if card.edition == nil then
                        table.insert(emptyEditionIndices, i)
                    end
                end

                if #emptyEditionIndices > 0 then
                    local randomIndex = emptyEditionIndices[math.random(1, #emptyEditionIndices)]
                    local card = G.hand.cards[randomIndex]

                    card:set_edition('e_btti_digital')
                    card:juice_up()
                else
                    sendInfoMessage("All cards already have editions!", "BTTI")
                end
            end
        end
        if G.GAME.blind.config.blind.key == 'bl_btti_pongBlind' then
            if not btti_PONG_initialized and btti_PONG_initByItself then
                btti_PONG_init()
                btti_PONG_initByItself = false
            end
        else
            if btti_PONG_initialized and btti_PONG_state ~= btti_PONG_STATES.GAME_OVER then
                btti_PONG_kill()
                btti_PONG_initByItself = true
            end
        end
        if G.GAME.blind.config.blind.key == 'bl_btti_gdBlind' then
            if not btti_JDASH_initialized and btti_JDASH_initByItself then
                btti_JDASH_init()
                btti_JDASH_initByItself = false
            end
        else
            if btti_JDASH_initialized and btti_JDASH_state ~= btti_JDASH_STATES.GAME_OVER then
                btti_JDASH_kill()
                btti_JDASH_initByItself = true
            end
        end
        --btti_JDASH_init()
    end

    btti_whorseFlashbangAlpha = lerp(btti_whorseFlashbangAlpha, 0.0, dt / 4.0)
    btti_dwayneTheRockAlpha = lerp(btti_dwayneTheRockAlpha, 0.0, dt)
end

local explosion = loadImage("explosion.png")
local explosionSpriteSheet = loadImageSpriteSheet("explosion.png", 200,
    282, 17, 0)
function btti_MODDRAW()
    love.graphics.push()

    love.graphics.setColor(1, 1, 1, btti_dwayneTheRockAlpha)
    love.graphics.draw(btti_dwayneTheRockImage, 0, 0, 0, (love.graphics.getWidth() / btti_dwayneTheRockImage:getWidth()),
        (love.graphics.getHeight() / btti_dwayneTheRockImage:getHeight()))
    love.graphics.setColor(1, 1, 1, btti_whorseFlashbangAlpha)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    btti_PONG_draw()
    btti_JDASH_draw()

    if G.effectmanager then
        --print("Effect manager has "..#G.effectmanager)
        for i = 1, #G.effectmanager do
            local _xscale = love.graphics.getWidth() / 1920
            local _yscale = love.graphics.getHeight() / 1080
            --print("G.effectmanager[i].name ".. G.effectmanager[i][1].name)
            if G.effectmanager[i] ~= nil then
                if G.effectmanager[i][1].name == "explosion" then
                    bttiEffectManagerImgToDraw = explosion
                    bttiEffectManagerQuadToDraw = explosionSpriteSheet
                    bttiEffectManagerImgIndex = G.effectmanager[i][1].frame
                    bttiEffectManagerXPos = G.effectmanager[i][1].xpos - (200 / 2)
                    bttiEffectManagerYPos = G.effectmanager[i][1].ypos - (282 / 2)
                    --print("_imgindex".. _imgindex)
                    love.graphics.setColor(1, 1, 1, 1)
                end
                if bttiEffectManagerQuadToDraw ~= nil then
                    love.graphics.draw(bttiEffectManagerImgToDraw, bttiEffectManagerQuadToDraw
                        [bttiEffectManagerImgIndex],
                        bttiEffectManagerXPos, bttiEffectManagerYPos, 0, 1, 1)
                end
            end
        end
    end

    love.graphics.pop()
end
