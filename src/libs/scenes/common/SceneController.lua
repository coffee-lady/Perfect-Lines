local Luject = require('src.libs.luject.luject')
local SubscriptionsMap = require('src.libs.event_bus.subscriptions_map')

--- @class SceneController
local SceneController = class('SceneController')

SceneController.__cparams = {'event_bus_gui'}

function SceneController:initialize(event_bus)
    self.event_bus = event_bus
end

function SceneController:init()
end

function SceneController:update(dt)
end

function SceneController:on_input(action_id, action)
end

function SceneController:on_message(message_id, message, sender)
end

function SceneController:set_subscriptions_map(map)
    self.subs_map = SubscriptionsMap(self, self.event_bus, map)
end

function SceneController:final()
    if self.subs_map then
        self.subs_map:unsubscribe()
    end
end

return SceneController
