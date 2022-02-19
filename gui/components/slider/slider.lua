local ScrollController = require('gui.components.slider.controllers.scroll_controller_slider')
local SliderIndicatorsView = require('gui.components.slider.view.indicators.slider_indicators_view')
local SliderArrowsView = require('gui.components.slider.view.arrows.slider_arrows_view')
local StickyElementView = require('gui.components.slider.view.sticky_element.sticky_element_view')

local ACTION_CLICK = hash('click')

--- @class Slider
local SliderComponent = class('SliderComponent')

SliderComponent.__cparams = {'event_bus'}

SliderComponent.STICKY_MAIN_COORDINATE = StickyElementView.MAIN_COORDINATE

function SliderComponent:initialize(event_bus, params, slider_common)
    --- @type EventBus
    self.event_bus = event_bus

    self.slider_common = slider_common or {}
    self.params = params

    self.params.items_count = params.items_count

    if params.data then
        self.params.items_count = self.params.items_count or #params.data
    end

    self.external_arrows = {}
    self.input_enabled = true

    self.scroll_handler = inject(ScrollController, params, self.slider_common)

    self.scroll_handler:on_scroll(function()
        self:_check_showing_arrows()
    end)

    self.event_bus:on(ACTION_CLICK, self.slide, self)

    self.event_selection_changed = self.scroll_handler.event_selection_changed
end

function SliderComponent:update_items(data_items)
    self.params.items_count = self.params.items_count or #data_items

    self.scroll_handler:update_items(data_items)
end

function SliderComponent:get_current_selection()
    return self.scroll_handler:get_current_selection()
end

function SliderComponent:is_scrolling()
    return self.scroll_handler:is_scrolling()
end

function SliderComponent:get_current_scroll_view()
    local index = self:get_current_selection()
    return self:get_view_by_index(index)
end

function SliderComponent:get_view_by_index(index)
    return self.scroll_handler:get_view_by_index(index)
end

function SliderComponent:get_views()
    return self.scroll_handler:get_views()
end

function SliderComponent:on_scroll(cb)
    self.scroll_handler:on_scroll(cb)
end

function SliderComponent:on_data_updated(data)
    self.scroll_handler:on_data_updated(data)
end

function SliderComponent:switch_to(index, callback)
    self.scroll_handler:switch_to(index, callback)
end

function SliderComponent:scroll_to(index, callback)
    self.scroll_handler:scroll_to(index, callback)
end

function SliderComponent:set_input_enabled(enabled)
    self.input_enabled = enabled
end

function SliderComponent:slide(action)
    if not self.input_enabled then
        return
    end

    if self.slider_arrows and self.slider_arrows:are_arrows_picked(action) then
        self.slider_arrows:on_click(action)
        return
    end

    if self.slider_indicators and self.slider_indicators:on_click(action) then
        return
    end

    for i = 1, #self.external_arrows do
        local arrows = self.external_arrows[i]

        if arrows:are_arrows_picked(action) then
            arrows:on_click(action)
            return
        end
    end

    self.scroll_handler:on_input(ACTION_CLICK, action)
end

function SliderComponent:update(dt)
    self.scroll_handler:update(dt)
end

function SliderComponent:add_arrows(params)
    params.items_count = self.params.items_count
    params.scroll_next = function()
        self:scroll_to(self.scroll_handler:get_scroll_index() + 1)
    end
    params.scroll_prev = function()
        self:scroll_to(self.scroll_handler:get_scroll_index() - 1)
    end

    self.slider_arrows = inject(SliderArrowsView, params)
    self.slider_common.arrows = self.slider_arrows
    self:_check_showing_arrows()
end

function SliderComponent:add_external_arrows(params)
    params.items_count = self.params.items_count
    params.scroll_next = function()
        self:scroll_to(self.scroll_handler:get_scroll_index() + 1)
    end
    params.scroll_prev = function()
        self:scroll_to(self.scroll_handler:get_scroll_index() - 1)
    end

    self.external_arrows[#self.external_arrows + 1] = inject(SliderArrowsView, params)

    self:_check_showing_arrows()
end

function SliderComponent:add_boundary_arrows(ids, callbacks)
    self.slider_arrows:add_boundary_arrows(ids, callbacks)
    self:_check_showing_arrows()
end

function SliderComponent:add_indicators(container_id, indicator_template_id, gap)
    self.slider_indicators =
        inject(SliderIndicatorsView, {template_id = indicator_template_id, items_gap = gap, container_id = container_id, items_count = self.params.items_count})
    self.slider_common.indicators = self.slider_indicators

    self.slider_indicators:on_item_picked(function(index)
        self:scroll_to(index)
    end)

    self.slider_indicators:choose(self.scroll_handler:get_scroll_index() + 1)

    self.scroll_handler:on_scroll(function(index)
        self.slider_indicators:choose(index + 1)
    end)
end

function SliderComponent:add_scrollbar(nodes, options)
    self.scroll_handler:set_scrollbar(nodes, options)
end

function SliderComponent:change_indicators_colors_to_modified()
    self.slider_indicators:change_colors_to_modified()
end

function SliderComponent:change_indicators_colors_to_initial()
    self.slider_indicators:change_colors_to_initial()
end

-- params = {
--     scroll_index
--     main_coord
--     min_axis
--     max_axis
-- }
function SliderComponent:add_sticky_element(nodes, params)
    self.sticky_elem = StickyElementView(nodes, params)

    local position = self.scroll_handler:get_item_position(params.scroll_index)
    self:_update_sticky_pos(position)

    self.scroll_handler:on_item_position_updated(function(rel_pos, scroll_index)
        if scroll_index == self.sticky_elem.scroll_index then
            self:_update_sticky_pos(rel_pos)
            self._pos_updated = true
        end
    end)

    self.scroll_handler:on_all_items_positions_updated(function(first_scroll_index)
        self:_check_border_sticky_pos(first_scroll_index)
    end)
end

function SliderComponent:final()
    local views = self:get_views()
    for i = 1, #views do
        local view = views[i]

        if view.final then
            view:final()
        end
    end

    if self.slider_indicators then
        self.slider_indicators:final()
    end
end

function SliderComponent:_check_showing_arrows()
    local current_scroll_index = self.scroll_handler:get_scroll_index()

    if self.slider_arrows then
        self.slider_arrows:check_showing_arrows(current_scroll_index)
    end

    for i = 1, #self.external_arrows do
        local arrows = self.external_arrows[i]
        arrows:check_showing_arrows(current_scroll_index)
    end
end

function SliderComponent:_check_border_sticky_pos(first_scroll_index)
    local scroll_index = self.sticky_elem.scroll_index

    if not self._pos_updated then
        if scroll_index < first_scroll_index then
            self.sticky_elem:set_max_pos()
        else
            self.sticky_elem:set_min_pos()
        end
    end

    self._pos_updated = false
end

function SliderComponent:_update_sticky_pos(rel_pos)
    local pos

    if self.sticky_elem.main_coord == SliderComponent.STICKY_MAIN_COORDINATE.x then
        pos = self.scroll_handler:get_pos_in_horizontal_scroll(rel_pos)
    else
        pos = self.scroll_handler:get_pos_in_vertical_scroll(rel_pos)
    end

    self.sticky_elem:update_pos(pos)
end

return SliderComponent
