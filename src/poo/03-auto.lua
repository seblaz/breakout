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
print(auto.velocidadMaxima(auto), auto.nombreCompleto(auto))

local auto2 = nuevoAuto('fiat 601')
print(auto2.velocidadMaxima(auto2), auto2.nombreCompleto(auto2))

--- Esta implementación soluciona los problemas anteriores

-- Es la misma función
print(auto.velocidadMaxima)
print(auto2.velocidadMaxima)

--- Pero hace que sea más verboso utilizar los métodos, dado que hay que pasar
--- al propio objeto como primer parámetro.