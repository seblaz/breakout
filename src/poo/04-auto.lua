local velocidadMaxima = function(_)
    return 100
end

local nombreCompleto = function(auto)
    return auto.nombre
end

local function nuevoAuto(nombre)

    local auto = {
        nombre = nombre
    }

    auto.nombreCompleto = nombreCompleto
    auto.velocidadMaxima = velocidadMaxima

    return auto
end

local auto = nuevoAuto('fiat 600')
print(auto:velocidadMaxima(), auto:nombreCompleto())

local auto2 = nuevoAuto('fiat 601')
print(auto2:velocidadMaxima(), auto2:nombreCompleto())

-- Es la misma función
print(auto.velocidadMaxima)
print(auto2.velocidadMaxima)

--- Esta implementación soluciona todos los problemas, simplemente con
--- "syntactic sugar":
--- auto:velocidadMaxima() <--> auto.velocidadMaxima(auto)
