local Luject = require('src.libs.luject.luject')
local MessagesSceneWrapper = require('src.libs.scenes.common.MessagesSceneWrapper')

local MSG_AQUIRE_INPUT_FOCUS = hash('acquire_input_focus')

--- @class StrategizedSceneGUI
local StrategizedSceneGUI = class('StrategizedSceneGUI', MessagesSceneWrapper)

StrategizedSceneGUI.__cparams = {'event_bus_gui', 'scenes_strategies_service'}

function StrategizedSceneGUI:initialize(event_bus, scenes_strategies_service, scene_id, render_order)
    MessagesSceneWrapper.initialize(self, event_bus)

    --- @type ScenesStrategiesService
    self.scenes_strategies_service = scenes_strategies_service
    self.render_order = render_order
    self.scene_id = scene_id

    self:register()
end

function StrategizedSceneGUI:init()
    if self.render_order then
        gui.set_render_order(self.render_order)
    end

    msg.post('.', MSG_AQUIRE_INPUT_FOCUS)

    self.strategy = self.scenes_strategies_service:get_strategy_instance_gui(self.scene_id)
    self.strategy:init()
end

function StrategizedSceneGUI:update(dt)
    self.strategy:update(dt)
end

function StrategizedSceneGUI:on_input(action_id, action)
    MessagesSceneWrapper.on_input(self, action_id, action)

    self.strategy:on_input(action_id, action)
end

function StrategizedSceneGUI:on_message(message_id, message, sender)
    MessagesSceneWrapper.on_message(self, message_id, message, sender)

    self.strategy:on_message(message_id, message, sender)
end

function StrategizedSceneGUI:final()
    MessagesSceneWrapper.final(self)

    self.strategy:final()
end

return StrategizedSceneGUI
