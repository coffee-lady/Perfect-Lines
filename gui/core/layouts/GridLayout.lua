local BaseLayout = require('gui.core.layouts.BaseLayout')

local Math = require('src.libs.tools.math.math')

--- @class GridLayout : BaseLayout
local GridLayout = class('GridLayout', BaseLayout)

function GridLayout:initialize(nodes, dimensions, gaps)
    --- @type Node[]
    self.nodes = {}
    self.gaps = gaps or {x = 0, y = 0}

    if nodes then
        for i = 1, #nodes do
            self.nodes[i] = nodes[i]
        end
    end

    self:set_dimensions(dimensions)
end

function GridLayout:set_dimensions(dimensions)
    self.dimensions = dimensions or {x = 1, y = 0}

    local dx, dy = self.dimensions.x, self.dimensions.y

    if dx == 0 then
        self.dimensions.x = math.ceil(#self.nodes / dy)
    end

    if dy == 0 then
        self.dimensions.y = math.ceil(#self.nodes / dx)
    end

    return self
end

function GridLayout:apply()
    local gaps = self.gaps
    local dx, dy = self.dimensions.x, self.dimensions.y

    local objects_sizes, elems_width, elems_height = self:_calc_actual_sizes()

    local prev_sizes_x = {}
    local prev_sizes_y = {}

    for index = 1, #objects_sizes do
        local sizes = objects_sizes[index]
        local y, x = Math.get_2d_pos_from_1d(index, dx)

        local pos = vmath.vector3()

        prev_sizes_y[x] = prev_sizes_y[x] or 0
        prev_sizes_x[y] = prev_sizes_x[y] or 0

        pos.x = -elems_width / 2 - (dx - 1) * gaps.x / 2 + prev_sizes_x[y] + (x - 1) * gaps.x + sizes.x / 2
        pos.y = elems_height / 2 + (dy - 1) * gaps.y / 2 - prev_sizes_y[x] - (y - 1) * gaps.y - sizes.y / 2

        self.nodes[index]:set_pos(pos)

        prev_sizes_x[y] = prev_sizes_x[y] + sizes.x
        prev_sizes_y[x] = prev_sizes_y[x] + sizes.y
    end

    return self
end

function GridLayout:adjust_container(container, paddings)
    paddings = paddings or {x = 0, y = 0}

    local dx, dy = self.dimensions.x, self.dimensions.y
    local _, elems_width, elems_height = self:_calc_actual_sizes()

    local width = elems_width + self.gaps.x * (dx - 1) + paddings.x * 2
    local height = elems_height + self.gaps.y * (dy - 1) + paddings.y * 2

    container:set_size_xy(width, height)

    return self
end

function GridLayout:_calc_actual_sizes()
    local objects_sizes = {}
    local elems_width = {}
    local elems_height = {}

    local dx = self.dimensions.x

    for i = 1, #self.nodes do
        local y, x = Math.get_2d_pos_from_1d(i, dx)

        local sizes = self.nodes[i]:get_actual_size()
        elems_width[y] = (elems_width[y] or 0) + sizes.x
        elems_height[x] = (elems_height[x] or 0) + sizes.y
        objects_sizes[i] = sizes
    end

    return objects_sizes, self:_calc_max_sizes_in_grid(elems_width, elems_height)
end

function GridLayout:_calc_max_sizes_in_grid(elems_width, elems_height)
    local max_width = 0
    local max_height = 0

    for i = 1, #elems_width do
        if elems_width[i] > max_width then
            max_width = elems_width[i]
        end
    end

    for i = 1, #elems_height do
        if elems_height[i] > max_height then
            max_height = elems_height[i]
        end
    end

    return max_width, max_height
end

return GridLayout
