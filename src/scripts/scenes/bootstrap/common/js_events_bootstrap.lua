local App = require('src.app')

local URL = App.constants.urls
local MSG = App.constants.msg

local SubscriptionsMap = App.libs.SubscriptionsMap

local JSEventsBootstrap = class('JSEventsBootstrap')

JSEventsBootstrap.__cparams = {'event_bus_gui'}

function JSEventsBootstrap:initialize(event_bus)
    self.event_bus = event_bus

    SubscriptionsMap(
        self,
        self.event_bus,
        {
            [MSG.js.save_data] = self.on_save_data,
            [MSG.js.resize] = self.on_window_resize,
            [MSG.js.online] = self.on_online,
            [MSG.js.offline] = self.on_offline,
            [MSG.js.several_tabs_warning] = self.on_tabs_warning
        }
    )
end

function JSEventsBootstrap:on_save_data()
end

function JSEventsBootstrap:on_window_resize()
    self.platform_service:on_resize()
end

function JSEventsBootstrap:on_online()
    self.platform_service:on_online()
end

function JSEventsBootstrap:on_offline()
    self.platform_service:on_offline()
end

function JSEventsBootstrap:on_tabs_warning()
end

return JSEventsBootstrap
