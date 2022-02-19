local Core = require('gui.core.core')
local Event = require('gui.fancy_scroll.helper.event.event')
local AutoscrollHelper = require('gui.fancy_scroll.helper.autoscroll_helper')
local Easing = require('gui.fancy_scroll.helper.easing_func')

local Math = require('src.libs.tools.math.math')
local Node = Core.Node

local Scroller = class('Scroller')

local DEFAULT_TOUCH_ID = hash('click')
local VELOCITY_MODIFIER = 10
local DEFAULT_SNAP_EASING = Easing.inSine
local DEFAULT_OPTIONS = {}

local function get(value, default)
    if value ~= nil then
        return value
    else
        return default
    end
end

function Scroller:initialize(node_view_port, options)
    assert(node_view_port)

    --- @type Node
    self.node_view_port = Node(node_view_port)

    options = options or DEFAULT_OPTIONS

    self.touch_id = DEFAULT_TOUCH_ID

    self.current_position = 0
    self.prev_position = 0

    -- OPTIONS
    self.deceleration_value = options.deceleration or 0.2
    self.scroll_elasticity = options.scroll_elasticity or 0.1

    self.is_inertia = get(options.is_inertia, true)

    self.is_horizontal = get(options.is_horizontal, true)
    self.is_elastic = get(options.is_elastic, true)

    self.scroll_sensivity = options.scroll_sensivity or 1

    self.is_snap = get(options.is_snap, true)

    self.snap_velocity_therehold = options.snap_velocity_therehold or 0.2
    self.snap_duration = options.snap_duration or 0.3
    self.snap_easing = options.snap_easing or DEFAULT_SNAP_EASING
    self.is_unrestricted = options.is_unrestricted or false
    self.drag_therehold = options.drag_therehold or 10
    self.bottom_offset = options.bottom_offset or 0
    ----------------------

    self.point_down = vmath.vector3(0)

    self.scroll_velocity = 0
    self.total_count = 0
    self.drag_length = 0

    self.view_port_size = self.node_view_port:get_size()

    self.autoscroll = AutoscrollHelper(Easing.outSine)

    self.event_position_updated = Event()
    self.event_update_selection = Event()
end

function Scroller:set_scrollbar(scrollbar)
    self:clear_scrollbar()
    self.scrollbar = scrollbar
    self.scrollbar.event_scrollbar_changed:add(self.on_scrollbar_changed, self)
end

function Scroller:clear_scrollbar()
    if not self.scrollbar then
        return
    end

    self.scrollbar.event_scrollbar_changed:remove(self.on_scrollbar_changed, self)
    self.scrollbar = nil
end

function Scroller:get_current_selection()
    return Math.clamp(Math.round(self.current_position), 0, self.total_count - 1)
end

function Scroller:on_scrollbar_changed(value)
    self:update_position(value * (self.total_count - 1 - self.bottom_offset), true)
end

function Scroller:get_view_port_size()
    if self.is_horizontal then
        return self.view_port_size.x
    end

    return self.view_port_size.y
end

function Scroller:set_total_count(value)
    assert(value)
    assert(value >= 0)

    self.total_count = value
end

function Scroller:update_selection(value)
    self.event_update_selection(value)
end

function Scroller:update(dt)
    self:update_inertia(dt)
    self:update_scroll_speed(dt)

    self.prev_position = self.current_position
end

function Scroller:update_scroll_speed(dt)
    if not self.is_process_pointer or self.autoscroll.enable or not self.is_inertia then
        return
    end

    local velocity = (self.current_position - self.prev_position) / dt
    self.scroll_velocity = Math.lerp(self.scroll_velocity, velocity, dt * VELOCITY_MODIFIER)
end

function Scroller:update_inertia(dt)
    if self.is_process_pointer then
        return
    end

    if self.autoscroll.enable then
        self:update_auto_scroll(dt)
    else
        self:update_velocity(dt)
    end
