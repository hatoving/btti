function Card:click()
    if self.area and self.area:can_highlight(self) then
        if (self.area == G.hand) and (G.STATE == G.STATES.HAND_PLAYED) then return end
        if self.highlighted ~= true then
            self.area:add_to_highlighted(self)
            SMODS.calculate_context { clicked_card = self, card_highlighted = true }
        else
            SMODS.calculate_context { clicked_card = self, card_highlighted = false }
            self.area:remove_from_highlighted(self)
            play_sound('cardSlide2', nil, 0.3)
        end
    end
    if self.area and self.area == G.deck and self.area.cards[1] == self then
        G.FUNCS.deck_info()
    end
end

local smodsCalcRef = SMODS.calculate_effect -- don't really need it but just in case
SMODS.calculate_effect = function(effect, scored_card, from_edition, pre_jokers)
    local ret = {}
    local hasXMult = false
    for _, key in ipairs(SMODS.calculation_keys) do
        if effect[key] then
            if effect.juice_card and not SMODS.no_resolve then
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()
                        effect.juice_card:juice_up(0.1)
                        if (not effect.message_card) or (effect.message_card and effect.message_card ~= scored_card) then
                            scored_card:juice_up(0.1)
                        end
                        return true
                    end
                }))
            end
            if G.GAME.blind.config.blind.key == 'bl_btti_captainBlind' then
                if (
                        key == "x_mult"
                        or key == "xmult"
                        or key == "Xmult"
                        or key == "x_mult_mod"
                        or key == "xmult_mod"
                        or key == "Xmult_mod"
                    ) then
                    effect[key] = 1
                    hasXMult = true
                end

                if hasXMult then
                    if key == "message" then
                        effect.message = "Nope!"
                    end
                    if key == "sound" then
                        sendInfoMessage("replacing sound", "BTTI")
                        effect[key] = 'card1'
                    elseif effect['sound'] == nil then
                        sendInfoMessage("replacing sound", "BTTI")
                        effect['sound'] = 'card1'
                    end
                end
            end
            local calc = SMODS.calculate_individual_effect(effect, scored_card, key, effect[key], from_edition)
            if calc == true then ret.calculated = true end
            if type(calc) == 'string' then
                ret[calc] = true
            elseif type(calc) == 'table' then
                for k, v in pairs(calc) do ret[k] = v end
            end
            if not SMODS.silent_calculation[key] then
                percent = (percent or 0) + (percent_delta or 0.08)
            end
        end
    end
    return ret
end

