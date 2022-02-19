--- @class GONode
--- @field id hash
local Node = class('Node')

function Node:initialize(id, node_component)
    self.id = msg.url(nil, id, node_component)
end

function Node:get_id()
    return self.id
end

--- @param parent Node
function Node:set_parent(parent, keep_scene_transform)
    if not self.id then
        return
    end

    go.set_parent(self.id, parent.id, keep_scene_transform)
end

function Node:set_scale(scale)
    if not self.id then
        return
    end

    if type(scale) == 'number' then
        scale = vmath.vector3(scale)
    end

    go.set_scale(scale, self.id)

    return self
end

function Node:get_scale()
    if not self.id then
        return
    end

    return go.get_scale(self.id)
end

function Node:set_rotation(rotation)
    if not self.id then
        return
    end

    go.set_rotation(rotation, self.id)

    return self
end

function Node:get_rotation()
    if not self.id then
        return
    end

    return go.get_rotation(self.id)
end

function Node:set_pos(pos)
    if not self.id then
        return
    end

    go.set_position(pos, self.id)
    return self
end

function Node:get_world_pos()
    if not self.id then
        return
    end

    return go.get_world_position(self.id)
end

function Node:set_pos_xy(pos_x, pos_y)
    if not self.id then
        return
    end

    local pos = go.get_position(self.id)
    pos.x = pos_x or pos.x
    pos.y = pos_y or pos.y
    go.set_position(pos, self.id)
    return self
end

function Node:get_pos()
    if not self.id then
        return
    end

    return go.get_position(self.id)
end

function Node:set_enabled(is_enabled)
    if not self.id then
        return
    end

    msg.post(self.id, is_enabled and 'enable' or 'disable')
    return self
end

function Node:delete()
    go.delete(self.id)
    self.id = nil
end

return Node
