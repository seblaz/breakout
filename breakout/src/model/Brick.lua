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

local EventBus = require 'src/model/EventBus'
local Events = require 'src/model/Events'

Brick = Class{}


function Brick:init(x, y, level)
    -- level is the number of hits required to destroy the brick.
    self._level = level

    self.x = x
    self.y = y
    self.width = 32
    self.height = 16
end

--[[
    Triggers a hit on the brick, taking it out of play if at 0 health or
    changing its color otherwise.
]]
function Brick:hit()
    EventBus:notify(Events.BRICK_HIT, self)

    if self:level() ~= 0 then
        self._level = self._level - 1
    end

    -- play a second layer sound if the brick is destroyed
    if not self:in_play() then
        gSounds['brick-hit-1']:stop()
        gSounds['brick-hit-1']:play()
    end
end

function Brick:level()
    return self._level
end

function Brick:in_play()
    return self._level ~= 0
end
