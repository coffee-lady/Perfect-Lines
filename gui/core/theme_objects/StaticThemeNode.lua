local AnimatedThemeNode = require('gui.core.theme_objects.AnimatedThemeNode')

--- @class StaticThemeNode : AnimatedThemeNode
local StaticThemeNode = class('StaticThemeNode', AnimatedThemeNode)

--- @param elems table <string, Node | NodesList >
function StaticThemeNode:initialize(elems, theme)
    self.nodes = elems
    self.colors = theme

    self:_paint(self.colors)
end

function StaticThemeNode:add_to_list(key, node)
    self.nodes[key]:add(node)

    return self
end

function StaticThemeNode:refresh(theme)
    self.colors = theme
    self:_paint(self.colors)
end

function StaticThemeNode:_paint(mode_colors)
    for key, node in pairs(self.nodes) do
        if mode_colors[key] then
            node:set_color(mode_colors[key])
        end
    end
end

return StaticThemeNode
