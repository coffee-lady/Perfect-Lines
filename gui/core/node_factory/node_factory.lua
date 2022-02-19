--- @class GUINodeFactory
local GUINodeFactory = class('GUINodeFactory')

function GUINodeFactory:initialize(node)
    if type(node) == 'string' then
        self.template = gui.get_node(node)
    else
        self.template = node
    end

    gui.set_enabled(self.template, false)
end

function GUINodeFactory:create()
    local clone = gui.clone(self.template)
    gui.set_enabled(clone, true)

    return clone
end

function GUINodeFactory:create_tree()
    gui.set_enabled(self.template, true)

    local gui_nodes = gui.clone_tree(self.template)

    gui.set_enabled(self.template, false)

    return gui_nodes
end

return GUINodeFactory
