local BaseLayout = require('gui.core.layouts.BaseLayout')

--- @class LandscapePositionLayout : BaseLayout
local LandscapePositionLayout = class('BindedGridLayout', BaseLayout)

function LandscapePositionLayout:initialize(container, nodes, gap, padding)

    self.container = container

    if nodes then
        self.nodes = nodes
    end

    self.gap = gap or 0
    self.padding = padding or 0
end

function LandscapePositionLayout:apply()
    local container_size = self.container:get_size()
    local container_length = container_size.x

    local count = #self.nodes
    local gap = self.gap
    local padding = self.padding

    for i = 1, count do
        local pos = vmath.vector3()

        pos.x = -container_length / 2 + padding + gap * (i - 1) + gap / 2
        self.nodes[i]:set_pos(pos)
    end
end

return LandscapePositionLayout
