local Core = require('gui.core.core')
local Widget = require('gui.widget.widget')

local BoxNode = Core.BoxNode

local TOGGLE_DURATION = 0.25

--- @class SwitchView : Widget
local SwitchView = class('SwitchView', Widget)

SwitchView.__cparams = {'event_bus', 'localization_service', 'ui_service'}

function SwitchView:initialize(event_bus, localization_service, ui_service, ids, enabled)
    Widget.initialize(self, event_bus, ui_service)

    self.localization_service = localization_service
    self.ui_service = ui_service

    self.nodes = {
        container = BoxNode(ids.container),
        icon = BoxNode(ids.icon)
    }

    self:set_theme_map(
        {
            switch = {
                primary_mode = 'enabled',
                disable_submode = true,
                map = {
                    container = self.nodes.container,
                    icon = self.nodes.icon
                }
            }
        }
    )

    self.theme_object = self:get_theme_objects().switch

    self.toggled_on_pos = self.nodes.icon:get_pos()
    self.toggled_off_pos = self.nodes.icon:get_pos()
    self.toggled_off_pos.x = -self.toggled_off_pos.x

    self:init(enabled)
end

function SwitchView:init(enabled)
    if not enabled then
        self.nodes.icon:set_pos(self.toggled_off_pos)
        self.theme_object:switch_to(self.theme_object.MODE.disabled)
    end
end

function SwitchView:is_pressed(action)
    return self.nodes.container:is_pressed(action)
end

function SwitchView:toggle_on()
    self.nodes.icon:animate_move_to(self.toggled_on_pos, TOGGLE_DURATION):run()
    self.theme_object:switch_to(self.theme_object.MODE.enabled)
end

function SwitchView:toggle_off()
    self.nodes.icon:animate_move_to(self.toggled_off_pos, TOGGLE_DURATION):run()
    self.theme_object:switch_to(self.theme_object.MODE.disabled)
end

function SwitchView:get_container()
    return self.nodes.container
end

return SwitchView
