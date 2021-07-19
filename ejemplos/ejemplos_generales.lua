-- Variables

--print(A)

-- A = 10

-- print(A)

-- A = nil

-- print(A)

-- local a = 2 

-- print(a)

-- Tipos de datos

--[[
print("El tipo de dato de 8 es:" .. type(8))

print("El tipo de dato de true es:" .. type(true))

print("El tipo de dato de un valor nulo es:" .. type(nil))

print("El tipo de dato de una String es:" .. type("8"))

-- Especiales

print("El tipo de dato de una funcion es:" .. type( function ()end  ))

print("El tipo de dato de {} es:" .. type({}))

print("Las corrutinas devuelven:" .. type( coroutine.create(function () end)))

--]]







-- Funciones

-- MostrarPorConsola = print

-- MostrarPorConsola("Las funciones son valores de primera clase")

-- Sumar = function (a,b)
--     return a + b
-- end

-- print("Sumando 2 y 3: " .. Sumar(2,3))

-- print("Las funciones solo toman los parametros necesarios: " .. Sumar(3,3,4,5,6))






-- Lexical Scoping


print("Creando un contador a través de una función")

function NewCounter()
    local n = 0
    return function ()
        n = n + 1
        return n
    end
end

Contador = NewCounter()

print("Aumentando el contador: ")

print(Contador())

print("Aumentando el contador: ")

print(Contador())

