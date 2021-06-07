local Object = require 'src/Object'

local Fonts = Object()

function Fonts:initialize()
    self._fonts = {
        ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
        ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
        ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
    }
end

function Fonts:get(size)
    return self._fonts[size]
end

return Fonts()