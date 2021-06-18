local Object = require 'src/Object'
local Constants = require 'src/constants'
local Frames = require 'src/assets/Frames'

local Ball = Object()

function Ball:initialize(ball)
    self.ball = ball
    self.color = math.random(7)
end


function Ball:render()

    -- gTexture is our global texture for all blocks
    -- gBallFrames is a table of quads mapping to each individual ball skin in the texture

    love.graphics.draw(
                    self._getTexture(),
                    self:_getColor(),
                    self.ball.x,
                    self.ball.y
                )
end


function Ball:_getColor()
    return Frames['balls'][self.color]
end

function Ball:_getTexture()
    return Constants.gTextures['main']
end

return Ball
