local Object = require 'src/Object'

local Health = Object()

function Health:initialize()
    self._points = 3
end

function Health:decrease()
    self._points = self._points - 1
end

function Health:is_alive()
    return self._points > 0
end

function Health:points()
    return self._points
end

return Health
