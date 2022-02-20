local App = require('src.app')
local Animations = require('animations.animations')

local ACTION = App.constants.actions

local AnimationsController = class('AnimationsController')

AnimationsController.__cparams = {'event_bus'}

function AnimationsController:initialize(event_bus)
    --- @type EventBus
    self.event_bus = event_bus
end

function AnimationsController:set_components(components)
    self.components = components
end

function AnimationsController:animate_start()
    self:_disable_actions()

    local seq = Animations.Sequence()

    seq:add_callback(function()
        self:_enable_actions()
    end)

    return seq
end

function AnimationsController:animate_victory()
    self:_disable_actions()

    local seq = Animations.Sequence()

    seq:add_callback(function()
        self:_enable_actions()
    end)

    return seq
end

function AnimationsController:_enable_actions()
    self.event_bus:enable(ACTION.click)
end

function AnimationsController:_disable_actions()
    self.event_bus:disable(ACTION.click)
end

return AnimationsController
