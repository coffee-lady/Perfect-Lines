local Math = require('src.libs.tools.math.math')
local Animations = require('animations.animations')
local AbstractButton = require('gui.controls.abstract_button.abstract_button')

local DEFAULT = {blackout = 0.1, scale = vmath.vector3(0.9, 0.9, 0), duration = 0.08, easing = gui.EASING_INBACK}

--- @class Button : AbstractButton
local Button = class('Button', AbstractButton)

Button.__cparams = {'scenes_service'}

function Button:initialize(scenes_service, ids, on_click)
    AbstractButton.initialize(self, scenes_service, ids, on_click)

    self:_set_animation_pressed()
    self:_set_animation_released()
end

function Button:press()
    if not self.animation_released:is_running() and not self.animation_pressed:is_running() then
        AbstractButton.press(self)
        self:_set_animation_pressed()
        self.animation_pressed:run()
        self:_set_animation_released()
    end
end

function Button:release()
    if not self.animation_released:is_running() and not self.animation_pressed:is_running() then
        AbstractButton.release(self)
        self.animation_released:run()
    end
end

function Button:_set_animation_released(config)
    config = config or {}

    local color_from = self.nodes.inner:get_color()

    local duration = config.duration or DEFAULT.duration

    self.animation_released = self:_create_animation(self._scale, color_from, duration)
end

function Button:_set_animation_pressed(config)
    config = config or {}

    local color_from = self.nodes.inner:get_color()

    local blackout = config.blackout or DEFAULT.blackout
    local scale_to = config.scale or DEFAULT.scale
    local duration = config.duration or DEFAULT.duration
    local color_to = self:_get_color_to(color_from, blackout)

    self._native_color = color_from

    self.animation_pressed = self:_create_animation(scale_to, color_to, duration)
end

function Button:_create_animation(scale, color, duration)
    local seq = Animations.Sequence()

    scale = vmath.vector3(scale)

    local node_scale = self.nodes.inner:get_scale()
    scale.x = scale.x * Math.sign(node_scale.x)
    scale.y = scale.y * Math.sign(node_scale.y)

    seq:add(self.nodes.inner:animate_scale_to(scale, duration))
    seq:join(self.nodes.inner:animate_color_to(color, duration))

    if self.nodes.icon_wrapper then
        seq:join(self.nodes.icon_wrapper:animate_color_to(color, duration))
    end

    return seq
end

function Button:_get_color_to(color, blackout)
    local color_to = vmath.vector4()

    for _, key in pairs({'x', 'y', 'z'}) do
        color_to[key] = color[key] - blackout > 0 and color[key] - blackout or 0
    end

    color_to.w = 1

    return color_to
end

function Button:hide()
    AbstractButton.hide(self)
    self.nodes.inner:set_color(self._native_color)
end

return Button
