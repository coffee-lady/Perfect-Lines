local GUI = require('gui.gui')
local Luject = require('src.libs.luject.luject')
local MessagesSceneWrapper = require('src.libs.scenes.common.MessagesSceneWrapper')

local MSG_AQUIRE_INPUT_FOCUS = hash('acquire_input_focus')

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

--- @class StandardScene
local StandardScene = class('Scene', MessagesSceneWrapper)

--- @param view SceneView
function StandardScene:initialize(event_bus, Controllers, Presenters, View, UIMaps, render_order)
    MessagesSceneWrapper.initialize(self, event_bus)

    self.Controllers, self.Presenters, self.View, self.UIMaps, self.render_order = Controllers, Presenters, View, UIMaps, render_order

    --- @type SceneController[]
    self.controllers = {}
    self.presenters = {}

    self.transition = {}
end

function StandardScene:set_screen_transition()
    self.transition = GUI.Transitions.ScreenTransition()
end

function StandardScene:set_popup_transition()
    self.transition = GUI.Transitions.PopupTransition()
end

function StandardScene:init()
    msg.post('.', MSG_AQUIRE_INPUT_FOCUS)

    if self.render_order then
        gui.set_render_order(self.render_order)
    end

    --- @type SceneView
    self.view = Luject:resolve_class(self.View, self.UIMaps)

    for key, Presenter in pairs(self.Presenters) do
        self.presenters[key] = Luject:resolve_class(Presenter, self.view)
    end

    for i = 1, #self.Controllers do
        self.controllers[i] = Luject:resolve_class(self.Controllers[i], self.presenters, self.view)
    end

    call_collection(self.controllers, 'init')
end

function StandardScene:update(dt)
    call_collection(self.controllers, 'update', dt)
end

function StandardScene:on_input(action_id, action)
    MessagesSceneWrapper.on_input(self, action_id, action)

    call_collection(self.controllers, 'on_input', action_id, action)
end

function StandardScene:on_message(message_id, message, sender)
    MessagesSceneWrapper.on_message(self, message_id, message, sender)

    call_safe(self.transition.on_message, self.transition, message_id, message, sender)
    call_collection(self.controllers, 'on_message', message_id, message, sender)
end

function StandardScene:final()
    MessagesSceneWrapper.final(self)

    call_collection(self.controllers, 'final')
    call_safe(self.transition.final, self.transition)
    call_safe(self.view.final, self.view)
end

return StandardScene
