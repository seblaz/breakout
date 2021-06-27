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

local List = require 'lib/List'
local Base = require 'src/scenes/Base'
local PlaySounds = require 'src/sounds/Play'

local EventBus = require 'src/model/EventBus'
local Events = require 'src/model/Events'
local Pause = require 'src/model/Pause'
local Brick = require 'src/model/Brick'
local Ball = require 'src/model/Ball'
local BrickUnbreakable = require 'src/model/BrickUnbreakable'
local BrickPaddleSize = require 'src/model/BrickPaddleSize'
local BrickMultiball = require 'src/model/BrickMultiball'
local PowerUpGenerator = require 'src/model/PowerUpGenerator'

local BrickView = require 'src/views/Brick'
local BallView = require 'src/views/Ball'
local BrickUnbreakableView = require 'src/views/BrickUnbreakable'
local BrickPaddleSizeView = require 'src/views/BrickPaddleSize'
local BrickMultiballView = require 'src/views/BrickMultiball'
local BrickClouds = require 'src/views/BrickClouds'
local ScoreView = require 'src/views/Score'
local HealthView = require 'src/views/Health'
local PauseView = require 'src/views/Pause'
local PowerUpFasterBallView = require 'src/views/PowerUpFasterBall'

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
    -- TODO: Balls borrar esta asociacion
    --self.ball = params.ball
    self.balls = params.balls
    --self.ballView = params.ballView
    --self.ballViews = params.ballViews
    self.level = params.level
    self.pause = Pause()
    self.power_ups = List()
    self.power_up_generator = PowerUpGenerator()


    self.recoverPoints = 5000

    -- give ball random starting velocity
    -- TODO: Ball borrar esta asignacion
    --self.ball.dx = math.random(-200, 200)
    --self.ball.dy = math.random(-50, -60)
    self.balls:foreach(function(ball)
        ball.dx = math.random(-200, 200)
        ball.dy = math.random(-50, -60)
    end)

    local clouds = BrickClouds()

    -- Views
    self.views = List({
        self.paddleView,
        -- TODO: Ball borrar esta asignacion
        --self.ballView, -- Recibo el ballView de otra escena para que mantenga la misma vista y no inicialice otra
        ScoreView(self.score),
        HealthView(self.health),
        PauseView(self.pause),
    })

    -- TODO: Ball revisar si solo hace falta hacer un map y no un select ya que la lista es de balls
    self.views:add(self.balls
        :select(function(ball) return ball:is_a(Ball) end)
        :map(BallView)
    )

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
        :select(function(brick) return brick:is_a(BrickMultiball) end)
        :map(BrickMultiballView)
    )
        
    self.views:insert(clouds) -- Insert it last to be on top of the bricks

    -- Models
    -- TODO: Balls models borrar
    -- TODO: Ball Analizar si crear ballManager model que maneje adentro la lista de balls
    --self.models = List { self.paddle, self.ball, clouds, self.power_up_generator }
    self.models = List { self.paddle, self.balls, clouds, self.power_up_generator }

    -- Sounds
    self.sounds = PlaySounds()

    self.world = {
        paddle = params.paddle,
        health = params.health,
        score = params.score,
        --ball = params.ball,
        balls = params.balls,
        views = self.views
    }
end

function Play:update(dt)
    self.pause:update()
    if self.pause:paused() then
        return
    end
    self:_update_model(dt)
    self:_detect_collisions()
    self:_generate_power_ups()
end

-- TODO: Ball borrar esta funcion por la de abajo
--[[function Play:_update_model(dt)
    self.models:foreach(function(model)
        model:update(dt)
    end)
end--]]

-- TODO: Ball update models --> Analizar ball manager para manejar la ballList
function Play:_update_model(dt)
    self.models:foreach(function(model)
        if model:is_a(List) then
            model:foreach(function (ball)
                ball:update(dt)
            end)
        else
            model:update(dt)
        end
    end)
end

-- TODO: Ball borrar esta funcion por la de abajo
--[[function Play:_detect_collisions()
    self.ball:collision_with_paddle(self.paddle)

    self.bricks:foreach(function(brick)
        self.ball:collision_with_brick(brick, self.world)
    end)

    self.ball:collision_with_window(self.world)

    self.power_ups:foreach(function(power_up)
        power_up:collision_with_paddle(self.paddle, self.world)
    end)

    self:_change_scene()
end--]]

-- TODO: Balls detect collistions
function Play:_detect_collisions()

    self.balls:foreach(function (ball)

        ball:collision_with_paddle(self.paddle)

        self.bricks:foreach(function (brick)
            ball:collision_with_brick(brick, self.world)
        end)

        ball:collision_with_window(self.world)

        self.power_ups:foreach(function (power_up)
            power_up:collision_with_paddle(self.paddle, self.world)
        end)

        self:_change_scene()
    end)
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
            --ball = self.ball,
            -- TODO: Ball borrar el ball
            -- TODO: Ball revisar victory recibiendo las balls
            balls = self.balls,
            -- ballView = self.ballView, -- Le paso el ballView al victory para que mantenga la misma vista y no inicialice otra
            recoverPoints = self.recoverPoints
        })
    end

    -- TODO: Ball borrar if para usar la funcion detect_balls_out_of...
    self:_detect_balls_out_of_bounds()
    --[[if self.ball:out_of_bounds() then
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
    end]]--

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function Play:_detect_balls_out_of_bounds()
    self.balls:foreach(function (ball)

        -- TODO: Ball Revisar esto para permitir que si se cae una no se pierda
        if ball:out_of_bounds() then
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
    end)
end

function Play:_level_completed()
    return self.bricks:all_satisfy(function(brick)
        return not brick:is_alive()
    end)
end

function Play:_generate_power_ups()
    local power_up = self.power_up_generator:generate()
    if power_up then
        self.models:insert(power_up)
        self.power_ups:insert(power_up)
        self.views:insert(PowerUpFasterBallView(power_up))
    end
end

function Play:render()
    self.views:foreach(function(view)
        view:render()
    end)
end

return Play