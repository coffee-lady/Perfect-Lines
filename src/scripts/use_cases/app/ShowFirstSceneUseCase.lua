local App = require('src.app')

local Base64 = App.libs.base64
local Array = App.libs.array

local DataStorageConfig = App.config.data_storage
local FILE = DataStorageConfig.file
local KEY_PASSED_FEEDS_LEVELS = DataStorageConfig.keys.passed_feeds_levels
local URL = App.constants.urls

--- @class ShowFirstSceneUseCase
local ShowFirstSceneUseCase = class('ShowFirstSceneUseCase')

ShowFirstSceneUseCase.__cparams = {'scenes_service', 'auth_service', 'data_storage_use_cases', 'scenes_strategies_service'}

function ShowFirstSceneUseCase:initialize(scenes_service, auth_service, data_storage_use_cases, scenes_strategies_service)
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
    self:_show_start_scene()
end

function ShowFirstSceneUseCase:_show_start_scene()
    self.scenes_service:show(URL.start_scene)
end

return ShowFirstSceneUseCase
