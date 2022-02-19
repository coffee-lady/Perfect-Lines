local Tools = require('src.libs.tools.tools')

local Libs = {
    math = Tools.math,
    easings = Tools.easings,
    color = Tools.color,
    date = Tools.date,
    event_observation = Tools.event_observation,
    middleclass = Tools.middleclass,
    linked_list = Tools.linked_list,
    array = Tools.array,
    async = Tools.async,
    IntervalTimer = Tools.IntervalTimer,
    TimeoutTimer = Tools.TimeoutTimer,
    AutosaveIntervalTimer = Tools.AutosaveIntervalTimer,
    AutosaveTimeoutTimer = Tools.AutosaveTimeoutTimer,
    string = Tools.string,
    inspect = Tools.inspect,
    json = Tools.json,
    base64 = Tools.base64,
    obfuscate = Tools.obfuscate,
    text_formatter = Tools.text_formatter,
    matrix = Tools.matrix,
    utf8 = Tools.utf8,
    currency = Tools.currency,
    geometry = Tools.geometry,
    rx = Tools.rx,
    debug = require('src.libs.debug.debug'),
    event_bus = require('src.libs.event_bus.event_bus'),
    SubscriptionsMap = require('src.libs.event_bus.subscriptions_map'),
    resources_storage = require('src.libs.resources_storage.resources_storage'),
    ScriptWrapper = require('src.libs.script_wrapper.ScriptWrapper'),
    ScriptInstance = require('src.libs.ScriptInstance.ScriptInstance'),
    Event = require('src.libs.Event.Event'),
    luject = require('src.libs.luject.luject'),
    scenes = require('src.libs.scenes.scenes')
}

return Libs
