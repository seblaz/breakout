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

setmetatable(Object, {__call = Object.new})

return Object