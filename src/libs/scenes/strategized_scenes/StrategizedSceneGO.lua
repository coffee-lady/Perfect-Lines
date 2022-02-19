local Luject = require('src.libs.luject.luject')
local MessagesSceneWrapper = require('src.libs.scenes.common.MessagesSceneWrapper')

local MSG_AQUIRE_INPUT_FOCUS = hash('acquire_input_focus')

--- @class StrategizedSceneGO
local StrategizedSceneGO = class('StrategizedSceneGO', MessagesSceneWrapper)

StrategizedSceneGO.__cparams = {'event_bus_go', 'scenes_strategies_service'}

function StrategizedSceneGO:initialize(event_bus, scenes_strategies_service, scene_id)
    MessagesSceneWrapper.initialize(self, event_bus)

    --- @type ScenesStrategiesService
    self.scenes_strategies_service = scenes_strategies_service
    self.scene_id = scene_id

    self:register()
end

function StrategizedSceneGO:init()
    msg.post('.', MSG_AQUIRE_INPUT_FOCUS)

    self.strategy = self.scenes_strategies_service:get_strategy_instance_go(self.scene_id)
    self.strategy:init()
end

function StrategizedSceneGO:update(dt)
    self.strategy:update(dt)
end

function StrategizedSceneGO:on_input(action_id, action)
    MessagesSceneWrapper.on_input(self, action_id, action)

    self.strategy:on_input(action_id, action)
end

function StrategizedSceneGO:on_message(message_id, message, sender)
    MessagesSceneWrapper.on_message(self, message_id, message, sender)

    self.strategy:on_message(message_id, message, sender)
end

function StrategizedSceneGO:final()
    MessagesSceneWrapper.final(self)

    self.strategy:final()
end

return StrategizedSceneGO
