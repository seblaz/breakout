local function nuevoAuto(nombre)

    local auto = {
        nombre = nombre
    }

    auto.velocidadMaxima = function()
        return 100
    end

    auto.nombreCompleto = function()
        return auto.nombre
    end

    return auto
end

local auto = nuevoAuto('fiat 600')
print(auto.velocidadMaxima(), auto.nombreCompleto())

local auto2 = nuevoAuto('fiat 601')
print(auto2.velocidadMaxima(), auto2.nombreCompleto())

--- El problema de esta implementación es que crea una nueva función
--- `auto.velocidadMaxima` cada vez que se crea un nuevo auto. Esto es poco
--- performante por el uso de memoria. Esto lo podemos evidenciar así:

-- Son funciones distintas
print(auto.velocidadMaxima)
print(auto2.velocidadMaxima)

