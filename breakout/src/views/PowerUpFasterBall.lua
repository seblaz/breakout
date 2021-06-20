local Object = require 'src/Object'
local Constants = require 'src/constants'
local Frames = require 'src/assets/Frames'

local FasterBall = Object()

function FasterBall:initialize(faster_ball)
    self.faster_ball = faster_ball
end

function FasterBall:render()
    if self.faster_ball:in_play() then
        love.graphics.draw(
                Constants.gTextures['main'],
                self:_sprite(),
                self.faster_ball.x,
                self.faster_ball.y
        )
    end
end

function FasterBall:_sprite()
    return Frames['power_ups'][5]
end

return FasterBall