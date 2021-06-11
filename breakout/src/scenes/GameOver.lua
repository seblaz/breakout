--[[
    GD50
    Breakout Remake

    -- GameOverState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The state in which we've lost all of our health and get our score displayed to us. Should
    transition to the EnterHighScore state if we exceeded one of our stored high scores, else back
    to the StartState.
]]

local Base = require 'src/scenes/Base'
local Fonts = require 'src/assets/Fonts'
local Constants = require 'src/constants'

local GameOver = Base()

function GameOver:enter(params)
    self.score = params.score
    self.highScores = params.highScores
end

function GameOver:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        -- see if score is higher than any in the high scores table
        local highScore = false
        
        -- keep track of what high score ours overwrites, if any
        for i = 10, 1, -1 do
            local score = self.highScores[i]
            if self.score > score then
                highScoreIndex = i
                highScore = true
            end
        end

        if highScore then
            Constants.gSounds['high-score']:play()
            self._scenes:change('enter-high-score', {
                highScores = self.highScores,
                score = self.score,
                scoreIndex = highScoreIndex
            })
        else 
            self._scenes:change('start', {
                highScores = self.highScores
            }) 
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function GameOver:render()
    love.graphics.setFont(Fonts:get('large'))
    love.graphics.printf('GAME OVER', 0, Constants.VIRTUAL_HEIGHT / 3, Constants.VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(Fonts:get('medium'))
    love.graphics.printf('Final Score: ' .. tostring(self.score:points()), 0, Constants.VIRTUAL_HEIGHT / 2,
        Constants.VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Enter!', 0, Constants.VIRTUAL_HEIGHT - Constants.VIRTUAL_HEIGHT / 4,
        Constants.VIRTUAL_WIDTH, 'center')
end

return GameOver