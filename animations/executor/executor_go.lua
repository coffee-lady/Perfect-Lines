local Easings = require('src.libs.tools.easings.easings')

local TweenGO = require('animations.tween.tween_go')
local ExecutorBase = require('animations.executor.executor_base')
local SequenceHelper = require('animations.sequence.sequence_helper')

local EasingsGO = Easings.go
local PathTween = ExecutorBase.PathTween

local ExecutorGO = {}

ExecutorGO.sequence = ExecutorBase.Sequence
ExecutorGO.counter = ExecutorBase.Counter

local PROP_POSITION = hash('position')
local PROP_SCALE = hash('scale')
local PROP_TINT = hash('tint')
local PROP_COLOR = hash('color')
local PROP_ROTATION = hash('rotation')
local PROP_EULER = hash('euler')

function ExecutorGO.create_tween(object, to, duration, anim_property)
    object = msg.url(object)

    local tween = TweenGO(object, to, duration, anim_property)

    return tween
end

function ExecutorGO.move_to(to, duration, object)
    object = object or go.get_id()

    local tween = ExecutorGO.create_tween(object, to, duration, PROP_POSITION)

    return tween
end

function ExecutorGO.rotate_to(to, duration, object)
    object = object or go.get_id()

    local tween = ExecutorGO.create_tween(object, to, duration, PROP_ROTATION)

    return tween
end

function ExecutorGO.euler_to(to, duration, object)
    object = object or go.get_id()

    local tween = ExecutorGO.create_tween(object, to, duration, PROP_EULER)

    return tween
end

function ExecutorGO.scale_to(to, duration, object)
    if type(to) == 'number' then
        to = vmath.vector3(to)
    end

    object = object or go.get_id()

    local tween = ExecutorGO.create_tween(object, to, duration, PROP_SCALE)

    return tween
end

function ExecutorGO.tint_to(url, to_color, duration)
    assert(url)
    return ExecutorGO.create_tween(url, to_color, duration, PROP_TINT)
end

function ExecutorGO.color_to(url, to_color, duration)
    assert(url)
    return ExecutorGO.create_tween(url, to_color, duration, PROP_COLOR)
end

function ExecutorGO.move_path(path, duration, object)
    assert(path, 'must define path')

    object = object or go.get_id()

    local tween = PathTween(object, path, duration, EasingsGO, go.set_position)

    return tween
end

function ExecutorGO.shake_sequence(radius, duration, power, object)
    object = object or go.get_id()

    local start_pos = go.get_position(object)

    return SequenceHelper.shake_sequence(ExecutorGO, object, start_pos, radius, power, duration)
end

function ExecutorGO.shake_sequence_x(delta_x, duration, power, object)
    object = object or go.get_id()

    local start_pos = go.get_position(object)

    return SequenceHelper.shake_x_sequence(ExecutorGO, object, start_pos, power, delta_x, duration)
end

return ExecutorGO
