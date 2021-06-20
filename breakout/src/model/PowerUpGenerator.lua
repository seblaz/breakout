local Object = require 'src/Object'
local FasterBall = require 'src/model/PowerUpFasterBall'

local Generator = Object()

function Generator:initialize()
    self:_reset()
end

function Generator:_reset()
    self._elapsed_time = 0
    self._remaining_time = math.random(7, 13)
end

function Generator:update(dt)
    self._elapsed_time = self._elapsed_time + dt
end

function Generator:generate()
    if self._elapsed_time > self._remaining_time then
        self:_reset()
        return FasterBall()
    end
end

return Generator