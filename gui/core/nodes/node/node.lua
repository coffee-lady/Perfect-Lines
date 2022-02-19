--- @class Node
--- @field target table
local Node = class('Node')

function Node:initialize(node)
    if type(node) == 'string' then
        local status, node = pcall(gui.get_node, node)

        if status then
            self.target = node
        end
    else
        self.target = node
    end

    self.id = node
    self.id_copy = tostring(node)
    self.url = msg.url()
end

function Node:get_node()
    return self.target
end

function Node:get_id()
    return gui.get_id(self.target)
end

--- @param parent Node
function Node:set_parent(parent, keep_scene_transform)
    if not self.target then
        return
    end

    gui.set_parent(self.target, parent.target, keep_scene_transform)
end

function Node:clone()
    if not self.target then
        return
    end

    return gui.clone(self.target)
end

function Node:clone_tree()
    if not self.target then
        return
    end

    return gui.clone_tree(self.target)
end

function Node:set_scale(scale)
    if not self.target then
        return
    end

    if type(scale) == 'number' then
        scale = vmath.vector3(scale)
    end

    gui.set_scale(self.target, scale)

    return self
end

function Node:get_scale()
    if not self.target then
        return
    end

    return gui.get_scale(self.target)
end

function Node:set_size_mode(size_mode)
    if not self.target then
        return
    end

    gui.set_size_mode(self.target, size_mode)
    return self
end

function Node:get_size_mode()
    if not self.target then
        return
    end

    return gui.get_size_mode(self.target)
end

function Node:set_outline(outline)
    if not self.target then
        return
    end

    gui.set_outline(self.target, outline)
    return self
end

function Node:get_outline()
    if not self.target then
        return
    end

    return gui.get_outline(self.target)
end

function Node:set_rotation(rotation)
    if not self.target then
        return
    end

    gui.set_rotation(self.target, rotation)
    return self
end

function Node:get_rotation()
    if not self.target then
        return
    end

    return gui.get_rotation(self.target)
end

function Node:set_pos(pos)
    if not self.target then
        return
    end

    gui.set_position(self.target, pos)
    return self
end

function Node:get_screen_pos()
    if not self.target then
        return
    end

    return gui.get_screen_position(self.target)
end

function Node:set_size(size)
    if not self.target then
        return
    end

    gui.set_size(self.target, size)
    return self
end

function Node:set_size_xy(size_x, size_y)
    if not self.target then
        return
    end

    local size = gui.get_size(self.target)
    size.x = size_x or size.x
    size.y = size_y or size.y
    gui.set_size(self.target, size)
    return self
end

function Node:set_pos_xy(pos_x, pos_y)
    if not self.target then
        return
    end

    local pos = gui.get_position(self.target)
    pos.x = pos_x or pos.x
    pos.y = pos_y or pos.y
    gui.set_position(self.target, pos)
    return self
end

function Node:get_adjust_mode()
    if not self.target then
        return
    end

    return gui.get_adjust_mode(self.target)
end

function Node:set_adjust_mode(adjust_mode)
    if not self.target then
        return
    end

    gui.set_adjust_mode(self.target, adjust_mode)
    return self
end

function Node:get_size()
    if not self.target then
        return
    end

    return gui.get_size(self.target)
end

function Node:get_width()
    if not self.target then
        return
    end

    return gui.get_size(self.target).x
end

function Node:get_height()
    if not self.target then
        return
    end

    return gui.get_size(self.target).y
end

function Node:get_pos()
    if not self.target then
        return
    end

    return gui.get_position(self.target)
end

function Node:set_color(color)
    if not self.target then
        return
    end

    gui.set_color(self.target, color)
    return self
end

function Node:get_color()
    if not self.target then
        return
    end

    return gui.get_color(self.target)
end

function Node:is_picked(action)
    if not self.target then
        return
    end

    return gui.pick_node(self.target, action.x, action.y)
end

function Node:is_pressed(action)
    return self:is_picked(action) and action.pressed
end

function Node:is_released(action)
    return self:is_picked(action) and action.released
end

function Node:set_enabled(is_enabled)
    if not self.target then
        return
    end

    gui.set_enabled(self.target, is_enabled)
    return self
end

function Node:is_enabled()
    if not self.target then
        return
    end

    return gui.is_enabled(self.target)
end

function Node:get_screen_position()
    if not self.target then
        return
    end

    return gui.get_screen_position(self.target)
end

function Node:set_alpha(alpha)
    if not self.target then
        return
    end

    gui.set_alpha(self.target, alpha)
    return self
end

function Node:get_actual_size()
    if not self.target then
        return
    end

    local sizes = self:get_size()

    return sizes
end

function Node:delete()
    gui.delete_node(self.target)
    self.target = nil
end

function Node.ids_from_template(template_id, nodes)
    local ids = {}

    for key, value in pairs(nodes) do
        ids[key] = template_id .. '/' .. value
    end

    return ids
end

return Node
