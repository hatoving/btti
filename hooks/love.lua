G.BTTI.whorseFlashbangAlpha = 0.0

G.BTTI.dwayneTheRockImage = loadImage('rock.png')
G.BTTI.dwayneTheRockAlpha = 0.0

G.BTTI.biteOf87Image = loadImage('biteOf87.png')
G.BTTI.biteOf87Quads = {}
local bo87W, bo87H = G.BTTI.biteOf87Image:getWidth(), G.BTTI.biteOf87Image:getHeight()
local bo87QuadW, bo87QuadH = 159, 155
local bo87Cols = math.floor(bo87W / bo87QuadW)
local bo87Rows = math.floor(bo87H / bo87QuadH)

for y = 0, bo87Rows - 1 do
    for x = 0, bo87Cols - 1 do
        table.insert(G.BTTI.biteOf87Quads,
            love.graphics.newQuad(x * bo87QuadW, y * bo87QuadH, bo87QuadW, bo87QuadH, bo87W, bo87H))
    end
end

G.BTTI.biteOf87_IDLE = { 1, 55 }
G.BTTI.biteOf87_SHOCK = { 75, 130 }
G.BTTI.biteOf87_SHOCK_LOOP = { 130, 144 }
G.BTTI.biteOf87_BITE = { 145, 398 }

SMODS.Sound({ key = "bo87_0", path = "bttiBiteOf87_0.ogg" })
SMODS.Sound({ key = "bo87_1", path = "bttiBiteOf87_1.ogg" })
SMODS.Sound({ key = "bo87_2", path = "bttiBiteOf87_2.ogg" })

G.BTTI.biteOf87Tick = 0
G.BTTI.biteOf87FrameDur = 0.02
G.BTTI.biteOf87Frame = 1
G.BTTI.biteOf87LastFrame = 1
G.BTTI.biteOf87FrameStart = 0
G.BTTI.biteOf87FrameMax = 55
G.BTTI.biteOf87Init = false
G.BTTI.biteOf87Ramble = loadSound("bttiBiteOf87Ramble.ogg", "stream")
G.BTTI.biteOf87Ramble:setLooping(true)
G.BTTI.biteOf87RambleVol = 1.0
G.BTTI.biteOf87PlayedClip = false

function G.BTTI.biteOf87Change(frame, which)
    G.BTTI.biteOf87PlayedClip = false
    G.BTTI.biteOf87Frame = frame
    G.BTTI.biteOf87FrameStart = which[1]
    G.BTTI.biteOf87FrameMax = which[2]

    if which ~= G.BTTI.biteOf87_IDLE then
        G.BTTI.biteOf87Ramble:pause()
    else
        G.BTTI.biteOf87Ramble:play()
    end
end

