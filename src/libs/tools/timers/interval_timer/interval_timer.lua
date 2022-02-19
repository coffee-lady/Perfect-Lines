local class = require('src.libs.tools.middleclass.middleclass')

local SEC = 1
local get_time = os.time
local difftime = os.difftime
local set_delay = timer.delay

--- @class IntervalTimer
local IntervalTimer = class('IntervalTimer')

function IntervalTimer:initialize(interval, callback, update_callback)
    self.interval = interval
    self.seconds_left = 0
    self.callback = callback or function()

    end
    self.update_callback = update_callback or function()

    end
end

function IntervalTimer:set_timer(interval)
    if interval == 0 then
        timer.delay(0, false, function()
            self.callback()
            self.update_callback(0)
        end)

        return
    end

    self.seconds_left = interval
    self.update_callback(self.seconds_left)

    local timer_started = get_time()
    self.timer = set_delay(SEC, true, function()
        local now = get_time()
        local time_elapsed = difftime(now, timer_started)
        local times_timer_expired = math.floor(time_elapsed / interval)

        for _ = 1, times_timer_expired do
            self.seconds_left = self.seconds_left - interval
            self.callback()
            self.update_callback(self.seconds_left)
        end

        local time_left_since_previous = (time_elapsed - times_timer_expired * interval)
        timer_started = now + time_left_since_previous
        self.seconds_left = self.seconds_left - time_left_since_previous

        if self.seconds_left == 0 then
            self:_complete()
        end
    end)
end

function IntervalTimer:get_seconds_left()
    return self.seconds_left
end

function IntervalTimer:resume()
    self:cancel()
    self:set_timer(self.interval)
end

function IntervalTimer:cancel()
    if self.timer then
        timer.cancel(self.timer)
        self.timer = nil
        self.seconds_left = 0
    end
end

function IntervalTimer:_complete()
    self:cancel()
    self:resume()
end

return IntervalTimer
