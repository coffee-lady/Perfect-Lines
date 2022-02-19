local class = require('src.libs.tools.middleclass.middleclass')
local Subscription = require('src.libs.tools.rx.classes.subscription')
local Array = require('src.libs.tools.types.array.array')

--- @class Observable
local Observable = class('Observable')

function Observable:initialize()
    self.subscribers = {}
    self.completed = false
end

function Observable:next(value)
    if self.completed then
        return
    end

    for i = 1, #self.subscribers do
        if self.subscribers[i] then
            self.subscribers[i]:next(value)
        end
    end
end

function Observable:next_with_exceptions(value, exceptions)
    if self.completed then
        return
    end

    exceptions = exceptions or {}

    for i = 1, #self.subscribers do
        if Array.first_index_of(self.subscribers[i], exceptions) then
            self.subscribers[i]:next(value)
        end
    end
end

function Observable:subscribe(object_self, next, complete)
    local subscription =
        Subscription(
        object_self,
        next,
        complete,
        function(subscriber)
            self:remove(subscriber)
        end
    )

    table.insert(self.subscribers, subscription)

    return subscription
end

function Observable:remove(subscriber)
    for i = 1, #self.subscribers do
        if self.subscribers[i] == subscriber then
            table.remove(self.subscribers, i)
            break
        end
    end
end

function Observable:complete()
    for i = 1, #self.subscribers do
        self.subscribers[i]:complete()
        self.subscribers[i]:unsubscribe()
    end

    self.completed = true

    self.subscribers = {}
end

return Observable
