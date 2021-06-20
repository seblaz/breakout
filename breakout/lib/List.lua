local Object = require 'src/Object'

local List = Object()

function List:initialize(table)
    self._elements = {}
    if table then
        for _, l in ipairs(table) do
            self:insert(l)
        end
    end
end

function List:insert(element)
    self._elements[self:count() + 1] = element
end

function List:count()
    return #self._elements
end

function List:elements()
    return ipairs(self._elements)
end

function List:foreach(f)
    for _, e in self:elements() do
        f(e)
    end
end

function List:select(f)
    local result = List()
    self:foreach(function(element)
        if f(element) then
            result:insert(element)
        end
    end)
    return result
end

function List:any_satisfy(f)
    for _, e in self:elements() do
        if f(e) then
            return true
        end
    end
    return false
end

function List:all_satisfy(f)
    for _, e in self:elements() do
        if not f(e) then
            return false
        end
    end
    return true
end

function List:map(f)
    local result = List()
    self:foreach(function(element)
        result:insert(f(element))
    end)
    return result
end

function List:add(list)
    list:foreach(function(element)
        self:insert(element)
    end)
end

return List