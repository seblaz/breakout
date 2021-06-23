local PaddleSize = {
    ['small'] = 32, --small
    ['medium'] = 64, --medium
    ['large'] = 96  --large
}
--[[
    function PaddleSize:width(size)
        return PaddleSize[size]
    end
]]

return PaddleSize
