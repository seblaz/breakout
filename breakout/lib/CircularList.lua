local Object = require 'src/Object'

local CircularList = Object()

function CircularList:initialize(table)
    self._elements = {}
    if table then
        for _, l in pairs(table) do
            self._elements[#self._elements + 1] = l
        end
    end
    self:_reset()
end

function CircularList:_reset()
    self._current = 1
end

function CircularList:current()
    return self._elements[self._current]
end

function CircularList:next()
    if self._current == self:_total() then
        self:_reset()
    else
        self._current = self._current + 1
    end
    return self:current()
end

function CircularList:_total()
    return #self._elements
end

CircularList:_set_type('CircularList')

return CircularList