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

-- global patterns (used to make the entire map a certain shape)
--NONE = 1
--SINGLE_PYRAMID = 2
--MULTI_PYRAMID = 3

-- per-row patterns
--SOLID = 1           -- all colors the same in this row
--ALTERNATE = 2       -- alternate colors
--SKIP = 3            -- skip every other block
--NONE = 4            -- no blocks this row

local Brick = require 'src/model/Brick'

local LevelMaker = Class{}

--[[
    Creates a table of Bricks to be returned to the main game, with different
    possible ways of randomizing rows and columns of bricks. Calculates the
    brick colors and tiers to choose based on the level passed in.
]]
function LevelMaker:createMap(level)
    local bricks = {}

    local num_of_rows = self:_number_of_rows()
    local num_of_cols = self:_number_of_columns()
    local highest_brick_level = self:_highest_brick_level(level)

    -- lay out bricks such that they touch each other and fill the space
    for y = 1, num_of_rows do
        local row = self:_create_row(y, num_of_cols, highest_brick_level)
        table.concatenate(bricks, row)
    end

    -- in the event we didn't generate any bricks, try again
    if #bricks == 0 then
        return self:createMap(level)
    else
        return bricks
    end
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

function LevelMaker:_skipping_row()
    -- whether we want to enable skipping for this row
    return math.random(1, 2) == 1 and true or false
end

function LevelMaker:_alternating_row_level()
    -- whether we want to enable alternating levels for this row
    return math.random(1, 2) == 1 and true or false
end

function LevelMaker:_create_row(row_number, num_of_cols, highest_brick_level)
    local bricks = {}
    local skipPattern = self:_skipping_row()
    local alternatePattern = self:_alternating_row_level()

    -- choose two tiers to alternate between
    local alternateTier1 = math.random(1, highest_brick_level)
    local alternateTier2 = math.random(1, highest_brick_level)

    -- used only when we want to skip a block, for skip pattern
    local skipFlag = math.random(2) == 1 and true or false

    -- used only when we want to alternate a block, for alternate pattern
    local alternateFlag = math.random(2) == 1 and true or false

    for x = 1, num_of_cols do
        -- if skipping is turned on and we're on a skip iteration...
        if skipPattern and skipFlag then
            -- turn skipping off for the next iteration
            skipFlag = not skipFlag

            -- Lua doesn't have a continue statement, so this is the workaround
            goto continue
        else
            -- flip the flag to true on an iteration we don't use it
            skipFlag = not skipFlag
        end

        -- if we're alternating, figure out which color/tier we're on
        local brick_level
        if alternatePattern and alternateFlag then
            brick_level = alternateTier1
            alternateFlag = not alternateFlag
        else
            brick_level = alternateTier2
            alternateFlag = not alternateFlag
        end

        local b = Brick(
                -- x-coordinate
                (x-1)                   -- decrement x by 1 because tables are 1-indexed, coords are 0
                * 32                    -- multiply by 32, the brick width
                + 8                     -- the screen should have 8 pixels of padding; we can fit 13 cols + 16 pixels total
                + (13 - num_of_cols) * 16,  -- left-side padding for when there are fewer than 13 columns

                -- y-coordinate
                row_number * 16,                 -- just use y * 16, since we need top padding anyway

                -- brick level
                brick_level
        )

        table.insert(bricks, b)

        -- Lua's version of the 'continue' statement
        ::continue::
    end
    return bricks
end

return LevelMaker