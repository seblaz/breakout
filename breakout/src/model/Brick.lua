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

local BrickView = require 'src/views/Brick'
local BrickCloud = require 'src/views/BrickCloud'

Brick = Class{}


function Brick:init(x, y, level)
    -- level is the number of hits required to destroy the brick.
    self._level = level

    self.x = x
    self.y = y
    self.width = 32
    self.height = 16

    self.view1 = BrickView(self)
    self.view2 = BrickCloud(self)
end

--[[
    Triggers a hit on the brick, taking it out of play if at 0 health or
    changing its color otherwise.
]]
function Brick:hit()
    -- notify the view2 of the hit. This should disappear once the events
    -- are implemented.
    self.view2:hit()

    -- sound on hit
    gSounds['brick-hit-2']:stop()
    gSounds['brick-hit-2']:play()

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

function Brick:update(dt)
    self.view2:update(dt)
end

function Brick:render()
    self.view1:render()
end

--[[
    Need a separate render function for our particles so it can be called after all bricks are drawn;
    otherwise, some bricks would render over other bricks' particle systems.
]]
function Brick:renderParticles()
    self.view2:render()
end