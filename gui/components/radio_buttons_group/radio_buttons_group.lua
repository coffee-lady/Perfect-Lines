local View = require('gui.components.radio_buttons_group.view.view_radio_buttons_group')

local BOOTSTRAP_URL = 'bootstrap'
local ACTION_CLICK = hash('click')

--- @class RadioButtonsGroup : Widget
local RadioButtonsGroup = class('RadioButtonsGroup')

RadioButtonsGroup.__cparams = {'event_bus', 'scenes_service'}

RadioButtonsGroup.RADIO_BUTTON_SELECTED = hash('radio_button_selected')

-- {
--     ID
--     localization_key
--     gaps
--     items
--     enabled
--     align
--     callback
-- }
function RadioButtonsGroup:initialize(event_bus, scenes_service, params)
    --- @type EventBus
    self.event_bus = event_bus
    --- @type ScenesService
    self.scenes_service = scenes_service

    self.view = inject(View, params)
    self.selected = nil
    self._on_selected = params.callback

    self.event_bus:on(ACTION_CLICK, self.on_click, self)
end

function RadioButtonsGroup:on_click(action)
    local pressed_btn_id = self.view:get_pressed_btn_id(action)

    if not pressed_btn_id then
        self.selected = nil
        return
    end

    if pressed_btn_id == self.selected then
        return
    end

    self.view:select(pressed_btn_id)
    self._on_selected(pressed_btn_id)

    self.scenes_service:post_to_go(
        BOOTSTRAP_URL,
        RadioButtonsGroup.RADIO_BUTTON_SELECTED,
        {
            id = pressed_btn_id
        }
    )
end

return RadioButtonsGroup
