local App = require('src.app')
local PlayerHelper = require('src.scripts.services.platform.yandex.leaderboards.helpers.PlayerHelper')

local Array = App.libs.array

local MockLeaderboards = {}

function MockLeaderboards.get_dummy_current_leaderboard_player()
    local player = App.config.dummy_data.yandex_player_entry
    PlayerHelper.format_player_name(player)
    return player
end

function MockLeaderboards.get_dummy_leaderboard()
    local current_player = MockLeaderboards.get_dummy_current_leaderboard_player()
    local dummy_leaderboard = Array.deepcopy(App.config.dummy_data.yandex_leaderboard)

    for i = 1, #dummy_leaderboard.players do
        local player = dummy_leaderboard.players[i]
        PlayerHelper.format_player_name(player)
    end

    return dummy_leaderboard
end

return MockLeaderboards
