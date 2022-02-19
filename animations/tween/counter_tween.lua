local Tween = require('animations.tween.tween')

--- @class CounterTween : Tween
local CounterTween = class('AnimationCounterTween', Tween)

function CounterTween:initialize(prev_value, next_value, duration, update)
    self.prev_value = prev_value
    self.next_value = next_value
    self.update = update
    self.anim_duration = duration
    self.callbacks = {}

    self.is_running = false

    self:run()
end

function CounterTween:on_run(callback)
    local range = self.next_value - self.prev_value

    if range < 0 then
        self.prev_value = 0
        range = self.next_value - self.prev_value
    end

    local elapsed_time = 0

    if range == 0 then
        self.update(self.next_value)
        return
    end

    self.update(self.prev_value)

    self.timer = timer.delay(self.anim_duration / (range * 10), true, function(_, handle, dt)
        elapsed_time = elapsed_time + dt

        local remaining_time = math.max((self.anim_duration - elapsed_time) / self.anim_duration, 0)
        local current = self.next_value - remaining_time * range

        self.update(current)

        if current == self.next_value then
            timer.cancel(handle)
            self.timer = nil
            callback(self)
        end
    end)
end

function CounterTween:on_cancel()
    if self.timer then
        timer.cancel(self.timer)
    end
end

return CounterTween
