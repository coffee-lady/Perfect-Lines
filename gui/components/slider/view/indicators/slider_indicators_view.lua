local Core = require('gui.core.core')
local Widget = require('gui.widget.widget')
local SliderIndicatorView = require('gui.components.slider.view.indicators.indicator_view.slider_indicator_view')

local BoxNode = Core.BoxNode

local ACTION_CLICK = hash('click')

--- @class IndicatorsView : Widget
local IndicatorsView = class('IndicatorsView', Widget)

IndicatorsView.__cparams = {'event_bus', 'ui_service'}

function IndicatorsView:initialize(event_bus, ui_service, params)
    Widget.initialize(self, event_bus, ui_service)

    --- @type EventBus
    self.event_bus = event_bus
    self.ui_service = ui_service

    self.template_id = params.template_id
    self.items_gap = params.items_gap
    self.container_node = BoxNode(params.container_id)
    self.items_count = params.items_count

    self.items = {}
    self.items_theme_objects = {}
    self.factory = self:create_factory(self.template_id)

    self:init()
end

function IndicatorsView:init()
    self:_create_items()
    self.event_bus:on(ACTION_CLICK, self.on_click, self)
end

function IndicatorsView:_create_items()
    local items_nodes = {}

    for i = 1, self.items_count do
        self.items[i], items_nodes[i] = self:_create_item_view()
    end

    self:align_nodes_horizontally(items_nodes, self.items_gap)
end

function IndicatorsView:_create_item_view()
    local item_node = BoxNode(self.factory:create())
    item_node:set_parent(self.container_node)

    return inject(SliderIndicatorView, item_node), item_node
end

function IndicatorsView:on_item_picked(callback)
    self._choose_item_callback = callback
end

function IndicatorsView:on_click(action)
    if not action.pressed then
        return false
    end

    for i = 1, #self.items do
        if self.items[i]:is_picked(action) then
            local is_choosed = self:choose(i)

            if is_choosed then
                self._choose_item_callback(i - 1)
            end

            return is_choosed
        end
    end
end

function IndicatorsView:choose(selected_index)
    if selected_index == self.selected_index then
        return false
    end

    self.selected_index = selected_index

    for i = 1, #self.items do
        if i == selected_index then
            self.items[i]:select()
        else
            self.items[i]:deselect()
        end
    end

    return true
end

function IndicatorsView:change_colors_to_modified()
    for i = 1, #self.items do
        self.items[i]:change_colors_to_modified()
    end
end

function IndicatorsView:change_colors_to_initial()
    for i = 1, #self.items do
        self.items[i]:change_colors_to_initial()
    end
end

function IndicatorsView:final()
    Widget.final(self)

    for i = 1, #self.items do
        self.items[i]:final()
    end
end

return IndicatorsView
