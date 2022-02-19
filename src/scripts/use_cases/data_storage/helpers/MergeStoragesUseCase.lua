local App = require('src.app')

local Array = App.libs.array

local DataStorageConfig = App.config.data_storage
local FILE = DataStorageConfig.file
local KEY_THEME = DataStorageConfig.keys.theme
local KEY_PREV_GAME = DataStorageConfig.keys.previous_game_data
local KEY_LANG = DataStorageConfig.keys.lang

local SYNC_KEYS = {
    KEY_PREV_GAME,
    KEY_THEME,
    KEY_LANG
}

--- @class MergeStoragesUseCase
local MergeStoragesUseCase = class('MergeStoragesUseCase')

MergeStoragesUseCase.__cparams = {'auth_service', 'local_storage', 'server_data_storage'}

function MergeStoragesUseCase:initialize(auth_service, local_storage, server_data_storage)
    --- @type AuthService
    self.auth_service = auth_service
    --- @type LocalStorage
    self.local_storage = local_storage
    --- @type ServerDataStorage
    self.server_data_storage = server_data_storage
end

function MergeStoragesUseCase:merge_storages()
    if not self.auth_service:is_authorized() then
        return
    end

    local local_data, server_data = self:_get_storages_data()

    self:_update_from_server_data(server_data)
end

function MergeStoragesUseCase:_get_storages_data()
    local local_data = {}
    local server_data = {}

    for i = 1, #SYNC_KEYS do
        local key = SYNC_KEYS[i]

        local_data[key] = self.local_storage:get(FILE, key)
        server_data[key] = self.server_data_storage:get(FILE, key)
    end

    return local_data, server_data
end

function MergeStoragesUseCase:_update_from_local_data(local_data)
    for i = 1, #SYNC_KEYS do
        local key = SYNC_KEYS[i]
        self.server_data_storage:set(FILE, key, local_data[key])
    end
end

function MergeStoragesUseCase:_update_from_server_data(server_data)
    for i = 1, #SYNC_KEYS do
        local key = SYNC_KEYS[i]
        self.local_storage:set(FILE, key, server_data[key])
    end
end

return MergeStoragesUseCase
