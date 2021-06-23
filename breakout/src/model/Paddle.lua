--[[
    GD50
    Breakout Remake

    -- Paddle Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents a paddle that can move left and right. Used in the main
    program to deflect the ball toward the bricks; if the ball passes
    the paddle, the player loses one heart. The Paddle can have a skin,
    which the player gets to choose upon starting the game.
]]
local Constants = require 'src/constants'
local Collidable = require 'src/model/Collidable'
local PaddleSize = require 'src/model/PaddleSize'
local List = require 'lib/List'

local Paddle = Collidable()

--[[
    Our Paddle will initialize at the same spot every time, in the middle
    of the world horizontally, toward the bottom.
]]
function Paddle:initialize(skin)

    -- the variant is which of the four paddle sizes we currently are;
    self.size = 2

    self:upper():initialize(
            Constants.VIRTUAL_WIDTH / 2 - 32, -- x
            Constants.VIRTUAL_HEIGHT - 32,    -- y
            64,                               -- width
            16                                -- height
    )

    -- start us off with no velocity
    self.dx = 0

    -- the skin only has the effect of changing our color, used to offset us
    -- into the gPaddleSkins table later
    self.skin = skin
    
end

function Paddle:update(dt)
    -- keyboard input
    if love.keyboard.isDown('left') then
        self.dx = - Constants.PADDLE_SPEED
    elseif love.keyboard.isDown('right') then
        self.dx = Constants.PADDLE_SPEED
    else
        self.dx = 0
    end

    -- math.max here ensures that we're the greater of 0 or the player's
    -- current calculated Y position when pressing up so that we don't
    -- go into the negatives; the movement calculation is simply our
    -- previously-defined paddle speed scaled by dt
    if self.dx < 0 then
        self.x = math.max(0, self.x + self.dx * dt)
    -- similar to before, this time we use math.min to ensure we don't
    -- go any farther than the bottom of the screen minus the paddle's
    -- height (or else it will go partially below, since position is
    -- based on its top left corner)
    else
        self.x = math.min(Constants.VIRTUAL_WIDTH - self:getWidth(), self.x + self.dx * dt)
    end
end

function Paddle:change_size(score)
    --if (score:points() >= 50) then
        self.size = 1
        self.width = 32
    --end
end

function Paddle:getWidth()
    return self.width
end

function Paddle:resetSize()
    self.size = 2
    self.width = 64
end

return Paddle