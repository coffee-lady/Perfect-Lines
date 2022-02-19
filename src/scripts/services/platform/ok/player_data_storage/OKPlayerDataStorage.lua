local App = require('src.app')
local OkAdapter = require('src.scripts.include.ok.ok')
local json = require('defsave.json')

local Debug = App.libs.debug
local Array = App.libs.array
local Async = App.libs.async

local StorageAdapter = OkAdapter.PlayerDataStorage

local HintsConfig = App.config.game.hints
local FreeHintsConfig = HintsConfig.free

local URL = App.constants.urls
local AppConfig = App.config.app
local FILE = AppConfig.file
local KEY_RANK = AppConfig.keys.rank_index
local KEY_THEME = AppConfig.keys.theme
local KEY_POINTS = AppConfig.keys.rank_points
local KEY_MASTERY_TIMER = AppConfig.keys.rank_points
local KEY_PREV_GAME = AppConfig.keys.prev_game_data
local KEY_AUTH_OFFER = AppConfig.keys.show_auth_offer
local KEY_FISRT_SHORT_AD = AppConfig.keys.is_first_short_ad
local KEY_SOUNDS_DISABLED = AppConfig.keys.is_sound_disabled
local KEY_LANG = AppConfig.keys.lang
local KEY_FREE_HINTS_COUNT = AppConfig.keys.free_hints_count

local DEBUG = App.config.debug_mode.PlayerDataStorage

local get_key = StorageAdapter.get_key

local FILE_KEY_TO_OBJECT_KEY = {
    rank = KEY_RANK,
    points = KEY_POINTS,
    mastery_timer = KEY_MASTERY_TIMER,
    prev_game = KEY_PREV_GAME,
    is_first_short_ad = KEY_FISRT_SHORT_AD,
    show_auth_offer = KEY_AUTH_OFFER,
    theme = KEY_THEME,
    is_sound_disabled = KEY_SOUNDS_DISABLED,
    lang = KEY_LANG,
}

--- @class OKPlayerDataStorage
local OKPlayerDataStorage = class('OKPlayerDataStorage')

OKPlayerDataStorage.__cparams = {'auth_service', 'scenes_service', 'local_storage'}

function OKPlayerDataStorage:init(auth_service, scenes_service, local_storage)
    self.auth_service = auth_service
    self.scenes_service = scenes_service
    self.debug = Debug('[OK] PlayerDataStorage', DEBUG)

    self.data = {}
    self.is_online = true

    StorageAdapter:init(self.local_storage)
    self:load_data_from_server()
    self:compare_data()

    StorageAdapter.saving_error_observable:subscribe(self, self.on_save_error)
end

function OKPlayerDataStorage:on_save_error()

end

function OKPlayerDataStorage:load_data_from_server()
    self.data = StorageAdapter:get_data_from_server_async(FILE, AppConfig.keys)
end

function OKPlayerDataStorage:on_online()
    self.is_online = true

    Async.bootstrap(function()
        self:load_data_from_server()
        self:compare_data()
    end)
end

function OKPlayerDataStorage:on_offline()
    self.is_online = false
end

function OKPlayerDataStorage:compare_data()
    self:_compare_free_hints()

    local local_data = {}
    local server_data = {}

    for object_key, file_key in pairs(FILE_KEY_TO_OBJECT_KEY) do
        local_data[object_key] = StorageAdapter:get_from_local_storage(FILE, file_key)
        server_data[object_key] = self.data[get_key(FILE, file_key)]
    end

    local_data.rank = local_data.rank or 1
    server_data.rank = server_data.rank or 1
    local_data.points = local_data.points or 0
    server_data.points = server_data.points or 0
    local_data.mastery_timer = local_data.mastery_timer or 0
    server_data.mastery_timer = server_data.mastery_timer or 0

    if local_data.rank > server_data.rank or (local_data.rank == server_data.rank and local_data.points > server_data.points) then
        self.debug:log('update from local data. case: points')
        self:_update_from_local_data(local_data)
        return
    end

    if local_data.mastery_timer > server_data.mastery_timer then
        self.debug:log('update from local data. case: mastery_timer')
        self:_update_from_local_data(local_data)
        return
    end

    self.debug:log('update from server data')
    self:_update_from_server_data(server_data)
end

function OKPlayerDataStorage:set(filename, key, value)
    local prev_value = self:get(filename, key)
    value = Array.deepcopy(value)

    if json.encode(prev_value) == json.encode(value) then
        return
    end

    if self.is_online then
        self:_set_to_server_storage(filename, key, value)
    end

    StorageAdapter:set_to_local_storage(filename, key, value)
end

function OKPlayerDataStorage:get(filename, key)
    local val
    local lc_value = StorageAdapter:get_from_local_storage(filename, key)
    local server_value = self.data[get_key(filename, key)]

    if not self.is_online then
        val = lc_value
    else
        val = server_value and server_value or lc_value
    end

    return Array.deepcopy(val)
end

function OKPlayerDataStorage:_compare_free_hints()
    local local_free_hints = StorageAdapter:get_from_local_storage(FILE, KEY_FREE_HINTS_COUNT) or FreeHintsConfig.count
    local server_free_hints = self.data[get_key(FILE, KEY_FREE_HINTS_COUNT)] or FreeHintsConfig.count

    if local_free_hints < server_free_hints then
        self:_set_to_server_storage(FILE, KEY_FREE_HINTS_COUNT, local_free_hints)
    else
        StorageAdapter:set_to_local_storage(FILE, KEY_FREE_HINTS_COUNT, server_free_hints)
    end
end

function OKPlayerDataStorage:_update_from_local_data(local_data)
    for object_key, file_key in pairs(FILE_KEY_TO_OBJECT_KEY) do
        self:_set_to_server_storage(FILE, file_key, local_data[object_key])
    end
end

function OKPlayerDataStorage:_update_from_server_data(server_data)
    for object_key, file_key in pairs(FILE_KEY_TO_OBJECT_KEY) do
        StorageAdapter:set_to_local_storage(FILE, file_key, server_data[object_key])
    end
end

function OKPlayerDataStorage:_set_to_server_storage(filename, key, value)
    local data_key = get_key(filename, key)

    self.data[data_key] = value

    Async.bootstrap(function()
        StorageAdapter:set_to_server_storage_async(filename, key, value)
    end)
end

return OKPlayerDataStorage
