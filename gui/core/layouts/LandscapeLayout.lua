local BaseLayout = require('gui.core.layouts.BaseLayout')

local Array = require('src.libs.tools.types.array.array')

--- @class LandscapeLayout : BaseLayout
local LandscapeLayout = class('LandscapeLayout', BaseLayout)

--- @param nodes Node[]
function LandscapeLayout:initialize(nodes, gaps)
    self.nodes = {}
    self.is_fixed_gap = type(gaps) == 'number'

    if self.is_fixed_gap then
        self.fixed_gap = gaps
    else
        self.gaps = Array.copy_1d(gaps)
    end

    if not nodes then
        return
    end

    for i = 1, #nodes do
        self.nodes[i] = nodes[i]
    end
end

function LandscapeLayout:apply()
    if self.is_fixed_gap then
        self:_apply_with_fixed_gap()
    else
        self:_apply_with_different_gaps()
    end

    return self
end

function LandscapeLayout:adjust_container(container)
    local width, height = self:_get_container_width(), self:_get_container_height()
    container:set_size_xy(width, height)
    return self
end

function LandscapeLayout:adjust_container_width(container)
    local width = self:_get_container_width()
    container:set_size_xy(width)
    return self
end

function LandscapeLayout:_apply_with_fixed_gap()
    local gap = self.fixed_gap
    local nodes = self.nodes

    local objects_sizes, whole_width = self:_calc_actual_sizes()
    whole_width = whole_width + gap * (#nodes - 1)

    local pos = vmath.vector3()
    pos.x = -whole_width / 2 - gap

    local prev_size = 0

    for i = 1, #nodes do
        local size = objects_sizes[i]

        pos.x = pos.x + prev_size / 2 + gap + size / 2
        nodes[i]:set_pos(pos)

        prev_size = size
    end
end

function LandscapeLayout:_apply_with_different_gaps()
    local gaps = self.gaps
    local nodes = self.nodes
    local objects_sizes, whole_width = self:_calc_actual_sizes()

    local gap_length = 0
    for i = 1, #gaps do
        gap_length = gap_length + gaps[i]
    end

    whole_width = whole_width + gap_length

    local pos = vmath.vector3()
    pos.x = -whole_width / 2
    local prev_size = 0

    for i = 1, #nodes do
        local size = objects_sizes[i]

        pos.x = pos.x + prev_size / 2 + gaps[i] + size / 2
        nodes[i]:set_pos(pos)

        prev_size = size
    end
end

function LandscapeLayout:_calc_actual_sizes()
    local objects_sizes = {}
    local whole_width = 0

    for i = 1, #self.nodes do
        local width = self.nodes[i]:get_actual_size().x

        whole_width = whole_width + width
        objects_sizes[#objects_sizes + 1] = width
    end

    return objects_sizes, whole_width
end

function LandscapeLayout:_get_container_width()
    local elems_width = Array.reduce(self.nodes, function(width, _, node)
        return (width or 0) + node:get_actual_size().x
    end)

    local gap_length = self.is_fixed_gap and #self.nodes * self.fixed_gap or Array.sum(self.gaps)

    return elems_width + gap_length
end

function LandscapeLayout:_get_container_height()
    return Array.reduce(self.nodes, function(max_height, _, node)
        local elem_height = node:get_actual_size().y

        if elem_height > (max_height or 0) then
            return elem_height
        end

        return max_height
    end)
end

return LandscapeLayout
