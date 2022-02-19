local Widget = require('gui.widget.widget')
local AbstractButton = require('gui.controls.abstract_button.abstract_button')

--- @class SliderIndicatorView : Widget
local SliderIndicatorView = class('SliderIndicatorView', Widget)

SliderIndicatorView.__cparams = {'event_bus', 'ui_service'}

function SliderIndicatorView:initialize(event_bus, ui_service, node)
    Widget.initialize(self, event_bus, ui_service)

    self.node = node

    self:create_link(
        {
            container = node
        },
        nil,
        AbstractButton.BUTTON_SLIDER
    )

    self:set_theme_map(
        {
            slider_indicator = {
                disable_submode = true,
                map = {
                    bg = node
                }
            }
        }
    )

    self.theme_object = self:get_theme_objects().slider_indicator
end

function SliderIndicatorView:select()
    self.selected = true
    self.theme_object:switch_to(self.theme_object.MODE.active)
end

function SliderIndicatorView:deselect()
    self.selected = false
    self.theme_object:switch_to_primary()
end

function SliderIndicatorView:refresh_colors()
    self:refresh_theme_map()
end

function SliderIndicatorView:is_picked(action)
    return self.node:is_picked(action)
end

function SliderIndicatorView:change_colors_to_modified()
    local MODE = self.theme_object.MODE

    if MODE.active_modified and MODE.primary_modified then
        if self.selected then
            self.theme_object:switch_to(MODE.active_modified)
        else
            self.theme_object:switch_to(MODE.primary_modified)
        end
    end
end

function SliderIndicatorView:change_colors_to_initial()
    local MODE = self.theme_object.MODE

    if self.selected then
        self.theme_object:switch_to(MODE.active)
    else
        self.theme_object:switch_to(MODE.primary)
    end
end

return SliderIndicatorView
