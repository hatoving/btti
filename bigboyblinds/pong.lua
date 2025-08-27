SMODS.Sound({ key = "pongScore", path = "bttiPongScore.ogg" })

local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()
local scaleX = screenWidth / 1280
local scaleY = screenHeight / 720

local player1 = {}
local player2 = {}
local ball = {}

local STARTING_GRAVITY = -5

local TOP_LIMIT = 200
local BOTTOM_LIMIT = 370

local createPlayer = function(x,xoff,y)
    local player = {
        x = x - xoff,
        xog = x,
        sx = -4,
        y = y,
        vx = 0, -- velocity X
        vy = 0, -- velocity Y
        w = 12,
        h = 94,
        r = 0,
        a = 0,
        vel = 6.0,
        gravity = STARTING_GRAVITY,
        speed = 6.0
    }
    function player:draw()
        love.graphics.setColor(0, 0, 0, self.a)
        drawRotatedRectangle(
            'fill',
            (self.x - self.sx - self.w / 2) * scaleX,
            (self.y + 4 - self.h / 2) * scaleY,
            self.w * scaleX,
            self.h * scaleY,
            self.r
        )

        love.graphics.setColor(1, 1, 1, self.a)
        drawRotatedRectangle(
            'fill',
            (self.x - self.w / 2) * scaleX,
            (self.y - self.h / 2) * scaleY,
            self.w * scaleX,
            self.h * scaleY,
            self.r
        )
    end
    function player:update(dt)
        if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
            self.vy = lerp(self.vy, self.vel, dt * self.speed)
            self.r = lerp(self.r, 0.05, 6.0 * dt)
        elseif love.keyboard.isDown("up") or love.keyboard.isDown("w") then
            self.vy = lerp(self.vy, -self.vel, dt * self.speed)
            self.r = lerp(self.r, -0.05, 6.0 * dt)
        else
            self.vy = lerp(self.vy, 0, dt * self.speed)
             self.r = lerp(self.r, 0.0, 6.0 * dt)
        end
        self.y = self.y + self.vy
        if self.y >= BOTTOM_LIMIT then
            self.y = BOTTOM_LIMIT
        end
        if self.y <= TOP_LIMIT then
            self.y = TOP_LIMIT
        end
    end
    function player:updateAI(ball, dt, difficulty)
        difficulty = math.max(0, math.min(1, difficulty or 0.5))
        local paddleCenter = self.y + self.h / 2
        self.reactionTimer = (self.reactionTimer or 0) - dt
        if self.reactionTimer <= 0 then
            local timeToReach = (self.x - ball.x) / (ball.vx ~= 0 and ball.vx or 1)
            local predictedY = ball.y + ball.vy * timeToReach

            local maxOffset = (1 - difficulty) * 60
            local aimOffset = math.random(-maxOffset, maxOffset)

            self.targetY = predictedY + aimOffset

            self.reactionTimer = 0.05 + (1 - difficulty) * 0.25
        end

        local diff = (self.targetY or ball.y) - paddleCenter
        local lerpStrength = dt * (2 + difficulty * 8)

        self.r = lerp(self.r, (0.05 * diff) / 120, 6.0 * dt)
        self.vy = lerp(self.vy, diff, lerpStrength)

        self.y = self.y + self.vy * dt

        if self.y < TOP_LIMIT then
            self.y = TOP_LIMIT
        elseif self.y + self.h > BOTTOM_LIMIT then
            self.y = BOTTOM_LIMIT - self.h
        end
    end
    return player
end

