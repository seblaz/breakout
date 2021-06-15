local Object = {}

function Object:new(...)
    self.__index = self
    self.__call = self.new
    local object = setmetatable({}, self)
    object:initialize(...)
    return object
end

function Object:initialize() end

function Object:proto()
    return getmetatable(getmetatable(self))
end

function Object:is_a(proto)
    if self == proto then
        return true
    end

    if not getmetatable(self) or not getmetatable(self).is_a then
        return false
    end

    return getmetatable(self):is_a(proto)
end

setmetatable(Object, {__call = Object.new})

return Object