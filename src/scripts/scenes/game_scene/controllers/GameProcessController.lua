local App = require('src.app')

local SceneController = App.libs.scenes.SceneController

local GameProcessController = class('GameProcessController', SceneController)

GameProcessController.__cparams = {}

function GameProcessController:initialize()
    SceneController.initialize(self)

    self:_initialize_game()
end

function GameProcessController:reset()
    self:_initialize_game()
end

function GameProcessController:_initialize_game()
    self:start_game()
end

function GameProcessController:start_game()
end

function GameProcessController:on_victory()
end

return GameProcessController
