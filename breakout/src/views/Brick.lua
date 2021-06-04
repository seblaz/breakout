local Object = require 'src/Object'

local Brick = Object()

function Brick:initialize(brick)
    self.brick = brick
end

function Brick:render()
    if self.brick:in_play() then
        love.graphics.draw(
                gTextures['main'],
                self:_color(),
                self.brick.x,
                self.brick.y
        )
    end
end

function Brick:_color()
    return gFrames['bricks'][self.brick:level()]
end

return Brick