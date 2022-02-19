local Core = require('gui.core.core')
local Widget = require('gui.widget.widget')

local BoxNode = Core.BoxNode
local TextNode = Core.TextNode

--- @class RadioButtonView : Widget
local RadioButtonView = class('RadioButtonView', Widget)

RadioButtonView.__cparams = {'event_bus', 'localization_service', 'ui_service'}

function RadioButtonView:initialize(event_bus, localization_service, ui_service, id, gui_nodes, params)
    Widget.initialize(self, event_bus, ui_service)

    self.localization_service = localization_service
    self.ui_service = ui_service

    local ids = params.ID

    self.id = id
    self.params = params
    self.nodes = {
        container = BoxNode(gui_nodes[ids.container]),
        mark_container = BoxNode(gui_nodes[ids.mark_container]),
        mark = BoxNode(gui_nodes[ids.mark]),
        title = TextNode(gui_nodes[ids.title])
    }

    self.theme_object =
        self:set_theme_map(
        {
            radio_button = {
                primary_mode = 'enabled',
                disable_submode = true,
                map = {
                    container = self.nodes.mark_container,
                    icon = self.nodes.mark,
                    title = self.nodes.title
                }
            }
        }
    ):get_map().radio_button

    self:init()
end

function RadioButtonView:init()
    local title_node_text = self.localization_service:get(self.params.localization_key)[self.id]
    self.nodes.title:set_text(title_node_text)

    if self.params.enabled ~= self.id then
        self:deselect()
    end
end

function RadioButtonView:is_pressed(action)
    return self.nodes.container:is_pressed(action)
end

function RadioButtonView:select()
    self.theme_object:switch_to(self.theme_object.MODE.enabled)
    self.nodes.mark:set_enabled(true)
end

function RadioButtonView:deselect()
    self.theme_object:switch_to(self.theme_object.MODE.disabled)
    self.nodes.mark:set_enabled(false)
end

function RadioButtonView:get_container()
    return self.nodes.container
end

return RadioButtonView
