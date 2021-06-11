local Object = require 'src/Object'
local EventBus = require 'src/model/EventBus'
local Events = require 'src/model/Events'
local Constants = require 'src/constants'

local Play = Object()

function Play:initialize()
    EventBus:subscribe(Events.BRICK_HIT, function() self:brick_hit() end)
    EventBus:subscribe(Events.BRICK_DESTROYED, function() self:brick_destroyed() end)
end

function Play:brick_hit()
    Constants.gSounds['brick-hit-2']:stop()
    Constants.gSounds['brick-hit-2']:play()
end

function Play:brick_destroyed()
    Constants.gSounds['brick-hit-1']:stop()
    Constants.gSounds['brick-hit-1']:play()
end

return Play