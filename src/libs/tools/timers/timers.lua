local Timers = {
    IntervalTimer = require('src.libs.tools.timers.interval_timer.interval_timer'),
    AutosaveIntervalTimer = require('src.libs.tools.timers.autosave_interval_timer.autosave_interval_timer'),
    TimeoutTimer = require('src.libs.tools.timers.timeout_timer.timeout_timer'),
    AutosaveTimeoutTimer = require('src.libs.tools.timers.autosave_timeout_timer.autosave_timeout_timer'),
}

return Timers