-- both musicIdx and musicIdxBoss MUST have the same jokers. one can't have more or less than the other
btti_musicIdx = {
    ['j_btti_Tenna'] = {
        'music_TennaNormal'
    }
}
btti_musicIdxBoss = {
    ['j_btti_Tenna'] = {
        'music_TennaBoss'
    }
}
local calcJokerRef = Card.calculate_joker
function Card:calculate_joker(context)
    if G.GAME.btti_selectedMusicIdx == nil then
        G.GAME.btti_selectedMusicIdx = 'NOTHING'
    end
    if context.setting_blind then
        btti_PONG_initByItself = true

        local jokers = {}
        for key, indexes in pairs(btti_musicIdx) do
            if jokerExists(key) then
                table.insert(jokers, key)
            end
        end

        if #jokers == 0 then
            G.GAME.btti_selectedMusicIdx = 'NOTHING'
        elseif #jokers == 1 then
            local list = (G.GAME.blind:get_type() == 'Boss') and btti_musicIdxBoss[jokers[1]] or
                btti_musicIdx[jokers[1]]
            if list and #list > 0 then
                G.GAME.btti_selectedMusicIdx = "btti_" .. list[math.random(1, #list)]
            else
                G.GAME.btti_selectedMusicIdx = "btti_" .. list[1]
            end
        else
            local chosenJoker = jokers[math.random(1, #jokers)]
            local list = (G.GAME.blind:get_type() == 'Boss') and btti_musicIdxBoss[chosenJoker] or
                btti_musicIdx[chosenJoker]
            if list and #list > 0 then
                G.GAME.btti_selectedMusicIdx = "btti_" .. list[math.random(1, #list)]
            else
                G.GAME.btti_selectedMusicIdx = "btti_" .. list[1]
            end
        end

        sendInfoMessage(
            "selecting music: " .. tostring(G.GAME.btti_selectedMusicIdx) ..
            ", is boss = " .. tostring((G.GAME.blind:get_type() == 'Boss')),
            "BTTI"
        )
    end
    if context.end_of_round then
        if btti_PONG_initialized then
            btti_PONG_kill()
        end
    end
    return calcJokerRef(self, context)
end


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

btti_whorseFlashbangAlpha = 0.0
btti_dwayneTheRockImage = loadImage('rock.png')
btti_dwayneTheRockAlpha = 0.0

local updateReal = love.update
function love.update(dt)
    updateReal(dt)
    
    if G and G.GAME then
        if G.GAME.btti_levelBlindCountdown == nil then  
            G.GAME.btti_levelBlindCountdown = 5.0
        end
        if G.STATE == G.STATES.MENU then
            if btti_PONG_state ~= btti_PONG_STATES.GAME_OVER then
                btti_PONG_initByItself = true
                btti_PONG_kill()
            end
        end
    end
    btti_PONG_update(dt)
    
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

                    card:set_edition()
                    card:set_edition('e_btti_digital')
                    card:juice_up()
                else
                    sendInfoMessage("All cards already have editions!", "BTTI")
                end
            end
        elseif G.GAME.blind.config.blind.key == 'bl_btti_pongBlind' then
            if not btti_PONG_initialized and btti_PONG_initByItself then
                btti_PONG_init()
                btti_PONG_initByItself = false
            end
        else
            if btti_PONG_initialized and btti_PONG_state ~= btti_PONG_STATES.GAME_OVER then
                btti_PONG_kill()
                btti_PONG_initByItself = true
            end
            G.GAME.btti_levelBlindCountdown = 5.0
        end
    end

    btti_whorseFlashbangAlpha = lerp(btti_whorseFlashbangAlpha, 0.0, dt / 4.0)
    btti_dwayneTheRockAlpha = lerp(btti_dwayneTheRockAlpha, 0.0, dt)
end

local drawRef = love.draw
function Game:draw()
    --#region STUFF I SHOULDN'T TOUCH
    G.FRAMES.DRAW = G.FRAMES.DRAW + 1
    --draw the room
    reset_drawhash()
    if G.OVERLAY_TUTORIAL and not G.OVERLAY_MENU then G.under_overlay = true end
    timer_checkpoint('start->canvas', 'draw')
    love.graphics.setCanvas { self.CANVAS }
    love.graphics.push()
    love.graphics.scale(G.CANV_SCALE)

    love.graphics.setShader()
    love.graphics.clear(0, 0, 0, 1)

    if G.SPLASH_BACK then
        if G.debug_background_toggle then
            love.graphics.clear({ 0, 1, 0, 1 })
        else
            love.graphics.push()
            G.SPLASH_BACK:translate_container()
            G.SPLASH_BACK:draw()
            love.graphics.pop()
        end
    end

    if not G.debug_UI_toggle then
        for k, v in pairs(self.I.NODE) do
            if not v.parent then
                love.graphics.push()
                v:translate_container()
                v:draw()
                love.graphics.pop()
            end
        end

        for k, v in pairs(self.I.MOVEABLE) do
            if not v.parent then
                love.graphics.push()
                v:translate_container()
                v:draw()
                love.graphics.pop()
            end
        end

        if G.SPLASH_LOGO then
            love.graphics.push()
            G.SPLASH_LOGO:translate_container()
            G.SPLASH_LOGO:draw()
            love.graphics.pop()
        end

        if G.debug_splash_size_toggle then
            for k, v in pairs(self.I.CARDAREA) do
                if not v.parent then
                    love.graphics.push()
                    v:translate_container()
                    v:draw()
                    love.graphics.pop()
                end
            end
        else
            if (not self.OVERLAY_MENU) or (not self.F_HIDE_BG) then
                timer_checkpoint('primatives', 'draw')
                for k, v in pairs(self.I.UIBOX) do
                    if not v.attention_text and not v.parent and v ~= self.OVERLAY_MENU and v ~= self.screenwipe and v ~= self.OVERLAY_TUTORIAL and v ~= self.debug_tools and v ~= self.online_leaderboard and v ~= self.achievement_notification then
                        love.graphics.push()
                        v:translate_container()
                        v:draw()
                        love.graphics.pop()
                    end
                end
                timer_checkpoint('uiboxes', 'draw')
                for k, v in pairs(self.I.CARDAREA) do
                    if not v.parent then
                        love.graphics.push()
                        v:translate_container()
                        v:draw()
                        love.graphics.pop()
                    end
                end

                for k, v in pairs(self.I.CARD) do
                    if (not v.parent and v ~= self.CONTROLLER.dragging.target and v ~= self.CONTROLLER.focused.target) then
                        love.graphics.push()
                        v:translate_container()
                        v:draw()
                        love.graphics.pop()
                    end
                end

                for k, v in pairs(self.I.UIBOX) do
                    if v.attention_text and v ~= self.debug_tools and v ~= self.online_leaderboard and v ~= self.achievement_notification then
                        love.graphics.push()
                        v:translate_container()
                        v:draw()
                        love.graphics.pop()
                    end
                end

                if G.SPLASH_FRONT then
                    love.graphics.push()
                    G.SPLASH_FRONT:translate_container()
                    G.SPLASH_FRONT:draw()
                    love.graphics.pop()
                end

                G.under_overlay = false
                if self.OVERLAY_TUTORIAL then
                    love.graphics.push()
                    self.OVERLAY_TUTORIAL:translate_container()
                    self.OVERLAY_TUTORIAL:draw()
                    love.graphics.pop()

                    if self.OVERLAY_TUTORIAL.highlights then
                        for k, v in ipairs(self.OVERLAY_TUTORIAL.highlights) do
                            love.graphics.push()
                            v:translate_container()
                            v:draw()
                            if v.draw_children then
                                v:draw_self()
                                v:draw_children()
                            end
                            love.graphics.pop()
                        end
                    end
                end
            end
            if (self.OVERLAY_MENU) or (not self.F_HIDE_BG) then
                if self.OVERLAY_MENU and self.OVERLAY_MENU ~= self.CONTROLLER.dragging.target then
                    love.graphics.push()
                    self.OVERLAY_MENU:translate_container()
                    self.OVERLAY_MENU:draw()
                    love.graphics.pop()
                end
            end

            if self.debug_tools then
                if self.debug_tools ~= self.CONTROLLER.dragging.target then
                    love.graphics.push()
                    self.debug_tools:translate_container()
                    self.debug_tools:draw()
                    love.graphics.pop()
                end
            end

            G.ALERT_ON_SCREEN = nil
            for k, v in pairs(self.I.ALERT) do
                love.graphics.push()
                v:translate_container()
                v:draw()
                G.ALERT_ON_SCREEN = true
                love.graphics.pop()
            end

            if self.CONTROLLER.dragging.target and self.CONTROLLER.dragging.target ~= self.CONTROLLER.focused.target then
                love.graphics.push()
                G.CONTROLLER.dragging.target:translate_container()
                G.CONTROLLER.dragging.target:draw()
                love.graphics.pop()
            end

            if self.CONTROLLER.focused.target and getmetatable(self.CONTROLLER.focused.target) == Card and
                (self.CONTROLLER.focused.target.area ~= G.hand or self.CONTROLLER.focused.target == self.CONTROLLER.dragging.target) then
                love.graphics.push()
                G.CONTROLLER.focused.target:translate_container()
                G.CONTROLLER.focused.target:draw()
                love.graphics.pop()
            end

            for k, v in pairs(self.I.POPUP) do
                love.graphics.push()
                v:translate_container()
                v:draw()
                love.graphics.pop()
            end

            if self.achievement_notification then
                love.graphics.push()
                self.achievement_notification:translate_container()
                self.achievement_notification:draw()
                love.graphics.pop()
            end


            if self.screenwipe then
                love.graphics.push()
                self.screenwipe:translate_container()
                self.screenwipe:draw()
                love.graphics.pop()
            end

            love.graphics.push()
            self.CURSOR:translate_container()
            love.graphics.translate(-self.CURSOR.T.w * G.TILESCALE * G.TILESIZE * 0.5,
                -self.CURSOR.T.h * G.TILESCALE * G.TILESIZE * 0.5)
            self.CURSOR:draw()
            love.graphics.pop()
            timer_checkpoint('rest', 'draw')
        end
    end
    love.graphics.pop()

    --#endregion

        love.graphics.push()

    love.graphics.setColor(1, 1, 1, btti_dwayneTheRockAlpha)
    love.graphics.draw(btti_dwayneTheRockImage, 0, 0, 0, (love.graphics.getWidth() / btti_dwayneTheRockImage:getWidth()),
        (love.graphics.getHeight() / btti_dwayneTheRockImage:getHeight()))
    love.graphics.setColor(1, 1, 1, btti_whorseFlashbangAlpha)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    btti_PONG_draw()

        love.graphics.pop()

    --#region STUFF I SHOULDN'T TOUCH PT. 2

    love.graphics.setCanvas(G.AA_CANVAS)
    love.graphics.push()
    love.graphics.setColor(G.C.WHITE)
    if (not G.recording_mode or G.video_control) and true then
        G.ARGS.eased_cursor_pos = G.ARGS.eased_cursor_pos or
        { x = G.CURSOR.T.x, y = G.CURSOR.T.y, sx = G.CONTROLLER.cursor_position.x, sy = G.CONTROLLER.cursor_position.y }
        G.screenwipe_amt = G.screenwipe_amt and
        (0.95 * G.screenwipe_amt + 0.05 * ((self.screenwipe and 0.4 or self.screenglitch and 0.4) or 0)) or 1
        G.SETTINGS.GRAPHICS.crt = G.SETTINGS.GRAPHICS.crt * 0.3
        G.SHADERS['CRT']:send('distortion_fac',
            { 1.0 + 0.07 * G.SETTINGS.GRAPHICS.crt / 100, 1.0 + 0.1 * G.SETTINGS.GRAPHICS.crt / 100 })
        G.SHADERS['CRT']:send('scale_fac',
            { 1.0 - 0.008 * G.SETTINGS.GRAPHICS.crt / 100, 1.0 - 0.008 * G.SETTINGS.GRAPHICS.crt / 100 })
        G.SHADERS['CRT']:send('feather_fac', 0.01)
        G.SHADERS['CRT']:send('bloom_fac', G.SETTINGS.GRAPHICS.bloom - 1)
        G.SHADERS['CRT']:send('time', 400 + G.TIMERS.REAL)
        G.SHADERS['CRT']:send('noise_fac', 0.001 * G.SETTINGS.GRAPHICS.crt / 100)
        G.SHADERS['CRT']:send('crt_intensity', 0.16 * G.SETTINGS.GRAPHICS.crt / 100)
        G.SHADERS['CRT']:send('glitch_intensity', 0) --0.1*G.SETTINGS.GRAPHICS.crt/100 + (G.screenwipe_amt) + 1)
        G.SHADERS['CRT']:send('scanlines', G.CANVAS:getPixelHeight() * 0.75 / G.CANV_SCALE)
        G.SHADERS['CRT']:send('mouse_screen_pos',
            G.video_control and { love.graphics.getWidth() / 2, love.graphics.getHeight() / 2 } or
            { G.ARGS.eased_cursor_pos.sx, G.ARGS.eased_cursor_pos.sy })
        G.SHADERS['CRT']:send('screen_scale', G.TILESCALE * G.TILESIZE)
        G.SHADERS['CRT']:send('hovering', 1)
        love.graphics.setShader(G.SHADERS['CRT'])
        G.SETTINGS.GRAPHICS.crt = G.SETTINGS.GRAPHICS.crt / 0.3
    end

    love.graphics.draw(self.CANVAS, 0, 0)
    love.graphics.pop()

    love.graphics.setCanvas()
    love.graphics.setShader()

    if G.AA_CANVAS then 
        love.graphics.push()
            love.graphics.scale(1/G.CANV_SCALE)
            love.graphics.draw(G.AA_CANVAS, 0, 0)
        love.graphics.pop()
    end

    timer_checkpoint('canvas', 'draw')

    if require("debugplus.config").getValue("showHUD") and not G.video_control and G.F_VERBOSE then
        love.graphics.push()
        love.graphics.setColor(0, 1, 1,1)
        local fps = love.timer.getFPS( )
        do
            local otherSize = 0
            for k,v in pairs(G.E_MANAGER.queues or {}) do 
                if k ~= 'base' then 
                    otherSize = otherSize + #v
                end
            end
            if otherSize ~= 0 then
                love.graphics.print(string.format("Current FPS: %d\nBase event queue: %d\nOther event queues: %d", fps, #(G.E_MANAGER.queues and G.E_MANAGER.queues.base or {}), otherSize), 10, 10)
            else
                love.graphics.print(string.format("Current FPS: %d\nBase event queue: %d", fps, #(G.E_MANAGER.queues and G.E_MANAGER.queues.base or {})), 10, 10)
            end
        end

        if G.check and G.SETTINGS.perf_mode then
            local section_h = 30
            local resolution = 60*section_h
            local poll_w = 1
            local v_off = 100
            for a, b in ipairs({G.check.update, G.check.draw}) do
                for k, v in ipairs(b.checkpoint_list) do
                    love.graphics.setColor(0,0,0,0.2)
                    love.graphics.rectangle('fill', 12, 20 + v_off,poll_w+poll_w*#v.trend,-section_h + 5)
                    for kk, vv in ipairs(v.trend) do
                        if a == 2 then 
                            love.graphics.setColor(0.3,0.7,0.7,1)
                        else
                            love.graphics.setColor(self:state_col(v.states[kk] or 123))
                        end
                        love.graphics.rectangle('fill', 10+poll_w*kk,  20 + v_off, 5*poll_w, -(vv)*resolution)
                    end
                    v_off = v_off + section_h
                    end
                    local v_off = v_off - section_h * #b.checkpoint_list
                    for k, v in ipairs(b.checkpoint_list) do
                    love.graphics.setColor(a == 2 and 0.5 or 1, a == 2 and 1 or 0.5, 1,1)
                    love.graphics.print(v.label..': '..(string.format("%.2f",1000*(v.average or 0)))..'\n', 10, -section_h + 30 + v_off)
                    v_off = v_off + section_h
                end
            end
        end

        love.graphics.pop()
    end
    timer_checkpoint('debug', 'draw')
    --#endregion
end