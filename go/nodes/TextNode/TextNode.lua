local AnimatableNode = require('go.nodes.AnimatableNode.AnimatableNode')

--- @class TextNode : AnimatableNode
local TextNode = class('TextNode', AnimatableNode)

function TextNode:initialize(id)
    AnimatableNode.initialize(self, id)
end

function TextNode:set_text(text)
    if not self.id then
        return
    end

    go.set(self.id, 'text', text)

    return self
end

function TextNode:get_text(color)
    if not self.id then
        return
    end

    return go.get(self.id, 'text')
end

function TextNode:set_color(color)
    if not self.id then
        return
    end

    go.set(self.id, 'color', color)

    return self
end

function TextNode:get_color(color)
    if not self.id then
        return
    end

    return go.get(self.id, 'color')
end

function TextNode:get_metrics(color)
    if not self.id then
        return
    end

    return label.get_text_metrics(self.id)
end

return TextNode
