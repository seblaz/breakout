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

function Object:_set_type(type)
    self._type = type
end

function Object:type()
    return self._type
end

setmetatable(Object, Object)

Object:_set_type('Object')

-- Auto
local Auto = Object()
Auto:_set_type('Auto')

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
local Ferrari = Auto("Ferrari")
Ferrari:_set_type('Ferrari')

function Ferrari:initialize(modelo)
    self:upper():initialize('ferrari ' .. modelo)
end

-- Lamborgini
local Lamborgini = Auto()
Lamborgini:_set_type('Lamborgini')

function Lamborgini:initialize(modelo)
    self:upper():initialize('lamborgini ' .. modelo)
end

-- Redefinición y llamada al método de la clase anterior
function Ferrari:velocidadMaxima()
    return 200 + self:proto():velocidadMaxima()
end

local object = Object()
local auto = Auto('fiat 600')
local ferrari = Ferrari('1000')
local lamborgini = Lamborgini('22')

print(object:type())
print(auto:type())
print(ferrari:type())
print(lamborgini:type())
