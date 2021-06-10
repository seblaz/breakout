local Object = require 'src/Object'

local Paddle = Object()

function Paddle:initialize(paddle)
    self.paddle = paddle
end


--[[
    Render the paddle by drawing the main texture, passing in the quad
    that corresponds to the proper skin and size.
]]
function Paddle:render()
    love.graphics.draw(
            gTextures['main'],
            self:_color(),
            self.paddle.x,
            self.paddle.y
    )
end

function Paddle:_color()
    return gFrames['paddles'][self.paddle.size + 4 * (self.paddle.skin - 1)]
end

return Paddle