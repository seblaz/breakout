--- Fix bug en proto.

-- Object
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

-- Auto
local Auto = Object()

function Auto:initialize(nombre)
    self.nombre = nombre
end

function Auto:velocidadMaxima()
    return 100
end

function Auto:nombreCompleto()
    return self.nombre
end

-- Ferrari
local Ferrari = Auto()

function Ferrari:initialize(modelo)
    self:upper():initialize('ferrari ' .. modelo)
end

-- Lamborgini
local Lamborgini = Auto()

function Lamborgini:initialize(modelo)
    self:upper():initialize('lamborgini ' .. modelo)
end

-- Redefinición y llamada al método de la clase anterior
function Ferrari:velocidadMaxima()
    return 200 + self:proto():velocidadMaxima()
end

local auto = Auto('fiat 600')
local ferrari = Ferrari('1000')
local lamborgini = Lamborgini('22')

print(auto:velocidadMaxima(), auto:nombreCompleto())
print(ferrari:velocidadMaxima(), ferrari:nombreCompleto())
print(lamborgini:velocidadMaxima(), lamborgini:nombreCompleto())

-- Checks
print(auto:is_a(Auto))      -- true
print(auto:is_a(Object))    -- true
print(auto:is_a(Ferrari))   -- false
print(ferrari:is_a(Auto))   -- true
print(ferrari:is_a(auto))   -- false
