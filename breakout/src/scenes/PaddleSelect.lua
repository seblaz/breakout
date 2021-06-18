--[[
    GD50
    Breakout Remake

    -- StartState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state the game is in when we've just started; should
    simply display "Breakout" in large text, as well as a message to press
    Enter to begin.
]]

local Base = require 'src/scenes/Base'
local Score = require 'src/model/Score'
local Health = require 'src/model/Health'
local Fonts = require 'src/assets/Fonts'
local Paddle = require 'src/model/Paddle'
local PaddleView = require 'src/views/Paddle'
local Constants = require 'src/constants'
local LevelMaker = require 'src/model/LevelMaker'
local Frames = require 'src/assets/Frames'

local PaddleSelect = Base()

function PaddleSelect:enter(params)
    self.highScores = params.highScores
end

function PaddleSelect:initialize(scenes)
    self:proto():initialize(scenes)
    -- the paddle we're highlighting; will be passed to the ServeState
    -- when we press Enter
    self.currentPaddle = 1
end

function PaddleSelect:update(dt)
    if love.keyboard.wasPressed('left') then
        if self.currentPaddle == 1 then
            Constants.gSounds['no-select']:play()
        else
            Constants.gSounds['select']:play()
            self.currentPaddle = self.currentPaddle - 1
        end
    elseif love.keyboard.wasPressed('right') then
        if self.currentPaddle == 4 then
            Constants.gSounds['no-select']:play()
        else
            Constants.gSounds['select']:play()
            self.currentPaddle = self.currentPaddle + 1
        end
    end

    -- select paddle and move on to the serve state, passing in the selection
    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        Constants.gSounds['confirm']:play()
        local paddleModel = Paddle(self.currentPaddle)
        local paddleSelectedView = PaddleView(paddleModel)
        self._scenes:change('serve', {
            paddle = paddleModel,
            paddleView = paddleSelectedView,
            bricks = LevelMaker:create_map(1),
            health = Health(),
            score = Score(10000),
            highScores = self.highScores,
            level = 1,
            recoverPoints = 5000
        })
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PaddleSelect:render()
    -- instructions
    love.graphics.setFont(Fonts:get('medium'))
    love.graphics.printf("Select your paddle with left and right!", 0, Constants.VIRTUAL_HEIGHT / 4,
        Constants.VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(Fonts:get('small'))
    love.graphics.printf("(Press Enter to continue!)", 0, Constants.VIRTUAL_HEIGHT / 3,
        Constants.VIRTUAL_WIDTH, 'center')
        
    -- left arrow; should render normally if we're higher than 1, else
    -- in a shadowy form to let us know we're as far left as we can go
    if self.currentPaddle == 1 then
        -- tint; give it a dark gray with half opacity
        love.graphics.setColor(0.16, 0.16, 0.16, 0.5)
    end
    
    love.graphics.draw(Constants.gTextures['arrows'], Frames['arrows'][1], Constants.VIRTUAL_WIDTH / 4 - 24,
        Constants.VIRTUAL_HEIGHT - Constants.VIRTUAL_HEIGHT / 3)
   
    -- reset drawing color to full white for proper rendering
    love.graphics.setColor(1, 1, 1)

    -- right arrow; should render normally if we're less than 4, else
    -- in a shadowy form to let us know we're as far right as we can go
    if self.currentPaddle == 4 then
        -- tint; give it a dark gray with half opacity
        love.graphics.setColor(0.16, 0.16, 0.16, 0.5)
    end
    
    love.graphics.draw(Constants.gTextures['arrows'], Frames['arrows'][2], Constants.VIRTUAL_WIDTH - Constants.VIRTUAL_WIDTH / 4,
        Constants.VIRTUAL_HEIGHT - Constants.VIRTUAL_HEIGHT / 3)
    
    -- reset drawing color to full white for proper rendering
    love.graphics.setColor(1, 1, 1)

    -- draw the paddle itself, based on which we have selected
    love.graphics.draw(Constants.gTextures['main'], Frames['paddles'][2 + 4 * (self.currentPaddle - 1)],
        Constants.VIRTUAL_WIDTH / 2 - 32, Constants.VIRTUAL_HEIGHT - Constants.VIRTUAL_HEIGHT / 3)
end

return PaddleSelect