--[[
    GD50
    Breakout Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the screen where we can view all high scores previously recorded.
]]

local Base = require 'src/scenes/Base'
local Fonts = require 'src/assets/Fonts'
local Constants = require 'src/constants'

local HighScore = Base()

function HighScore:enter(params)
    self.highScores = params.highScores
end

function HighScore:update(dt)
    -- return to the start screen if we press escape
    if love.keyboard.wasPressed('escape') then
        Constants.gSounds['wall-hit']:play()

        self._scenes:change('start', {
            highScores = self.highScores
        })
    end
end

function HighScore:render()
    love.graphics.setFont(Fonts:get('large'))
    love.graphics.printf('High Scores', 0, 20, Constants.VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(Fonts:get('medium'))

    -- iterate over all high score indices in our high scores table
    for i = 1, 10 do
        local name = self.highScores[i]:name()
        local score = self.highScores[i]:points()

        -- score number (1-10)
        love.graphics.printf(tostring(i) .. '.', Constants.VIRTUAL_WIDTH / 4,
            60 + i * 13, 50, 'left')

        -- score name
        love.graphics.printf(name, Constants.VIRTUAL_WIDTH / 4 + 38,
            60 + i * 13, 50, 'right')
        
        -- score itself
        love.graphics.printf(tostring(score), Constants.VIRTUAL_WIDTH / 2,
            60 + i * 13, 100, 'right')
    end

    love.graphics.setFont(Fonts:get('small'))
    love.graphics.printf("Press Escape to return to the main menu!",
        0, Constants.VIRTUAL_HEIGHT - 18, Constants.VIRTUAL_WIDTH, 'center')
end

return HighScore