local Object = require 'src/Object'
local List = require 'lib/List'

local EventBus = Object()

function EventBus:initialize()
    self:reset()
end

function EventBus:reset()
    self._subscribers = {}
end

function EventBus:subscribe(event, observer)
    self:_event_subscribers(event):insert(observer)
end

function EventBus:_event_subscribers(event)
    if not self._subscribers[event] then
        self._subscribers[event] = List()
    end
    return self._subscribers[event]
end

function EventBus:notify(event, ...)
    local args = ...
    self:_event_subscribers(event)
        :foreach(function(subscriber) subscriber(args) end)
end

return EventBus()