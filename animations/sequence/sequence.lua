local SequencePart = require('animations.sequence.sequence_part')
local SequenceExecutorCallback = require('animations.sequence.sequence_executor_callback')

--- @class Sequence
local Sequence = class('Sequence')

local function check_time_value(val)
    assert(type(val) == 'number')
    assert(val >= 0)
end

function Sequence:initialize()
    self.parts = {}

    self.current_time = 0
    self.last_start_time = 0
    self.sequence_duration = 0

    self.is_loop = false

    self.sequence_executor = SequenceExecutorCallback()
end

function Sequence:is_running()
    return self.sequence_executor.is_running
end

function Sequence:get_duration()
    return self.sequence_duration
end

--- @param tween Tween
function Sequence:add(tween)
    local duration = assert(tween:get_duration())

    local part = SequencePart(self.current_time, duration):from_tween(tween)

    self:_update_duration(part)
    self:_adjust_start_time(duration)

    table.insert(self.parts, part)

    return self
end

function Sequence:add_callback(callback)
    local part = SequencePart(self.current_time, 0):from_callback(callback)

    self:_update_duration(part)

    self.last_start_time = self.current_time

    table.insert(self.parts, part)

    return self
end

function Sequence:add_delay(delay)
    local part = SequencePart(self.current_time, delay)

    self:_update_duration(part)
    self:_adjust_start_time(delay)

    table.insert(self.parts, part)

    return self
end

function Sequence:insert(at_time, tween)
    check_time_value(at_time)
    assert(tween)

    local duration = tween:get_duration()
    local part = SequencePart(at_time, duration):from_tween(tween)

    self:_update_duration(part)

    local end_time = at_time + duration

    if end_time > self.current_time then
        self:_adjust_start_time(end_time - self.current_time)
    end

    table.insert(self.parts, part)

    return self
end

function Sequence:insert_callback(at_time, callback)
    check_time_value(at_time)

    local part = SequencePart(at_time, 0):from_callback(callback)

    self:_update_duration(part)

    if at_time > self.current_time then
        self:_adjust_start_time(at_time - self.current_time)
    end

    table.insert(self.parts, part)

    return self
end

function Sequence:join(tween)
    if #self.parts == 0 then
        self:add(tween)
        return
    end
    assert(tween)

    local duration = assert(tween:get_duration())

    local part = SequencePart(self.last_start_time, duration):from_tween(tween)

    local old_duration = self:get_duration()

    self:_update_duration(part)

    local complete_time = self.last_start_time + duration

    if complete_time > old_duration then
        self.current_time = self.current_time + complete_time - self.current_time
    end

    table.insert(self.parts, part)

    return self
end

function Sequence:join_callback(callback)
    assert(callback)

    local part = SequencePart(self.last_start_time, 0):from_callback(callback)

    table.insert(self.parts, part)

    return self
end

function Sequence:set_loop(value)
    self.is_loop = value
end

function Sequence:cancel()
    self.sequence_executor:cancel()
end

function Sequence:reset_tweens()
    for i = 1, #self.parts do
        local part = self.parts[i]

        if part then
            part:cancel()
        end
    end
end

function Sequence:run()
    self.sequence_executor:run(self)
end

function Sequence:run_async()
    self.sequence_executor:run_async(self)
end

function Sequence:_adjust_start_time(value)
    self.last_start_time = self.current_time
    self.current_time = self.current_time + value
end

function Sequence:_update_duration(part)
    local last_duration = part.start_time + part.duration

    if last_duration > self.sequence_duration then
        self.sequence_duration = last_duration
    end
end

return Sequence
