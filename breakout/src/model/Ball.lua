--[[
    GD50
    Breakout Remake

    -- Ball Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents a ball which will bounce back and forth between the sides
    of the world space, the player's paddle, and the bricks laid out above
    the paddle. The ball can have a skin, which is chosen at random, just
    for visual variety.
]]
local Constants = require 'src/constants'

local Ball = Class{}

function Ball:init()
    -- simple positional and dimensional variables
    self.width = 8
    self.height = 8

    -- these variables are for keeping track of our velocity on both the
    -- X and Y axis, since the ball can move in two dimensions
    self.dy = 0
    self.dx = 0

end

--[[
    Expects an argument with a bounding box, be that a paddle or a brick,
    and returns true if the bounding boxes of this and the argument overlap.
]]
function Ball:collides(target)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
end

function Ball:collision_with_paddle(paddle)
    if self:collides(paddle) then
        -- raise ball above paddle in case it goes below it, then reverse dy
        self.y = paddle.y - 8
        self.dy = -self.dy

        --
        -- tweak angle of bounce based on where it hits the paddle
        --

        -- if we hit the paddle on its left side while moving left...
        if self.x < paddle.x + (paddle.width / 2) and paddle.dx < 0 then
            self.dx = -50 + -(8 * (paddle.x + paddle.width / 2 - self.x))

            -- else if we hit the paddle on its right side while moving right...
        elseif self.x > paddle.x + (paddle.width / 2) and paddle.dx > 0 then
            self.dx = 50 + (8 * math.abs(paddle.x + paddle.width / 2 - self.x))
        end

        Constants.gSounds['paddle-hit']:play()
    end
end

function Ball:collision_with_brick(brick, score)
    -- only check collision if we're in play
    if brick:in_play() and self:collides(brick) then

        score:add(brick:points())

        brick:hit()

        -- if we have enough points, recover a point of health
        -- this had a bug because it always added one more health above xxx points
        --if self.score:points() > self.recoverPoints then
        --    -- can't go above 3 health
        --    self.health = math.min(3, self.health + 1)
        --
        --    -- multiply recover points by 2
        --    self.recoverPoints = math.min(100000, self.recoverPoints * 2)
        --
        --    -- play recover sound effect
        --    Constants.gSounds['recover']:play()
        --end

        --
        -- collision code for bricks
        --
        -- we check to see if the opposite side of our velocity is outside of the brick;
        -- if it is, we trigger a collision on that side. else we're within the X + width of
        -- the brick and should check to see if the top or bottom edge is outside of the brick,
        -- colliding on the top or bottom accordingly
        --

        -- left edge; only check if we're moving right, and offset the check by a couple of pixels
        -- so that flush corner hits register as Y flips, not X flips
        if self.x + 2 < brick.x and self.dx > 0 then

            -- flip x velocity and reset position outside of brick
            self.dx = -self.dx
            self.x = brick.x - 8

            -- right edge; only check if we're moving left, , and offset the check by a couple of pixels
            -- so that flush corner hits register as Y flips, not X flips
        elseif self.x + 6 > brick.x + brick.width and self.dx < 0 then

            -- flip x velocity and reset position outside of brick
            self.dx = -self.dx
            self.x = brick.x + 32

            -- top edge if no X collisions, always check
        elseif self.y < brick.y then

            -- flip y velocity and reset position outside of brick
            self.dy = -self.dy
            self.y = brick.y - 8

            -- bottom edge if no X collisions or top collision, last possibility
        else

            -- flip y velocity and reset position outside of brick
            self.dy = -self.dy
            self.y = brick.y + 16
        end

        -- slightly scale the y velocity to speed up the game, capping at +- 150
        if math.abs(self.dy) < 150 then
            self.dy = self.dy * 1.02
        end
    end
end

function Ball:collision_with_window(health)
    if self:out_of_bounds() then
        health:decrease()
    end
end

function Ball:out_of_bounds()
    return self.y >= Constants.VIRTUAL_HEIGHT
end

--[[
    Places the ball in the middle of the screen, with no movement.
]]
function Ball:reset()
    self.x = Constants.VIRTUAL_WIDTH / 2 - 2
    self.y = Constants.VIRTUAL_HEIGHT / 2 - 2
    self.dx = 0
    self.dy = 0
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    -- allow ball to bounce off walls
    if self.x <= 0 then
        self.x = 0
        self.dx = -self.dx
        Constants.gSounds['wall-hit']:play()
    end

    if self.x >= Constants.VIRTUAL_WIDTH - 8 then
        self.x = Constants.VIRTUAL_WIDTH - 8
        self.dx = -self.dx
        Constants.gSounds['wall-hit']:play()
    end

    if self.y <= 0 then
        self.y = 0
        self.dy = -self.dy
        Constants.gSounds['wall-hit']:play()
    end
end

return Ball
