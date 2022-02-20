local Collection = require('src.libs.Collection.Collection')
local ScriptInstance = require('src.libs.ScriptInstance.ScriptInstance')

local Event = class('Event')

function Event:initialize()
    self.callbacks = Collection:new()
end

function Event:emit(...)
    local caller_script = ScriptInstance:get_instance()
    local len = self.callbacks:length()
    local res = nil

    for i = 1, len do
        local callback_data = self.callbacks:at(i)

        if callback_data.caller_script then
            ScriptInstance:set_instance(callback_data.caller_script)
        else
            ScriptInstance:set_instance(caller_script)
        end

        local caller = callback_data.caller

        if caller then
            res = callback_data.callback(caller, ...)
        else
            res = callback_data.callback(...)
        end
    end

    ScriptInstance:set_instance(caller_script)

    return res
end

function Event:add(callback, caller)
    assert(callback, debug.traceback())

    local cb_data = {caller_script = ScriptInstance:get_instance(), callback = callback, caller = caller}

    self.callbacks:push(cb_data)

    return self
end

function Event:clear()
    self.callbacks:clear()
    return self
end

function Event:remove(callback)
    assert(callback)

    for i = 1, self.callbacks:length() do
        local callback_data = self.callbacks:at(i)

        if callback_data.callback == callback then
            self.callbacks:remove(callback_data)
            return
        end
    end

    return self
end

if _G then
    _G.Event = function(...)
        return inject(Event, ...)
    end
end

return Event
