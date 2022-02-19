--- @class SequencePart
local SequencePart = class('SequencePart')

function SequencePart:initialize(start_time, duration)
    self.start_time = start_time
    self.duration = duration

    self.on_run = function()
    end

    self.on_cancel = function()
    end
end

--- @param tween Tween
function SequencePart:from_tween(tween)
    self.on_run = function()
        tween:run()
    end

    self.on_cancel = function()
        tween:cancel()
    end

    return self
end

function SequencePart:from_callback(func)
    self.on_run = func

    return self
end

function SequencePart:run()
    self.on_run()
end

function SequencePart:cancel()
    self.on_cancel()
end

function SequencePart:get_duration()
    return self.duration
end

function SequencePart:get_start_time()
    return self.start_time
end

return SequencePart
