local Object = require 'src/Object'
local Frames = require 'src/assets/Frames'
local Constants = require 'src/constants'

local BrickMultiball = Object()

function BrickMultiball:initialize(brick)
    self.brick = brick
end

function BrickMultiball:render()
    if self.brick:in_play() then
        love.graphics.draw(
            Constants.gTextures['main'],
            self:_getColor(),
            self.brick.x,
            self.brick.y
        )
    end
end

function BrickMultiball:_getColor()
    return Frames['bricks'][11]
end

return BrickMultiball