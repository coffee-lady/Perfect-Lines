local App = require('src.app')
local ContentEncoder = require('src.scripts.include.nakama.helpers.content_encoder')

local JSON = App.libs.json
local Debug = App.libs.debug

--- @class ServiceNakamaServer
--- @param config NakamaConfigService
local NakamaAPI = {}

local DataStorageConfig = App.config.data_storage
local FILE = DataStorageConfig.file
local NakamaConfig = App.config.nakama
local DEBUG = App.config.debug_mode.NakamaAdapter
local CODE_ERROR_NAME_IN_USE = 6

NakamaAPI.__cparams = {'config_server', 'key_storage_server'}

--- @param server_config NakamaConfigService
function NakamaAPI:init(nakama, engine_defold, server_config, local_storage)
    self.config = assert(server_config)
    self.nakama = nakama
    self.local_storage = local_storage
    self.content_encoder = ContentEncoder(server_config.encode_key)

    self.debug = Debug('NakamaAdapter', DEBUG)

    self.client = self:_init_client(self.config.config_client, engine_defold)
    self:_load_state()
end

function NakamaAPI:authorize_id_async(user_id, username)
    assert(user_id, 'id cant be null')

    self.debug:log('auth with id', user_id, username)

    if self:_is_valid_auth_data() and self.auth_data.custom_id == user_id then
        self.debug:log('token valid, use saved token')
        self.nakama.set_bearer_token(self.client, self.auth_data.token)
        return true
    end

    local auth_data = {
        custom_id = user_id,
    }

    local body_api_custom = self.nakama.create_api_account_custom(user_id)
    local result = self.nakama.authenticate_custom(self.client, body_api_custom, true, username)

    self.debug:log('auth res ', result)
    if result and result.error then
        if result.code == CODE_ERROR_NAME_IN_USE then
            self.debug:log('Error name in use', username)
            result = self.nakama.authenticate_custom(self.client, body_api_custom, true)
        end
    end

    self.debug:log('auth result', self.debug:inspect(result))

    if result and result.token then
        auth_data.user_id = result.user_id
        auth_data.username = result.username
        auth_data.expires = result.expires
        auth_data.token = result.token
        auth_data.time_auth = os.time()

        self:_save_state(auth_data)
        self.auth_data = auth_data
        self.nakama.set_bearer_token(self.client, result.token)
        self.debug:log('token valid, use saved token')
        return true
    end

    self:_save_state(auth_data)

    return false
end

--- @param save_data table @ save_data = {
---   {
---      collection = "collection_key",
---      key = "key_in_collection",
---      value = {} -- table value for save,
---      version
---   },
---   {
---      ...
---   }
--- }
--- @return table @ result = {
---   rc = 0 : number error code 0 - OK
---   content : Array = {
---      {
---         key = "collection_key",
---         version = "save_version"
---      }
---   }
---}
function NakamaAPI:write_data_async(save_data)
    return self:_request_rpc_secure_data(save_data, NakamaConfig.RPC.save_storage_secure)
end

--- @param data_info table @ data_info = {
---  {
---     collection = "collection_key",
---     key = "key_in_collection",
---     user_id = "some_user_id" [optional, if not present used current user id]
---  }
--- }
--- @return table @ result = {
---  rc = 0 : number error code 0 - OK,
---  content = {
---    {
---     collection = "collection_key",
---     key = "key_in_collection",
---     value = {},
---     version : string = "asdf" -- version of save
---    }
---  }
---}
function NakamaAPI:load_data_async(data_info)
    return self:_request_rpc_secure_data(data_info, NakamaConfig.RPC.load_storage_secure)
end

function NakamaAPI:sync_wallet_events(data_info)
    return self:_request_rpc_secure_data(data_info, NakamaConfig.RPC.sync_wallet_events)
end

function NakamaAPI:get_user_account_async()
    if not self:_recheck_auth_async() then
        return nil
    end

    local account_data = self.nakama.get_account(self.client)
    self.debug:log('retrieve user account ', account_data)

    return account_data
end

function NakamaAPI:get_user_wallet_async()
    local account_data = self:get_user_account_async()

    if not account_data or not account_data.wallet then
        return nil
    end

    local status, wallet = pcall(JSON.decode, account_data.wallet)

    if not status then
        return nil
    end

    return wallet
end

function NakamaAPI:get_user_id()
    return self.user_id
end

function NakamaAPI:is_authorized()
    return self.client and self.client.config.bearer_token ~= nil and self:_is_valid_auth_data()
end

function NakamaAPI:get_catalog_async()
    if not self:_recheck_auth_async() then
        self.debug:log('not auth get_purchase_list_async')
        return nil
    end

    local result = self.nakama.rpc_func2(self.client, NakamaConfig.RPC.get_purchase_list, '{}', self.config.key_http)

    self.debug:log('payments list result', self.debug:inspect(result))

    if not result or not result.payload then
        return nil
    end

    local status, parse_result = pcall(JSON.decode, result.payload)

    if not status then
        return nil
    end

    return parse_result
end

--- @param config NakamaConfigClient
function NakamaAPI:_init_client(config, engine_defold)
    config = {
        host = config.host,
        port = config.port,
        use_ssl = config.use_ssl,
        username = config.username,
        password = config.password,
        timeout = config.timeout or NakamaConfig.DEFAULT_TIMEOUT,
        engine = engine_defold,
    }

    return self.nakama.create_client(config)
end

function NakamaAPI:_load_state()
    local state = {}

    self.auth_data = state or nil
end

function NakamaAPI:_save_state(state)
    self.local_storage:set(FILE, NakamaConfig.KEY_STORAGE_STATE, state)
end

function NakamaAPI:_is_valid_auth_data()
    local auth_data = self.auth_data

    self.debug:log_dump(auth_data)

    if auth_data == nil or auth_data.token == nil or auth_data.expires == nil or auth_data.time_auth == nil then
        return false
    end

    local delta_time = os.difftime(os.time(), auth_data.time_auth)
    self.debug:log('is_valid_auth_data ', delta_time, delta_time)
    return delta_time >= 0 and delta_time <= self.config.session_interval
end

function NakamaAPI:_recheck_auth_async()
    if self:is_authorized() then
        return true
    end

    if not self.auth_data or not self.auth_data.custom_id then
        self.debug:log('invalid auth data!', self.auth_data)
        return false
    end

    local res = self:authorize_id_async(self.auth_data.custom_id, self.auth_data.username or '')
    return res
end

--- @param request_data table
--- @param rpc_key string
--- @return table @ encode request_data make request at rpc_key, decode answer and return
function NakamaAPI:_request_rpc_secure_data(request_data, rpc_key)
    if not self:_recheck_auth_async() then
        self.debug:log('not auth _request_rpc_secure_data')
        return nil
    end

    -- self.debug:log('prepare rpc body', self.debug:inspect(request_data, {
    --     depth = 4,
    -- }), rpc_key)

    local body_data = self.content_encoder:encode_content_json(request_data)

    local result = self.nakama.rpc_func(self.client, rpc_key, body_data, self.config.key_http)

    if not result then
        return nil
    end

    local decoded_content = self.content_encoder:decode_container_json(result.payload)
    -- self.debug:log('_request_rpc_secure_data', rpc_key, self.debug:inspect(decoded_content, {
    --     depth = 4,
    -- }))

    return decoded_content
end

return NakamaAPI
