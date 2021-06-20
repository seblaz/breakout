--[[
    GD50
    Breakout Remake

    -- EnterHighScoreState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Screen that allows us to input a new high score in the form of three characters, arcade-style.
]]

local Base = require 'src/scenes/Base'
local HighScoreRepo = require 'src/repositories/HighScore'
local Fonts = require 'src/assets/Fonts'
local Constants = require 'src/constants'

local EnterHighScore = Base()

-- individual chars of our string
local chars = {
    [1] = 65,
    [2] = 65,
    [3] = 65
}

-- char we're currently changing
local highlightedChar = 1

function EnterHighScore:initialize(scenes)
    self:upper():initialize(scenes)
    self._high_score_repo = HighScoreRepo()
end

function EnterHighScore:enter(params)
    self.highScores = params.highScores
    self.score = params.score
    self.scoreIndex = params.scoreIndex
end

function EnterHighScore:update(_)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        -- update scores table

        -- go backwards through high scores table till this score, shifting scores
        for i = 10, self.scoreIndex, -1 do
            self.highScores[i + 1] = self.highScores[i]
        end

        local name = string.char(chars[1]) .. string.char(chars[2]) .. string.char(chars[3])
        self.score:set_name(name)
        self.highScores[self.scoreIndex] = self.score

        self._high_score_repo:save(self.highScores)

        self._scenes:change('high-scores', {
            highScores = self.highScores
        })
    end

    -- scroll through character slots
    if love.keyboard.wasPressed('left') and highlightedChar > 1 then
        highlightedChar = highlightedChar - 1
        Constants.gSounds['select']:play()
    elseif love.keyboard.wasPressed('right') and highlightedChar < 3 then
        highlightedChar = highlightedChar + 1
        Constants.gSounds['select']:play()
    end

    -- scroll through characters
    if love.keyboard.wasPressed('up') then
        chars[highlightedChar] = chars[highlightedChar] + 1
        if chars[highlightedChar] > 90 then
            chars[highlightedChar] = 65
        end
    elseif love.keyboard.wasPressed('down') then
        chars[highlightedChar] = chars[highlightedChar] - 1
        if chars[highlightedChar] < 65 then
            chars[highlightedChar] = 90
        end
    end
end

function EnterHighScore:render()
    love.graphics.setFont(Fonts:get('medium'))
    love.graphics.printf('Your score: ' .. tostring(self.score:points()), 0, 30,
        Constants.VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(Fonts:get('large'))
    
    --
    -- render all three characters of the name
    --
    if highlightedChar == 1 then
        love.graphics.setColor(0.4, 1, 1)
    end
    love.graphics.print(string.char(chars[1]), Constants.VIRTUAL_WIDTH / 2 - 28, Constants.VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(1, 1, 1)

    if highlightedChar == 2 then
        love.graphics.setColor(0.4, 1, 1)
    end
    love.graphics.print(string.char(chars[2]), Constants.VIRTUAL_WIDTH / 2 - 6, Constants.VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(1, 1, 1)

    if highlightedChar == 3 then
        love.graphics.setColor(0.4, 1, 1)
    end
    love.graphics.print(string.char(chars[3]), Constants.VIRTUAL_WIDTH / 2 + 20, Constants.VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(1, 1, 1)
    
    love.graphics.setFont(Fonts:get('small'))
    love.graphics.printf('Press Enter to confirm!', 0, Constants.VIRTUAL_HEIGHT - 18,
        Constants.VIRTUAL_WIDTH, 'center')
end

return EnterHighScore