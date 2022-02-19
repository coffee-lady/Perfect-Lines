local App = require('src.app')
local OKAPI = require('src.scripts.include.ok.ok')

local ServerConfig = App.config.server[App.config.platform]

--- @class OkPlatformService
local OkPlatformService = class('OkPlatformService')

OkPlatformService.__cparams = {'event_bus_gui'}

function OkPlatformService:initialize(event_bus)
    OKAPI.init(event_bus, ServerConfig)
end

function OkPlatformService:on_resize()
    OKAPI.on_resize()
end

return OkPlatformService
