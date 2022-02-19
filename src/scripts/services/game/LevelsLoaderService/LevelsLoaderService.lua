local App = require('src.app')

local ResourcesStorage = App.libs.resources_storage

local ResourcesConfig = App.config.resources
local DataStorageConfig = App.config.data_storage
local FILE = DataStorageConfig.file
local KEY_CURRENT_LEVEL = DataStorageConfig.keys.current_level
local KEY_PROGRESS_LEVEL = DataStorageConfig.keys.progress_level

--- @class LevelsLoaderService
local LevelsLoaderService = class('LevelsLoaderService')

LevelsLoaderService.__cparams = {'data_storage_use_cases'}

function LevelsLoaderService:initialize(data_storage_use_cases)
    --- @type ServerDataStorage
    self.data_storage_use_cases = data_storage_use_cases
end

function LevelsLoaderService:load_level(level_index)
    local filepath = string.format(ResourcesConfig.levels, level_index)
    return ResourcesStorage:get_json_data(filepath)
end

return LevelsLoaderService
