local Core = require('gui.core.core')

local Node = Core.Node

--- @class ViewItemVerticalScroll
local ViewItemVerticalScroll = class('ViewItemVerticalScroll', Node)

ViewItemVerticalScroll.__cparams = {}

function ViewItemVerticalScroll:initialize(container, viewport)
    Node.initialize(self, container)

    self.viewport_size = viewport:get_size()
    self.item_size = self:get_size()
    self.tmp_pos = vmath.vector3(0)
end

function ViewItemVerticalScroll:update_position(position)
    self.tmp_pos.y = (self.item_size.y + self.viewport_size.y) / 2 - position * (self.viewport_size.y + self.item_size.y)
    self:set_pos(self.tmp_pos)

    return self.tmp_pos
end

function ViewItemVerticalScroll:get_pos_in_scroll(i_pos)
    local pos = vmath.vector3()
    pos.y = (self.item_size.y + self.viewport_size.y) / 2 - i_pos * (self.viewport_size.y + self.item_size.y)
    return pos
end

return ViewItemVerticalScroll
