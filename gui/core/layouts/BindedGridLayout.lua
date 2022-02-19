local BaseLayout = require('gui.core.layouts.BaseLayout')

--- @class BindedGridLayout : BaseLayout
local BindedGridLayout = class('BindedGridLayout', BaseLayout)

-- binding_table = {{nil, nil, 1}, {2, 3, 4}, {5, 6, nil}}
-- sets nodes positions in grid according to node index and index in table
function BindedGridLayout:initialize(container, dimensions, binding_table, gaps, nodes)
    BaseLayout.initialize(self, container)

    if nodes then
        self.nodes = nodes
    end

    self.dimensions = dimensions
    self.binding_table = binding_table

    if type(gaps) == 'number' then
        self.gaps = {x = gaps, y = gaps}
    elseif type(gaps) == 'table' and gaps.x and gaps.y then
        self.gaps = gaps
    end
end

function BindedGridLayout:apply()
    local node_size = self.nodes[1]:get_size()
    local node_size_x = node_size.x
    local node_size_y = node_size.y
    local gaps = self.gaps
    local dx, dy = self.dimensions.x, self.dimensions.y

    for y, rows in pairs(self.binding_table) do
        for x, i in pairs(rows) do
            local pos = vmath.vector3()

            pos.x = node_size_x * (x - 1) + gaps.x * (x - 1) + node_size_x / 2
            pos.y = -node_size_y * (y - 1) - gaps.y * (y - 1) - node_size_y / 2

            self.nodes[i]:set_pos(pos)
        end
    end
end

return BindedGridLayout
