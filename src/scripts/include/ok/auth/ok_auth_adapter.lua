local OKGames = require('OKGames.okgames')
local App = require('src.app')
local NakamaAdapter = require('src.scripts.include.nakama.nakama')

local Debug = App.libs.debug
local Async = App.libs.async
local TextFormatter = App.libs.text_formatter

local DEBUG = App.config.debug_mode.AuthService
local debug_logger = Debug('[OK] AuthAdapter', DEBUG)

local MAX_USERNAME_LENGTH = 17

local AuthAdapter = {}

AuthAdapter.IMAGE_SIZE = {small = 'small', medium = 'medium', large = 'large'}

function AuthAdapter:init()
    local player_info = OKGames:get_current_player_info_async()

    if not player_info.status then
        self.user_info = {}
        return
    end

    self.user_info = player_info.player_data
    debug_logger:log('got user_info', debug_logger:inspect(self.user_info))

    NakamaAdapter:authorize_id_async(self:get_user_id())
end

function AuthAdapter:get_player_info()
    return self.user_info
end

function AuthAdapter:is_authorized()
    return true
end

function AuthAdapter:get_user_id()
    return self.user_info.uid or 'debug_id'
end

function AuthAdapter:get_user_name()
    local first_name = self.user_info.first_name
    local last_name = self.user_info.last_name

    debug_logger:log('username', first_name, last_name)

    if not first_name then
        return
    end

    return TextFormatter.format_user_name(first_name .. ' ' .. last_name, MAX_USERNAME_LENGTH)
end

function AuthAdapter:get_current_user_photo_async(images_url)
    local url = self.user_info.pic128x128

    if not url or url == '' then
        return nil, nil
    end

    local res = Async.http_request(url, 'GET')

    debug_logger:log('user img url', url)

    if not res.response or res.response == '' then
        local res2 = Async.http_request(images_url .. url, 'GET')

        debug_logger:log_dump(res2)

        return res2.response, url
    end

    return res.response, url
end

function AuthAdapter:get_user_photo_async(user_img_url, images_url)
    if not user_img_url or user_img_url == '' then
        return nil, nil
    end

    local res = Async.http_request(user_img_url, 'GET')

    debug_logger:log('user img url', user_img_url)

    if not res.response or res.response == '' then
        local res2 = Async.http_request(images_url .. user_img_url, 'GET')

        debug_logger:log_dump(res2)

        return res2.response, user_img_url
    end

    return res.response, user_img_url
end

return AuthAdapter
