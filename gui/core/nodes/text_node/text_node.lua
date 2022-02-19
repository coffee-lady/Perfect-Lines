local AnimatableNode = require('gui.core.nodes.animatable.animatable_node')

--- @class TextNode : AnimatableNode
local TextNode = class('TextNode', AnimatableNode)

function TextNode:set_text(text)
    gui.set_text(self.target, text)
    return self
end

function TextNode:get_text()
    return gui.get_text(self.target)
end

function TextNode:set_font(font)
    gui.set_font(self.target, font)
    return self
end

function TextNode:get_font()
    return gui.get_font(self.target)
end

function TextNode:get_actual_size()
    local metrics = self:get_metrics()
    local scale = self:get_scale()

    local sizes = vmath.vector3()
    sizes.x = metrics.width * scale.x
    sizes.y = metrics.height * scale.y

    return sizes
end

function TextNode:get_metrics()
    return gui.get_text_metrics_from_node(self.target)
end

function TextNode:set_fit_text(text)
    self:set_text(text)

    local scale = self:get_scale()

    local text_metrics = self:get_metrics()
    local node_size = self:get_size()

    local node_scale = math.min(scale.x, node_size.x / text_metrics.width)

    if node_scale * text_metrics.height > node_size.y then
        node_scale = node_size.y / text_metrics.height
    end

    self:set_scale(node_scale)
    return self
end

return TextNode
