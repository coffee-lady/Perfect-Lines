local App = require('src.app')
local YandexAPI = require('src.scripts.include.yandex.yandex')
local MockLeaderboards = require('src.scripts.services.platform.yandex.leaderboards.helpers.MockLeaderboards')
local PlayerHelper = require('src.scripts.services.platform.yandex.leaderboards.helpers.PlayerHelper')
local LeaderboardsProcessor = require('src.scripts.services.platform.yandex.leaderboards.helpers.LeaderboardsProcessor')
local CurrentPlayerManager = require('src.scripts.services.platform.yandex.leaderboards.YandexLeaderboardCurrentPlayerManager')

local YandexLeaderboards = YandexAPI.YandexLeaderboards

local Debug = App.libs.debug
local Luject = App.libs.luject

local DEBUG = App.config.debug_mode.LeaderboardsService

--- @class LeaderboardsService
local YandexLeaderboardsService = class('YandexLeaderboardsService')

YandexLeaderboardsService.IMAGE_SIZE = YandexLeaderboards.IMAGE_SIZE

function YandexLeaderboardsService:initialize()
    self.debug = Debug('[Yandex] LeaderboardsService', DEBUG)

    --- @type YandexLeaderboards
    self.yandex_leaderboards = YandexLeaderboards()
    --- @type YandexLeaderboardCurrentPlayerManager
    self.current_player_manager = Luject:resolve_class(CurrentPlayerManager)

    self.yandex_leaderboards:init_async()
end

function YandexLeaderboardsService:set_current_player_score_async(leaderboard_id, score)
    self.debug:log('_update_user_score_async', score)

    self.yandex_leaderboards:set_score_async(leaderboard_id, score)
end

function YandexLeaderboardsService:get_leaderboard_current_player(leaderboard_id)
    local entry = self.yandex_leaderboards:get_player_entry_async(leaderboard_id)
    local current_player = self.current_player_manager:load_current_leaderboard_player(entry)

    return current_player
end

function YandexLeaderboardsService:get_leaderboard_async(id, options)
    --- @type LeaderboardPlayerEntityPlain
    local leaderboard_data = self.yandex_leaderboards:get_leaderboard_async(id, options)

    if not leaderboard_data then
        return MockLeaderboards.get_dummy_leaderboard()
    end

    local leaderboard = {
        id = id,
        title = leaderboard_data.leaderboard.title,
        players = {}
    }

    local current_player = self:get_current_leaderboard_player(id)
    LeaderboardsProcessor:process_leaderboard_entries(leaderboard_data, leaderboard, current_player)

    return leaderboard
end

function YandexLeaderboardsService:load_player_photo_async(player)
    PlayerHelper.update_player_photo(player)
    return player
end

return YandexLeaderboardsService
