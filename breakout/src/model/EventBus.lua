local Object = require 'src/Object'

local EventBus = Object()

function EventBus:initialize()
    self.subscribers = {}
end

function EventBus:subscribe(event, observer)
    table.insert(self:_event_subscribers(event), observer)
end

function EventBus:_event_subscribers(event)
    if not self.subscribers[event] then
        self.subscribers[event] = {}
    end
    return self.subscribers[event]
end

function EventBus:notify(event, ...)
    local args = ...
    local subscribers = self:_event_subscribers(event)
    table.apply(subscribers, function(subscriber) subscriber(args) end)
end

return EventBus()