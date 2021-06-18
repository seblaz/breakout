local Object = require 'src/Object'
local Constants = require 'src/constants'
local Frames = require 'src/assets/Frames'

local Brick = Object()

function Brick:initialize(brick)
    self.brick = brick
end

function Brick:render()
    love.graphics.draw(
            Constants.gTextures['main'],
            self:_color(),
            self.brick.x,
            self.brick.y
    )
end

function Brick:_color()
    return Frames['bricks'][21]
end

return Brick