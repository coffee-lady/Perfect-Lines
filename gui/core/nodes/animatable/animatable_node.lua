local GUINode = require('gui.core.nodes.node.node')

local Easings = require('src.libs.tools.easings.easings')
local Math = require('src.libs.tools.math.math')

local Animations = require('animations.animations')
local TweenGUI = require('animations.tween.tween_gui')
local PathTween = require('animations.tween.path_tween')

local FULL_ANGLE = 360
local PERC = 100

local EasingsGUI = Easings.gui

--- @class AnimatableNode : Node
local AnimatableNode = class('AnimatableNode', GUINode)

function AnimatableNode:_create_tween(to, duration, anim_property)
    return TweenGUI(self, to, duration, anim_property)
end

local function check_duration(duration)
    assert(type(duration) == 'number')
    assert(duration >= 0)
end

function AnimatableNode:animate_move_to(to, duration)
    check_duration(duration)

    return self:_create_tween(to, duration, gui.PROP_POSITION)
end

function AnimatableNode:animate_fill_perc_to(perc, duration)
    check_duration(duration)

    local angle = perc * FULL_ANGLE / PERC

    return self:_create_tween(angle, duration, gui.PROP_FILL_ANGLE)
end

function AnimatableNode:animate_fill_angle_to(to, duration)
    check_duration(duration)

    return self:_create_tween(to, duration, gui.PROP_FILL_ANGLE)
end

function AnimatableNode:animate_move_path(path, duration)
    check_duration(duration)

    if #path < 2 then
        self:set_pos(path[1])
        return Animations.Sequence()
    end

    return PathTween(self, path, duration, EasingsGUI)
end

function AnimatableNode:animate_scale_to(to, duration)
    if type(to) == 'number' then
        to = vmath.vector3(to)
    end

    check_duration(duration)

    return self:_create_tween(to, duration, gui.PROP_SCALE)
end

function AnimatableNode:animate_scale_in(to, duration)
    local scale = self:get_scale()

    if type(to) == 'number' then
        to = vmath.vector3(to)
    end

    to.x = scale.x * to.x

    check_duration(duration)

    return self:_create_tween(to, duration, gui.PROP_SCALE)
end

function AnimatableNode:animate_size_to(to, duration)
    check_duration(duration)

    return self:_create_tween(to, duration, gui.PROP_SIZE)
end

function AnimatableNode:animate_rotate_to(to, duration)
    check_duration(duration)

    return self:_create_tween(to, duration, gui.PROP_ROTATION)
end

function AnimatableNode:animate_move_circle(perc_from, perc_to, duration, radius, circle_rotation)
    local path = {}

    for i = perc_from * FULL_ANGLE / PERC, perc_to * FULL_ANGLE / PERC do
        path[#path + 1] = Math.get_point_on_circle(i, radius, circle_rotation)
    end

    if #path < 2 then
        self:set_pos(path[1])
        return Animations.Sequence()
    end

    return self:animate_move_path(path, duration):easing(gui.EASING_LINEAR)
end

function AnimatableNode:animate_move_circle_back(perc_from, perc_to, duration, radius, circle_rotation)
    local path = {}

    for i = perc_from * FULL_ANGLE / PERC, perc_to * FULL_ANGLE / PERC, -1 do
        path[#path + 1] = Math.get_point_on_circle(i, radius, circle_rotation)
    end

    if #path < 2 then
        self:set_pos(path[1])
        return Animations.Sequence()
    end

    return self:animate_move_path(path, duration):easing(gui.EASING_LINEAR)
end

function AnimatableNode:animate_fill_angle(to, duration)
    return self:_create_tween(to, duration, gui.PROP_FILL_ANGLE)
end

local function fade_outline(self, duration, from, to)
    check_duration(duration)

    local start_color = self:get_outline()
    start_color.w = from

    local to_color = vmath.vector4(start_color)
    to_color.w = to

    local tween = self:create_tween(to_color, duration, gui.PROP_OUTLINE)

    return tween
end

local function fade_color(self, duration, from, to)
    check_duration(duration)

    local start_color = self:get_color()
    start_color.w = from

    local to_color = vmath.vector4(start_color)
    to_color.w = to

    local tween = self:_create_tween(to_color, duration, gui.PROP_COLOR)

    return tween
end

function AnimatableNode:animate_fade_to(duration, to, from)
    if not from then
        from = self:get_color().w
    end

    return fade_color(self, duration, from, to)
end

function AnimatableNode:animate_fade_in(duration)
    return fade_color(self, duration, 0, 1)
end

function AnimatableNode:animate_fade_out(duration)
    return fade_color(self, duration, 1, 0)
end

function AnimatableNode:animate_fade_in_outline(duration)
    return fade_outline(self, duration, 0, 1)
end

function AnimatableNode:animate_fade_out_outline(duration)
    return fade_outline(self, duration, 1, 0)
end

function AnimatableNode:animate_color_to(to, duration)
    return self:_create_tween(to, duration, gui.PROP_COLOR)
end

function AnimatableNode:animate_counter(prev_value, next_value, duration, update)
    return Animations.Counter(prev_value, next_value, duration, update or function(value)
        self:set_text(value)
    end)
end

return AnimatableNode
