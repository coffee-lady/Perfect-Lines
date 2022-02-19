local Timers = require('src.libs.tools.timers.timers')

local ToolLibs = {
    inspect = require('src.libs.tools.inspect.inspect'),
    math = require('src.libs.tools.math.math'),
    easings = require('src.libs.tools.easings.easings'),
    color = require('src.libs.tools.color.color'),
    date = require('src.libs.tools.types.date.date'),
    event_observation = require('src.libs.tools.rx.rx'),
    middleclass = require('src.libs.tools.middleclass.middleclass'),
    linked_list = require('src.libs.tools.types.linked_list.linked_list'),
    array = require('src.libs.tools.types.array.array'),
    async = require('src.libs.tools.async.async'),
    string = require('src.libs.tools.types.string.string'),
    json = require('src.libs.tools.data.json.json'),
    utf8 = require('src.libs.tools.data.utf8.utf8'),
    base64 = require('src.libs.tools.data.base64.base64'),
    obfuscate = require('src.libs.tools.data.obfuscate.obfuscate'),
    text_formatter = require('src.libs.tools.data.text_formatter.text_formatter'),
    currency = require('src.libs.tools.types.currency.currency'),
    geometry = require('src.libs.tools.math.geometry.geometry'),
    rx = require('src.libs.tools.rx.rx'),
    matrix = {
        grid_helper = require('src.libs.tools.math.matrix.matrix_grid_helper')
    },
    IntervalTimer = Timers.IntervalTimer,
    TimeoutTimer = Timers.TimeoutTimer,
    AutosaveIntervalTimer = Timers.AutosaveIntervalTimer,
    AutosaveTimeoutTimer = Timers.AutosaveTimeoutTimer
}

return ToolLibs
