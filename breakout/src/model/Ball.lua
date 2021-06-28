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
local Collidable = require 'src/model/Collidable'

local Ball = Collidable()

function Ball:initialize()
    self:upper():initialize(0, 0, 8, 8)

    -- these variables are for keeping track of our velocity on both the
    -- X and Y axis, since the ball can move in two dimensions
    self.dy = 0
    self.dx = 0
end

function Ball:collision_with_paddle(paddle)
    if self:collides(paddle) then
        -- raise ball above paddle in case it goes below it, then reverse dy
        local paddleWidth = paddle:getWidth()
        self.y = paddle.y - self.height
        if math.abs(self.dy) < 150 then
            self.dy = self.dy * 1.04
        end
        self.dy = -math.abs(self.dy)

        -- if we hit the paddle on its left side
        if self.x < paddle.x + (paddleWidth / 2) then
            if (self.dx < 0) then
                self.dx = (4 * math.abs(paddle.x + paddleWidth / 2 - self.x))
            elseif (self.dx > 0) then
                if (paddle.dx < 0) then
                    self.dx = -(2 * math.abs(paddle.x + paddleWidth / 2 - self.x))
                elseif (paddle.dx > 0) then
                    self.dx = (2 * math.abs(paddle.x + paddleWidth / 2 - self.x))
                end
            end

        -- else if we hit the paddle on its right side
        elseif self.x > paddle.x + (paddleWidth / 2) then
            if (self.dx > 0) then
                self.dx = -(4 * math.abs(paddle.x + paddleWidth / 2 - self.x))
            elseif (self.dx < 0) then
                if (paddle.dx < 0) then
                    self.dx = -(2 * math.abs(paddle.x + paddleWidth / 2 - self.x))
                elseif (paddle.dx > 0) then
                    self.dx = -(1 * math.abs(paddle.x + paddleWidth / 2 - self.x))
                end
            end
        end
        Constants.gSounds['paddle-hit']:play()
    end
end

function Ball:collision_with_brick(brick, world)
    -- only check collision if we're in play
    if brick:in_play() and self:collides(brick) then

        world.score:add(brick:points())

        brick:hit(world)

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

function Ball:collision_with_window(world)
    -- TODO: Ball revisar para evitar que cada bola saque una vida
    if self:out_of_bounds() then
        world.health:decrease()
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

function Ball:clone(anotherBall)
    self.dy = anotherBall.dy * 0.9
    self.dx = anotherBall.dx * 0-9
    self.y = anotherBall.y
    self.x = anotherBall.x
    self.width = anotherBall.width
    self.height = anotherBall.height
end

return Ball