end

function Scroller:update_auto_scroll(dt)
    local position = 0
    local offset = self:calculate_offset(self.current_position)

    if self.autoscroll.elastic then
        position, self.scroll_velocity = Math.smoth_damp(self.current_position, self.current_position + offset,
                                                         self.scroll_velocity, self.scroll_elasticity, Math.INFINITY, dt)

        if math.abs(self.scroll_velocity) < 0.01 then
            position = Math.clamp(Math.round(position), 0, self.total_count - 1)
            self.scroll_velocity = 0
            self.autoscroll:complete()
            return
        end
    else

        local alpha = Math.clamp01((socket.gettime() - self.autoscroll.start_time) /
                                       math.max(self.autoscroll.duration, 0.0001))
        position = Math.lerp_unclamped(self.scroll_start_position, self.autoscroll.position_end,
                                       self.autoscroll.easing_func(alpha))

        if (Math.approximately(alpha, 1)) then
            self.autoscroll:complete()
        end

    end

    self:update_position(position)
end

function Scroller:update_velocity(dt)
    local offset = self:calculate_offset(self.current_position)
    local is_offset_zero = Math.approximately(offset, 0)

    if self.is_process_pointer or (is_offset_zero and Math.approximately(self.scroll_velocity, 0)) then
        return
    end

    local position = self.current_position

    if not is_offset_zero then
        self.autoscroll.enable = true
        self.autoscroll.elastic = true

        if self.autoselection then
            self:update_selection(Math.clamp(Math.round(position), 0, self.total_count - 1))
        end
    elseif self.is_inertia then

        self.scroll_velocity = self.scroll_velocity * math.pow(self.deceleration_value, dt)

        local abs_velocity = math.abs(self.scroll_velocity)
        if abs_velocity < 0.001 then
            self.scroll_velocity = 0
        end

        position = position + self.scroll_velocity * dt

        if self.is_snap and abs_velocity < self.snap_velocity_therehold then
            self:scroll_to(Math.round(self.current_position), self.snap_duration, self.snap_easing)
        end
    else
        self.scroll_velocity = 0
    end

    if not Math.approximately(self.scroll_velocity, 0) then
        self:update_position(position)
    end
end

function Scroller:on_input(action_id, action)
    if action_id ~= self.touch_id then
        return false
    end

    if action.pressed then
        self:on_pointer_down(action)
    elseif action.released and self.is_process_pointer then
        self:on_pointer_up(action)
    elseif self.is_process_pointer then
        self:on_pointer_move(action)
    end

    return self.is_catch_input
end

function Scroller:on_pointer_down(action)
    local in_node = self.node_view_port:is_picked(action)

    if not in_node then
        return false
    end

    self:update_down_pos(action)
    self.is_process_pointer = true

    self.scroll_start_position = self.current_position
    self.scroll_velocity = 0

    self.is_hold = true
    self.is_drag = false
    self.is_catch_input = false
    self.drag_length = 0

    self.autoscroll:reset()
    return true
end

function Scroller:on_pointer_move(action)
    local delta_x = action.x - self.point_down.x
    local delta_y = action.y - self.point_down.y
    self:update_down_pos(action)

    self.drag_length = self.drag_length + math.sqrt(delta_x * delta_x + delta_y * delta_y)

    if self.drag_length > self.drag_therehold then
        self:on_drag_start()
    end

    local view_port_size = self:get_view_port_size()
    local move_delta = 0

    if self.is_horizontal then
        move_delta = -delta_x
    else
        move_delta = delta_y
    end

    if math.abs(move_delta) == 0 then
        return false
    end

    local position = self.current_position + move_delta / view_port_size * self.scroll_sensivity

    local offset = self:calculate_offset(position)
    position = position + offset

    if self.is_elastic then
        position = position - self:get_rubber_delta(offset, self.scroll_sensivity)
    end

    self:update_position(position)

    return true
