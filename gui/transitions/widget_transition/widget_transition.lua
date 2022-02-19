local Transition = require('gui.transitions.Transition.Transition')

local WidgetTransition = class('WidgetTransition')

-- config = {
--     root_node? = 'node',
--     back_out = {
--         duration = 3,
--         easing = gui.EASING_INBACK
--     }
-- }
-- params? = {
--     disable_show_in = true,
--     disable_show_out = true,
-- }

function WidgetTransition:initialize(config, node)
    self.user_config = config
    self.node = node

    self.transition = Transition(self.node)

    local user_config = self.user_config
    for transition_key, transition_config in pairs(user_config) do
        transition_config.object = self.node
        self.transition[transition_key](self.transition, transition_config)
    end
end

function WidgetTransition:on_message(message_id, message, sender)
    self.transition:on_message(message_id, message, sender)
end

function WidgetTransition:final()
    self.transition:final()
end

return WidgetTransition
