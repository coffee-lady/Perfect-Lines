local Luject = require('src.libs.luject.luject')
local SubscriptionsMap = require('src.libs.event_bus.subscriptions_map')
local ScriptWrapper = require('src.libs.script_wrapper.ScriptWrapper')

--- @class MessagesSceneWrapper
local MessagesSceneWrapper = class('MessagesSceneWrapper', ScriptWrapper)

MessagesSceneWrapper.__cparams = {'event_bus'}

function MessagesSceneWrapper:initialize(event_bus)
    self.event_bus = event_bus

    self:register()
end

function MessagesSceneWrapper:on_input(action_id, action)
    if not action_id then
        return
    end

    self.event_bus:emit(action_id, action)
end

function MessagesSceneWrapper:on_message(message_id, message, sender)
    self.event_bus:emit(message_id, message)
end

function MessagesSceneWrapper:set_subscriptions_map(map)
    self.subs_map = SubscriptionsMap(self, self.event_bus, map)
end

function MessagesSceneWrapper:final()
    if self.subs_map then
        self.subs_map:unsubscribe()
    end
end

return MessagesSceneWrapper
