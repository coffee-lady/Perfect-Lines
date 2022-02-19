local View = require('gui.components.checkbox.view.view_checkbox')

local ACTION_CLICK = hash('click')

--- @class Checkbox : Widget
local Checkbox = class('Checkbox')

Checkbox.__cparams = {'event_bus'}

function Checkbox:initialize(event_bus, params)
    --- @type EventBus
    self.event_bus = event_bus

    self.view = inject(View, params.ID, params.gap)

    self.is_checked = params.is_checked

    self:init()
    self:localize(params.localization_key)
end

function Checkbox:init()
    self:reset()
end

function Checkbox:reset()
    self.event_bus:on(ACTION_CLICK, self.switch, self)
    self:check_selection()
end

function Checkbox:switch(action)
    if not self.view:is_pressed(action) then
        return
    end

    self.is_checked = not self.is_checked
    self:check_selection()
    self._on_switch(self.is_checked)
end

function Checkbox:check_selection()
    if self.is_checked then
        self.view:check()
    else
        self.view:uncheck()
    end
end

function Checkbox:localize(key, vars)
    if not key then
        return
    end

    self.view:localize(key, vars)
end

function Checkbox:set_text(text)
    self.view:set_text(text or '')
end

function Checkbox:on_switch(callback)
    self._on_switch = callback
end

function Checkbox:get_container()
    return self.view:get_container()
end

return Checkbox
