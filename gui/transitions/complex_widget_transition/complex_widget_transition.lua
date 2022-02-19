local Transition = require('gui.transitions.Transition.Transition')

local ComplexWidgetTransition = class('ComplexWidgetTransition')

ComplexWidgetTransition.TYPE = Transition.TYPE

function ComplexWidgetTransition:initialize(config, nodes)
    self.user_config = config
    self.nodes = nodes

    self.transition = Transition()

    for type, _ in pairs(self.user_config) do
        self:_set_type_transition(type)
    end
end

function ComplexWidgetTransition:_set_type_transition(type)
    local user_config = self.user_config

    for transition_key, parts in pairs(user_config[type]) do
        for part_key, part_config in pairs(parts) do
            part_config.object = self.nodes[part_key]
            self.transition[transition_key](self.transition, part_config)
        end
    end
end

function ComplexWidgetTransition:on_message(message_id, message, sender)
    self.transition:on_message(message_id, message, sender)
end

function ComplexWidgetTransition:final()
    self.transition:final()
end

return ComplexWidgetTransition
