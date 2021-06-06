local Object = require 'src/Object'
local Score = require 'src/model/Score'

local HighScore = Object()

function HighScore:save(highScores)
    local scoresStr = ''

    for i = 1, 10 do
        scoresStr = scoresStr .. highScores[i]:name() .. '\n'
        scoresStr = scoresStr .. tostring(highScores[i]:points()) .. '\n'
    end

    love.filesystem.write('breakout.lst', scoresStr)
end

function HighScore:load()
    love.filesystem.setIdentity('breakout')

    -- if the file doesn't exist, initialize it with some default scores
    if not love.filesystem.getInfo('breakout.lst') then
        local scores = ''
        for i = 10, 1, -1 do
            scores = scores .. 'CTO\n'
            scores = scores .. tostring(i * 1000) .. '\n'
        end

        love.filesystem.write('breakout.lst', scores)
    end

    -- flag for whether we're reading a name or not
    local name = true
    local counter = 1

    -- initialize scores table with at least 10 blank entries
    local scores = {}

    -- iterate over each line in the file, filling in names and scores
    for line in love.filesystem.lines('breakout.lst') do
        if name then
            scores[counter] = Score(0, string.sub(line, 1, 3))
        else
            scores[counter]:add(tonumber(line))
            counter = counter + 1
        end

        -- flip the name flag
        name = not name
    end

    return scores
end

return HighScore