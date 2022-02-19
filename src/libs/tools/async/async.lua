local Promise = require('src.libs.tools.async.promise.promise')

local Async = {}

local RUNNING = 0
local YIELDED = 1
local DONE = 2

local unpack = _G.unpack or table.unpack

Async.Promise = Promise

function Async.bootstrap(func, ...)
    local main_thread = coroutine.create(func)

    coroutine.resume(main_thread, ...)
end

function Async.bootstrap_fn(func)
    return function()
        Async.bootstrap(func)
    end
end

function Async.async(fn, ...)
    assert(fn)

    local co = coroutine.running()
    assert(co)

    local results = nil
    local state = RUNNING

    fn(function(...)

        results = {...}
        if state == YIELDED then
            local res, error = coroutine.resume(co)

            if not res then
                print(error)
                print(debug.traceback())
            end
        else
            state = DONE
        end
    end, ...)

    if state == RUNNING then
        state = YIELDED
        coroutine.yield()

        state = DONE
    end

    return unpack(results)
end

function Async.http_request(url, method, headers, post_data, options)
    return Async.async(function(done)
        http.request(url, method, function(_, _, response)
            done(response)
        end, headers, post_data, options)
    end)
end

function Async.delay(time)
    Async.async(function(done)
        timer.delay(time, false, done)
    end)
end

setmetatable(Async, {
    __call = function(_, ...)
        return Async.async(...)
    end,
})

return Async
