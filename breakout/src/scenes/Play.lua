--[[
    GD50
    Breakout Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state of the game in which we are actively playing;
    player should control the paddle, with the ball actively bouncing between
    the bricks, walls, and the paddle. If the ball goes below the paddle, then
    the player should lose one point of health and be taken either to the Game
    Over screen if at 0 health or the Serve screen otherwise.
]]

local table = require 'table'
local EventBus = require 'src/model/EventBus'
local Base = require 'src/scenes/Base'

local Fonts = require 'src/assets/Fonts'
local PlaySounds = require 'src/sounds/Play'

local BrickView = require 'src/views/Brick'
local BrickClouds = require 'src/views/BrickClouds'
local PaddleView = require 'src/views/Paddle'
local ScoreView = require 'src/views/Score'
local HealthView = require 'src/views/Health'
local Constants = require 'src/constants'

local Play = Base()

--[[
    We initialize what's in our PlayState via a state table that we pass between
    states as we go from playing to serving.
]]
function Play:enter(params)
    self.paddle = params.paddle
    self.paddleView = params.paddleView
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores
    self.ball = params.ball
    self.ballView = params.ballView
    self.level = params.level

    self.recoverPoints = 5000

    -- give ball random starting velocity
    self.ball.dx = math.random(-200, 200)
    self.ball.dy = math.random(-50, -60)

    -- Views
    local clouds = BrickClouds()
    self.views = table.map(self.bricks, BrickView)
    table.insert(self.views, clouds)
    table.insert(self.views, self.paddleView)
    table.insert(self.views, self.ballView) -- Recibo el ballView de otra escena para que mantenga la misma vista y no inicialice otra
    table.insert(self.views, ScoreView(self.score))
    table.insert(self.views, HealthView(self.health))

    -- Models
    self.models = {self.paddle, self.ball, clouds}

    -- Sounds
    self.sounds = PlaySounds()
end

function Play:update(dt)
    if self:_paused() then return end

    self:_update_model(dt)

    self:_detect_collisions()
end

function Play:_paused()
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            Constants.gSounds['pause']:play()
            return false
        else
            return true
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        Constants.gSounds['pause']:play()
        return true
    end
    return false
end

function Play:_update_model(dt)
    table.apply(self.models, function(model) model:update(dt) end)
end

function Play:_detect_collisions()
    self.ball:collision_with_paddle(self.paddle)

    -- detect collision across all bricks with the ball
    for k, brick in pairs(self.bricks) do
        self.ball:collision_with_brick(brick, self.score)
    end

    -- go to our victory screen if there are no more bricks left
    if self:checkVictory() then
        Constants.gSounds['victory']:play()

        EventBus:reset()

        self._scenes:change('victory', {
            level = self.level,
            paddle = self.paddle,
            paddleView = self.paddleView,
            health = self.health,
            score = self.score,
            highScores = self.highScores,
            ball = self.ball,
            ballView = self.ballView, -- Le paso el ballView al victory para que mantenga la misma vista y no inicialice otra
            recoverPoints = self.recoverPoints
        })
    end

    -- if ball goes below bounds, revert to serve state and decrease health
    if self.ball.y >= Constants.VIRTUAL_HEIGHT then
        self.health:decrease()
        Constants.gSounds['hurt']:play()

        if not self.health:is_alive() then
            self._scenes:change('game-over', {
                score = self.score,
                highScores = self.highScores
            })
        else
            self._scenes:change('serve', {
                paddle = self.paddle,
                paddleView = self.paddleView,
                bricks = self.bricks,
                health = self.health,
                score = self.score,
                highScores = self.highScores,
                level = self.level,
                recoverPoints = self.recoverPoints
            })
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function Play:render()
    table.apply(self.views, function(view) view:render() end)

    -- pause text, if paused
    if self.paused then
        love.graphics.setFont(Fonts:get('large'))
        love.graphics.printf("PAUSED", 0, Constants.VIRTUAL_HEIGHT / 2 - 16, Constants.VIRTUAL_WIDTH, 'center')
    end
end

function Play:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick:in_play() then
            return false
        end
    end

    return true
end

return Play