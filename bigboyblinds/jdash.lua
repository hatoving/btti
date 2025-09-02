SMODS.Sound({ key = "JDASHLose", path = "bttiJDashLose.ogg" })

SMODS.Sound {
    key = "music_JDash",
    path = "music_bttiJDash.ogg",
    pitch = 1,
    volume = 1.0,
    select_music_track = function(self)
        return G.GAME and G.GAME.blind and G.GAME.blind.config.blind.key == 'bl_btti_gdBlind'
    end
}

local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()
local scaleX = screenWidth / 1280
local scaleY = screenHeight / 720

local function nearestRightAngle(a)
    local quarter = math.pi / 2
    return math.floor((a + quarter / 2) / quarter) * quarter
end

local player = {}

local GROUND = 390
local GROUND_LIMIT = 390
local GRAVITY = 5200
local JUMP_FORCE = -1250
local LEVEL_SPEED = 525
local FADE_DISTANCE = 950

local placeholderImg = loadImage('jimboDashPlaceholder.png')
local spikeImg = loadImage('jimboDashSpike.png')
local smallSpikeImg = loadImage('jimboDashSmallSpike.png')
local wallImg = loadImage('jimboDashWall.png')

local BLOCK_TYPE = {
    EMPTY = 0,
    SPIKE = 1,
    SMALL_SPIKE = 2,
    WALL = 3,
}

local blockSize = { w = 60, h = 60 }
local levelData = {
    {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    },
    {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    },
    {
        0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 2, 1, 0, 0, 0, 0, 3, 3, 3, 0, 0, 0, 0, 1, 3, 3,
        0, 0, 0, 0, 0, 3, 1, 1, 2, 0, 0, 0, 0, 0, 2, 1, 0, 0, 0, 0, 3, 3, 3, 3, 3, 3,
        0, 0, 0, 0, 0, 3, 0, 0, 0, 3, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1, 2,
    },
}