local createBall = function (x,y)
    local ball = {
        x = x,
        sx = -4,
        y = y,
        img = loadImage('jimboBall.png'),
        vx = 0,
        vy = 0,
        r = 0,
        a = 0,
        gravity = STARTING_GRAVITY,
        speed = .75
    }
    function ball:draw()
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.draw(
            self.img,
            (self.x - self.sx - self.img:getWidth() / 2) * scaleX,
            (self.y - self.img:getHeight() / 2) * scaleY,
            self.r
        )
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(
            self.img,
            (self.x - self.img:getWidth() / 2) * scaleX,
            (self.y - self.img:getHeight() / 2) * scaleY,
            self.r
        )
    end

    function ball:launch()
        self.vx = math.random(2) == 1 and 100 or -100
        self.vy = math.random(-100, 100)
        self.speed = 0.75
    end

    function ball:hit()
        G.ROOM.jiggle = G.ROOM.jiggle + 3
        play_sound('multhit1', (math.random() * 0.2 + 1))
        play_sound('voice' .. math.random(1, 11), G.SPEEDFACTOR * (math.random() * 0.2 + 1), 0.5)
        self.speed = self.speed + 0.05
    end

    function ball:update(player, dt)
        local steps = math.ceil(math.max(math.abs(self.vx), math.abs(self.vy)) * dt / 5)
        local stepDT = dt / steps

        for i = 1, steps do
            self.x = self.x + (self.vx * stepDT) * self.speed
            self.y = self.y + (self.vy * stepDT) * self.speed

            local hbX = player.x
            local hbY = player.y
            local hbW = player.w
            local hbH = player.h

            if checkCollision(
                    self.x, self.y, self.img:getWidth(), self.img:getHeight(),
                    hbX, hbY, hbW, hbH
                ) then
                self.vx = -self.vx

                self:hit()

                if self.vx > 0 then
                    self.x = hbX + hbW
                else
                    self.x = hbX - self.img:getWidth()
                end
            end

            if self.x < player.x - 20 and player == player1 then
                G.STATE = G.STATES.GAME_OVER
                if not G.GAME.won and not G.GAME.seeded and not G.GAME.challenge then
                    G.PROFILES[G.SETTINGS.profile].high_scores.current_streak.amt = 0
                end
                G:save_settings()
                G.FILE_HANDLER.force = true
                G.STATE_COMPLETE = false
                btti_PONG_kill()
                return
            elseif self.x > player.x + 20 and player == player2 then
                btti_PONG_score()
            end

            -- top/bottom wall collision
            if self.y + self.img:getHeight() >= BOTTOM_LIMIT then
                self.vy = -math.abs(self.vy)
                self:hit()
            end
            if self.y <= 200 then
                self.vy = math.abs(self.vy)
                self:hit()
            end
        end
    end

    return ball
end

btti_PONG_STATES = {
    START = 0,
    LOOP = 1,
    GAME_OVER = 2,
}

btti_PONG_initByItself = true
btti_PONG_initialized = false

btti_PONG_state = btti_PONG_STATES.START
btti_PONG_timer = 0
btti_PONG_timerTarget = 2
btti_PONG_dontDraw = false
btti_PONG_backgroundA = 0
btti_PONG_plyrScore = 0

function btti_PONG_score()
    btti_PONG_timer = 0
    btti_PONG_timerTarget = 3
    btti_PONG_state = btti_PONG_STATES.START
    btti_PONG_plyrScore = btti_PONG_plyrScore + 1
    play_sound('btti_pongScore', (math.random() * 0.2 + 1))
end

function btti_PONG_init()
    if (G.STATE == G.STATES.GAME_OVER or G.STATE == G.STATES.MENU) then
        btti_PONG_kill()
        return
    end
    if not btti_PONG_initialized then
        sendInfoMessage("pong is init NOW", "BTTI")
        btti_PONG_initialized = true
        btti_PONG_dontDraw = false

        btti_PONG_plyrScore = 0
        btti_PONG_backgroundA = 0

        player1 = createPlayer(1280 / 2 - 150, 150, 720 / 2 - 65)
        player2 = createPlayer(1280 / 2 + 320, -150, 720 / 2 - 65)
        player2.sx = 4

        local midX = (player1.x + player2.x) / 2
        local midY = (player1.y + player2.y) / 2

        ball = createBall(midX, midY)

        btti_PONG_state = btti_PONG_STATES.START
        btti_PONG_timer = 0
   end 
end

