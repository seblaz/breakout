local Object = require 'src/Object'

local SpecialBrick = Object()

function SpecialBrick:initialize(x, y, level)
    self._level = 1
    self.x = x
    self.y = y
    self.width = 32
    self.height = 16
end

function SpecialBrick:hit(world) end

function SpecialBrick:level()
    return self._level
end

function SpecialBrick:points()
    return self:level() * 10
end

function SpecialBrick:in_play()
    return self._level ~= 0
end

function SpecialBrick:is_alive()
    return self:in_play()
end

return SpecialBrick