local Object = require 'src/Object'

local Set = Object()

function Set:initialize(table)
    self._elements = {}
    if table then
        for _, l in pairs(table) do
            self:insert(l)
        end
    end
end

function Set:insert(element)
    self._elements[element] = true
end

function Set:remove(element)
    self._elements[element] = nil
end

function Set:has(element)
    return self._elements[element] ~= nil
end

function Set:elements()
    local next, t = pairs(self._elements)
    return function(...) return (next(...)) end, t
end

function Set:foreach(f)
    for e in self:elements() do
        f(e)
    end
end

function Set:select(f)
    local result = Set()
    self:foreach(function(element)
        if f(element) then
            result:insert(element)
        end
    end)
    return result
end

function Set:__add (a,b)
    local res = Set()
    for k in a:elements() do
        res:insert(k)
    end
    for k in b:elements() do
        res:insert(k)
    end
    return res
end

function Set.__mul (a,b)
    local result = Set()
    for k in a:elements() do
        if b:has(k) then
            result:insert(k)
        end
    end
    return result
end

return Set