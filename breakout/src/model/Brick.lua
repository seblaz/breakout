--[[
    GD50
    Breakout Remake

    -- Brick Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents a brick in the world space that the ball can collide with;
    differently colored bricks have different point values. On collision,
    the ball will bounce away depending on the angle of collision. When all
    bricks are cleared in the current map, the player should be taken to a new
    layout of bricks.
]]

local Object = require 'src/Object'
local EventBus = require 'src/model/EventBus'
local Events = require 'src/model/Events'

local Brick = Object()


function Brick:initialize(x, y, level)
    -- level is the number of hits required to destroy the brick.
    self._level = level

    self.x = x
    self.y = y
    self.width = 32
    self.height = 16
end

function Brick:hit()
    EventBus:notify(Events.BRICK_HIT, self)

    if self:in_play() then
        self._level = self._level - 1
    end

    if not self:in_play() then
        EventBus:notify(Events.BRICK_DESTROYED, self)
    end
end

function Brick:level()
    return self._level
end

function Brick:points()
    return self:level() * 25
end

function Brick:in_play()
    return self._level ~= 0
end

function Brick:is_alive()
    return self:in_play()
end

return Brick