local GUICore = require('gui.core.core')
local UIConfig = require('gui.transitions.config.screen_transition_config')
local Transition = require('gui.transitions.Transition.Transition')

local BoxNode = GUICore.BoxNode

local ROOT = 'root'

local ScreenTransition = class('ScreenTransition')

function ScreenTransition:initialize(params)
    self.root = BoxNode(ROOT)

    params = params or {}

    self:enable(params)
end

function ScreenTransition:enable(params)
    self.transition = Transition(self.root)

    for key, config in pairs(UIConfig) do
        if not params['disable_' .. key] then
            self.transition[key](self.transition, config)
        end
    end
end

function ScreenTransition:on_message(message_id, message, sender)
    self.transition:on_message(message_id, message, sender)
end

function ScreenTransition:skip(screen_id)
    self.transition:skip(screen_id)
end

function ScreenTransition:final()
    self.transition:final()
end

return ScreenTransition
