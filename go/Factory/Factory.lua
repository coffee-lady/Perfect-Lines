local Node = require('go.nodes.Node.Node')

--- @class Factory
local Factory = class('ParticlefxNode')

function Factory:initialize(id)
    self.id = id
end

--- @return GONode
function Factory:create(settings)
    settings = settings or {}
    return factory.create(self.id, settings.pos, settings.rotation, settings.properties, settings.scale)
end

return Factory
