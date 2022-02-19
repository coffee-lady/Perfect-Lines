local class = require('src.libs.tools.middleclass.middleclass')

local Subscriber = class('Subscriber')

function Subscriber:initialize(object_self, next, complete, _unsubs_behavior)
    self._object_self = object_self
    self._next = next
    self._complete = complete
    self._unsubscribe_behavior = _unsubs_behavior

    self.completed = false
end

function Subscriber:next(value)
    if self.completed then
        return
    end

    if self._next then
        self._next(self._object_self, value)
    end
end

function Subscriber:complete()
    if self.completed then
        return
    end

    if self._complete then
        self._complete(self._object_self)
    end

    self.completed = true
end

function Subscriber:unsubscribe()
    if self.completed then
        return
    end

    self._unsubscribe_behavior(self)
    self.completed = true
end

return Subscriber
