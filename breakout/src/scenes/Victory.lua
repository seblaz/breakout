--[[
    GD50
    Breakout Remake

    -- StartState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state that the game is in when we've just completed a level.
    Very similar to the ServeState, except here we increment the level 
]]

local Base = require 'src/scenes/Base'

local Fonts = require 'src/assets/Fonts'

local ScoreView = require 'src/views/Score'
local HealthView = require 'src/views/Health'

Victory = Base()

function Victory:enter(params)
    self.level = params.level
    self.score = params.score
    self.highScores = params.highScores
    self.paddle = params.paddle
    self.health = params.health
    self.ball = params.ball
    self.ballView = params.ballView -- Recibo el ballView de otra escena para que mantenga la misma vista y no inicialice otra
    self.recoverPoints = params.recoverPoints

    self.views = {
        HealthView(self.health),
        ScoreView(self.score),
        self.paddle,
        self.ballView,
    }
end

function Victory:update(dt)
    self.paddle:update(dt)

    -- have the ball track the player
    self.ball.x = self.paddle.x + (self.paddle.width / 2) - 4
    self.ball.y = self.paddle.y - 8

    -- go to play screen if the player presses Enter
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('serve', {
            level = self.level + 1,
            bricks = LevelMaker:createMap(self.level + 1),
            paddle = self.paddle,
            health = self.health,
            score = self.score,
            highScores = self.highScores,
            recoverPoints = self.recoverPoints
        })
    end
end

function Victory:render()
    table.apply(self.views, function(view) view:render() end)

    -- level complete text
    love.graphics.setFont(Fonts:get('large'))
    love.graphics.printf("Level " .. tostring(self.level) .. " complete!",
        0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')

    -- instructions text
    love.graphics.setFont(Fonts:get('medium'))
    love.graphics.printf('Press Enter to serve!', 0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH, 'center')
end