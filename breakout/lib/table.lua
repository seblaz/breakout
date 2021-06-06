local table = require 'table'

table.map = function(tbl, f)
    local t = {}
    for k, v in ipairs(tbl) do
        t[k] = f(v)
    end
    return t
end

table.concatenate = function(table1, table2)
    for _, v in ipairs(table2) do
        table.insert(table1, v)
    end
end

table.apply = function(tbl, f)
    for _, v in ipairs(tbl) do
        f(v)
    end
end