function btti_PONG_update(dt)
    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()
    scaleX = screenWidth / 1280
    scaleY = screenHeight / 720

    if btti_PONG_initialized == true and (not G.SETTINGS.paused or G.STATE == G.STATES.GAME_OVER) then
        player1.a = lerp(player1.a, 1.0, 6.0 * dt)
        player2.a = lerp(player2.a, 1.0, 6.0 * dt)
        if btti_PONG_state == btti_PONG_STATES.START then
            btti_PONG_backgroundA = lerp(btti_PONG_backgroundA, 1, 6.0 * dt)
            btti_PONG_timer = btti_PONG_timer + dt
            player1.x = lerp(player1.x, player1.xog, 6.0 * dt)
            player2.x = lerp(player2.x, player2.xog, 6.0 * dt)
            if btti_PONG_timer > btti_PONG_timerTarget then
                btti_PONG_timer = 0
                local midX = (player1.x + player2.x) / 2
                local midY = (player1.y + player2.y) / 2
                ball.x = midX
                ball.y = midY
                ball:launch()
                btti_PONG_state = btti_PONG_STATES.LOOP
            end
        elseif btti_PONG_state == btti_PONG_STATES.LOOP then
            player1:update(dt)
            player2:updateAI(ball, dt, math.random(0.2, 0.5))
            ball:update(player1, dt)
            ball:update(player2, dt)
        elseif btti_PONG_state == btti_PONG_STATES.GAME_OVER then
            btti_PONG_timer = btti_PONG_timer + dt
            player1.r = player1.r + dt * 2
            player1.y = player1.y + player1.gravity
            player2.r = player2.r - dt * 2
            player2.y = player2.y + player2.gravity
            ball.y = ball.y + ball.gravity
            player1.gravity = player1.gravity + dt * 12
            player2.gravity = player2.gravity + dt * 12
            ball.gravity = ball.gravity + dt * 12
            btti_PONG_backgroundA = lerp(btti_PONG_backgroundA, 0.0, 6.0 * dt)
            if btti_PONG_timer > btti_PONG_timerTarget then
                btti_PONG_timer = 0
                btti_PONG_initialized = false

                btti_PONG_dontDraw = true
                sendInfoMessage("pong is dead NOW", "BTTI")

                player1 = {}
                player2 = {}
                ball = {}
            end
        end
    end
end

function btti_PONG_draw()
    if btti_PONG_initialized and not btti_PONG_dontDraw then
        if G.STATE ~= G.STATES.GAME_OVER and G.STATE ~= G.STATES.MENU and not G.SETTINGS.paused then
            love.graphics.setColor(0, 0, 0, .65 * btti_PONG_backgroundA)

            local rectX = (1280 / 2 - 172) * scaleX
            local rectY = (TOP_LIMIT - 10) * scaleY
            local rectW = 520 * scaleX
            local rectH = ((BOTTOM_LIMIT - TOP_LIMIT) + 40) * scaleY
            love.graphics.rectangle('fill', rectX, rectY, rectW, rectH)

            local middleX = rectX + rectW / 2
            local middleY = rectY + rectH / 2

            love.graphics.setColor(1, 1, 1, btti_PONG_backgroundA)
            love.graphics.setLineWidth(3)
            love.graphics.line(middleX, middleY - 100, middleX, middleY + 100)
            love.graphics.setLineWidth(1)

            love.graphics.setColor(0, 0, 0, btti_PONG_backgroundA)
            love.graphics.printf("s: " .. btti_PONG_plyrScore, middleX - 4, middleY + 104, 0, "center")
            love.graphics.setColor(1, 1, 1, btti_PONG_backgroundA)
            love.graphics.printf("s: " .. btti_PONG_plyrScore, middleX, middleY + 100, 0, "center")

            love.graphics.setColor(1, 1, 1, 1)
        end

        if not G.SETTINGS.paused or G.STATE == G.STATES.GAME_OVER then
            player1:draw()
            player2:draw()
            ball:draw()
        end
    end
end

function btti_PONG_kill()
    sendInfoMessage("pong is dead :(", "BTTI")
    btti_PONG_timerTarget = 5
    btti_PONG_timer = 0
    btti_PONG_state = btti_PONG_STATES.GAME_OVER
end