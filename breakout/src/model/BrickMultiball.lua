local SpecialBrick = require 'src/model/SpecialBrick'
local EventBus = require 'src/model/EventBus'
local Events = require 'src/model/Events'
local Ball = require 'src/model/Ball'
local BallView = require 'src/views/Ball'
local List = require 'lib/List'

local BrickMultiball = SpecialBrick()

function BrickMultiball:hit(world)

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

    local status, err = pcall(BallMultiplication, world)

    if status == true then
        print("No hubo ningun error")
    else
        print("Hubo un error")
        print(err)
    end

end


--[[ world: { Lista de balls, lista de views } ]]

function BallMultiplication(world)
    if world.balls:count() < 2 then

        local existentBall = world.balls:get(1)
        local newBall = Ball()
        newBall:clone(existentBall)

        world.balls:insert(newBall)
        world.views:insert(BallView(newBall))
    end
end


return BrickMultiball