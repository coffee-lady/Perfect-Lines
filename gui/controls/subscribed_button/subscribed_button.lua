local Button = require('gui.controls.button.button')

local ACTION_CLICK = hash('click')

--- @class SubscribedButton : Button
local SubscribedButton = class('SubscribedButton', Button)

SubscribedButton.__cparams = {
    'scenes_service',
    'event_bus'
}

function SubscribedButton:initialize(scenes_service, event_bus, ids, on_click)
    Button.initialize(self, scenes_service, ids, on_click)

    --- @type EventBus
    self.event_bus = event_bus

    self.subs = self.event_bus:on(ACTION_CLICK, self.click, self)
end

function SubscribedButton:get_subscription()
    return self.subs
end

function SubscribedButton:delete()
    self.subs:unsubscribe()
end

return SubscribedButton
