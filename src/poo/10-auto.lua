--- Otra sintaxis de creación.

-- Object
local Object = {}

function Object:new(...)
    local object = {}
    self.__index = self
    self.__call = self.new
    setmetatable(object, self)
    object:initialize(...)
    return object
end

function Object:initialize() end

function Object:proto()
    return getmetatable(getmetatable(self))
end

setmetatable(Object, {__call = Object.new})

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

-- Redefinición y llamada al método de la clase anterior
function Ferrari:velocidadMaxima()
    return 200 + self:proto():velocidadMaxima()
end

local auto = Auto('fiat 600')
print(auto:velocidadMaxima(), auto:nombreCompleto())

local ferrari = Ferrari('ferrari 1000')
print(ferrari:velocidadMaxima(), ferrari:nombreCompleto())

-- Distintas funciones
print(auto.velocidadMaxima)
print(ferrari.velocidadMaxima)


-- Misma función
print(auto.nombreCompleto)
print(ferrari.nombreCompleto)
