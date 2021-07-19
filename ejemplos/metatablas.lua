
local metatabla = {} 

metatabla.__add = function (a, b)
    print("metatabla.__add")
    return {x = a.x + b.x, y = a.y + b.y}
end
 
metatabla.__eq = function (a, b)
    print("metatabla.__eq")
    return a.x == b.x and a.y == b.y
end
 
metatabla.__tostring = function (point)
    print("metatabla.__tostring")
    return string.format("[x = %f, y = %f]", point.x, point.y)
end

--
 
Punto = {}

function Punto.new(x, y)
    local punto = {x = x, y = y}
    setmetatable(punto, metatabla)
    return punto
end
 
local punto_uno = Punto.new(20, 20)
local punto_dos = Punto.new(20, 20)
print(tostring(punto_uno))
print(tostring(punto_dos))
 
print("----------")
local punto_tres = punto_uno + punto_dos
print(punto_tres.x)
print(punto_tres["x"])
print(punto_tres.y)

print("----------")
print(punto_uno == punto_dos)