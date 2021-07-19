co = coroutine.create(
    function()
        print("Hola")
    end
)

print(co)

-- Estados: Suspended, Running, Dead

print("El estado de la corutina es: " .. coroutine.status(co))

coroutine.resume(co) --> running

print("El estado de la corutina luego de correr: " .. coroutine.status(co))














-- Producer = coroutine.create(
--       function ()
--         local n = 1
--         while true do
--           Send("Mensaje " .. n)
--           n = n + 1
--         end
--       end)

-- function Send(x)
--     print("El estado de la corutina antes del yield: " .. coroutine.status(Producer))
--     coroutine.yield(x)
-- end

-- function Receive(producer)
--     print("El estado de la antes de recibir es: " .. coroutine.status(producer))

--     local estado, valor = coroutine.resume(producer)

--     print("El estado de la corutina despues del resume: " .. coroutine.status(producer))
--     return valor
-- end


-- print("Recibiendo: " .. Receive(Producer))

-- print("Recibiendo: " .. Receive(Producer))

-- print("Recibiendo: " .. Receive(Producer))