G.BTTI.dvdLogo = {
    Image = loadImage('dvdLogo.png'),
    X = 0.0,
    Y = 0.0,
    VX = 100 * (math.random(0, 1) == 0 and -1 or 1),
    VY = 100 * (math.random(0, 1) == 0 and -1 or 1),
    Alpha = 0.0,
    Colors = {
        { 1,   0,   0 }, -- Red
        { 0,   1,   0 }, -- Green
        { 0,   0,   1 }, -- Blue
        { 1,   1,   0 }, -- Yellow
        { 1,   0,   1 }, -- Magenta
        { 0,   1,   1 }, -- Cyan
        { 1,   0.5, 0 }, -- Orange
        { 0.5, 0,   1 }, -- Purple
    },
    Color = nil,
}
G.BTTI.dvdLogo.Color = G.BTTI.dvdLogo.Colors[love.math.random(1, #G.BTTI.dvdLogo.Colors)]
function G.BTTI.dvdLogoNextColor(current)
    local newColor
    repeat
        newColor = G.BTTI.dvdLogo.Colors[love.math.random(1, #G.BTTI.dvdLogo.Colors)]
    until newColor ~= current
    return newColor
end

G.BTTI.steamCheckTimer = 0.0
G.BTTI.installedSteamApps = G.BTTI.countInstalledSteamApps()
G.BTTI.foundSteamApps = G.BTTI.installedSteamApps ~= 0

G.BTTI.ytDataCheckTimer = 0.0

local screenWidth, screenHeight = love.graphics.getDimensions()

SMODS.Sound({ key = "explosion", path = "bttiExplosion.ogg" })

SMODS.Sound({ key = "brimstone0", path = "bttiBrimstone0.ogg" })
SMODS.Sound({ key = "brimstone1", path = "bttiBrimstone1.ogg" })
SMODS.Sound({ key = "brimstone2", path = "bttiBrimstone2.ogg" })

local function jokerAnimUpdate(dt)
    local scCenter = G.P_CENTERS.j_btti_SayThatAgain
    scCenter.ticks = scCenter.ticks + dt
    if scCenter.ticks >= scCenter.frameDur then
        scCenter.ticks = 0
        scCenter.frame = scCenter.frame + 1
        if scCenter.frame > scCenter.maxFrame then
            scCenter.frame = 0
        end
        scCenter.pos.x = math.fmod(scCenter.frame, 6)
        scCenter.pos.y = math.floor(scCenter.frame / 6)
    end

    scCenter = G.P_CENTERS.j_btti_GIFCompression
    scCenter.ticks = scCenter.ticks + dt
    if scCenter.ticks >= scCenter.frameDur then
        scCenter.ticks = 0
        scCenter.frame = scCenter.frame + 1
        if scCenter.frame > scCenter.maxFrame then
            scCenter.frame = 0
        end
        scCenter.pos.x = math.fmod(scCenter.frame, 6)
        scCenter.pos.y = math.floor(scCenter.frame / 6)
    end
end

local updateReal = love.update
function love.update(dt)
    updateReal(dt)
    G.BTTI.ytDataCheckTimer = G.BTTI.ytDataCheckTimer - dt
    if G.BTTI.ytDataCheckTimer <= 0.0 then
        G.BTTI.HTTPS.getYouTubeData()
        G.BTTI.ytDataCheckTimer = 3600 -- this roughly an hour in seconds
    end

    if G then
        jokerAnimUpdate(dt)

        if jokerExists('j_btti_BiteOf87') then
            G.BTTI.biteOf87RambleVol = lerp(G.BTTI.biteOf87RambleVol, 0.35 * (G.SETTINGS.SOUND.game_sounds_volume / 100),
                2.0 * dt)
            G.BTTI.biteOf87Ramble:setVolume(G.BTTI.biteOf87RambleVol)
            G.BTTI.biteOf87Tick = G.BTTI.biteOf87Tick + dt
            if G.BTTI.biteOf87Frame >= 278 and not G.BTTI.biteOf87PlayedClip then
                play_sound('btti_bo87_' .. math.random(0, 2))
                G.BTTI.biteOf87PlayedClip = true
            end
            if G.BTTI.biteOf87Tick >= G.BTTI.biteOf87FrameDur then
                G.BTTI.biteOf87Tick = 0
                G.BTTI.biteOf87Frame = G.BTTI.biteOf87Frame + 1
                if G.BTTI.biteOf87Frame > G.BTTI.biteOf87FrameMax then
                    if G.BTTI.biteOf87FrameMax == G.BTTI.biteOf87_BITE then
                        G.BTTI.biteOf87Change(0, G.BTTI.biteOf87_IDLE)
                    elseif G.BTTI.biteOf87FrameMax == G.BTTI.biteOf87_SHOCK then
                        G.BTTI.biteOf87Change(0, G.BTTI.biteOf87_SHOCK_LOOP)
                    else
                        G.BTTI.biteOf87Change(0, G.BTTI.biteOf87_IDLE)
                    end
                end
            end
        else
            if G.BTTI.biteOf87Ramble:isPlaying() then
                G.BTTI.biteOf87Ramble:stop()
            end
            G.BTTI.biteOf87RambleVol = 1.0 * (G.SETTINGS.SOUND.game_sounds_volume / 100)
        end

        if jokerExists('j_btti_Steam') and G.BTTI.foundSteamApps then
            G.BTTI.steamCheckTimer = G.BTTI.steamCheckTimer + dt
            if G.BTTI.steamCheckTimer >= 120.0 then
                G.BTTI.steamCheckTimer = 0.0
                G.BTTI.installedSteamApps = G.BTTI.countInstalledSteamApps()
            end
        end

        if (G and G.jokers and G.jokers.cards) and (not jokerExists('j_btti_Huntrix')) then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.huntrix then
                        G.jokers.cards[i].ability.huntrix = false
                        G.jokers.cards[i].ability.eternal = false
                end
            end
         end

        if G and G.GAME then
            if G.STATE == G.STATES.MENU then
                if G.BTTI.PONG_state ~= G.BTTI.PONG_STATES.GAME_OVER then
                    G.BTTI.PONG_initByItself = true
                    G.BTTI.PONG_kill()
                end
                if G.BTTI.JDASH_state ~= G.BTTI.JDASH_STATES.GAME_OVER then
                    G.BTTI.JDASH_initByItself = true
                    G.BTTI.JDASH_kill()
                    ----sendInfoMessage("G.BTTI.JDASH_kill at 72", "BTTI")
                end
            end
        end

        G.BTTI.PONG_update(dt)
        G.BTTI.JDASH_update(dt)

        -- shamlessly stolen from yahimod
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

                    if _eff.name == "brimstone" then
                        _eff.yscale = _eff.yscale - (dt * 2.2)
                        if _eff.yscale <= 0 then
                            _eff.yscale = 0
                        end
                    end
                elseif G.effectmanager[i][1].duration ~= nil and G.effectmanager[i][1].duration <= 0 then
                    if G.effectmanager[i][1].name ~= "brimstone" then
                        G.effectmanager[i] = nil
                    else
                        G.effectmanager[i][1].duration = 99
                        if G.effectmanager[i][1].yscale <= 0 then
                            G.effectmanager[i] = nil
                        end
                    end
                end
            end
        end

        if G.GAME.blind then
            if G.GAME.blind.config.blind.key == 'bl_btti_truckBlind' or G.GAME.blind.config.blind.key == 'bl_btti_ticketBlind' then
                --G.GAME.blind.loc_debuff_lines = { math.random(1, 69), math.random(1, 69), G.GAME.blind.debuffedHand or 'Nothing mistah white...' }
                G.GAME.blind:set_text()
            end

            if G.GAME.blind.config.blind.key == 'bl_btti_levelBlind' then
				if G.BTTI.levelBlindCountdown == nil then
					G.BTTI.levelBlindCountdown = 5
				end
                G.BTTI.levelBlindCountdown = G.BTTI.levelBlindCountdown - dt
                if G.BTTI.levelBlindCountdown <= 0.0 then
                    G.BTTI.levelBlindCountdown = 5.0
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
                if not G.BTTI.PONG_initialized and G.BTTI.PONG_initByItself then
                    G.BTTI.PONG_init()
                    G.BTTI.PONG_initByItself = false
                end
            else
                if G.BTTI.PONG_initialized and G.BTTI.PONG_state ~= G.BTTI.PONG_STATES.GAME_OVER then
                    G.BTTI.PONG_kill()
                    G.BTTI.PONG_initByItself = true
                end
            end
            if G.GAME.blind.config.blind.key == 'bl_btti_gdBlind' then
                if not G.BTTI.JDASH_initialized and G.BTTI.JDASH_initByItself then
                    G.BTTI.JDASH_init()
                    G.BTTI.JDASH_initByItself = false
                end
            else
                if G.BTTI.JDASH_initialized and G.BTTI.JDASH_state ~= G.BTTI.JDASH_STATES.GAME_OVER then
                    G.BTTI.JDASH_kill()
                    ----sendInfoMessage("G.BTTI.JDASH_kill at 147", "BTTI")
                    G.BTTI.JDASH_initByItself = true
                end
            end
            --G.BTTI.JDASH_init()
        end

        G.BTTI.dvdLogo.X = G.BTTI.dvdLogo.X + G.BTTI.dvdLogo.VX * dt
        G.BTTI.dvdLogo.Y = G.BTTI.dvdLogo.Y + G.BTTI.dvdLogo.VY * dt

        if G.BTTI.dvdLogo.X <= 0 then
            G.BTTI.dvdLogo.X = 0
            G.BTTI.dvdLogo.VX = -G.BTTI.dvdLogo.VX
            G.BTTI.dvdLogo.Color = G.BTTI.dvdLogoNextColor(G.BTTI.dvdLogo.Color)
        elseif G.BTTI.dvdLogo.X + G.BTTI.dvdLogo.Image:getWidth() >= screenWidth then
            G.BTTI.dvdLogo.X = screenWidth - G.BTTI.dvdLogo.Image:getWidth()
            G.BTTI.dvdLogo.VX = -G.BTTI.dvdLogo.VX
            G.BTTI.dvdLogo.Color = G.BTTI.dvdLogoNextColor(G.BTTI.dvdLogo.Color)
        end
        if G.BTTI.dvdLogo.Y <= 0 then
            G.BTTI.dvdLogo.Y = 0
            G.BTTI.dvdLogo.VY = -G.BTTI.dvdLogo.VY
            G.BTTI.dvdLogo.Color = G.BTTI.dvdLogoNextColor(G.BTTI.dvdLogo.Color)
        elseif G.BTTI.dvdLogo.Y + G.BTTI.dvdLogo.Image:getHeight() >= screenHeight then
            G.BTTI.dvdLogo.Y = screenHeight - G.BTTI.dvdLogo.Image:getHeight()
            G.BTTI.dvdLogo.VY = -G.BTTI.dvdLogo.VY
            G.BTTI.dvdLogo.Color = G.BTTI.dvdLogoNextColor(G.BTTI.dvdLogo.Color)
        end

        G.BTTI.fakeCrash:update(dt)

        G.BTTI.whorseFlashbangAlpha = lerp(G.BTTI.whorseFlashbangAlpha, 0.0, dt / 4.0)
        G.BTTI.dwayneTheRockAlpha = lerp(G.BTTI.dwayneTheRockAlpha, 0.0, dt)
    end
end

local explosion = loadImage("explosion.png")
local explosionSpriteSheet = loadImageSpriteSheet("explosion.png", 200, 282, 17, 0)
local brimstone = loadImage("brimstone.png")
local brimstoneSpriteSheet = loadImageSpriteSheet("brimstone.png", 352, 276, 4, 0)

local loveDrawRef = love.draw
function love.draw()
    loveDrawRef()

    G.BTTI.JDASH_draw()
    G.BTTI.PONG_draw()

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
                if G.effectmanager[i][1].name == "brimstone" then
                    bttiEffectManagerImgToDraw = brimstone
                    bttiEffectManagerQuadToDraw = brimstoneSpriteSheet
                    bttiEffectManagerImgIndex = G.effectmanager[i][1].frame
                    bttiEffectManagerXPos = G.effectmanager[i][1].xpos
                    bttiEffectManagerYPos = G.effectmanager[i][1].ypos - (276 / 2)
                    --print("_imgindex".. _imgindex)
                    love.graphics.setColor(1, 1, 1, 1)
                end
                if bttiEffectManagerQuadToDraw ~= nil then
                    local offsetY = 0
                    if G.effectmanager[i][1].name == "brimstone" then
                        offsetY = 276 * (1 - (G.effectmanager[i][1].yscale or 1)) / 2
                    end
                    love.graphics.draw(bttiEffectManagerImgToDraw, bttiEffectManagerQuadToDraw
                        [bttiEffectManagerImgIndex],
                        bttiEffectManagerXPos, bttiEffectManagerYPos + offsetY, 0, G.effectmanager[i][1].xscale, G.effectmanager[i][1].yscale or 1)
                end
            end
        end
    end

    love.graphics.setColor(1, 1, 1, G.BTTI.dwayneTheRockAlpha)
    love.graphics.draw(G.BTTI.dwayneTheRockImage, 0, 0, 0,
    (love.graphics.getWidth() / G.BTTI.dwayneTheRockImage:getWidth()),
        (love.graphics.getHeight() / G.BTTI.dwayneTheRockImage:getHeight()))
    love.graphics.setColor(1, 1, 1, G.BTTI.whorseFlashbangAlpha)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.setColor(G.BTTI.dvdLogo.Color[1], G.BTTI.dvdLogo.Color[2], G.BTTI.dvdLogo.Color[3], G.GAME.dvdLogoAlpha or 0)
    love.graphics.draw(G.BTTI.dvdLogo.Image, G.BTTI.dvdLogo.X, G.BTTI.dvdLogo.Y)

    if jokerExists('j_btti_BiteOf87') then
        love.graphics.setColor(1, 1, 1, 1)
        if G.BTTI.biteOf87Quads[G.BTTI.biteOf87Frame] ~= nil then
            G.BTTI.biteOf87LastFrame = G.BTTI.biteOf87Frame
            love.graphics.draw(G.BTTI.biteOf87Image, G.BTTI.biteOf87Quads[G.BTTI.biteOf87Frame], 0, 0, 0,
                1 * (love.graphics.getWidth() / 1280), 1 * (love.graphics.getWidth() / 1280))
        else
            love.graphics.draw(G.BTTI.biteOf87Image, G.BTTI.biteOf87Quads[G.BTTI.biteOf87LastFrame], 0, 0, 0,
                1 * (love.graphics.getWidth() / 1280), 1 * (love.graphics.getWidth() / 1280))
        end
    end
    
    G.BTTI.fakeCrash:draw()
end

local loveResize = love.resize
function love.resize(w, h)
    loveResize(w, h)
    screenWidth, screenHeight = w, h
end
