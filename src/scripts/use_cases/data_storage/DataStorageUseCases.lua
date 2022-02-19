local App = require('src.app')
local YandexAPI = require('src.scripts.include.yandex.yandex')
local MergeStoragesUseCase = require('src.scripts.use_cases.data_storage.helpers.MergeStoragesUseCase')

local Array = App.libs.array
local Luject = App.libs.luject

--- @class DataStorageUseCases
local DataStorageUseCases = class('DataStorageUseCases')

DataStorageUseCases.__cparams = {'auth_service', 'local_storage', 'server_data_storage', 'platform_service'}

function DataStorageUseCases:initialize(auth_service, local_storage, server_data_storage, platform_service)
    --- @type AuthService
    self.auth_service = auth_service
    --- @type LocalStorage
    self.local_storage = local_storage
    --- @type ServerDataStorage
    self.server_data_storage = server_data_storage
    --- @type PlatformService
    self.platform_service = platform_service

    --- @type MergeStoragesUseCase
    self.merge_storages_use_case = Luject:resolve_class(MergeStoragesUseCase)

    self.platform_service.event_online:add(self.on_online, self)
    self.auth_service.event_auth_success:add(self.on_authorized, self)

    self.merge_storages_use_case:merge_storages()

    if self.auth_service:is_authorized() then
        self.server_data_storage:load_data()
    end
end

function DataStorageUseCases:on_online()
    self.merge_storages_use_case:merge_storages()
end

function DataStorageUseCases:on_authorized()
    self.server_data_storage:load_data()
    self.merge_storages_use_case:merge_storages()
end

function DataStorageUseCases:set(filename, key, value)
    if self:_is_already_set_value(filename, key, value) then
        return
    end

    self:_try_set_to_server(filename, key, value)
    self.local_storage:set(filename, key, value)
end

function DataStorageUseCases:get(filename, key)
    local can_get_from_server = self.auth_service:is_authorized() and self.platform_service.is_online

    if can_get_from_server then
        return self.server_data_storage:get(filename, key)
    end

    return self.local_storage:get(filename, key)
end

function DataStorageUseCases:_is_already_set_value(filename, key, value)
    local prev_value = self:get(filename, key)
    return json.encode(prev_value) == json.encode(value)
end

function DataStorageUseCases:_try_set_to_server(filename, key, value)
    local can_set_to_server = self.auth_service:is_authorized() and self.platform_service.is_online

    if can_set_to_server then
        self.server_data_storage:set(filename, key, value)
    end
end

return DataStorageUseCases
