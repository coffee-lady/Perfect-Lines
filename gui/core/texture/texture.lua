--- @class Texture
local Texture = class('Texture')

Texture.TYPE = {
    RGB = 'rgb',
    RGBA = 'rgba',
    LUMINANCE = 'l'
}

function Texture:initialize(id, size, type, buffer, flip)
    self.id = id

    if flip == nil then
        flip = false
    end

    gui.new_texture(id, size.x, size.y, type, buffer, flip)
end

function Texture:set_data(size, type, buffer, flip)
    if flip == nil then
        flip = false
    end

    gui.set_texture_data(self.id, size.x, size.y, type, buffer, flip)
end

return Texture
