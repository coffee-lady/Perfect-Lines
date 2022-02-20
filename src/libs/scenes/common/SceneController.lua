local SubscriptionsMap = require('src.libs.event_bus.subscriptions_map')

--- @class SceneController
local SceneController = class('SceneController')

SceneController.__cparams = {}

function SceneController:initialize()
    self.events_callbacks = {}
end

function SceneController:set_components(components)
    self.components = components
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
    self.subs_map = inject(SubscriptionsMap, self, map)
end

function SceneController:add_event_subs(event, callback)
    event:add(callback, self)

    self.events_callbacks[#self.events_callbacks + 1] = {event = event, callback = callback}
end

function SceneController:final()
    if self.subs_map then
        self.subs_map:unsubscribe()
    end

    for i = 1, #self.events_callbacks do
        local data = self.events_callbacks[i]
        data.event:remove(data.callback, self)
    end

    if self.components then
        for _, component in pairs(self.components) do
            if component.final then
                component:final()
            end
        end
    end
end

return SceneController
