--- Soluciona el mismo problema que 06 pero aprovechando el uso de self.

local Auto = {}

function Auto:velocidadMaxima()
    return 100
end

function Auto:nombreCompleto()
    return self.nombre
end

Auto.__index = Auto

function Auto:new (nombre)
    local auto = {
        nombre = nombre
    }

    setmetatable(auto, self)

    return auto
end

local auto = Auto:new('fiat 600')
print(auto:velocidadMaxima(), auto:nombreCompleto())

local auto2 = Auto:new('fiat 601')
print(auto2:velocidadMaxima(), auto2:nombreCompleto())

-- Es la misma función
print(auto.velocidadMaxima)
print(auto2.velocidadMaxima)