end

function Scroller:on_drag_start()
    self.is_hold = false
    self.is_drag = true
    self.is_catch_input = true
end

function Scroller:on_pointer_up(action)
    self.is_process_pointer = false

    if self.is_hold and self.is_snap then
        self:update_selection(Math.clamp(Math.round(self.current_position), 0, self.total_count - 1))
        self:scroll_to(Math.round(self.current_position), self.snap_duration, self.snap_easing)
    end

    self.is_hold = false
    self.is_drag = false
    self.drag_length = 0

    return true
end

function Scroller:update_down_pos(action)
    self.point_down.x = action.x
    self.point_down.y = action.y
end

function Scroller:update_position(position, skip_scrollbar)
    self.current_position = position
    self.event_position_updated(position)

    if not skip_scrollbar and self.scrollbar then
        self.scrollbar:set_position_raw(Math.clamp01(position / math.max(self.total_count - 1 - self.bottom_offset, 1)))
    end
end

function Scroller:calculate_offset(position)
    if self.is_unrestricted then
        return 0
    end

    if position < 0 then
        return -position
    end

    local max_position = math.max(self.total_count - 1 - self.bottom_offset, 0)
    if position > max_position then
        return max_position - position
    end

    return 0
end

function Scroller:scroll_to(position, duration, easing_func, complete_callback)
    if (duration <= 0) then
        self.current_position = Math.circular_position(position, self.total_count)

        if complete_callback then
            complete_callback()
        end

        return
    end

    self.autoscroll:reset()
    self.autoscroll.enable = true
    self.autoscroll.duration = duration

    self.autoscroll.easing_func = easing_func or DEFAULT_SNAP_EASING
    self.autoscroll.start_time = socket.gettime()
    self.autoscroll.position_end = self.current_position +
                                       self:calculate_movement_amount(self.current_position, position)

    self.autoscroll.on_complete = complete_callback

    self.scroll_velocity = 0
    self.scroll_start_position = self.current_position

    self:update_selection(Math.round(Math.circular_position(self.autoscroll.position_end, self.total_count)))
end

function Scroller:move_to_loop(position, duration, easing, complete_callback)
    self.autoscroll:reset()
    self.autoscroll.enable = true
    self.autoscroll.duration = duration

    self.autoscroll.easing_func = easing or DEFAULT_SNAP_EASING
    self.autoscroll.start_time = socket.gettime()
    self.autoscroll.position_end = self.current_position + position - self.current_position
    self.autoscroll.on_complete = complete_callback

    self.scroll_velocity = 0
    self.scroll_start_position = self.current_position

    self:update_selection(self.autoscroll.position_end)
end

function Scroller:jump_to(index)
    if index < 0 or index > self.total_count - 1 then
        error('Illegal index ' .. index)
    end

    -- if self.bottom_offset > 0 and index <= self.bottom_offset then
    --     return
    -- end

    index = math.min(self.total_count - 1 - self.bottom_offset, index)

    self.autoscroll:reset()
    self.scroll_velocity = 0
    self.is_process_pointer = false
    self.is_drag = false
    self.is_hold = false

    self:update_selection(index)
    self:update_position(index)
end

function Scroller:calculate_movement_amount(from_position, to_position)
    if not self.is_unrestricted then
        return Math.clamp(to_position, 0, self.total_count - 1) - from_position
    end

    local amount = Math.circular_position(to_position, self.total_count) -
                       Math.circular_position(from_position, self.total_count)
    local amount_abs = math.abs(amount)

    if amount_abs > self.total_count * 0.5 then
        amount = Math.sign(-amount) * (self.total_count - amount_abs)
    end

    return amount
end

function Scroller:get_rubber_delta(over_stretch, sensivity)
    return (1 - 1 / (math.abs(over_stretch) * 0.55 / sensivity + 1)) * sensivity * Math.sign(over_stretch)
end

return Scroller
