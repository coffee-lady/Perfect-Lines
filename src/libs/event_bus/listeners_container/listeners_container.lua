local Tools = require('src.libs.tools.tools')

local class = Tools.middleclass
local Observable = Tools.event_observation.observable

local ListenersContainer = class('ListenersContainer')

function ListenersContainer:initialize()
    self.observer = Observable()
    self.subscribers = {}
end

function ListenersContainer:add(object_self, callback)
    local subs = self.observer:subscribe(object_self, callback)

    table.insert(self.subscribers, subs)

    return subs
end

function ListenersContainer:next(data)
    self.observer:next(data)
end

return ListenersContainer
