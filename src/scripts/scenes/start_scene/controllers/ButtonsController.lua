local App = require('src.app')

local SubscriptionsMap = App.libs.SubscriptionsMap
local SceneController = App.libs.scenes.SceneController

local MSG = App.constants.msg

--- @class ButtonsController : SceneController
local ButtonsController = class('ButtonsController', SceneController)

function ButtonsController:initialize(event_bus, presenters)
    SceneController.initialize(self, event_bus)

    self:set_subscriptions_map({})
end

function ButtonsController:on_authorized()
end

return ButtonsController
