local Object = require 'src/Object'

local BallSkin = Object()

function BallSkin:initialize(ball)
    self.ball = ball
    self.color = 2
end

function BallSkin:render()

    -- gTexture is our global texture for all blocks
    -- gBallFrames is a table of quads mapping to each individual ball skin in the texture
    love.graphics.draw(
                    self._getTexture(),
                    self:_getColor(),
                    self.ball.x,
                    self.ball.y
                )
end


function BallSkin:_getColor()
    return gFrames['balls'][self.color]
end

function BallSkin:_getTexture()
    return gTextures['main']
end