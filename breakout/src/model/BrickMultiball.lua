local SpecialBrick = require 'src/model/SpecialBrick'
local EventBus = require 'src/model/EventBus'
local Events = require 'src/model/Events'
local Ball = require 'src/model/Ball'
local BallView = require 'src/views/Ball'


local SecondBall = Ball()
local SecondBallView = BallView(SecondBall)
local BrickMultiball = SpecialBrick()

function BrickMultiball:hit(world)

    --world.ballManager:multiply();
    print("Se golpeo el ladrillo Multiball")
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
    -- TODO: Ball revisar iterar sobre la lista de bolas y generar una ball nueva para cada una de las bolas
    --SecondBall:clone(world.balls:get(0))
    world.balls:foreach(function (ball)
        SecondBall:clone(ball)
    end)
    world.balls:insert(SecondBall)
    world.views:insert(SecondBallView)
end

return BrickMultiball