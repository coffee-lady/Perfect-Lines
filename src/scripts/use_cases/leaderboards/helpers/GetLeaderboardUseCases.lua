local App = require('src.app')

local LeaderboardEntity = App.entities.LeaderboardEntity
local LeaderboardPlayerEntity = App.entities.LeaderboardPlayerEntity

local MSG = App.constants.msg
local LeaderboardsConfig = App.config.leaderboards

--- @class GetLeaderboardUseCases
local GetLeaderboardUseCases = class('GetLeaderboardUseCases')

GetLeaderboardUseCases.__cparams = {
    'leaderboards_service'
}

function GetLeaderboardUseCases:initialize(leaderboards_service)
    --- @type LeaderboardsService
    self.leaderboards_service = leaderboards_service
end

function GetLeaderboardUseCases:get_main_leaderboard_async()
    local leaderboard_id = LeaderboardsConfig.id
    return self:get_leaderboard_async(leaderboard_id)
end

function GetLeaderboardUseCases:get_leaderboard_async(leaderboard_id)
    local leaderboard_data = self:_get_leaderboard_data_async(leaderboard_id)
    local leaderboard = LeaderboardEntity(leaderboard_data)

    return leaderboard
end

function GetLeaderboardUseCases:_get_leaderboard_data_async(leaderboard_id)
    local current_player = self.leaderboards_service:get_leaderboard_current_player(leaderboard_id)
    local options = self:_get_leaderboard_options(current_player)

    local leaderboard_data = self.leaderboards_service:get_leaderboard_async(leaderboard_id, options)

    return leaderboard_data
end

function GetLeaderboardUseCases:_get_leaderboard_options(current_player)
    local player_rank = current_player.rank
    local options = {
        include_user = true
    }

    local AMOUNT_TOP = LeaderboardsConfig.top_count_by_player
    local AMOUNT_AROUND = LeaderboardsConfig.around_player_count

    if player_rank <= AMOUNT_TOP + AMOUNT_AROUND + 1 then
        options.amount_top = player_rank
        options.amount_around = math.max(AMOUNT_TOP - player_rank, AMOUNT_AROUND)
    else
        options.amount_top = AMOUNT_TOP
        options.amount_around = AMOUNT_AROUND
    end

    return options
end

return GetLeaderboardUseCases
