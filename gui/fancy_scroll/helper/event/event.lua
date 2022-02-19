local EventSimple = class('EventSimple')

function EventSimple:initialize()
    self.callbacks = {}
end

function EventSimple:find_callback(func, caller)
    if not func then
        return nil
    end

    for i = 1, #self.callbacks do
        local callback_data = self.callbacks[i]
        if callback_data.func == func then
            if not caller or caller == callback_data.caller then
                return callback_data, i
            end
        end
    end

    return nil
end

function EventSimple:add(func_execute, caller)
    if not func_execute or self:find_callback(func_execute, caller) then
        return
    end

    local execute_func = func_execute

    if caller then
        execute_func = function(...)
            func_execute(caller, ...)
        end
    end

    local calback_data = {
        func = func_execute,
        caller = caller,
        execute_func = execute_func
    }

    table.insert(self.callbacks, calback_data)
end

function EventSimple:remove(func_execute, self_instance)
    local callback_data, index = self:find_callback(func_execute, self_instance)
    if callback_data then
        table.remove(self.callbacks, index)
    end
end

function EventSimple:clear()
    for i = 1, #self.callbacks do
        self.callbacks[i] = nil
    end
end

function EventSimple:call(...)
    for i = 1, #self.callbacks do
        self.callbacks[i].execute_func(...)
    end
end

function EventSimple:__call(...)
    self:call(...)
end

return EventSimple
