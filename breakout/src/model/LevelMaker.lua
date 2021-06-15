--[[
    GD50
    Breakout Remake

    -- LevelMaker Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Creates randomized levels for our Breakout game. Returns a table of
    bricks that the game can render, based on the current level we're at
    in the game.
]]

local CircularList = require 'lib/CircularList'
local Object = require 'src/Object'

local Brick = require 'src/model/Brick'
local BrickUnbreakable = require 'src/model/BrickUnbreakable'

local LevelMaker = Object()

--[[
    Creates a table of Bricks to be returned to the main game, with different
    possible ways of randomizing rows and columns of bricks. Calculates the
    brick colors and tiers to choose based on the level passed in.
]]
function LevelMaker:create_map(level)
    local num_of_rows = self:_number_of_rows()
    local num_of_cols = self:_number_of_columns()
    local highest_brick_level = self:_highest_brick_level(level)

    local bricks
    repeat
        bricks = self:_create_map(num_of_rows, num_of_cols, highest_brick_level)
    until #bricks ~= 0
    return bricks
end

function LevelMaker:_number_of_rows()
    -- randomly choose the number of rows
    return math.random(1, 5)
end

function LevelMaker:_number_of_columns()
    -- randomly choose the number of columns, ensuring odd
    local n = math.random(7, 13)
    n = n % 2 == 0 and (n + 1) or n
    return n
end

function LevelMaker:_highest_brick_level(level)
    -- highest possible spawned brick level in this level; ensure we
    -- don't go above 21
    return math.min(21, math.ceil(level / 5))
end

function LevelMaker:_create_map(num_of_rows, num_of_cols, highest_brick_level)
    local bricks = {}
    for y = 1, num_of_rows do
        local row = self:_create_row(y, num_of_cols, highest_brick_level)
        table.concatenate(bricks, row)
    end
    return bricks
end

function LevelMaker:_create_row(row_number, num_of_cols, highest_brick_level)
    local bricks = {}

    local brick_levels = self:_brick_levels(highest_brick_level)
    local brick_skip = self:_brick_skip()
    local brick_types = self:_brick_types()

    for x = 1, num_of_cols do
        if not brick_skip:next() then
            table.insert(bricks, self:_create_brick(
                    x,
                    num_of_cols,
                    row_number,
                    brick_levels:next(),
                    brick_types:next()
            ))
        end
    end
    return bricks
end

function LevelMaker:_random_boolean(probability)
    probability = probability or 0.5
    return math.random(0, 1) < probability
end

function LevelMaker:_brick_levels(highest_brick_level)
    if self:_random_boolean() then
        return CircularList {
            math.random(1, highest_brick_level),
            math.random(1, highest_brick_level),
        }
    end
    return CircularList { math.random(1, highest_brick_level) }
end

function LevelMaker:_brick_types()
    if self:_random_boolean(0.2) then
        return CircularList {
            Brick,
            Brick,
            BrickUnbreakable,
            Brick,
            Brick,
        }
    end
    return CircularList { Brick }
end

function LevelMaker:_brick_skip()
    if self:_random_boolean() then
        local skip_block = self:_random_boolean()
        return CircularList {skip_block, not skip_block}
    end
    return CircularList {false}
end

function LevelMaker:_create_brick(x, num_of_cols, row_number, brick_level, type)
    return type(
            -- x-coordinate
            (x-1)                       -- decrement x by 1 because tables are 1-indexed, coords are 0
            * 32                        -- multiply by 32, the brick width
            + 8                         -- the screen should have 8 pixels of padding; we can fit 13 cols + 16 pixels total
            + (13 - num_of_cols) * 16,  -- left-side padding for when there are fewer than 13 columns
            -- y-coordinate
            row_number * 16,            -- just use y * 16, since we need top padding anyway
            -- brick level
            brick_level
    )

end

return LevelMaker