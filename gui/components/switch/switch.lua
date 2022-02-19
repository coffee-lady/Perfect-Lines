local View = require('gui.components.switch.view.view_switch')

local BOOTSTRAP_URL = 'bootstrap'
local ACTION_CLICK = hash('click')

--- @class Switch : Widget
local Switch = class('Switch')

Switch.__cparams = {'event_bus', 'scenes_service'}

Switch.SWITCH_TOGGLED = hash('switch_toggled')

function Switch:initialize(event_bus, scenes_service, params)
    --- @type EventBus
    self.event_bus = event_bus
    --- @type ScenesService
    self.scenes_service = scenes_service

    self.view = inject(View, params.ID, params.enabled)

    self.enabled = params.enabled
    self._on_switch = params.callback

    self:init()
end

function Switch:init()
    self:reset()
end

function Switch:reset()
    self.event_bus:on(ACTION_CLICK, self.switch, self)
    self:_check_toggle()
end

function Switch:switch(action)
    if not self.view:is_pressed(action) then
        return
    end

    self.enabled = not self.enabled
    self:_check_toggle()
    self._on_switch(self.enabled)

    self.scenes_service:post_to_go(
        BOOTSTRAP_URL,
        Switch.SWITCH_TOGGLED,
        {
            enabled = self.enabled
        }
    )
end

function Switch:_check_toggle()
    if self.enabled then
        self.view:toggle_on()
    else
        self.view:toggle_off()
    end
end

function Switch:get_container()
    return self.view:get_container()
end

return Switch
