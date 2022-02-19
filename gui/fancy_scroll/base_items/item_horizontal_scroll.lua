local Core = require('gui.core.core')

local Node = Core.Node

--- @class ViewItemHorizontalScroll
local ViewItemHorizontalScroll = class('ViewItemVerticalScroll', Node)

ViewItemHorizontalScroll.__cparams = {}

function ViewItemHorizontalScroll:initialize(container, viewport)
    Node.initialize(self, container)

    self.viewport_size = viewport:get_size()
    self.item_size = self:get_size()
    self.tmp_pos = vmath.vector3(0)
end

function ViewItemHorizontalScroll:update_position(position)
    self.tmp_pos.x = -(self.item_size.x + self.viewport_size.x) / 2 + position * (self.viewport_size.x + self.item_size.x)
    self:set_pos(self.tmp_pos)

    return self.tmp_pos
end

function ViewItemHorizontalScroll:get_pos_in_scroll(i_pos)
    local pos = vmath.vector3()
    pos.x = -(self.item_size.x + self.viewport_size.x) / 2 + i_pos * (self.viewport_size.x + self.item_size.x)
    return pos
end

return ViewItemHorizontalScroll
