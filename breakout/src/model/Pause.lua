local Object = require 'src/Object'

local EventBus = require 'src/model/EventBus'
local Events = require 'src/model/Events'

local Pause = Object()

function Pause:initialize()
    self._paused = false
end

function Pause:update()
    if love.keyboard.wasPressed('space') then
        EventBus:notify(Events.GAME_PAUSED_OR_UNPAUSED)
        self._paused = not self._paused
    end
end

function Pause:paused()
    return self._paused
end

return Pause
