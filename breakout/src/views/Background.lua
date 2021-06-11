local Object = require 'src/Object'
local Constants = require 'src/constants'

local Background = Object()

function Background:render()
    -- background should be drawn regardless of state, scaled to fit our
    -- virtual resolution
    local backgroundWidth = gTextures['background']:getWidth()
    local backgroundHeight = gTextures['background']:getHeight()

    love.graphics.draw(gTextures['background'],
        -- draw at coordinates 0, 0
        0, 0,
        -- no rotation
        0,
        -- scale factors on X and Y axis so it fills the screen
        Constants.VIRTUAL_WIDTH / (backgroundWidth - 1), Constants.VIRTUAL_HEIGHT / (backgroundHeight - 1)
    )
end

return Background