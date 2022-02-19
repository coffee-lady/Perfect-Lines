local Tools = require('src.libs.tools.tools')
local class = Tools.middleclass

local ListenersContainer = require('src.libs.event_bus.listeners_container.listeners_container')

--- @class EventBus
local EventBus = class('EventBus')

function EventBus:initialize()
    self._subscriptions = {}
    self.disabled = {}
    self.exceptions = {}
end

function EventBus:enable(event_id)
    self.disabled[event_id] = false

    if not self.exceptions[event_id] then
        self.exceptions[event_id] = {}
    end

    for i = 1, #self.exceptions[event_id] do
        self.exceptions[event_id][i] = nil
    end
end

function EventBus:disable(event_id, exceptions)
    self.disabled[event_id] = true
    self.exceptions[event_id] = exceptions or {}
end

local function create_listeners_container(self, event_id)
    self._subscriptions[event_id] = ListenersContainer()

    return self._subscriptions[event_id]
end

function EventBus:emit(event_id, data)
    if not self._subscriptions[event_id] then
        create_listeners_container(self, event_id)
    end

    if self.disabled[event_id] then
        self._subscriptions[event_id].observer:next_with_exceptions(data, self.exceptions[event_id])
    else
        self._subscriptions[event_id].observer:next(data)
    end
end

function EventBus:on(event_id, callback, object_self)
    local listeners_container = self._subscriptions[event_id]

    if not listeners_container then
        listeners_container = create_listeners_container(self, event_id)
    end

    return listeners_container:add(object_self, callback)
end

function EventBus:clear()
    self._subscriptions = {}
end

return EventBus
