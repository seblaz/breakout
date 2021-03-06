local Object = require 'src/Object'
local EventBus = require 'src/model/EventBus'
local Events = require 'src/model/Events'
local Constants = require 'src/constants'

local Play = Object()

function Play:initialize()
    EventBus:subscribe(Events.BRICK_HIT, function() self:brick_hit() end)
    EventBus:subscribe(Events.BRICK_DESTROYED, function() self:brick_destroyed() end)
    EventBus:subscribe(Events.BRICK_UNBREAKABLE_HIT, function() self:brick_unbreakable_hit() end)
    EventBus:subscribe(Events.LEVEL_COMPLETED, function() self:level_completed() end)
    EventBus:subscribe(Events.HEALTH_DECREASED, function() self:health_decreased() end)
    EventBus:subscribe(Events.HEALTH_DECREASED, function() self:health_decreased() end)
    EventBus:subscribe(Events.GAME_PAUSED_OR_UNPAUSED, function() self:game_paused_or_unpaused() end)
    EventBus:subscribe(Events.POWER_UP_ACTIVATED, function() self:power_up_activated() end)
    EventBus:subscribe(Events.BRICK_PADDLESIZE_HIT, function() self:brick_paddlesize_hit() end)
    EventBus:subscribe(Events.BRICK_MULTIBALL_HIT, function() self:brick_multiball_hit() end)

end

function Play:brick_hit()
    Constants.gSounds['brick-hit-2']:stop()
    Constants.gSounds['brick-hit-2']:play()
end

function Play:brick_destroyed()
    Constants.gSounds['brick-hit-1']:stop()
    Constants.gSounds['brick-hit-1']:play()
end

function Play:brick_unbreakable_hit()
    Constants.gSounds['brick-unbreakable-hit']:stop()
    Constants.gSounds['brick-unbreakable-hit']:play()
end

function Play:level_completed()
    Constants.gSounds['victory']:play()
end

function Play:health_decreased()
    Constants.gSounds['hurt']:play()
end

function Play:game_paused_or_unpaused()
    Constants.gSounds['pause']:play()
end

function Play:power_up_activated()
    Constants.gSounds['power-up-activated']:play()
end

function Play:brick_paddlesize_hit()
    Constants.gSounds['brick-paddlesize-hit']:play()
end

function Play:brick_multiball_hit()
    Constants.gSounds['brick-multiball-hit']:play()
end

return Play