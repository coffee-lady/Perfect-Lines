local App = require('src.app')
local YandexAdapter = require('src.scripts.include.yandex.yandex')

local Event = App.libs.Event

local UserEntity = App.entities.UserEntity
local YandexAuth = YandexAdapter.YandexAuth

local MSG = App.constants.msg
local IMAGES_URL = App.config.images_url

--- @class AuthService
local YandexAuthService = class('YandexAuthService')

YandexAuthService.__cparams = {}

YandexAuthService.IMAGE_SIZE = YandexAuth.IMAGE_SIZE

function YandexAuthService:initialize()
    self.yandex_auth = YandexAuth()

    self.event_auth_success = Event()
    self.event_auth_attempt = Event()

    self.yandex_auth:init_async()

    local is_authorized = self.yandex_auth:is_authorized()
    if is_authorized then
        self:_set_current_user_data()
    end
end

function YandexAuthService:authenticate()
    local cb_success_auth = function()
        self:_set_current_user_data()

        self.event_auth_attempt:emit(
            {
                success = true
            }
        )

        self.event_auth_success:emit()
    end

    local cb_auth_fail = function()
        self.event_auth_attempt:emit(
            {
                success = false
            }
        )
    end

    self.yandex_auth:authenticate(cb_success_auth, cb_auth_fail)
end

function YandexAuthService:_set_current_user_data()
    local photo, photo_url = self.yandex_auth:get_current_user_photo_async(IMAGES_URL)
    self.user =
        UserEntity(
        {
            id = self.yandex_auth:get_user_id(),
            name = self.yandex_auth:get_user_name(),
            photo = photo,
            photo_url = photo_url,
            lang = self.yandex_auth:get_environment().i18n.lang
        }
    )
end

function YandexAuthService:is_authorized()
    return self.yandex_auth:is_authorized()
end

--- @return UserEntityPlain
function YandexAuthService:get_user()
    return self.user and self.user:get_plain_data() or nil
end

function YandexAuthService:get_env_lang()
    -- return  self.yandex_auth:get_environment().i18n.lang
    return 'en'
end

function YandexAuthService:get_url_payload()
    return self.yandex_auth:get_environment().payload
end

return YandexAuthService
