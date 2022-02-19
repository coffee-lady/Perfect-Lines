local AnimatableNode = require('go.nodes.AnimatableNode.AnimatableNode')

--- @class CollisionNode : AnimatableNode
local CollisionNode = class('CollisionNode', AnimatableNode)

function CollisionNode:initialize(id, node_component)
    AnimatableNode.initialize(self, id, node_component or 'collisionobject')
end

function CollisionNode:get_mass()
    if not self.id then
        return
    end

    return go.get(self.id, 'mass')
end

function CollisionNode:get_angular_velocity()
    if not self.id then
        return
    end

    return go.get(self.id, 'angular_velocity')
end

function CollisionNode:set_angular_velocity(angular_velocity)
    if not self.id then
        return
    end

    go.set(self.id, 'angular_velocity', angular_velocity)

    return self
end

function CollisionNode:get_linear_damping()
    if not self.id then
        return
    end

    return go.get(self.id, 'linear_damping')
end

function CollisionNode:set_linear_damping(linear_damping)
    if not self.id then
        return
    end

    go.set(self.id, 'linear_damping', linear_damping)

    return self
end

function CollisionNode:get_angular_damping()
    if not self.id then
        return
    end

    return go.get(self.id, 'angular_damping')
end

function CollisionNode:set_angular_damping(angular_damping)
    if not self.id then
        return
    end

    go.set(self.id, 'angular_damping', angular_damping)

    return self
end

function CollisionNode:get_linear_velocity()
    if not self.id then
        return
    end

    return go.get(self.id, 'linear_velocity')
end

function CollisionNode:set_linear_velocity(linear_velocity)
    if not self.id then
        return
    end

    go.set(self.id, 'linear_velocity', linear_velocity)

    return self
end

return CollisionNode
