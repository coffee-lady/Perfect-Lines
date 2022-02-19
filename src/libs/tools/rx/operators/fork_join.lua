local Observable = require('src.libs.tools.rx.classes.observable')

local function fork_join(...)
    local subscribers = {...}
    local completed = 0
    local results = {}
    local observer = Observable()

    local function process()
        completed = completed + 1

        if completed == #subscribers then
            observer:next(results)
            observer:complete(results)
        end
    end

    if #subscribers == 0 then
        return results
    end

    for i = 1, #subscribers do
        if subscribers[i].completed then
            process()
        else
            subscribers[i]:subscribe(nil, function(value)
                process()
                results[i] = value
            end)
        end
    end

    return observer
end

return fork_join
