local Object = require 'src/Object'
local FasterBall = require 'src/model/PowerUpFasterBall'

local Generator = Object()

function Generator:initialize()
    self._counter = 300
end

function Generator:update()
    self._counter = self._counter + 1
end

function Generator:generate()
    if self._counter % 310 == 0 then
        return FasterBall()
    end
end

return Generator