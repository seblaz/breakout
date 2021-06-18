local Object = require 'src/Object'
local Constants = require 'src/constants'
local Frames = require 'src/assets/Frames'

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
            Constants.gTextures['main'],
            self:_color(),
            self.paddle.x,
            self.paddle.y
    )
end

function Paddle:_color()
    return Frames['paddles'][self.paddle.size + 4 * (self.paddle.skin - 1)]
end

return Paddle