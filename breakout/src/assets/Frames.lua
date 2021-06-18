--
-- Created by IntelliJ IDEA.
-- User: soldiazreal
-- Date: 16/06/2021
-- Time: 14:16
-- To change this template use File | Settings | File Templates.
--
local Object = require 'src/Object'
local Constants = require 'src/constants'

local Frames = Object()

--[[
    Given an "atlas" (a texture with multiple sprites), as well as a
    width and a height for the tiles therein, split the texture into
    all of the quads by simply dividing it evenly.
]]

local function GenerateQuads(atlas, tilewidth, tileheight)
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    local sheetCounter = 1
    local spritesheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spritesheet[sheetCounter] =
            love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth,
                tileheight, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return spritesheet
end

--[[
    This function is specifically made to piece out the bricks from the
    sprite sheet. Since the sprite sheet has non-uniform sprites within,
    we have to return a subset of GenerateQuads.
]]

local function GenerateQuadsBricks(atlas)
    return table.slice(GenerateQuads(atlas, 32, 16), 1, 21)
end

--[[
    This function is specifically made to piece out the paddles from the
    sprite sheet. For this, we have to piece out the paddles a little more
    manually, since they are all different sizes.
]]

local function GenerateQuadsPaddles(atlas)
    local x = 0
    local y = 64

    local counter = 1
    local quads = {}

    for i = 0, 3 do
        -- smallest
        quads[counter] = love.graphics.newQuad(x, y, 32, 16,
            atlas:getDimensions())
        counter = counter + 1
        -- medium
        quads[counter] = love.graphics.newQuad(x + 32, y, 64, 16,
            atlas:getDimensions())
        counter = counter + 1
        -- large
        quads[counter] = love.graphics.newQuad(x + 96, y, 96, 16,
            atlas:getDimensions())
        counter = counter + 1
        -- huge
        quads[counter] = love.graphics.newQuad(x, y + 16, 128, 16,
            atlas:getDimensions())
        counter = counter + 1

        -- prepare X and Y for the next set of paddles
        x = 0
        y = y + 32
    end

    return quads
end

--[[
    This function is specifically made to piece out the balls from the
    sprite sheet. For this, we have to piece out the balls a little more
    manually, since they are in an awkward part of the sheet and small.
]]

local function GenerateQuadsBalls(atlas)
    local x = 96
    local y = 48

    local counter = 1
    local quads = {}

    for i = 0, 3 do
        quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
        x = x + 8
        counter = counter + 1
    end

    x = 96
    y = 56

    for i = 0, 2 do
        quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
        x = x + 8
        counter = counter + 1
    end

    return quads
end
-- Quads we will generate for all of our textures; Quads allow us
-- to show only part of a texture and not the entire thing
local Frames = {
        ['arrows'] = GenerateQuads(Constants.gTextures['arrows'], 24, 24),
        ['paddles'] = GenerateQuadsPaddles(Constants.gTextures['main']),
        ['balls'] = GenerateQuadsBalls(Constants.gTextures['main']),
        ['bricks'] = GenerateQuadsBricks(Constants.gTextures['main']),
        ['hearts'] = GenerateQuads(Constants.gTextures['hearts'], 10, 9)
}

return Frames

