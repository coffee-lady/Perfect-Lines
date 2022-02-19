local BaseLayout = require('gui.core.layouts.BaseLayout')

local Array = require('src.libs.tools.types.array.array')

--- @class VerticalLayout : BaseLayout
local VerticalLayout = class('VerticalLayout', BaseLayout)

--- @param nodes Node[]
function VerticalLayout:initialize(nodes, gaps)
    self.nodes = {}
    self.is_fixed_gap = type(gaps) == 'number'

    if self.is_fixed_gap then
        self.fixed_gap = gaps
    else
        self.gaps = gaps and Array.copy_1d(gaps) or {}
    end

    if not nodes then
        return
    end

    for i = 1, #nodes do
        self.nodes[i] = nodes[i]
    end
end

function VerticalLayout:apply()
    if self.is_fixed_gap then
        self:_apply_with_fixed_gap()
    else
        self:_apply_with_different_gaps()
    end

    return self
end

function VerticalLayout:adjust_container(container)
    local width, height = self:_get_container_width(), self:_get_container_height()
    container:set_size_xy(width, height)
    return self
end

function VerticalLayout:adjust_container_height(container)
    local height = self:_get_container_height()
    container:set_size_xy(nil, height)
    return self
end

function VerticalLayout:_apply_with_fixed_gap()
    local gap = self.fixed_gap
    local nodes = self.nodes

    local objects_sizes, whole_height = self:_calc_actual_sizes()
    whole_height = whole_height + gap * (#nodes - 1)

    local pos = vmath.vector3()
    pos.y = whole_height / 2 + gap

    local prev_size = 0

    for i = 1, #nodes do
        local size = objects_sizes[i]

        pos.y = pos.y - prev_size / 2 - gap - size / 2
        nodes[i]:set_pos(pos)

        prev_size = size
    end
end

function VerticalLayout:_apply_with_different_gaps()
    local gaps = self.gaps
    local nodes = self.nodes
    local objects_sizes, whole_height = self:_calc_actual_sizes()

    local gap_length = 0
    for i = 1, #gaps do
        gap_length = gap_length + gaps[i]
    end

    whole_height = whole_height + gap_length

    local pos = vmath.vector3()
    pos.y = whole_height / 2
    local prev_size = 0

    for i = 1, #nodes do
        local size = objects_sizes[i]

        pos.y = pos.y - prev_size / 2 - gaps[i] - size / 2
        nodes[i]:set_pos(pos)

        prev_size = size
    end
end

function VerticalLayout:_calc_actual_sizes()
    local objects_sizes = {}
    local whole_height = 0

    for i = 1, #self.nodes do
        local height = self.nodes[i]:get_actual_size().y

        whole_height = whole_height + height
        objects_sizes[#objects_sizes + 1] = height
    end

    return objects_sizes, whole_height
end

function VerticalLayout:get_container_width(padding_x)
    local max_width = 0

    for i = 1, #self.nodes do
        local sizes = self.nodes[i]:get_actual_size()
        if sizes.x > max_width then
            max_width = sizes.x
        end
    end

    return max_width + (padding_x or 0) * 2
end

function VerticalLayout:_get_container_width()
    return Array.reduce(self.nodes, function(max_width, _, node)
        local elem_width = node:get_actual_size().x

        if elem_width > (max_width or 0) then
            return elem_width
        end

        return max_width
    end)
end

function VerticalLayout:_get_container_height()
    local elems_height = Array.reduce(self.nodes, function(height, _, node)
        return (height or 0) + node:get_actual_size().y
    end)

    local gap_length = self.is_fixed_gap and #self.nodes * self.fixed_gap or Array.sum(self.gaps)

    return elems_height + gap_length
end

return VerticalLayout
