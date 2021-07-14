local Object = require 'src/Object'

local Serializer = Object()

function Serializer:serialize(o, stream)
    stream:write("Root ")
    self:_serialize(o, stream)
end

function Serializer:_serialize(o, stream)
    local t = type(o)
    if t == "number" or t == "string" or t == "boolean" or t == "nil" then
        stream:write(string.format("%q", o))
    elseif t == "table" then
        if o.type ~= nil then
            stream:write(o:type() .. "{\n")
        else
            stream:write("{\n")
        end

        for k, v in pairs(o) do
            stream:write(string.format(" [%s] = ", string.format("%q", k)))
            self:_serialize(v, stream)
            stream:write(",\n")
        end
        stream:write("}\n")
    else
        error("cannot serialize a " .. type(o))
    end
end

return Serializer