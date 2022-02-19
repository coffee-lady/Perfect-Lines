local BaseLayout = require('gui.core.layouts.BaseLayout')

--- @class FixedGridLayout : BaseLayout
local FixedGridLayout = class('FixedGridLayout', BaseLayout)

function FixedGridLayout:initialize(nodes, container, gaps)
    --- @type Node[]
    self.nodes = {}
    self.container = container
    self.gaps =
        gaps or
        {
            x = 0,
            y = 0
        }

    if nodes then
        for i = 1, #nodes do
            self.nodes[i] = nodes[i]
        end
    end
end

function FixedGridLayout:apply()
    local gaps = self.gaps
    local nodes = self.nodes
    local container_sizes = self.container:get_actual_size()
    local prev_pos = vmath.vector3()
    prev_pos.x = -container_sizes.x / 2
    prev_pos.y = container_sizes.y / 2

    local current_row_sizes = vmath.vector3()
    local current_x_elems_count = 0
    local row_index = 1
    local _, max_height = self:_calc_max_sizes()

    for i = 1, #nodes do
        local node_sizes = nodes[i]:get_actual_size()

        if current_row_sizes.x + node_sizes.x + current_x_elems_count * gaps.x > container_sizes.x then
            current_row_sizes.x = 0
            current_x_elems_count = 0
            row_index = row_index + 1
            prev_pos.x = -container_sizes.x / 2
            prev_pos.y = prev_pos.y - max_height
        end

        current_row_sizes.x = current_row_sizes.x + node_sizes.x
        current_x_elems_count = current_x_elems_count + 1

        local pos = vmath.vector3()
        pos.x = prev_pos.x + (current_x_elems_count - 1) * gaps.x + node_sizes.x / 2
        pos.y = prev_pos.y - (row_index - 1) * gaps.y - max_height / 2

        nodes[i]:set_pos(pos)

        prev_pos.x = prev_pos.x + node_sizes.x
    end

    return self
end

function FixedGridLayout:_calc_max_sizes()
    local max_width = 0
    local max_height = 0

    for i = 1, #self.nodes do
        local node_sizes = self.nodes[i]:get_size()
        if node_sizes.x > max_width then
            max_width = node_sizes.x
        end
        if node_sizes.y > max_height then
            max_height = node_sizes.y
        end
    end

    return max_width, max_height
end

return FixedGridLayout
