local class = require('src.libs.tools.middleclass.middleclass')

local SEC = 1
local get_time = os.time
local difftime = os.difftime
local set_delay = timer.delay

--- @class AutosaveIntervalTimer
local AutosaveIntervalTimer = class('AutosaveIntervalTimer')

function AutosaveIntervalTimer:initialize(interval, callback, update_callback)
    self.interval = interval
    self.seconds_left = 0
    self.callback = callback or function()

    end
    self.update_callback = update_callback or function()

    end
end

function AutosaveIntervalTimer:enable_saving(file, key, storage)
    self.file = file
    self.key = key
    self.storage = storage
end

function AutosaveIntervalTimer:autoresume()
    local timer_started = self.storage:get(self.file, self.key)

    if not timer_started then
        self:resume()
        return
    end

    local time_elapsed = difftime(get_time(), timer_started)
    self.times_timer_expired = math.floor(time_elapsed / self.interval)

    local time_left = time_elapsed - self.times_timer_expired * self.interval

    if time_left > 0 then
        self.storage:set(self.file, self.key, difftime(get_time(), time_left))
        self:set_timer(time_left)
        return
    end

    self:resume()
end

function AutosaveIntervalTimer:set_timer(interval)
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

        if times_timer_expired > 0 then
            self.storage:set(self.file, self.key, now)
        end

        local time_left_since_previous = time_elapsed - times_timer_expired * interval
        timer_started = now
        self.seconds_left = self.seconds_left - time_left_since_previous

        if self.seconds_left < 0 then
            self.seconds_left = 0
        end

        if self.seconds_left == 0 then
            self:_complete()
        end
    end)
end

function AutosaveIntervalTimer:get_times_expired()
    return self.times_timer_expired or 0
end

function AutosaveIntervalTimer:get_seconds_left()
    return self.seconds_left
end

function AutosaveIntervalTimer:resume()
    self:cancel()
    self:set_timer(self.interval)
    self.storage:set(self.file, self.key, get_time())
end

function AutosaveIntervalTimer:cancel()
    self.storage:set(self.file, self.key, nil)

    if self.timer then
        timer.cancel(self.timer)
        self.timer = nil
        self.seconds_left = 0
    end
end

function AutosaveIntervalTimer:_complete()
    self:cancel()
    self:resume()
end

return AutosaveIntervalTimer
