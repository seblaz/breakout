local Collidable = require 'src/model/Collidable'
local Constants = require 'src/constants'

local EventBus = require 'src/model/EventBus'
local Events = require 'src/model/Events'

local FasterBal = Collidable()

function FasterBal:initialize(x, y)
    self:upper():initialize(
            x or Constants.VIRTUAL_WIDTH / 2 - 8, -- x
            y or 0,                               -- y
            16,                                   -- width
            16                                    -- height
    )

    self.dx = 0
    self.dy = 80

    self._active = true
end

function FasterBal:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function FasterBal:in_play()
    return self._active and self.y < Constants.VIRTUAL_HEIGHT
end

function FasterBal:collision_with_paddle(paddle, world)
    if self:in_play() and self:collides(paddle) then
        self:activate(world)
    end
end

function FasterBal:activate(world)
    EventBus:notify(Events.POWER_UP_ACTIVATED)
    self._active = false
    -- TODO: Ball borrar esta asignacion
    --world.ball.dx = world.ball.dx * 1.3
    --world.ball.dy = world.ball.dy * 1.3
    world.balls:foreach(function (ball)
        ball.dx = ball.dx * 1.3
        ball.dy = ball.dy * 1.3
    end)
end

return FasterBal