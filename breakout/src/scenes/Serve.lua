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

local Set = require 'lib/Set'
local Base = require 'src/scenes/Base'

local Fonts = require 'src/assets/Fonts'

local BrickView = require 'src/views/Brick'
local ScoreView = require 'src/views/Score'
local HealthView = require 'src/views/Health'
local BallView = require 'src/views/Ball'
local PaddleView = require 'src/views/Paddle'
local Ball = require 'src/model/Ball'
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
    self.views = Set({
        self.paddleView,
        self.ballView,
        ScoreView(self.score),
        HealthView(self.health),
        unpack(table.map(self.bricks, BrickView)),
    })

    --table.concatenate(
    --        self.views,
    --        table.map(table.filter(self.bricks, function(brick)
    --            return brick:is_a(Brick)
    --        end), BrickView)
    --)
    --table.concatenate(
    --        self.views,
    --        table.map(table.filter(self.bricks, function(brick)
    --            return brick:is_a(BrickUnbreakable)
    --        end), BrickUnbreakableView)
    --)

end

function Serve:update(dt)
    -- have the ball track the player
    self.paddle:update(dt)
    self.ball.x = self.paddle.x + (self.paddle.width / 2) - 4
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
            ballView = self.ballView, -- Le paso el ballView al play para que mantenga la misma vista y no inicialice otra
            level = self.level,
            recoverPoints = self.recoverPoints
        })
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function Serve:render()
    self.views:foreach(function(view) view:render() end)

    love.graphics.setFont(Fonts:get('large'))
    love.graphics.printf('Level ' .. tostring(self.level), 0, Constants.VIRTUAL_HEIGHT / 3,
        Constants.VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(Fonts:get('medium'))
    love.graphics.printf('Press Enter to serve!', 0, Constants.VIRTUAL_HEIGHT / 2,
        Constants.VIRTUAL_WIDTH, 'center')
end

return Serve