local auto_prototype = {
    velocidadMaxima = function(_)
        return 100
    end,
    nombreCompleto = function(auto)
        return auto.nombre
    end
}

local auto_metatable = {
    __index = function (auto, key)
        return function()
            return auto_prototype[key](auto)
        end
    end
}

local function nuevoAuto(nombre)

    local auto = {
        nombre = nombre
    }

    setmetatable(auto, auto_metatable)

    return auto
end

local auto = nuevoAuto('fiat 600')
print(auto.velocidadMaxima(), auto.nombreCompleto())

local auto2 = nuevoAuto('fiat 601')
print(auto2.velocidadMaxima(), auto2.nombreCompleto())

--- Esta implementación tiene el mismo problema que la 01:

-- Son funciones distintas
print(auto.velocidadMaxima)
print(auto2.velocidadMaxima)
