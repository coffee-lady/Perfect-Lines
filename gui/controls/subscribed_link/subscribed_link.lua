local Link = require('gui.controls.link.link')

local ACTION_CLICK = hash('click')

--- @class SubscribedLink : Link
local SubscribedLink = class('SubscribedLink', Link)

SubscribedLink.__cparams = {'event_bus', 'scenes_service'}

function SubscribedLink:initialize(event_bus, scenes_service, ids, on_click)
    Link.initialize(self, scenes_service, ids, on_click)

    --- @type EventBus
    self.event_bus = event_bus
    self.subs = self.event_bus:on(ACTION_CLICK, self.click, self)
end

function SubscribedLink:get_subscription()
    return self.subs
end

function SubscribedLink:delete()
    self.subs:unsubscribe()
end

return SubscribedLink
