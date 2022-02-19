--- @class Tween
local Tween = class('AnimationTween')

function Tween:initialize(object, to, duration, anim_property)
    self.object = object
    self.to = to
    self.anim_property = anim_property
    self.anim_playback = nil
    self.anim_delay = 0
    self.anim_easing = nil
    self.anim_duration = duration
    self.callbacks = {}

    self.is_running = false
end

function Tween:easing(val)
    self.anim_easing = val

    return self
end

function Tween:delay(delay)
    self.anim_delay = delay or 0

    return self
end

function Tween:on_complete(callback)
    local callbacks = self.callbacks

    for i = 1, #callbacks do
        if callbacks[i] == callback then
            return
        end
    end

    callbacks[#callbacks + 1] = callback

    return self
end

function Tween:on_run(...)

end

function Tween:on_cancel(...)

end

function Tween:playback(val)
    self.anim_playback = val

    return self
end

function Tween:get_duration()
    return self.anim_duration
end

local function cancel_timer(self)
    if self.timer then
        timer.cancel(self.timer)

        self.timer = nil
    end
end

function Tween:cancel()
    if not self.is_running then
        return
    end

    cancel_timer(self)

    self:on_cancel()

    self.is_running = false
end

local function on_complete(self)
    self.is_running = false
    cancel_timer(self)

    local callbacks = self.callbacks

    for i = 1, #callbacks do
        callbacks[i](self)
    end

    if self.thread_co then
        local res, error = coroutine.resume(self.thread_co)

        if not res then
            print(error)
        end

        self.thread_co = nil
    end
end

function Tween:_start_tween()
    self.is_running = true

    self:on_run(on_complete)
end

function Tween:run()
    if self.is_running then
        print('already running tween!')
        print(debug.traceback())
        return
    end

    self:_start_tween()
end

function Tween:run_async()
    if self.is_running then
        print('already running tween!')
        return
    end

    local co = coroutine.running()

    self.thread_co = co
    self:_start_tween()

    coroutine.yield()
end

return Tween
