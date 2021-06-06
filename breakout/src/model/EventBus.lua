local Object = require 'src/Object'

local EventBus = Object()

function EventBus:initialize()
    self:reset()
end

function EventBus:reset()
    self._subscribers = {}
end

function EventBus:subscribe(event, observer)
    table.insert(self:_event_subscribers(event), observer)
end

function EventBus:_event_subscribers(event)
    if not self._subscribers[event] then
        self._subscribers[event] = {}
    end
    return self._subscribers[event]
end

function EventBus:notify(event, ...)
    local args = ...
    local subscribers = self:_event_subscribers(event)
    table.apply(subscribers, function(subscriber) subscriber(args) end)
end

return EventBus()