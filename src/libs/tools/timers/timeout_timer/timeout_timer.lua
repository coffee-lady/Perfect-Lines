local class = require('src.libs.tools.middleclass.middleclass')

local SEC = 1
local get_time = os.time
local difftime = os.difftime
local set_delay = timer.delay

--- @class TimeoutTimer
local TimeoutTimer = class('TimeoutTimer')

function TimeoutTimer:initialize(timeout, callback, update_callback)
    self.timeout = timeout
    self.seconds_left = 0
    self.callback = callback or function()

    end
    self.update_callback = update_callback or function()

    end
end

function TimeoutTimer:set_timer(timeout)
    if timeout == 0 then
        return
    end

    self.seconds_left = timeout
    self.update_callback(self.seconds_left)

    local timer_started = os.time()
    self.timer = set_delay(SEC, true, function()
        local time_elapsed = difftime(get_time(), timer_started)
        self.seconds_left = timeout - time_elapsed
        self.seconds_left = self.seconds_left >= 0 and self.seconds_left or 0

        self.update_callback(self.seconds_left)

        if self.seconds_left == 0 then
            self:_complete()
        end
    end)
end

function TimeoutTimer:resume()
    self:cancel()
    self:set_timer(self.timeout)
end

function TimeoutTimer:cancel()
    if self.timer then
        timer.cancel(self.timer)
    end
    self.seconds_left = 0
end

function TimeoutTimer:is_expired()
    return self.seconds_left == 0
end

function TimeoutTimer:get_seconds_left()
    return self.seconds_left
end

function TimeoutTimer:_complete()
    self:cancel()
    self.callback()
end

return TimeoutTimer
