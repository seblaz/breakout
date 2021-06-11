local Fonts = require 'src/assets/Fonts'

local Object = require 'src/Object'
local Constants = require 'src/constants'

local Score = Object()

function Score:initialize(score)
    self._score = score
end

function Score:render()
    love.graphics.setFont(Fonts:get('small'))
    love.graphics.print('Score:', Constants.VIRTUAL_WIDTH - 60, 5)
    love.graphics.printf(tostring(self._score:points()), Constants.VIRTUAL_WIDTH - 50, 5, 40, 'right')
end

return Score