--- @class LeaderboardEntity
local LeaderboardEntity = class('LeaderboardEntity')

function LeaderboardEntity:initialize(params)
    self.data = {id = params.id, title = params.title, players = params.players}
end

function LeaderboardEntity:get_plain_data()
    return self.data
end

return LeaderboardEntity
