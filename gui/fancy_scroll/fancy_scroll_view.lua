local Scroller = require('gui.fancy_scroll.core.scroller')
local CoreScrollView = require('gui.fancy_scroll.core.core_scroll_view')
local Scrollbar = require('gui.fancy_scroll.scrollbar.scrollbar')
local Event = require('gui.fancy_scroll.helper.event.event')
local Easing = require('gui.fancy_scroll.helper.easing_func')

--- @class FancyScrollView : CoreScrollView
local FancyScrollView = class('FancyScrollView', CoreScrollView)

FancyScrollView.__cparams = {}
FancyScrollView.Easing = Easing

function FancyScrollView:initialize(viewport_node, view_creator, options)
    local scroller = Scroller(viewport_node, options)
    CoreScrollView.initialize(self, scroller, view_creator, options)

    self.duration_select = options.duration_select or 0.2
    self.easing_select = Easing.outSine

    self.scroller.event_update_selection:add(self.on_selection_updated, self)
    self.event_position_updated = self.scroller.event_position_updated

    self.event_selection_changed = Event()
    self.current_index = 0

    self.on_scroll_callbacks = {}
end

function FancyScrollView:on_scroll(callback)
    self.on_scroll_callbacks[#self.on_scroll_callbacks + 1] = callback

    self.scroller.event_update_selection:add(function(index)
        callback(index)
    end)
end

function FancyScrollView:clear()
    CoreScrollView.update_items(self, {})
end

function FancyScrollView:update_items(items)
    CoreScrollView.update_items(self, items)
    self.scroller:jump_to(0)
end

function FancyScrollView:switch_to(index)
    self.scroller:jump_to(index)
    self.current_index = index
end

function FancyScrollView:is_scrolling()
    return self.scroller.scroll_velocity ~= 0 or self.scroller.is_hold or self.scroller.is_drag
end

function FancyScrollView:scroll_to(index, complete_callback)
    if not self:valid_index(index) then
        if complete_callback then
            complete_callback()
        end
        print('index invalid')
        return
    end

    self.current_index = index
    self.scroller:scroll_to(index, self.duration_select, self.easing_select, function()
        if complete_callback then
            complete_callback()
        end
    end)
end

function FancyScrollView:move_to_loop(index, complete_callback)
    if not self:valid_index(index) then
        if complete_callback then
            complete_callback()
        end
        print('index invalid')
        return
    end

    self.current_index = index
    self.scroller:move_to_loop(index, self.duration_select, self.easing_select, function()
        if complete_callback then
            complete_callback()
        end
    end)
end

function FancyScrollView:get_scroll_index()
    return self.current_index
end

function FancyScrollView:set_scrollbar(scrollbar)
    self.scroller:set_scrollbar(scrollbar)
end

function FancyScrollView:set_restricted(value)
    self.scroller.is_unrestricted = not value
end

function FancyScrollView:select_cell(index)
    if not self:valid_index(index) then
        print('FancyScrollView:select_cell invalid index!', index, self.current_index)
        return
    end

    self.current_index = index
    self.scroller:jump_to(index)
end

function FancyScrollView:valid_index(index)
    if self.scroller.is_unrestricted then
        return true
    end

    return index ~= self.current_index and index >= 0 and index < self:get_count()
end

function FancyScrollView:get_views()
    return self.views
end

function FancyScrollView:get_view_by_index(index)
    for i, view in ipairs(self.views) do
        if view.index == index then
            return view
        end
    end
end

function FancyScrollView:next()
    self:scroll_to(self.current_index + 1)
end

function FancyScrollView:prev()
    self:scroll_to(self.current_index - 1)
end

function FancyScrollView:on_selection_updated(index)
    self.current_index = index
    self.event_selection_changed(index)
end

function FancyScrollView:get_current_selection()
    return self.scroller:get_current_selection()
end

function FancyScrollView:update(dt)
    self.scroller:update(dt)
end

function FancyScrollView:on_input(action_id, action)
    self.scroller:on_input(action_id, action)

    if self.scroller.scrollbar then
        self.scroller.scrollbar:on_input(action_id, action)
    end
end

return FancyScrollView
