local Fonts = require 'src/assets/Fonts'

local Object = require 'src/Object'
local Constants = require 'src/constants'

local Pause = Object()

function Pause:initialize(pause)
    self._pause = pause
end

function Pause:render()
    if self._pause:paused() then
        love.graphics.setFont(Fonts:get('large'))
        love.graphics.printf("PAUSED", 0, Constants.VIRTUAL_HEIGHT / 2 - 16, Constants.VIRTUAL_WIDTH, 'center')
    end
end

return Pause