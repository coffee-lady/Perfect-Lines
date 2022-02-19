--- @class SequenceExecutor
local SequenceExecutor = class('SequenceExecutor')

local log = function(...)
end

function SequenceExecutor:initialize()
    --- @type Sequence
    self.run_sequence = nil
end

function SequenceExecutor:debug()
    log = pprint
end

--- @param sequence Sequence
function SequenceExecutor:run(sequence)
    if self.is_running then
        log('already running!!')
        return
    end

    self.run_sequence = sequence
    sequence:reset_tweens()

    self.is_running = true

    self.co = coroutine.create(function()
        self:execute_sequence()
    end)

    local status, error = coroutine.resume(self.co, self)

    if not status then
        print(error)
    end
end

--- @param sequence Sequence
function SequenceExecutor:run_async(sequence)
    if self.run_sequence then
        log('already running!!')
        return
    end

    self.thread_co = coroutine.running()
    assert(self.thread_co)
    self:run(sequence)

    coroutine.yield()
end

function SequenceExecutor:cancel_timer()
    if self.sequence_timer then
        timer.cancel(self.sequence_timer)
        self.sequence_timer = nil
    end
end

function SequenceExecutor:cancel()
    if not self.run_sequence or not self.is_running then
        log('Sequence no running')
        return
    end

    self:cancel_timer()
    self.run_sequence:reset_tweens()
    self:complete_sequence()
end

function SequenceExecutor:complete_sequence()
    self.is_running = false
    self.co = nil

    if self.thread_co then
        coroutine.resume(self.thread_co)
        self.thread_co = nil
    end

    self.run_sequence = nil
end

function SequenceExecutor:execute_sequence()
    local sequence = self.run_sequence
    local parts = sequence.parts

    local cur_time = 0

    table.sort(parts, function(a, b)
        return a.start_time < b.start_time
    end)

    local last_run_block = 0

    while true do
        local wait_time = 0
        local next_time = math.huge

        for i = last_run_block + 1, #parts do
            local part = parts[i]

            if cur_time >= part.start_time then
                last_run_block = i

                part:run()

                if part.duration > wait_time then
                    wait_time = part.duration
                end
            elseif cur_time < part.start_time and next_time > part.start_time then
                next_time = part.start_time
            end
        end

        if next_time ~= math.huge then
            wait_time = next_time - cur_time
        end

        if wait_time == 0 then
            if not sequence.is_loop or not self.is_running then
                break
            else
                cur_time = 0
                last_run_block = 0
            end
        end

        self:_set_sequence_timer(wait_time)

        cur_time = cur_time + wait_time
        coroutine.yield()
    end

    self:complete_sequence()
end

function SequenceExecutor:_set_sequence_timer(wait_time)
    local time_hack = 0.0001

    self.sequence_timer = timer.delay(wait_time + time_hack, false, function()
        if not self.co then
            return
        end

        local status, err = coroutine.resume(self.co)

        if not status then
            pprint(err)
        end
    end)
end

return SequenceExecutor
