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

-- the "__includes" bit here means we're going to inherit all of the methods
-- that BaseState has, so it will have empty versions of all StateMachine methods
-- even if we don't override them ourselves; handy to avoid superfluous code!
local Base = require 'src/scenes/Base'
local Fonts = require 'src/assets/Fonts'
local Constants = require 'src/constants'

local Start = Base()

-- whether we're highlighting "Start" or "High Scores"
local highlighted = 1

function Start:enter(params)
    self.highScores = params.highScores
end

function Start:update()
    -- toggle highlighted option if we press an arrow key up or down
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
        highlighted = highlighted == 1 and 2 or 1
        Constants.gSounds['paddle-hit']:play()
    end

    -- confirm whichever option we have selected to change screens
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        Constants.gSounds['confirm']:play()

        if highlighted == 1 then
            gStateMachine:change('paddle-select', {
                highScores = self.highScores
            })
        else
            gStateMachine:change('high-scores', {
                highScores = self.highScores
            })
        end
    end

    -- we no longer have this globally, so include here
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function Start:render()
    -- title
    love.graphics.setFont(Fonts:get('large'))
    love.graphics.printf("BREAKOUT", 0, Constants.VIRTUAL_HEIGHT / 3,
        Constants.VIRTUAL_WIDTH, 'center')

    -- instructions
    love.graphics.setFont(Fonts:get('medium'))

    -- if we're highlighting 1, render that option blue
    if highlighted == 1 then
        love.graphics.setColor(0.4, 1, 1)
    end
    love.graphics.printf("START", 0, Constants.VIRTUAL_HEIGHT / 2 + 70,
        Constants.VIRTUAL_WIDTH, 'center')

    -- reset the color
    love.graphics.setColor(1, 1, 1)

    -- render option 2 blue if we're highlighting that one
    if highlighted == 2 then
        love.graphics.setColor(0.4, 1, 1)
    end
    love.graphics.printf("HIGH SCORES", 0, Constants.VIRTUAL_HEIGHT / 2 + 90,
        Constants.VIRTUAL_WIDTH, 'center')

    -- reset the color
    love.graphics.setColor(1, 1, 1)
end

return Start