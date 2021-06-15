local EventBus = require 'src/model/EventBus'
local Events = require 'src/model/Events'
local Object = require 'src/Object'

local BrickUnbreakable = Object()

function BrickUnbreakable:initialize(x, y)
    self.x = x
    self.y = y
    self.width = 32
    self.height = 16
end

function BrickUnbreakable:hit()
    EventBus:notify(Events.BRICK_UNBREAKABLE_HIT, self)
end

function BrickUnbreakable:points()
    return 0
end

function BrickUnbreakable:is_alive()
    return false
end

function BrickUnbreakable:in_play()
    return true
end

return BrickUnbreakable