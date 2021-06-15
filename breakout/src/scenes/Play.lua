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
local List = require 'lib/List'
local Base = require 'src/scenes/Base'
local PlaySounds = require 'src/sounds/Play'

local EventBus = require 'src/model/EventBus'
local Events = require 'src/model/Events'
local Pause = require 'src/model/Pause'
local Brick = require 'src/model/Brick'
local BrickUnbreakable = require 'src/model/BrickUnbreakable'

local BrickView = require 'src/views/Brick'
local BrickUnbreakableView = require 'src/views/BrickUnbreakable'
local BrickClouds = require 'src/views/BrickClouds'
local ScoreView = require 'src/views/Score'
local HealthView = require 'src/views/Health'
local PauseView = require 'src/views/Pause'

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
    self.pause = Pause()

    self.recoverPoints = 5000

    -- give ball random starting velocity
    self.ball.dx = math.random(-200, 200)
    self.ball.dy = math.random(-50, -60)

    local clouds = BrickClouds()

    -- Views
    self.views = List({
        self.paddleView,
        self.ballView, -- Recibo el ballView de otra escena para que mantenga la misma vista y no inicialice otra
        ScoreView(self.score),
        HealthView(self.health),
        PauseView(self.pause),
    })
    self.views:add(List(self.bricks)
            :select(function(brick) return brick:is_a(Brick) end)
            :map(BrickView)
    )

    self.views:add(List(self.bricks)
            :select(function(brick) return brick:is_a(BrickUnbreakable) end)
            :map(BrickUnbreakableView)
    )
    self.views:insert(clouds) -- Insert it last to be on top of the bricks

    -- Models
    self.models = { self.paddle, self.ball, clouds }

    -- Sounds
    self.sounds = PlaySounds()
end

function Play:update(dt)
    self.pause:update()
    if self.pause:paused() then
        return
    end
    self:_update_model(dt)
    self:_detect_collisions()
end

function Play:_update_model(dt)
    table.apply(self.models, function(model)
        model:update(dt)
    end)
end

function Play:_detect_collisions()
    self.ball:collision_with_paddle(self.paddle)

    for _, brick in pairs(self.bricks) do
        self.ball:collision_with_brick(brick, self.score)
    end

    self.ball:collision_with_window(self.health)

    self:_change_scene()
end

function Play:_change_scene()
    if self:_level_completed() then
        EventBus:notify(Events.LEVEL_COMPLETED)

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

    if self.ball:out_of_bounds() then
        if self.health:is_alive() then
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
        else
            self._scenes:change('game-over', {
                score = self.score,
                highScores = self.highScores
            })
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function Play:_level_completed()
    for _, brick in pairs(self.bricks) do
        if brick:in_play() then
            return false
        end
    end

    return true
end

function Play:render()
    self.views:foreach(function(view)
        view:render()
    end)
end

return Play