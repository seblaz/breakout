local Object = require 'src/Object'
local Constants = require 'src/constants'
local Frames = require 'src/assets/Frames'

local BrickPaddleSize = Object()

function BrickPaddleSize:initialize(brick)
    self.brick = brick
end

function BrickPaddleSize:render()
    if self.brick:in_play() then
            love.graphics.draw(
                        Constants.gTextures['main'],
                        self:_color(),
                        self.brick.x,
                        self.brick.y
            )
    end
end

function BrickPaddleSize:_color()
    return Frames['bricks'][19]
end

return BrickPaddleSize