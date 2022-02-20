local App = require('src.app')
local OkAdapter = require('src.scripts.include.ok.ok')

local UserEntity = App.entities.UserEntity
local AuthAdapter = OkAdapter.Auth

local IMAGES_URL = App.config.images_url

--- @class OKAuthService
local OKAuthService = class('OKAuthService')

OKAuthService.__cparams = {'event_bus'}

OKAuthService.IMAGE_SIZE = AuthAdapter.IMAGE_SIZE

function OKAuthService:initialize(event_bus)
    AuthAdapter:init()

    local photo, photo_url = AuthAdapter:get_current_user_photo_async(IMAGES_URL)
    self.user = UserEntity({
        id = AuthAdapter.get_user_id(),
        name = AuthAdapter.get_user_name(),
        photo = photo,
        photo_url = photo_url,
        lang = AuthAdapter.get_player_info().locale,
    })
end

function OKAuthService:on_authenticate()
end

function OKAuthService:on_auth_error()
end

function OKAuthService:authenticate()
end

function OKAuthService:is_authorized()
    return AuthAdapter:is_authorized()
end

--- @return UserEntityPlain
function OKAuthService:get_user()
    return self.user:get_plain_data()
end

function OKAuthService:get_env_lang()
    return AuthAdapter:get_player_info().locale
end

function OKAuthService:get_url_payload()
    return nil
end

return OKAuthService
