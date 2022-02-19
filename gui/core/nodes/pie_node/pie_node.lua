local AnimatableNode = require('gui.core.nodes.animatable.animatable_node')

local FULL_ANGLE = 360
local PERC = 100

--- @class PieNode : AnimatableNode
local PieNode = class('PieNode', AnimatableNode)

function PieNode:set_image(animation)
    gui.play_flipbook(self.target, animation)
    return self
end

function PieNode:get_actual_size()
    local sizes = self:get_size()
    local scale = self:get_scale()

    sizes.x = sizes.x * scale.x
    sizes.y = sizes.y * scale.y

    return sizes
end

function PieNode:set_fill_angle(angle)
    gui.set_fill_angle(self.target, angle)
    return self
end

function PieNode:set_fill_angle_perc(angle_perc)
    gui.set_fill_angle(self.target, angle_perc * FULL_ANGLE / PERC)
    return self
end

return PieNode
