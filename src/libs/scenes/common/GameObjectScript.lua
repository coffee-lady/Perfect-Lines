local LujectClassWrapper = require('src.libs.script_wrapper.LujectClassWrapper')

--- @class GameObjectScript
local GameObjectScript = class('GameObjectScript', LujectClassWrapper)

GameObjectScript.__cparams = {'event_bus_go'}

function GameObjectScript:initialize(event_bus_go)
    self:register()

    --- @type EventBus
    self.event_bus_go = event_bus_go
end

function GameObjectScript:init()
    self.id = go.get_id()
end

function GameObjectScript:on_message(message_id, message, sender)
    message.go_id = self.id
    self.event_bus_go:emit(message_id, message)
end

return GameObjectScript
