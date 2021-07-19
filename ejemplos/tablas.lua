tabla = { [1] = "a", 
          [2] = "b", 
          [3]= "c" }

tabla2 = { ["pos1"] = "a", 
           ["pos2"] = "b", 
           ["pos3"]= "c" }

tabla3 = {"a", 
          [2] = "b", 
          ["ident"] = "hola"}

tabla4 = {}

tabla5 = {33,55,7,77,33,3}

print(tabla[1])
print(tabla2.pos1)
print(tabla2["pos1"])
print(tabla3["ident"])