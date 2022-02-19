local Core = require('gui.core.core')
local Widget = require('gui.widget.widget')

local BoxNode = Core.BoxNode
local TextNode = Core.TextNode

--- @class CheckboxView : Widget
local CheckboxView = class('CheckboxView', Widget)

CheckboxView.__cparams = {'event_bus', 'localization_service', 'ui_service'}

function CheckboxView:initialize(event_bus, localization_service, ui_service, ids, gap)
    Widget.initialize(self, event_bus, ui_service, true)

    self.localization_service = localization_service
    self.ui_service = ui_service

    self.nodes = {
        container = BoxNode(ids.container),
        text = TextNode(ids.text),
        checkmark = BoxNode(ids.checkmark),
        checkmark_stroke = BoxNode(ids.checkmark_stroke)
    }

    self:set_theme_map(
        {
            checkbox = {
                is_static = true,
                map = {
                    text = self.nodes.text,
                    icon = self.nodes.checkmark,
                    stroke = self.nodes.checkmark_stroke
                }
            }
        }
    )

    self.gap = gap
    self:align_nodes_horizontally({self.nodes.checkmark_stroke, self.nodes.text}, self.gap)
end

function CheckboxView:is_pressed(action)
    return self.nodes.checkmark_stroke:is_pressed(action)
end

function CheckboxView:check()
    self.nodes.checkmark:set_enabled(true)
end

function CheckboxView:uncheck()
    self.nodes.checkmark:set_enabled(false)
end

function CheckboxView:localize(key, vars)
    local text = self.localization_service:get(key, vars)
    self:set_text(text)
end

function CheckboxView:set_text(text)
    self.nodes.text:set_text(text)
    self:align_nodes_horizontally({self.nodes.checkmark_stroke, self.nodes.text}, self.gap)
end

function CheckboxView:get_container()
    return self.nodes.container
end

return CheckboxView
