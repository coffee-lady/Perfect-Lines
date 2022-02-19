local ExecutorBase = require('animations.executor.executor_base')

local Sequence = ExecutorBase.Sequence

local SequenceHelper = {}

local function rand_circle_pos(center, radius)
    local angle_rand = math.random() * math.pi * 2

    local pos = vmath.vector3(center.x + math.cos(angle_rand) * radius, center.y + math.sin(angle_rand) * radius, center.z)
    return pos
end

function SequenceHelper.shake(executor, object, start_pos, radius, power, duration)
    local seq = Sequence()
    local step_dur = duration / (power + 1)

    for i = 1, power do
        local rand_pos = rand_circle_pos(start_pos, radius)

        seq:add(executor.move_to(rand_pos, step_dur, object):easing(go.EASING_OUTCIRC))
    end

    seq:add(executor.move_to(start_pos, step_dur, object):easing(go.EASING_OUTQUAD))

    return seq
end

function SequenceHelper.shake_x(executor, object, start_pos, power, delta_x, duration)
    local seq = Sequence()
    local step_dur = duration / (power + 1)

    for i = 1, power do
        local rand_pos = vmath.vector3(start_pos)
        local delta = delta_x * (0.85 + math.random() * 0.3)

        if i % 2 == 0 then
            delta = -delta
        end

        rand_pos.x = rand_pos.x + delta

        seq:add(executor.move_to(rand_pos, step_dur, object):easing(go.EASING_OUTCIRC))
    end

    seq:add(executor.move_to(start_pos, step_dur, object):easing(go.EASING_OUTQUAD))

    return seq
end

return SequenceHelper
