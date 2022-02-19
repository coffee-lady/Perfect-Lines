local App = require('src.app')

local ResourcesStorage = App.libs.resources_storage

local ResourcesConfig = App.config.resources
local DataStorageConfig = App.config.data_storage
local FILE = DataStorageConfig.file
local KEY_CURRENT_LEVEL = DataStorageConfig.keys.current_level
local KEY_PROGRESS_LEVEL = DataStorageConfig.keys.progress_level

--- @class LevelsUseCases
local LevelsUseCases = class('LevelsUseCases')

LevelsUseCases.__cparams = {'data_storage_use_cases', 'levels_loader_service'}

function LevelsUseCases:initialize(data_storage_use_cases, levels_loader_service)
    --- @type ServerDataStorage
    self.data_storage_use_cases = data_storage_use_cases
    --- @type LevelsLoaderService
    self.levels_loader_service = levels_loader_service

    self.progress_level = self.data_storage_use_cases:get(FILE, KEY_PROGRESS_LEVEL) or 1
    self.current_level = self.data_storage_use_cases:get(FILE, KEY_CURRENT_LEVEL) or 1
end

function LevelsUseCases:get_current_level()
    return self:_get_level(self.current_level)
end

function LevelsUseCases:start_progress_level()
    self.current_level = self.progress_level
    self.data_storage_use_cases:set(FILE, KEY_CURRENT_LEVEL, self.current_level)
end

function LevelsUseCases:start_next_level()
    self.current_level = self.current_level + 1
    self.data_storage_use_cases:set(FILE, KEY_CURRENT_LEVEL, self.current_level)

    if self.current_level > self.progress_level then
        self.data_storage_use_cases:set(FILE, KEY_PROGRESS_LEVEL, self.current_level)
        self.progress_level = self.current_level
    end
end

function LevelsUseCases:get_progress_level_index()
    return self.progress_level
end

function LevelsUseCases:get_current_level_index()
    return self.current_level
end

function LevelsUseCases:_get_level(level_index)
    self.current_level = level_index
    self.data_storage_use_cases:set(FILE, KEY_CURRENT_LEVEL, level_index)

    if level_index > self.progress_level then
        self.data_storage_use_cases:set(FILE, KEY_PROGRESS_LEVEL, level_index)
        self.progress_level = level_index
    end

    return self.levels_loader_service:load_level(level_index)
end

return LevelsUseCases