local level = {}
createLevel = function ()
    local level = {
        x = 1200,
        y = GROUND_LIMIT - 120,
        a = 1.0,
        data = {}
    }

    for i = 1, 3, 1 do
        for z = 1, #levelData[i] do
            local entry = {}
            entry.px = (z - 1) * blockSize.w
            entry.py = (i - 1) * blockSize.h
            entry.x = entry.px
            entry.y = entry.py
            entry.a = 0
            entry.type = (levelData[i])[z]
            if entry.type == BLOCK_TYPE.SPIKE then
                entry.img = spikeImg
                entry.collider = {
                    x = 20,
                    y = 15,
                    w = 25,
                    h = 45
                }
            elseif entry.type == BLOCK_TYPE.SMALL_SPIKE then
                entry.img = smallSpikeImg
                entry.collider = {
                    x = 35,
                    y = 35,
                    w = 10,
                    h = 25
                }
            elseif entry.type == BLOCK_TYPE.WALL then
                entry.img = wallImg
                entry.collider = {
                    x = 0,
                    y = 0,
                    w = 60,
                    h = 60
                }
            else
                entry.collider = {}
                entry.img = nil
            end
            table.insert(level.data, entry)
        end
    end

    function level:update(dt)
        local collided = false
        local highestGround = -math.huge
        local playerRect = { x = player.x, y = player.y, w = 60, h = 60, r = player.r }
        for i = 1, #self.data, 1 do
            self.data[i].x = self.data[i].px + self.x
            self.data[i].y = self.data[i].py + self.y

            local dy = self.data[i].x - player.x

            local alpha = 1 - math.clamp(dy / FADE_DISTANCE, 0, 1)
            self.data[i].a = alpha * self.a

            if self.data[i].type == BLOCK_TYPE.SPIKE or self.data[i].type == BLOCK_TYPE.SMALL_SPIKE then
                local tileRect = {
                    x = self.data[i].x + self.data[i].collider.x,
                    y = self.data[i].y + self.data[i].collider.y,
                    w = self.data[i].collider.w,
                    h = self.data[i].collider.h,
                    r = 0
                }
                if checkCollisionRect(playerRect, tileRect) then
                    LOSE_GAME_NOW()
                    G.BTTI.JDASH_kill()
                    --sendInfoMessage("G.BTTI.JDASH_kill JDASH.lua at 137", "BTTI")
                end
            elseif self.data[i].type == BLOCK_TYPE.WALL then
                local tileRect = {
                    x = self.data[i].x + self.data[i].collider.x,
                    y = self.data[i].y + self.data[i].collider.y,
                    w = self.data[i].collider.w,
                    h = self.data[i].collider.h,
                    r = 0
                }

                if checkCollisionRect(playerRect, tileRect) then
                    local tileTop = tileRect.y - (tileRect.h / 2)
                    local playerPrevBottom = player.prevY + (playerRect.h / 2)

                    local EPS = 6
                    if playerPrevBottom <= tileTop + EPS and player.vy >= 0 then
                        if tileTop > highestGround then
                            highestGround = tileTop
                            collided = true
                        end
                    else
                        LOSE_GAME_NOW()
                        G.BTTI.JDASH_kill()
                        --sendInfoMessage("G.BTTI.JDASH_kill JDASH.lua at 161", "BTTI")
                    end
                end
            end
        end
        if collided then
            player.y = highestGround - (player.img:getHeight() * 0.5)
            player.vy = math.min(player.vy, 0) 
            player:stayOnFloor()

            if not player.jumping then
                player.checkRotate = false
            end
            player.wasonwall = true
        else
            if player.onfloor and player.wasonwall then
                -- GOING TO THIS ALMOST EVERY FUCKING FRAME IF OON THE WALL FML
                player.wasonwall = false
                player.onfloor = false
            end
        end
    end

    function level:draw()
        for i = 1, #self.data, 1 do
            if self.data[i].img then
                local iw, ih = self.data[i].img:getWidth(), self.data[i].img:getHeight()

                love.graphics.setColor(0, 0, 0, self.data[i].a * self.a)
                love.graphics.draw(
                    self.data[i].img,
                    (self.data[i].x + 4) * scaleX,
                    (self.data[i].y + 4) * scaleY,
                    0,
                    scaleX * 1.05, scaleY * 1.05,
                    iw / 2, ih / 2
                )

                -- main image
                love.graphics.setColor(1, 1, 1, self.data[i].a * self.a)
                love.graphics.draw(
                    self.data[i].img,
                    self.data[i].x * scaleX,
                    self.data[i].y * scaleY,
                    0,
                    scaleX, scaleY,
                    iw / 2, ih / 2
                )
            end
        end
    end
    return level
end

local createPlayer = function(x, y)
    local player = {
        x = x,
        y = y,
        xog = x,
        prevY = y,
        vy = 0,
        sx = 4,
        r = 0,
        dontr = false,
        onfloor = false,
        jumping = false,
        wasonwall = false,
        a = 1.0,
        img = loadImage('jimboDashCube.png'),
    }

    function player:stayOnFloor()
        self.vy = 0
        self.onfloor = true
        self.checkRotate = true
    end

    function player:update(dt)
        self.prevY = self.y

        if self.jumping and self.onfloor then
            self.jumping = false
        end

        if love.keyboard.isDown("space") then
            if self.onfloor then
                self.vy = JUMP_FORCE
                self.onfloor = false
                self.jumping = true
                self.checkRotate = true
            end
        end

        if not self.onfloor then
            self.vy = self.vy + GRAVITY * dt
            self.y = self.y + self.vy * dt
        end
        if self.y >= GROUND_LIMIT then
            self.y = GROUND_LIMIT
            self:stayOnFloor()
            self.jumping = false
        end

        if self.checkRotate then
            if not self.onfloor then
                self.r = self.r + math.pi * 2 * dt
            else
                if not self.wasonwall then
                    local target = nearestRightAngle(self.r)
                    self.r = lerpAngle(self.r, target, 20 * dt)
                end
            end
        else
            local target = nearestRightAngle(self.r)
            self.r = lerpAngle(self.r, target, 20 * dt)
        end
    end

    function player:draw()
        local iw, ih = self.img:getWidth(), self.img:getHeight()
        --local cx, cy = self.x * scaleX, self.y * scaleY -- sprite center
        love.graphics.setColor(0, 0, 0, 0.6 * self.a)
        love.graphics.draw(
            self.img,
            (self.x + 4) * scaleX,
            (self.y + 4) * scaleY,
            self.r,
            scaleX * 1.05, scaleY * 1.05,
            iw / 2, ih / 2
        )
        
        -- main image
        love.graphics.setColor(1, 1, 1, self.a)
        love.graphics.draw(
            self.img,
            self.x * scaleX,
            self.y * scaleY,
            self.r,
            scaleX, scaleY,
            iw / 2, ih / 2
        )
    end
    return player
