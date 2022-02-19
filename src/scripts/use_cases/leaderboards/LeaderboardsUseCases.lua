local App = require('src.app')
local GetLeaderboardUseCases = require('src.scripts.use_cases.leaderboards.helpers.GetLeaderboardUseCases')

local LeaderboardEntity = App.entities.LeaderboardEntity
local LeaderboardPlayerEntity = App.entities.LeaderboardPlayerEntity

local Async = App.libs.async

local Luject = App.libs.luject
local Event = App.libs.Event

local MSG = App.constants.msg
local LeaderboardsConfig = App.config.leaderboards

--- @class LeaderboardsUseCases
local LeaderboardsUseCases = class('LeaderboardsUseCases')

LeaderboardsUseCases.__cparams = {
    'platform_service',
    'auth_service',
    'leaderboards_service'
}

function LeaderboardsUseCases:initialize(platform_service, auth_service, leaderboards_service)
    --- @type PlatformService
    self.platform_service = platform_service
    --- @type AuthService
    self.auth_service = auth_service
    --- @type LeaderboardsService
    self.leaderboards_service = leaderboards_service

    self.get_leaderboard_use_cases = Luject:resolve_class(GetLeaderboardUseCases)

    self.event_score_update = Event()

    self.auth_service.event_auth_success:add(self.on_authorized, self)
    self.platform_service.event_online:add(self.on_online, self)

    self:update_user_score_async()
end

function LeaderboardsUseCases:on_authorized()
    self:update_user_score_async()
end

function LeaderboardsUseCases:on_online()
    self:update_user_score_async()
end

function LeaderboardsUseCases:update_user_score_async()
    if not self.auth_service:is_authorized() then
        return
    end

    local score = 0
    self.leaderboards_service:set_current_player_score_async(LeaderboardsConfig.id, score)

    self.event_score_update:emit()
end

function LeaderboardsUseCases:get_main_leaderboard_current_player_async()
    local leaderboard_id = LeaderboardsConfig.id
    return self:get_leaderboard_current_player_async(leaderboard_id)
end

function LeaderboardsUseCases:get_leaderboard_current_player_async(leaderboard_id)
    return self.leaderboards_service:get_leaderboard_current_player(leaderboard_id)
end

function LeaderboardsUseCases:get_main_leaderboard_async()
    local leaderboard_id = LeaderboardsConfig.id
    return self.get_leaderboard_use_cases:get_leaderboard_async(leaderboard_id)
end

function LeaderboardsUseCases:get_leaderboard_async(leaderboard_id)
    return self.get_leaderboard_use_cases:get_leaderboard_async(leaderboard_id)
end

function LeaderboardsUseCases:load_player_photo_async(player)
    return self.leaderboards_service:load_player_photo_async(player)
end

function LeaderboardsUseCases:is_available()
    return true
end

return LeaderboardsUseCases
