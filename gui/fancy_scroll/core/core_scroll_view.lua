local Event = require('gui.fancy_scroll.helper.event.event')

local Math = require('src.libs.tools.math.math')

--- @class CoreScrollView
local CoreScrollView = class('CoreScrollView')

local DEFAULT_OPTIONS = {scroll_offset = 0.5, item_interval = 0.35, is_loop = false}

function CoreScrollView:initialize(scroller, view_creator, options)
    assert(scroller, 'scroller cant be nil')
    assert(view_creator, 'view creator cant be nil')

    options = options or DEFAULT_OPTIONS
    self.view_creator = view_creator
    self:init_scroller(scroller)
    self.items = {}

    self.views = {}

    self.scroll_offset = Math.clamp01(options.scroll_offset or DEFAULT_OPTIONS.scroll_offset)
    self.item_interval = Math.clamp01(options.item_interval or DEFAULT_OPTIONS.item_interval)
    self.is_loop = options.is_loop or DEFAULT_OPTIONS.is_loop

    self.current_position = 0

    self.event_item_position_updated = Event()
    self.event_all_items_positions_updated = Event()
end

function CoreScrollView:init_scroller(scroller)
    self.scroller = scroller
    self.scroller.event_position_updated:add(self.on_position_updated, self)
end

function CoreScrollView:add_on_item_position_updated(cb)
    self.event_item_position_updated:add(cb)
end

function CoreScrollView:add_on_all_items_positions_updated(cb)
    self.event_all_items_positions_updated:add(cb)
end

function CoreScrollView:get_items()
    return self.items
end

function CoreScrollView:create_cell()
    return self.view_creator()
end

function CoreScrollView:update_items(items)
    self.items = items
    self.scroller:set_total_count(#items)

    if self.scroller.scrollbar then
        self.scroller.scrollbar:set_percentage(self.scroller.bottom_offset / (#items - 1))
    end

    self:refresh()
end

function CoreScrollView:refresh()
    self:update_position(self.current_position)
end

function CoreScrollView:get_count()
    return #self.items
end

function CoreScrollView:on_position_updated(position)
    self:update_position(position)
end

function CoreScrollView:update_position(position, force_refresh)
    self.current_position = position
    local p = position - self.scroll_offset / self.item_interval
    local first_index = math.ceil(p)
    local first_position = (first_index - p) * self.item_interval

    if first_position + #self.views * self.item_interval < 1 then
        self:resize_pool(first_position)
    end

    self:update_cells(first_position, first_index, force_refresh)
end

function CoreScrollView:resize_pool(first_position)
    local count_add = math.ceil((1 - first_position) / self.item_interval) - #self.views

    for i = 1, count_add do
        local view = self.view_creator()
        view:set_enabled(false)

        if view.on_spawned then
            view:on_spawned()
        end

        table.insert(self.views, view)
    end
end

function CoreScrollView:update_cells(first_position, first_index, force_refresh)
    local count_views = #self.views
    local items_count = #self.items

    self._last_first_position = first_position

    for i = 1, #self.views do
        local j = i - 1
        local index = first_index + j
        local position = first_position + j * self.item_interval
        local circ_index = Math.circular_position(index, count_views)
        local view = self.views[circ_index + 1]

        if view then
            if self.is_loop then
                index = Math.circular_position(index, items_count)
            end

            if index < 0 or index >= items_count or position > 1 then
                view:set_enabled(false)
            else
                if force_refresh or view.index ~= index or not view:is_enabled() then
                    view.index = index
                    view:set_enabled(true)
                    view:update_data(self.items[index + 1], index)
                end

                view:update_position(position)
                self.event_item_position_updated(position, index)
            end
        end
    end

    self.event_all_items_positions_updated(first_index)
end

function CoreScrollView:get_item_position(scroll_index)
    return self._last_first_position + scroll_index * self.item_interval
end

return CoreScrollView
