local AnimatableNode = require('gui.core.nodes.animatable.animatable_node')
local Texture = require('gui.core.texture.texture')

--- @class BoxNode : AnimatableNode
local BoxNode = class('BoxNode', AnimatableNode)

function BoxNode:set_image(animation)
    gui.play_flipbook(self.target, animation)
    return self
end

--- @param texture Texture
function BoxNode:set_texture(texture)
    gui.set_texture(self.target, texture.id)
    return self
end

function BoxNode:set_texture_id(texture_id)
    gui.set_texture(self.target, texture_id)
    return self
end

function BoxNode:set_new_texture(id, buffer)
    local img = image.load(buffer)
    local size = vmath.vector3()
    size.x = img.width
    size.y = img.height
    local texture = Texture(id, size, img.type, img.buffer)

    self:set_texture(texture)
    return self
end

function BoxNode:get_actual_size()
    local sizes = self:get_size()
    local scale = self:get_scale()

    sizes.x = sizes.x * scale.x
    sizes.y = sizes.y * scale.y

    return sizes
end

return BoxNode
