local App = require('src.app')

local URL = App.constants.urls

--- @class ShowFirstSceneUseCase
local ShowFirstSceneUseCase = class('ShowFirstSceneUseCase')

ShowFirstSceneUseCase.__cparams = {
    'scenes_service', 'auth_service', 'data_storage_use_cases', 'scenes_strategies_service',
}

function ShowFirstSceneUseCase:initialize(scenes_service, auth_service, data_storage_use_cases,
                                          scenes_strategies_service)
    --- @type ScenesService
    self.scenes_service = scenes_service
    --- @type AuthService
    self.auth_service = auth_service
    --- @type ServerDataStorage
    self.data_storage_use_cases = data_storage_use_cases
    --- @type ScenesStrategiesService
    self.scenes_strategies_service = scenes_strategies_service
end

function ShowFirstSceneUseCase:show_first_scene()
    self.scenes_strategies_service:select_standard_game()
    self:_show_game_scene()
end

function ShowFirstSceneUseCase:_show_game_scene()
    self.scenes_service:show(URL.game_scene)
end

return ShowFirstSceneUseCase