end
G.BTTI.JDASH_STATES = {
    LOOP = 0,
    GAME_OVER = 1,
}

G.BTTI.JDASH_initByItself = true
G.BTTI.JDASH_initialized = false

G.BTTI.JDASH_state = G.BTTI.JDASH_STATES.LOOP
G.BTTI.JDASH_timer = 0
G.BTTI.JDASH_timerTarget = 4
G.BTTI.JDASH_dontDraw = false

function G.BTTI.JDASH_init()
    if (G.STATE == G.STATES.GAME_OVER or G.STATE == G.STATES.MENU) then
        if G.BTTI.JDASH_initialized then
            G.BTTI.JDASH_kill()
            --sendInfoMessage("G.BTTI.JDASH_kill JDASH.lua at 322", "BTTI")
        end
        return
    end
    if not G.BTTI.JDASH_initialized then
        sendInfoMessage("JDASH is init NOW", "BTTI")

        G.BTTI.JDASH_initialized = true
        G.BTTI.JDASH_dontDraw = false

        player = createPlayer(1280 / 2 - 150, 720 / 2 - math.random(50, 100))
        level = createLevel()

        G.BTTI.JDASH_state = G.BTTI.JDASH_STATES.LOOP
        G.BTTI.JDASH_timer = 0
    end
end

function G.BTTI.JDASH_update(dt)
    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()
    scaleX = screenWidth / 1280
    scaleY = screenHeight / 720

    if G.BTTI.JDASH_initialized and (not G.SETTINGS.paused or G.STATE == G.STATES.GAME_OVER) then
        if G.BTTI.JDASH_state == G.BTTI.JDASH_STATES.LOOP then
            level.x = level.x - dt * LEVEL_SPEED
            if level.x <= -4800 then
                level.x = 1200
            end
            level:update(dt)
            player:update(dt)
            level.a = 1.0
            G.BTTI.JDASH_dontDraw = false
        elseif G.BTTI.JDASH_state == G.BTTI.JDASH_STATES.GAME_OVER then
            G.BTTI.JDASH_timer = G.BTTI.JDASH_timer + dt
            level.a = level.a - dt
            level.a = math.clamp(level.a, 0, 1)
            if G.BTTI.JDASH_timer > G.BTTI.JDASH_timerTarget then
                G.BTTI.JDASH_timer = 0
                G.BTTI.JDASH_initialized = false

                G.BTTI.JDASH_dontDraw = true
                sendInfoMessage("jdash is dead NOW", "BTTI")

                player = {}
                level = {}
            end
        end
    end
end

function G.BTTI.JDASH_draw()
    if G.BTTI.JDASH_initialized and not G.BTTI.JDASH_dontDraw then
        if not G.SETTINGS.paused or G.STATE == G.STATES.GAME_OVER then
            level:draw()
            player:draw()
        end
    end
end

function G.BTTI.JDASH_kill()
    if G.BTTI.JDASH_initialized then
        sendInfoMessage("gdash is dead :(", "BTTI")
        G.BTTI.JDASH_timer = 0
        G.BTTI.JDASH_timerTarget = 2
        G.BTTI.JDASH_dontDraw = false

        player.a = 0.0
        bttiEffectManagerPlay('explosion', player.x + 70, player.y + 65)
        play_sound('btti_JDASHLose', math.random(1.0, 1.2))

        G.BTTI.JDASH_state = G.BTTI.JDASH_STATES.GAME_OVER
        G.ROOM.jiggle = G.ROOM.jiggle + 3
    end
end
