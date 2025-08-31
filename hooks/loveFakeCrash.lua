G.BTTI.fakeCrash = {
    phase = 0,
    timer = 0.0,
    freezeTex = nil,
    ogVolume = 0,
    crashImg = loadImage('fakeCrash.png'),
    catImg = loadImage('laughingCat.png'),
    whiteFreezeAlpha = 0.0,
    catAlpha = 0.0,
    actualCrash = false,
    on = false
}

local function captureScreenshotCallback(img)
    G.BTTI.fakeCrash.freezeTex = love.graphics.newImage(img, { linear = false })
    G.BTTI.fakeCrash.phase = 1 -- switch to "frozen" phase once screenshot is ready
    G.BTTI.fakeCrash.on = true
end

function G.BTTI.fakeCrash:turnOn()
    self.on = true
    self.phase = 0
    self.timer = 0
    love.graphics.captureScreenshot(captureScreenshotCallback)
end

function G.BTTI.fakeCrash:update(dt)
    if not self.on then return end

    self.timer = self.timer + dt
    if self.phase == 1 then
        if self.timer > 3 then
            self.phase = 2
            self.whiteFreezeAlpha = 0.0
            self.timer = 0
        end
    elseif self.phase == 2 then
        self.whiteFreezeAlpha = lerp(self.whiteFreezeAlpha, 0.55, 3.0 * dt)
        if self.timer > math.random(2.5, 5) then
            self.phase = 3

            self.ogVolume = G.SETTINGS.SOUND.volume
            G.SETTINGS.SOUND.volume = 0

            self.timer = 0
        end
    elseif self.phase == 3 then
        if self.timer > 2 then
            local idx = math.random(0, 1)
            if idx == 0 then
                self.phase = 4
            else
                G.SETTINGS.SOUND.volume = self.ogVolume
                SMODS.restart_game()
            end

            self.catAlpha = 0.0
            self.timer = 0
        end
    elseif self.phase == 4 then
        self.catAlpha = lerp(self.catAlpha, 0.55, 2.0 * dt)
        if self.timer > 2 then
            G.SETTINGS.SOUND.volume = self.ogVolume
            self.timer = 0
            self.on = false
        end
    end
end

function G.BTTI.fakeCrash:draw()
    if not self.on then return end
    
    if self.phase >= 1 then
        local sx = love.graphics.getWidth() / self.freezeTex:getWidth()
        local sy = love.graphics.getHeight() / self.freezeTex:getHeight()
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(self.freezeTex, 0, 0, 0, sx, sy)
    end
    if self.phase == 2 then
        love.graphics.setColor(1, 1, 1, self.whiteFreezeAlpha)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    end
    if self.phase >= 3 then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(self.crashImg, 0, 0)
    end
    if self.phase >= 4 then
        local screenW, screenH = love.graphics.getWidth(), love.graphics.getHeight()
        local imgW, imgH = self.catImg:getWidth(), self.catImg:getHeight()

        local x = (screenW - imgW) / 2
        local y = (screenH - imgH) / 2

        love.graphics.setColor(1, 1, 1, self.catAlpha)
        love.graphics.draw(self.catImg, x, y)
    end
end
