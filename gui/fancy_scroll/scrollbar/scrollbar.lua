local Core = require('gui.core.core')
local Event = require('gui.fancy_scroll.helper.event.event')

local Math = require('src.libs.tools.math.math')
local Node = Core.Node

local BaseScrollbar = class('BaseScrollbar', Node)

local ACTION_TOUCH = hash('click')

-- nodes {pointer, touch_cursor}
-- options {is_vertical, sensitivity}
function BaseScrollbar:initialize(nodes, options)
    options = options or {}

    Node.initialize(self, nodes.container.target)

    self.pointer_view = nodes.pointer
    self.touch_cursor = nodes.touch_cursor

    self.event_scrollbar_changed = Event()

    self.min_pointer_size = Math.clamp(options.min_pointer_size or 0.1, 0, 1)
    self.is_vertical = options.is_vertical == nil and true or options.is_vertical
    self.sensitivity = options.sensitivity or 1
    self.current_position = 0

    self:set_position_raw(0)
    self:set_percentage(0.2)
end

function BaseScrollbar:set_percentage(value)
    local size_value = Math.clamp(value, self.min_pointer_size, 1)
    local pointer_size = self:get_full_size(self) * size_value

    self:update_pointer_size(pointer_size)
    self:update_pointer_position(self.current_position)
end

function BaseScrollbar:set_position(value)
    self:set_position_raw(value)
    self.event_scrollbar_changed(self.current_position)
end

function BaseScrollbar:set_position_raw(value)
    self.current_position = self:update_pointer_position(value)
end

function BaseScrollbar:update_pointer_position(value)
    value = Math.clamp(value, 0, 1)
    local fullsize = self:get_full_size(self)
    local pointer_size = self:get_full_size(self.touch_cursor)
    local delta_move = math.max(fullsize - pointer_size, 0)
    local pos = self.touch_cursor:get_pos()
    local offset = delta_move * value
    local pos_next = (fullsize - pointer_size) / 2 - offset

    local asigned_value = 0
    if delta_move > 0 then
        asigned_value = offset / delta_move
    end

    if self.is_vertical then
        pos.y = pos_next
    else
        pos.x = pos_next
    end

    self.touch_cursor:set_pos(pos)
    return asigned_value
end

function BaseScrollbar:get_full_size(view)
    local max_size = view:get_size()
    local full_size = max_size.x

    if self.is_vertical then
        full_size = max_size.y
    end

    return full_size
end

function BaseScrollbar:update_pointer_size(size)
    self:update_scroll_view_size(self.pointer_view, size)
    self:update_scroll_view_size(self.touch_cursor, size)
end

function BaseScrollbar:update_scroll_view_size(view, size)
    local view_size = view:get_size()

    if self.is_vertical then
        view_size.y = size
    else
        view_size.x = size
    end

    view:set_size(view_size)
end

function BaseScrollbar:on_input(action_id, action)
    if not action_id == ACTION_TOUCH then
        return false
    end

    if action.pressed then
        self:on_press(action)
    elseif action.released and self.is_input then
        self:on_release(action)
    elseif self.is_input then
        self:on_move(action)
    end
end

function BaseScrollbar:on_press(action)
    if not self.touch_cursor:is_picked(action) then
        return
    end

    self.press_x = action.x
    self.press_y = action.y

    self.is_input = true
end

function BaseScrollbar:on_move(action)
    local delta = action.x - self.press_x
    if self.is_vertical then
        delta = self.press_y - action.y
    end

    local fullsize = self:get_full_size(self)

    self.current_position = self.current_position + delta * self.sensitivity / fullsize

    self:set_position(self.current_position)
    self.press_x = action.x
    self.press_y = action.y
end

function BaseScrollbar:on_release(action)
    self.is_input = false
end

return BaseScrollbar
