--- @class BaseLayout
local BaseLayout = class('BaseLayout')

BaseLayout.ALIGN_CENTER = 'a'
BaseLayout.ALIGN_LEFT = 'b'
BaseLayout.ALIGN_RIGHT = 'c'

function BaseLayout:set_node(node, pos)
    if not pos then
        self.nodes[#self.nodes + 1] = node
        return
    end

    for i = #self.nodes + 1, pos + 1, -1 do
        self.nodes[i] = self.nodes[i - 1]
    end

    self.nodes[pos] = node
end

function BaseLayout:remove_node(node)
    for i = #self.nodes, 1, -1 do
        if self.nodes[i] == node then
            table.remove(self.nodes, i)
        end
    end
end

return BaseLayout
