local Tools = require('src.libs.tools.tools')
local class = Tools.middleclass

--- @class SubscriptionsMap
local SubscriptionsMap = class('SubscriptionsMap')

function SubscriptionsMap:initialize(object_self, event_bus, map)
    self.event_bus = event_bus
    self.object_self = object_self
    self.subscriptions = {}

    map = map or {}

    for msg, callback in pairs(map) do
        self.subscriptions[#self.subscriptions + 1] = event_bus:on(msg, callback, object_self)
    end
end

function SubscriptionsMap:add(msg, callback)
    self.subscriptions[#self.subscriptions + 1] = self.event_bus:on(msg, callback, self.object_self)
end

function SubscriptionsMap:unsubscribe()
    for i = 1, #self.subscriptions do
        self.subscriptions[i]:unsubscribe()
    end
end

return SubscriptionsMap
