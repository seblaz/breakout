--[[
    GD50
    Breakout Remake

    -- ServeState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The state in which we are waiting to serve the ball; here, we are
    basically just moving the paddle left and right with the ball until we
    press Enter, though everything in the actual game now should render in
    preparation for the serve, including our current health and score, as
    well as the level we're on.
]]

local List = require 'lib/List'
local Base = require 'src/scenes/Base'
local Fonts = require 'src/assets/Fonts'

local Ball = require 'src/model/Ball'
local Brick = require 'src/model/Brick'
local BrickUnbreakable = require 'src/model/BrickUnbreakable'
local BrickPaddleSize = require 'src/model/BrickPaddleSize'
local BrickMultiball = require 'src/model/BrickMultiball'

local BrickView = require 'src/views/Brick'
local BrickUnbreakableView = require 'src/views/BrickUnbreakable'
local BrickPaddleSizeView = require 'src/views/BrickPaddleSize'
local BrickMultiballView = require 'src/views/BrickMultiball'
local ScoreView = require 'src/views/Score'
local HealthView = require 'src/views/Health'
local BallView = require 'src/views/Ball'
local Constants = require 'src/constants'

local Serve = Base()

function Serve:enter(params)
    -- grab game state from params
    self.paddle = params.paddle
    self.paddleView = params.paddleView
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores
    self.level = params.level
    self.recoverPoints = params.recoverPoints

    self.ball = Ball()
    --En cada serve se inicializa un color nuevo para la bola, se puede dejar fijo
    self.ballView = BallView(self.ball)

    -- Views
    self.views = List({
        self.paddleView,
        self.ballView,
        ScoreView(self.score),
        HealthView(self.health),
    })

    self.views:add(self.bricks
            :select(function(brick) return brick:is_a(Brick) end)
            :map(BrickView)
    )

    self.views:add(self.bricks
            :select(function(brick) return brick:is_a(BrickUnbreakable) end)
            :map(BrickUnbreakableView)
    )

    self.views:add(self.bricks
            :select(function(brick) return brick:is_a(BrickPaddleSize) end)
            :map(BrickPaddleSizeView)
    )

    self.views:add(self.bricks
            :select(function (brick) return brick:is_a(BrickMultiball) end)
            :map(BrickMultiballView)
        )

end

function Serve:update(dt)
    -- have the ball track the player
    self.paddle:update(dt)
    self.paddle:resetSize()
    local paddleWidth = self.paddle:getWidth()
    self.ball.x = self.paddle.x + (paddleWidth / 2) - 4
    self.ball.y = self.paddle.y - 8

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        -- pass in all important state info to the PlayState
        self._scenes:change('play', {
            paddle = self.paddle,
            paddleView = self.paddleView,
            bricks = self.bricks,
            health = self.health,
            score = self.score,
            highScores = self.highScores,
            ball = self.ball,
            ballView = self.ballView,
            level = self.level,
            recoverPoints = self.recoverPoints
        })
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function Serve:render()
    self.views:foreach(function(view)
        view:render()
    end)

    love.graphics.setFont(Fonts:get('large'))
    love.graphics.printf('Level ' .. tostring(self.level), 0, Constants.VIRTUAL_HEIGHT / 3,
            Constants.VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(Fonts:get('medium'))
    love.graphics.printf('Press Enter to serve!', 0, Constants.VIRTUAL_HEIGHT / 2,
            Constants.VIRTUAL_WIDTH, 'center')
end

return Serve