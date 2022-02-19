local AnimatableNode = require('gui.core.nodes.animatable.animatable_node')

--- @class ParticlefxNode : AnimatableNode
local ParticlefxNode = class('ParticlefxNode', AnimatableNode)

function ParticlefxNode:play(emitter_state_function)
    gui.play_particlefx(self.target, emitter_state_function)
    return self
end

function ParticlefxNode:stop()
    gui.stop_particlefx(self.target)
    return self
end

function ParticlefxNode:set(particlefx)
    gui.set_particlefx(self.target, particlefx)
    return self
end

function ParticlefxNode:get()
    return gui.get_particlefx(self.target)
end

return ParticlefxNode
