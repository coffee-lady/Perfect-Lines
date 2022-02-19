local GUI = require('gui.gui')
local Luject = require('src.libs.luject.luject')

local function call_safe(func, ...)
    if func then
        func(...)
    end
end

local function call_collection(arr, func, ...)
    for i = 1, #arr do
        call_safe(arr[i][func], arr[i], ...)
    end
end

--- @class SceneStrategy
local SceneStrategy = class('SceneStrategy')

--- @param view SceneView
function SceneStrategy:initialize(Controllers, Presenters, View, UIMaps)
    --- @type SceneController[]
    self.controllers = {}
    self.presenters = {}
    --- @type SceneView
    self.view = Luject:resolve_class(View, UIMaps)

    for key, Presenter in pairs(Presenters) do
        self.presenters[key] = Luject:resolve_class(Presenter, self.view)
    end

    for i = 1, #Controllers do
        self.controllers[i] = Luject:resolve_class(Controllers[i], self.presenters, self.view)
    end

    self.transition = {}
end

function SceneStrategy:set_screen_transition()
    self.transition = GUI.Transitions.ScreenTransition()
end

function SceneStrategy:set_popup_transition()
    self.transition = GUI.Transitions.PopupTransition()
end

function SceneStrategy:init()
    call_collection(self.controllers, 'init')
end

function SceneStrategy:update(dt)
    call_collection(self.controllers, 'update', dt)
end

function SceneStrategy:on_input(action_id, action)
    call_collection(self.controllers, 'on_input', action_id, action)
end

function SceneStrategy:on_message(message_id, message, sender)
    call_safe(self.transition.on_message, self.transition, message_id, message, sender)
    call_collection(self.controllers, 'on_message', message_id, message, sender)
end

function SceneStrategy:final()
    call_collection(self.controllers, 'final')
    call_safe(self.transition.final, self.transition)
    call_safe(self.view.final, self.view)
end

return SceneStrategy
