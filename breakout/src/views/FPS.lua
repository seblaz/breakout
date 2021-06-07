local Fonts = require 'src/assets/Fonts'

local Object = require 'src/Object'

local FPS = Object()

function FPS:render()
    love.graphics.setFont(Fonts:get('small'))
    love.graphics.setColor(0, 1, 0)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)
end

return FPS