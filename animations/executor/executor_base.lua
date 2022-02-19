local Sequence = require('animations.sequence.sequence')
local SequenceExecutorCallback = require('animations.sequence.sequence_executor_callback')
local CounterTween = require('animations.tween.counter_tween')

local Executor = {}

Executor.PathTween = require('animations.tween.path_tween')

function Executor.Sequence()
    local executor = SequenceExecutorCallback()

    return Sequence(executor)
end

function Executor.Counter(prev_value, next_value, duration, update)
    return CounterTween(prev_value, next_value, duration, update)
end

return Executor
