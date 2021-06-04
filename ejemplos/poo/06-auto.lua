--- Soluciona el mismo problema que 04 y 05 pero de una forma que nos hace
--- acordar más a las clases.

local Auto = {
    velocidadMaxima = function(_)
        return 100
    end,
    nombreCompleto = function(auto)
        return auto.nombre
    end
}

Auto.__index = Auto

Auto.new = function(nombre)
    local auto = {
        nombre = nombre
    }

    setmetatable(auto, Auto)

    return auto
end

local auto = Auto.new('fiat 600')
print(auto:velocidadMaxima(), auto:nombreCompleto())

local auto2 = Auto.new('fiat 601')
print(auto2:velocidadMaxima(), auto2:nombreCompleto())

-- Es la misma función
print(auto.velocidadMaxima)
print(auto2.velocidadMaxima)

