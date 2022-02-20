local GUI = require('gui.gui')

--- @class SceneStrategy
local SceneStrategy = class('SceneStrategy')

function SceneStrategy:initialize(Controllers, Presenters, View, UIMaps)
    --- @type SceneController[]
    self.controllers = {}
    self.presenters = {}
    --- @type SceneView
    self.view = inject(View, UIMaps)

    for key, Presenter in pairs(Presenters) do
        self.presenters[key] = inject(Presenter, self.view)
    end

    for key, Ctrl in pairs(Controllers) do
        self.controllers[key] = inject(Ctrl, self.presenters, self.view)
    end

    self.transition = {}
end

function SceneStrategy:set_screen_transition(params)
    self.transition = GUI.Transitions.ScreenTransition(params)
end

function SceneStrategy:set_popup_transition(params)
    self.transition = GUI.Transitions.PopupTransition(params)
end

function SceneStrategy:init()
    self:call_collection(self.controllers, 'init')
end

function SceneStrategy:update(dt)
    self:call_collection(self.controllers, 'update', dt)
    self:call_safe(self.view.update, self.view, dt)
end

function SceneStrategy:on_input(action_id, action)
    self:call_collection(self.controllers, 'on_input', action_id, action)
    self:call_safe(self.view.on_input, self.view, action_id, action)
end

function SceneStrategy:on_message(message_id, message, sender)
    self:call_safe(self.transition.on_message, self.transition, message_id, message, sender)
    self:call_collection(self.controllers, 'on_message', message_id, message, sender)
end

function SceneStrategy:final()
    self:call_collection(self.controllers, 'final')
    self:call_safe(self.transition.final, self.transition)
    self:call_safe(self.view.final, self.view)
end

function SceneStrategy:call_safe(func, ...)
    if func then
        func(...)
    end
end

function SceneStrategy:call_collection(arr, func, ...)
    for _, item in pairs(arr) do
        self:call_safe(item[func], item, ...)
    end
end

return SceneStrategy
