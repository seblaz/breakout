local Object = require 'src/Object'

local Ball = Object()

function Ball:initialize(ball)
    self.ball = ball
    self.color = math.random(7)
end


function Ball:render()

    -- gTexture is our global texture for all blocks
    -- gBallFrames is a table of quads mapping to each individual ball skin in the texture
    --[[for k,v in pairs(self.ball) do
        print(k)  
        print(v)
       end]]

    love.graphics.draw(
                    self._getTexture(),
                    self:_getColor(),
                    self.ball.x,
                    self.ball.y
                )
end


function Ball:_getColor()
    return gFrames['balls'][self.color]
end

function Ball:_getTexture()
    return gTextures['main']
end

return Ball
