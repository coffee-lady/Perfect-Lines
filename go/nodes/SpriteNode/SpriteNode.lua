local AnimatableNode = require('go.nodes.AnimatableNode.AnimatableNode')

--- @class SpriteNode : AnimatableNode
local SpriteNode = class('SpriteNode', AnimatableNode)

function SpriteNode:initialize(id, node_component)
    AnimatableNode.initialize(self, id, node_component or 'sprite')
end

function SpriteNode:set_image(animation)
    sprite.play_flipbook(self.id, hash(animation))
    return self
end

--- @param texture Texture
function SpriteNode:set_texture(texture)
    go.set(self.id, 'image', texture)
    return self
end

function SpriteNode:set_color(color)
    if not self.id then
        return
    end

    go.set(self.id, 'tint', color)

    return self
end

function SpriteNode:get_color()
    if not self.id then
        return
    end

    return go.get(self.id, 'tint')
end

function SpriteNode:get_size()
    if not self.id then
        return
    end

    return go.get(self.id, 'size')
end

return SpriteNode
