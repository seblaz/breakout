local Object = {}

function Object:__call(...)
    self.__index = self
    self.__call = self.__call
    local object = setmetatable({}, self)
    object:initialize(...)
    return object
end

function Object:initialize() end

function Object:proto()
    return getmetatable(getmetatable(self))
end

function Object:upper()
    return setmetatable({}, {
        __index = function(_, method)
            return function(_, ...)
                return self:proto()[method](self, ...)
            end
        end
    })
end

function Object:is_a(proto)
    if self == proto then
        return true
    end

    if getmetatable(self) == self then
        return false
    end

    return getmetatable(self):is_a(proto)
end

setmetatable(Object, Object)

return Object