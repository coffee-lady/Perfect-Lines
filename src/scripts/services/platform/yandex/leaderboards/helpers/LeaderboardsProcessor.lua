local PlayerHelper = require('src.scripts.services.platform.yandex.leaderboards.helpers.PlayerHelper')

--- @class LeaderboardsProcessor
local LeaderboardsProcessor = {}

function LeaderboardsProcessor:process_leaderboard_entries(leaderboard_data, leaderboard, current_player)
    self:_fill_leaderboard_players(leaderboard_data, leaderboard)
    self:_remove_leaderboard_players_duplicates(leaderboard)
    self:_sort_leaderboard_players(leaderboard, current_player)
end

function LeaderboardsProcessor:_fill_leaderboard_players(leaderboard_data, leaderboard)
    for i = 1, #leaderboard_data.entries do
        local entry = leaderboard_data.entries[i]
        leaderboard.players[i] = self:process_player_from_entry(entry)
    end
end

function LeaderboardsProcessor:process_player_from_entry(entry)
    local player = {
        id = entry.player.uniqueID,
        name = entry.player.publicName,
        photo_url = entry.player.getAvatarSrc,
        score = entry.score,
        rank = entry.rank
    }

    PlayerHelper.format_player_name(player)

    return player
end

function LeaderboardsProcessor:_remove_leaderboard_players_duplicates(leaderboard)
    local players = leaderboard.players

    for i = #players, 1, -1 do
        local player_id = players[i].id

        for j = 1, i - 1 do
            if players[j].id == player_id then
                table.remove(players, i)
                break
            end
        end
    end
end

function LeaderboardsProcessor:_sort_leaderboard_players(leaderboard, current_player)
    local players = leaderboard.players

    table.sort(
        players,
        function(playerA, playerB)
            if playerA.rank == playerB.rank and playerA.id == current_player.id then
                return false
            end

            return playerA.rank < playerB.rank
        end
    )
end

return LeaderboardsProcessor
