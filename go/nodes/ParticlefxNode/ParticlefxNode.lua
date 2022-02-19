local AnimatableNode = require('go.nodes.AnimatableNode.AnimatableNode')

--- @class ParticlefxNode : AnimatableNode
local ParticlefxNode = class('ParticlefxNode', AnimatableNode)

function ParticlefxNode:initialize(id, node_component)
    AnimatableNode.initialize(self, id, node_component or 'particlefx')
end

function ParticlefxNode:play(emitter_state_function)
    particlefx.play(self.id, emitter_state_function)
    return self
end

function ParticlefxNode:stop()
    particlefx.stop(self.id)
    return self
end

function ParticlefxNode:set_color(color, emitter)
    particlefx.set_constant(self.id, emitter or 'emitter', 'tint', color)
    return self
end

return ParticlefxNode
