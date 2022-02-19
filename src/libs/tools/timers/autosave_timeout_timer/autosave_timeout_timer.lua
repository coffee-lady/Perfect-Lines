local class = require('src.libs.tools.middleclass.middleclass')

local SEC = 1
local get_time = os.time
local difftime = os.difftime
local set_delay = timer.delay

--- @class AutosaveTimeoutTimer
local AutosaveTimeoutTimer = class('AutosaveTimeoutTimer')

function AutosaveTimeoutTimer:initialize(timeout, callback, update_callback)
    self.timeout = timeout
    self.seconds_left = 0
    self.callback = callback or function()

    end
    self.update_callback = update_callback or function()

    end
end

function AutosaveTimeoutTimer:enable_saving(file, key, storage)
    self.file = file
    self.key = key
    self.storage = storage
end

function AutosaveTimeoutTimer:restore_unfinished()
    local timer_started = self.storage:get(self.file, self.key)

    if not timer_started or type(timer_started) ~= 'number' then
        return
    end

    local time_elapsed = difftime(get_time(), timer_started)
    local time_left = self.timeout - time_elapsed

    if time_left > 0 then
        self:set_timer(time_left)
    end
end

function AutosaveTimeoutTimer:set_timer(timeout)
    if timeout == 0 then
        timer.delay(0, false, function()
            self.callback()
            self.update_callback(0)
        end)

        return
    end

    self.seconds_left = timeout
    self.update_callback(self.seconds_left)

    local timer_started = get_time()
    self.timer = set_delay(SEC, true, function()
        local now = get_time()
        local time_elapsed = difftime(now, timer_started)

        timer_started = now
        self.seconds_left = self.seconds_left - time_elapsed

        if self.seconds_left < 0 then
            self.seconds_left = 0
        end

        if self.seconds_left == 0 then
            self:_complete()
        end
    end)
end

function AutosaveTimeoutTimer:get_seconds_left()
    return self.seconds_left
end

function AutosaveTimeoutTimer:resume()
    self:cancel()
    self:set_timer(self.timeout)
    self.storage:set(self.file, self.key, get_time())
end

function AutosaveTimeoutTimer:cancel()
    self.storage:set(self.file, self.key, nil)

    if self.timer then
        timer.cancel(self.timer)
        self.timer = nil
        self.seconds_left = 0
    end
end

function AutosaveTimeoutTimer:is_expired()
    return self.seconds_left == 0
end

function AutosaveTimeoutTimer:_complete()
    self:cancel()
    self.callback()
end

return AutosaveTimeoutTimer
