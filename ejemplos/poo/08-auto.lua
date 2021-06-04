--- Herencia.

local Auto = {}

function Auto:new (nombre)
    local auto = {
        nombre = nombre
    }

    self.__index = self
    setmetatable(auto, self)

    return auto
end

function Auto:velocidadMaxima()
    return 100
end

function Auto:nombreCompleto()
    return self.nombre
end

-- Ferrari hereda de Auto
local Ferrari = Auto:new()

function Ferrari:new(nombre)
    local auto = Auto:new(nombre)

    self.__index = self
    setmetatable(auto, self)

    return auto
end

-- Redefinición y llamada al método de la clase anterior
function Ferrari:velocidadMaxima()
    -- return 200 + Auto:velocidadMaxima()
    -- return 200 + getmetatable(Ferrari):velocidadMaxima()
    return 200 + getmetatable(getmetatable(self)):velocidadMaxima()
end

local auto = Auto:new('fiat 600')
print(auto:velocidadMaxima(), auto:nombreCompleto())

local ferrari = Ferrari:new('ferrari 1000')
print(ferrari:velocidadMaxima(), ferrari:nombreCompleto())

-- Distintas funciones
print(auto.velocidadMaxima)
print(ferrari.velocidadMaxima)


-- Misma función
print(auto.nombreCompleto)
print(ferrari.nombreCompleto)
