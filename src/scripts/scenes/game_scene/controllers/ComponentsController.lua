local App = require('src.app')

local SceneController = App.libs.scenes.SceneController

local ComponentsController = class('ComponentsController', SceneController)

ComponentsController.__cparams = {}

function ComponentsController:initialize(presenters, view)
    --- @type ViewGameScreen
    self.view = view

    self:set_components({})

    SceneController.initialize(self)
end

return ComponentsController
