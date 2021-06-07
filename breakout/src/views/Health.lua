local Object = require 'src/Object'

local Health = Object()

function Health:initialize(health)
    self._health = health
end

function Health:render()
    -- start of our health rendering
    local healthX = VIRTUAL_WIDTH - 100

    -- render health left
    for i = 1, self._health:points() do
        love.graphics.draw(gTextures['hearts'], gFrames['hearts'][1], healthX, 4)
        healthX = healthX + 11
    end

    -- render missing health
    for i = 1, 3 - self._health:points() do
        love.graphics.draw(gTextures['hearts'], gFrames['hearts'][2], healthX, 4)
        healthX = healthX + 11
    end
end

return Health