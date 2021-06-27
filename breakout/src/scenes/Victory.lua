--[[
    GD50
    Breakout Remake

    -- StartState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state that the game is in when we've just completed a level.
    Very similar to the ServeState, except here we increment the level 
]]

local List = require 'lib/List'

local Base = require 'src/scenes/Base'

local Fonts = require 'src/assets/Fonts'

local ScoreView = require 'src/views/Score'
local BallView = require 'src/views/Ball'
local HealthView = require 'src/views/Health'
local Constants = require 'src/constants'
local LevelMaker = require 'src/model/LevelMaker'
local Ball = require 'src/model/Ball' --TODO: Ball Revisar select si no hace falta map (Borrar este import)

local Victory = Base()

function Victory:enter(params)
    self.level = params.level
    self.score = params.score
    self.highScores = params.highScores
    self.paddleView = params.paddleView
    self.paddle = params.paddle
    self.health = params.health
    -- TODO: Ball borrar esta asociacion
    --self.ball = params.ball
    self.balls = params.balls
    -- TODO: Ball revisar si no hace falta resetear las balls para que se vuelva a tener una sola
    --self.ballView = params.ballView -- Recibo el ballView de otra escena para que mantenga la misma vista y no inicialice otra
    self.recoverPoints = params.recoverPoints

    self.views = List {
        HealthView(self.health),
        ScoreView(self.score),
        self.paddleView,
        -- TODO: Ball borrar esta asociacion
        --self.ballView,
    }

    -- TODO: Ball revisar si solo hace falta hacer un map y no un select ya que la lista es de balls - Se repite en Play
    self.views:add(self.balls
        :select(function(ball) return ball:is_a(Ball) end)
        :map(BallView)
    )
end

function Victory:update(dt)
    self.paddle:update(dt)

    -- have the ball track the player
    local paddleWidth = self.paddle:getWidth()
    -- TODO: Ball borrar esta asignacion
    --self.ball.x = self.paddle.x + (paddleWidth / 2) - 4
    --self.ball.y = self.paddle.y - 8
    -- TODO: Ball revisar si habilitar funcion para actualizar posicion x,y (Este codigo se repite en Serve)
    self.balls:foreach(function (ball)
        ball.x = self.paddle.x + (paddleWidth / 2) - 4
        ball.y = self.paddle.y - 8
    end)

    -- go to play screen if the player presses Enter
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        self._scenes:change('serve', {
            level = self.level + 1,
            bricks = LevelMaker:create_map(self.level + 1),
            paddle = self.paddle,
            paddleView = self.paddleView,
            health = self.health,
            score = self.score,
            highScores = self.highScores,
            recoverPoints = self.recoverPoints
        })
    end
end

function Victory:render()
    self.views:foreach(function(view) view:render() end)

    -- level complete text
    love.graphics.setFont(Fonts:get('large'))
    love.graphics.printf("Level " .. tostring(self.level) .. " complete!",
        0, Constants.VIRTUAL_HEIGHT / 4, Constants.VIRTUAL_WIDTH, 'center')

    -- instructions text
    love.graphics.setFont(Fonts:get('medium'))
    love.graphics.printf('Press Enter to serve!', 0, Constants.VIRTUAL_HEIGHT / 2,
        Constants.VIRTUAL_WIDTH, 'center')
end

return Victory