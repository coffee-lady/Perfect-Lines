local MessagesSceneWrapper = require('src.libs.scenes.common.MessagesSceneWrapper')

local MSG_AQUIRE_INPUT_FOCUS = hash('acquire_input_focus')

--- @class StrategizedSceneGUI
local StrategizedSceneGUI = class('StrategizedSceneGUI', MessagesSceneWrapper)

StrategizedSceneGUI.__cparams = {'event_bus', 'scenes_strategies_service', 'scenes_service'}

function StrategizedSceneGUI:initialize(event_bus, scenes_strategies_service, scenes_service, scene_id, render_order)
    MessagesSceneWrapper.initialize(self, event_bus)

    --- @type ScenesStrategiesService
    self.scenes_strategies_service = scenes_strategies_service
    self.scenes_service = scenes_service
    self.render_order = render_order
    self.scene_id = scene_id

    self:register()
end

function StrategizedSceneGUI:on_scene_change(data)
    local current_scene = data.current_scene
    local new_strategy_class = self.scenes_strategies_service:get_strategy_gui(self.scene_id)

    if current_scene == hash(self.scene_id) and self.strategy_class ~= new_strategy_class then
        self.strategy:final()
        self:_set_strategy()
        self.strategy:init()
    end
end

function StrategizedSceneGUI:init()
    if self.render_order then
        gui.set_render_order(self.render_order)
    end

    msg.post('.', MSG_AQUIRE_INPUT_FOCUS)

    self:_set_strategy()
    self.strategy:init()

    self.scenes_service.event_scene_change:add(self.on_scene_change, self)
end

function StrategizedSceneGUI:_set_strategy()
    local strategy_class = self.scenes_strategies_service:get_strategy_gui(self.scene_id)

    self.strategy = self.scenes_strategies_service:get_strategy_instance_gui(self.scene_id)
    self.strategy_class = strategy_class
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
    self.scenes_service.event_scene_change:remove(self.on_scene_change, self)
end

return StrategizedSceneGUI
