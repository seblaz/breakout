local Object = require 'src/Object'
local Set = require 'lib/Set'
local EventBus = require 'src/model/EventBus'
local Events = require 'src/model/Events'
local Constants = require 'src/constants'

local BrickCloud = Object()

-- some of the colors in our palette (to be used with particle systems)
local paletteColors = {
    -- blue
    [1] = {
        ['r'] = 0.38,
        ['g'] = 0.6,
        ['b'] = 1
    },
    -- green
    [2] = {
        ['r'] = 0.41,
        ['g'] = 0.75,
        ['b'] = 0.18
    },
    -- red
    [3] = {
        ['r'] = 0.85,
        ['g'] = 0.34,
        ['b'] = 0.38
    },
    -- purple
    [4] = {
        ['r'] = 0.84,
        ['g'] = 0.48,
        ['b'] = 0.72
    },
    -- gold
    [5] = {
        ['r'] = 0.98,
        ['g'] = 0.94,
        ['b'] = 0.21
    }
}

--- Represents a single brick cloud

function BrickCloud:initialize(brick)
    self.brick = brick

    -- particle system belonging to the brick, emitted on hit
    self.psystem = love.graphics.newParticleSystem(Constants.gTextures['particle'], 64)

    -- various behavior-determining functions for the particle system
    -- https://love2d.org/wiki/ParticleSystem

    -- lasts between 0.5-1 seconds seconds
    self.psystem:setParticleLifetime(0.5, 1)

    -- give it an acceleration of anywhere between X1,Y1 and X2,Y2 (0, 0) and (80, 80) here
    -- gives generally downward
    self.psystem:setLinearAcceleration(-15, 0, 15, 80)

    -- spread of particles; normal looks more natural than uniform
    self.psystem:setEmissionArea('normal', 10, 10)

    -- set the particle system to interpolate between two colors; in this case, we give
    -- it our self.color but with varying alpha; brighter for higher tiers, fading to 0
    -- over the particle's lifetime (the second color)
    self.psystem:setColors(
            paletteColors[math.floor(self.brick:level() / 5) + 1].r,
            paletteColors[math.floor(self.brick:level() / 5) + 1].g,
            paletteColors[math.floor(self.brick:level() / 5) + 1].b,
            55 * (math.floor(self.brick:level() / 5) + 1) / 255,
            paletteColors[math.floor(self.brick:level() / 5) + 1].r,
            paletteColors[math.floor(self.brick:level() / 5) + 1].g,
            paletteColors[math.floor(self.brick:level() / 5) + 1].b,
            0
    )
    self.psystem:emit(64)
end

function BrickCloud:update(dt)
    self.psystem:update(dt)
end

function BrickCloud:finished()
    return self.psystem:getCount() == 0
end

function BrickCloud:render()
    love.graphics.draw(self.psystem, self.brick.x + 16, self.brick.y + 8)
end

--- Represents all the brick clouds

local BrickClouds = Object()

function BrickClouds:initialize()
    self.clouds = Set()
    EventBus:subscribe(Events.BRICK_HIT, function(...)
        self:brick_hit(...)
    end)
end

function BrickClouds:brick_hit(brick)
    self.clouds:insert(BrickCloud(brick))
end

function BrickClouds:update(dt)
    self.clouds:foreach(function(cloud)
        cloud:update(dt)
    end)
    self:_remove_finished_clouds()
end

function BrickClouds:_remove_finished_clouds()
    self.clouds:
    select(function(cloud)
        return cloud:finished()
    end):
    foreach(function(cloud)
        self.clouds:remove(cloud)
    end)
end

function BrickClouds:render()
    self.clouds:foreach(function(cloud)
        cloud:render()
    end)
end

return BrickClouds