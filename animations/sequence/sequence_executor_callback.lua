--- @class SequenceExecutorCallback
local SequenceExecutorCallback = class('SequenceExecutor')

local log = function(...)
end

function SequenceExecutorCallback:initialize()
    --- @type Sequence
    self.run_sequence = nil
end

function SequenceExecutorCallback:debug()
    log = pprint
end

function SequenceExecutorCallback:run(sequence)
    if self.is_running then
        log('already running!')
        return
    end

    self.run_sequence = sequence
    sequence:reset_tweens()

    self.is_running = true

    self:_init_run_data()
    self:_execute_next()
end

function SequenceExecutorCallback:run_async(sequence)
    if self.run_sequence then
        log('already running!!')
        return
    end

    self.thread_co = coroutine.running()
    assert(self.thread_co)

    self:run(sequence)
    coroutine.yield()
end

function SequenceExecutorCallback:cancel_timer()
    if self.sequence_timer then
        timer.cancel(self.sequence_timer)
        self.sequence_timer = nil
    end
end

function SequenceExecutorCallback:cancel()
    if not self.run_sequence or not self.is_running then
        log('Sequence is not running')
        return
    end

    self:cancel_timer()
    self.run_sequence:reset_tweens()
    self:complete_sequence()
end

function SequenceExecutorCallback:complete_sequence()
    self.is_running = false
    self.co = nil

    if self.thread_co then
        coroutine.resume(self.thread_co)
        self.thread_co = nil
    end

    self.run_sequence = nil
end

function SequenceExecutorCallback:_init_run_data()
    local sequence = self.run_sequence
    local parts = sequence.parts

    self.cur_time = 0
    self.last_run_block = 0

    table.sort(
        parts,
        function(a, b)
            return a.start_time < b.start_time
        end
    )
end

function SequenceExecutorCallback:_execute_next()
    local sequence = self.run_sequence
    local parts = sequence.parts

    local wait_time, next_time = self:_execute_block_time(self.cur_time, parts)

    if next_time ~= math.huge then
        wait_time = next_time - self.cur_time
    end

    if wait_time <= 0 then
        if not sequence.is_loop or not self.is_running then
            self:complete_sequence()
            return
        else
            self.cur_time = 0
            self.last_run_block = 0
        end
    end

    local time_hack = 0.0001

    self.sequence_timer =
        timer.delay(
        wait_time + time_hack,
        false,
        function()
            self:_execute_next()
        end
    )

    self.cur_time = self.cur_time + wait_time
end

function SequenceExecutorCallback:_execute_block_time(run_time, parts)
    local wait_time = 0
    local next_time = math.huge

    for i = self.last_run_block + 1, #parts do
        local part = parts[i]

        if run_time >= part.start_time then
            self.last_run_block = i

            part:run()

            if part.duration > wait_time then
                wait_time = part.duration
            end
        elseif run_time < part.start_time and next_time > part.start_time then
            next_time = part.start_time
        end
    end

    return wait_time, next_time
end

return SequenceExecutorCallback
