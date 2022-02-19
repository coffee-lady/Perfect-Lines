local yagames = require('yagames.yagames')
local App = require('src.app')

local Debug = App.libs.debug
local Async = App.libs.async
local TextFormatter = App.libs.text_formatter

local DEBUG = App.config.debug_mode.AuthService
local debug_logger = Debug('[Yandex] AuthAdapter', DEBUG)

local MAX_USERNAME_LENGTH = 17

local function exec(func)
    if func then
        func()
    end
end

--- @class YandexAuth
local YandexAuth = class('YandexAuth')

YandexAuth.IMAGE_SIZE = {
    small = 'small',
    medium = 'medium',
    large = 'large'
}

function YandexAuth:init_async()
    return Async(
        function(done)
            yagames.player_init(
                nil,
                function(_, err)
                    debug_logger:log('PLAYER INITTED')

                    if err then
                        debug_logger:log('ERROR:', err)
                        done(false)
                        return
                    end

                    done(true)
                end
            )
        end
    )
end

function YandexAuth:get_environment()
    return yagames.environment()
end

function YandexAuth:authenticate(on_resolve, on_reject)
    local user_logged = false

    Async(
        function(done)
            yagames.auth_open_auth_dialog(
                function(_, err)
                    debug_logger:log('DIALOG OPENED')
                    user_logged = true

                    if err then
                        exec(on_reject)
                    end

                    done()
                end
            )
        end
    )

    if not user_logged then
        return
    end

    Async(
        function(done)
            yagames.player_init(
                {
                    scope = true
                },
                function(_, err)
                    debug_logger:log('GOT LOGGED IN PLAYER DATA')

                    if err then
                        debug_logger:log('ERROR', err)
                        return
                    end

                    done()
                end
            )
        end
    )

    exec(on_resolve)
end

function YandexAuth:is_authorized()
    debug_logger:log('is_authorized:', self:get_user_id() ~= nil)

    return self:get_user_id() ~= nil
end

function YandexAuth:get_user_id()
    local succeeded, res = pcall(yagames.player_get_unique_id)

    return succeeded and res or nil
end

function YandexAuth:get_user_name()
    local succeeded, username = pcall(yagames.player_get_name)

    if not succeeded or not username then
        return nil
    end

    return TextFormatter.format_user_name(username, MAX_USERNAME_LENGTH)
end

function YandexAuth:get_current_user_photo_async(images_url, image_size)
    local succeeded, url = pcall(yagames.player_get_photo, image_size or YandexAuth.IMAGE_SIZE.small)

    if succeeded and url then
        local res = Async.http_request(images_url .. url, 'POST')
        return res.response, url
    end

    return nil
end

function YandexAuth:get_user_photo_async(user_img_url, images_url)
    if not user_img_url or user_img_url == '' then
        return nil, nil
    end

    local res = Async.http_request(user_img_url, 'GET')
    return res.response, user_img_url
end

return YandexAuth
