local Animations = require('animations.animations')
local TweenGUI = require('animations.tween.tween_gui')

--- @class NodesList
local NodesList = class('NodesList')

function NodesList:initialize(...)
    self.nodes = {...}
end

function NodesList:from_arr(arr)
    self.nodes = arr

    return self
end

function NodesList:add(node)
    self.nodes[#self.nodes + 1] = node
end

--- @param gui_object Node
function NodesList:set(key, gui_object)
    self.nodes[key] = gui_object
end

function NodesList:get(key)
    return self.nodes[key]
end

function NodesList:set_color(color)
    for _, node in pairs(self.nodes) do
        node:set_color(color)
    end
end

function NodesList:set_scale(scale)
    for _, node in pairs(self.nodes) do
        node:set_scale(scale)
    end
end

function NodesList:set_size(size)
    for _, node in pairs(self.nodes) do
        node:set_size(size)
    end
end

function NodesList:set_text(text)
    for _, node in pairs(self.nodes) do
        node:set_text(text)
    end
end

function NodesList:set_enabled(is_enabled)
    for _, node in pairs(self.nodes) do
        node:set_enabled(is_enabled)
    end
end

function NodesList:set_image(animation)
    for _, node in pairs(self.nodes) do
        node:set_image(animation)
    end
end

function NodesList:scale_to(sizes)
    for _, node in pairs(self.nodes) do
        node:scale_to(sizes)
    end
end

function NodesList:delete()
    for _, node in pairs(self.nodes) do
        node:delete()
    end
end

function NodesList:animate_color_to(to, duration)
    local seq = Animations.Sequence()

    for _, node in pairs(self.nodes) do
        seq:join(self:_create_tween(node, to, duration, gui.PROP_COLOR))
    end

    return seq
end

function NodesList:_create_tween(node, to, duration, anim_property)
    return TweenGUI(node, to, duration, anim_property)
end

return NodesList
