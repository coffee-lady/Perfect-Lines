local Controls = require('gui.controls.controls')
local Core = require('gui.core.core')
local Transitions = require('gui.transitions.transitions')
local LocalizationMap = require('gui.localization.localization_map')

--- @class Widget
local Widget = class('Widget')

Widget.__cparams = {'event_bus', 'ui_service'}

Widget.TRANSITION_SIMPLE = Transitions.WidgetTransition
Widget.TRANSITION_COMPLEX = Transitions.ComplexWidgetTransition

function Widget:initialize(event_bus, ui_service, is_common)
    --- @type EventBus
    self.event_bus = event_bus
    self.ui_service = ui_service

    self.is_common = is_common
    self.transitions = {}
    self.nodes = {}
    self.buttons = {}
    self.links = {}
    self.factories = {}
end

function Widget:set_nodes(map)
    self.nodes = map
end

function Widget:add_node(key, node)
    self.nodes[key] = node
end

function Widget:get_nodes()
    return self.nodes
end

function Widget:set_theme_map(scheme, extra_theme_key)
    local settings = {
        is_common = self.is_common,
        extra_key = extra_theme_key
    }

    self.theme_map = inject(Core.ThemeMap, settings, scheme)
    return self.theme_map
end

function Widget:refresh_theme_map()
    self.theme_map:refresh()
end

function Widget:add_to_theme_map(theme_object_key, item)
    self.theme_map:add(theme_object_key, item)
end

function Widget:add_to_theme_map_list(list_key, theme_object_map, params)
    self.theme_map:add_to_list(list_key, theme_object_map, params)
end

function Widget:add_list_to_theme_map(list_key, list_data)
    self.theme_map:add_list(list_key, list_data)
end

function Widget:get_theme_objects()
    return self.theme_map:get_map()
end

function Widget:create_button(ids, callback, type_id)
    local btn = inject(Controls.SubscribedButton, ids, callback)

    if type_id then
        btn:set_button_type_id(type_id)
    end

    return btn
end

function Widget:create_link(ids, callback, type_id)
    local btn = inject(Controls.SubscribedLink, ids, callback)

    if type_id then
        btn:set_button_type_id(type_id)
    end

    return btn
end

function Widget:set_buttons_menu(map)
    self.buttons = inject(Controls.ButtonsMenu, map)
    return self.buttons
end

function Widget:set_flow_buttons_menu(map)
    self.buttons = inject(Controls.FlowButtonsMenu, map)
    return self.buttons
end

function Widget:flow_buttons_on_click(action)
    self.buttons:on_click(action)
    return self.buttons
end

function Widget:set_links_menu(map)
    self.links = inject(Controls.LinksMenu, map)
    return self.links
end

function Widget:add_to_buttons_menu(ids, callback)
    self.buttons:add(ids, callback)
end

function Widget:set_button_type_id(ids, type_id)
    self.buttons:set_button_type_id(ids, type_id)
end

function Widget:set_button_link_id(ids, type_id)
    self.links:set_button_type_id(ids, type_id)
end

function Widget:add_to_links_menu(ids, callback)
    self.links:add(ids, callback)
end

function Widget:set_localization(key, map)
    self.localization_map = inject(LocalizationMap, key, map)
end

function Widget:add_to_localization(data)
    self.localization_map:add(data)
end

function Widget:create_nodes_grid_layout(nodes, dimensions, gaps)
    return Core.layouts.GridLayout(nodes, dimensions, gaps)
end

function Widget:align_nodes_to_grid(nodes, dimensions, gaps)
    Core.layouts.GridLayout(nodes, dimensions, gaps):apply()
end

function Widget:align_nodes_to_grid_and_adjust_container(nodes, dimensions, gaps, container, paddings)
    Core.layouts.GridLayout(nodes, dimensions, gaps):apply():adjust_container(container, paddings)
end

function Widget:create_nodes_fixed_grid_layout(nodes, container, gaps)
    return Core.layouts.FixedGridLayout(nodes, container, gaps)
end

function Widget:align_nodes_to_fixed_grid(nodes, container, gaps)
    Core.layouts.FixedGridLayout(nodes, container, gaps):apply()
end

function Widget:create_nodes_vertical_layout(nodes, gaps)
    return Core.layouts.VerticalLayout(nodes, gaps)
end

function Widget:align_nodes_vertically(nodes, gaps)
    Core.layouts.VerticalLayout(nodes, gaps):apply()
end

function Widget:align_nodes_vertically_and_adjust_container(nodes, gaps, container)
    Core.layouts.VerticalLayout(nodes, gaps):apply():adjust_container(container)
end

function Widget:create_nodes_landscape_layout(nodes, gaps)
    return Core.layouts.LandscapeLayout(nodes, gaps)
end

function Widget:align_nodes_horizontally(nodes, gaps)
    Core.layouts.LandscapeLayout(nodes, gaps):apply()
end

function Widget:align_nodes_horizontally_and_adjust_container(nodes, gaps, container)
    Core.layouts.LandscapeLayout(nodes, gaps):apply():adjust_container(container)
end

function Widget:create_factory(node_id)
    local factory = Core.NodeFactory(node_id)
    self.factories[#self.factories + 1] = factory
    return factory
end

function Widget:add_transition(config, node)
    self.transitions[#self.transitions + 1] = Transitions.WidgetTransition(config, node)
end

function Widget:add_complex_transition(config, nodes)
    self.transitions[#self.transitions + 1] = Transitions.ComplexWidgetTransition(config, nodes)
end

function Widget:on_message(message_id, message, sender)
    for i = 1, #self.transitions do
        self.transitions[i]:on_message(message_id, message, sender)
    end
end

function Widget:final()
    for i = 1, #self.transitions do
        self.transitions[i]:final()
    end

    if self.theme_map then
        self.theme_map:final()
    end

    if self.localization_map then
        self.localization_map:final()
    end
end

return Widget
