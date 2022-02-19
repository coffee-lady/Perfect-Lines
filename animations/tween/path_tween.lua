local Tween = require('animations.tween.tween')

--- @class PathTween : Tween
local PathTween = class('AnimationPathTween', Tween)

local UPDATE_INTERVAL = 0

local function buid_path_data(path)
    assert(path)
    assert(#path > 1)
    local path_len = 0

    local path_data = {}
    local from = path[1]

    for i = 1, #path - 1 do
        local segment = {}
        local to = path[i + 1]
        local vec = to - from
        local seg_len = vmath.length(vec)

        segment.length = seg_len
        segment.from = from
        segment.to = to

        if from.x == to.x and from.y == to.y then
            segment.vec = vmath.vector3(0)
        else
            segment.vec = vmath.normalize(vec)
        end

        segment.path_before = path_len
        path_len = path_len + seg_len
        segment.path = path_len

        from = to
        table.insert(path_data, segment)
    end

    return path_data, path_len
end

--- @param easing_selector EasingSelector
function PathTween:initialize(object, path, duration, easing_selector)
    self.object = object
    self.to = path
    self.anim_property = 'position'
    self.anim_playback = nil
    self.anim_delay = 0
    self.anim_duration = duration
    self.callbacks = {}
    self.easing_selector = easing_selector
    self.anim_easing = nil

    self.path_data, self.path_len = buid_path_data(path)
    self.path_data_count = #self.path_data

    self.is_running = false
end

function PathTween:easing(easing_type)
    self.easing_func = self.easing_selector:get(easing_type)

    return self
end

local function delay_run(self)
    self.timer_id = timer.delay(UPDATE_INTERVAL, true, function(_, _, dt)
        self:_update(dt)
    end)
end

function PathTween:on_run(callback)
    assert(not self.timer_id)

    self.complete_cb = callback
    self.current_time = 0
    self.last_segment = 1
    self.timer_id = timer.delay(self.anim_delay, false, function()
        delay_run(self)
    end)
end

local function on_complete(self)
    self:on_cancel()

    if self.complete_cb then
        self.complete_cb(self, self.object)
    end
end

function PathTween:_update(dt)
    self.current_time = self.current_time + dt

    if self.current_time > self.anim_duration then
        self.current_time = self.anim_duration
    end

    local path_value = self.easing_func(self.current_time, 0, self.path_len, self.anim_duration)

    self.last_segment = self:_select_segment(path_value, self.last_segment)

    local segment = self.path_data[self.last_segment]

    if segment then
        local pos = segment.from + segment.vec * (path_value - segment.path_before)
        self.object:set_pos(pos)
    end

    if self.current_time >= self.anim_duration then
        on_complete(self)
    end
end

function PathTween:_select_segment(path_value, start_index)
    for i = start_index, self.path_data_count do
        local segment = self.path_data[i]

        if path_value <= segment.path then
            return i
        end
    end

    local last_seg = self.path_data[self.path_data_count]

    if path_value > last_seg.path then
        return last_seg
    end

    return 0
end

function PathTween:on_cancel()
    if not self.timer_id then
        return
    end

    timer.cancel(self.timer_id)
    self.timer_id = nil
end

return PathTween
