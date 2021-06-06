local Object = require 'src/Object'

local Score = Object()

function Score:initialize(points, name)
    self._points = points or 0
    self._name = name
end

function Score:add(points)
    self._points = self._points + points
end

-- Less than
function Score:__lt(b)
    return self:points() < b:points()
end

-- Less or equal than
function Score:__le(b)
    return self:points() <= b:points()
end

function Score:points()
    return self._points
end

function Score:name()
    return self._name
end

function Score:set_name(name)
    self._name = name
end

return Score