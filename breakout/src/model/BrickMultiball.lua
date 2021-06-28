local SpecialBrick = require 'src/model/SpecialBrick'
local EventBus = require 'src/model/EventBus'
local Events = require 'src/model/Events'
local Ball = require 'src/model/Ball'
local BallView = require 'src/views/Ball'
local List = require 'lib/List'

local BrickMultiball = SpecialBrick()

function BrickMultiball:hit(world)

    --TODO: Ball revisar si implementar ball manager
    --world.ballManager:multiply();
    self:activate(world)

    if self:in_play() then
        self._level = self._level -1
    end

    if not self:in_play() then
        EventBus:notify(Events.BRICK_MULTIBALL_HIT, self)
    end
    
end

function BrickMultiball:activate(world)

    -- TODO: Ball revisar cambiar si clonar el primer elemento de la lista
    if world.balls:count() < 4 then
        local NewBalls = List()
        local NewBallViews = List()

        world.balls:foreach(function (ball)
            local ClonedBall = Ball()
            ClonedBall:clone(ball)
            NewBalls:insert(ClonedBall)
            NewBallViews:insert(BallView(ClonedBall))
        end)

        world.balls:add(NewBalls)
        world.views:add(NewBallViews)
    end
    
end

return BrickMultiball