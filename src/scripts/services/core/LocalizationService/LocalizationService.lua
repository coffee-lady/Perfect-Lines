local App = require('src.app')
local ResourcesStorage = require('src.libs.resources_storage.resources_storage')
local Config = require('src.scripts.config.config')

local Event = App.libs.Event

local MSG = App.constants.msg
local ResourcesConfig = App.config.resources
local DataStorageConfig = App.config.data_storage
local FILE = DataStorageConfig.file
local KEY_LANG = DataStorageConfig.keys.lang

local function replace_vars(str, vars)
    if not vars then
        vars = str
    end

    return (string.gsub(
        str,
        '({([^}]+)})',
        function(whole, key)
            return vars[key] or whole
        end
    ))
end

--- @class LocalizationService
local LocalizationService = class('LocalizationService')

LocalizationService.__cparams = {'data_storage_use_cases', 'auth_service'}

function LocalizationService:initialize(data_storage_use_cases, auth_service)
    --- @type DataStorageUseCases
    self.data_storage_use_cases = data_storage_use_cases
    --- @type AuthService
    self.auth_service = auth_service

    self.event_language_changed = Event()

    self.auth_service.event_auth_success:add(self.on_authorized, self)

    self:_check_current_lang()
end

function LocalizationService:on_authorized()
    self:_check_current_lang()
end

function LocalizationService:_check_current_lang()
    local user_lang = self.auth_service:get_env_lang()
    self.lang = self.data_storage_use_cases:get(FILE, KEY_LANG) or user_lang

    self:change_lang(self.lang)
end

function LocalizationService:get_language()
    return self.lang
end

function LocalizationService:get_localization_path()
    return string.format(ResourcesConfig.localization, self.lang)
end

function LocalizationService:change_lang(lang)
    self.lang = lang

    local path = self:get_localization_path()
    self.data = ResourcesStorage:get_json_data(path)

    self.data_storage_use_cases:set(FILE, KEY_LANG, self.lang)

    self:_run_web_change_lang()

    self.event_language_changed:emit()
end

function LocalizationService:_run_web_change_lang()
    if html5 then
        html5.run('changeLang("' .. self.lang .. '");')
    end
end

local function get_localized_table(data, vars)
    local result = {}

    for node_id, str in pairs(data) do
        if type(str) == 'table' then
            result[node_id] = get_localized_table(str, vars)
        else
            result[node_id] = replace_vars(str, vars)
        end
    end

    return result
end

function LocalizationService:get_localized_text(key, vars)
    if type(self.data[key]) == 'string' then
        return replace_vars(self.data[key], vars)
    end

    return get_localized_table(self.data[key], vars)
end

return LocalizationService
