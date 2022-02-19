local App = require('src.app')
local YandexAdapter = require('src.scripts.include.yandex.yandex')

local AuthAdapter = YandexAdapter.Auth
local TextFormatter = App.libs.text_formatter

local UIConfig = {
    max_user_name_length = 22,
    max_user_name_lines = 2,
}
local IMAGES_URL = App.config.images_url

local PlayerHelper = {}

function PlayerHelper.update_player_photo(player)
    player.photo = AuthAdapter.get_user_photo_async(player.photo_url, IMAGES_URL)
    return player
end

function PlayerHelper.format_player_name(player)
    player.name = TextFormatter.format_text_lines(player.name, UIConfig.max_user_name_length, UIConfig.max_user_name_lines)
    return player
end

return PlayerHelper
