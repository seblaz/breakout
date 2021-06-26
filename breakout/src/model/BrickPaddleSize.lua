local SpecialBrick = require 'src/model/SpecialBrick'
local EventBus = require 'src/model/EventBus'
local Events = require 'src/model/Events'

local BrickPaddleSize = SpecialBrick()

function BrickPaddleSize:hit(world)
    --EventBus:notify(Events.BRICK_PADDLESIZE_HIT, self)

    world.paddle:change_size(world.score);

    if self:in_play() then
        self._level = self._level - 1
    end

    if not self:in_play() then
        EventBus:notify(Events.BRICK_PADDLESIZE_HIT, self)
    end
end

return BrickPaddleSize