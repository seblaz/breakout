local SpecialBrick = require 'src/model/SpecialBrick'
local EventBus = require 'src/model/EventBus'
local Events = require 'src/model/Events'

local BrickMultiball = SpecialBrick()

function BrickMultiball:hit(world)

    --world.ballManager:multiply();
    print("Se golpeo el ladrillo Multiball")

    if self:in_play() then
        self._level = self._level -1
    end

    if not self:in_play() then
        EventBus:notify(Events.BRICK_MULTIBALL_HIT, self)
    end
    
end

return BrickMultiball