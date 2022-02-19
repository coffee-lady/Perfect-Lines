local App = require('src.app')
local NakamaAdapter = require('src.scripts.include.nakama.nakama')

local Debug = App.libs.debug
local Async = App.libs.async

local TempFileConfig = App.config.app.file_temp
local FILE_TMP = TempFileConfig.filename
local KEY_DATA_VERSION = TempFileConfig.keys.data_version
local DEFAULT_DATA_VERSION = '*'
local DEBUG = App.config.debug_mode.PlayerDataStorage

local SAVE_DELAY = 3

local debug_logger = Debug('[OK] PlayerDataStorageAdapter', DEBUG)

local OKPlayerDataStorageAdapter = {}

function OKPlayerDataStorageAdapter:get_key(filename, key)
    return filename .. key
end

local get_key = OKPlayerDataStorageAdapter.get_key

function OKPlayerDataStorageAdapter:init(local_storage)
    self.local_storage = local_storage
    self.requests_to_write_queue = {}

    self.write_data_timer = timer.delay(SAVE_DELAY, true, function()
        Async.bootstrap(function()
            self:_post_write_requests_async()
        end)
    end)

    self.saving_error_observable = App.libs.rx.observable()
end

function OKPlayerDataStorageAdapter:get_data_from_server_async(filename, keys)
    local request_data = {}

    for _, key in pairs(keys) do
        request_data[#request_data + 1] = {
            collection = filename,
            key = key,
        }
    end

    local response = NakamaAdapter:load_data_async(request_data)

    -- debug_logger:log('get all data from  server. response ok:', response.rc == 0, debug_logger:inspect({
    --     RESPONSE = response,
    -- }, {
    --     depth = 6,
    -- }))

    if not response or response.rc ~= 0 then
        debug_logger:log('ERROR on get_from_server:', debug_logger:inspect({
            RESPONSE = response,
        }, {
            depth = 6,
        }))
        return {}
    end

    local data = {}

    for _, content_item in pairs(response.content) do
        local item_key = get_key(filename, content_item.key)
        data[item_key] = content_item.value.value

        local key_data_version = get_key(KEY_DATA_VERSION, item_key)
        self.local_storage:set(FILE_TMP, key_data_version, content_item.version)
    end

    return data
end

function OKPlayerDataStorageAdapter:set_to_server_storage_async(filename, key, value)
    self:_add_to_write_queue(filename, key, value)
end

function OKPlayerDataStorageAdapter:_add_to_write_queue(filename, key, value)
    for i = 1, #self.requests_to_write_queue do
        local item = self.requests_to_write_queue[i]

        if item.filename == filename and item.key == key then
            item.value = value
            return
        end
    end

    self.requests_to_write_queue[#self.requests_to_write_queue + 1] = {
        filename = filename,
        key = key,
        value = value,
    }
end

function OKPlayerDataStorageAdapter:_post_write_requests_async()
    if #self.requests_to_write_queue == 0 then
        return
    end

    local request_data = {}

    for i = #self.requests_to_write_queue, 1, -1 do
        local item = self.requests_to_write_queue[i]
        local item_key = get_key(item.filename, item.key)
        local key_data_version = get_key(KEY_DATA_VERSION, item_key)
        local prev_data_version = self.local_storage:get(FILE_TMP, key_data_version) or DEFAULT_DATA_VERSION

        request_data[#request_data + 1] = {
            collection = item.filename,
            key = item.key,
            value = {
                value = item.value,
            },
            version = prev_data_version,
        }

        table.remove(self.requests_to_write_queue)
    end

    local response = NakamaAdapter:write_data_async(request_data)

    if not response then
        return
    end

    debug_logger:log('set queue data to  server. response ok:', response.rc == 0)

    if response.rc ~= 0 then
        debug_logger:log('ERROR on set_to_server:', debug_logger:inspect({
            RESPONSE = response,
            REQUEST = request_data,
        }, {
            depth = 4,
        }))

        self.saving_error_observable:next()
        return
    end

    for i = 1, #response.content do
        local response_item_data = response.content[i]
        local item_key = get_key(response_item_data.collection, response_item_data.key)
        local key_data_version = get_key(KEY_DATA_VERSION, item_key)
        self.local_storage:set(FILE_TMP, key_data_version, response_item_data.version)
    end
end

function OKPlayerDataStorageAdapter:set_to_local_storage(filename, key, value)
    debug_logger:log('set', filename, key, value, 'to local storage')

    self.local_storage:set(filename, key, value)
end

function OKPlayerDataStorageAdapter:get_from_local_storage(filename, key)
    local value = self.local_storage:get(filename, key)

    debug_logger:log('get', filename, key, '=', value, 'from local storage')

    return value
end

return OKPlayerDataStorageAdapter
