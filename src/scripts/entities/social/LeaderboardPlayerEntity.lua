--- @class LeaderboardPlayerEntity
local LeaderboardPlayerEntity = class('LeaderboardPlayerEntity')

function LeaderboardPlayerEntity:initialize(params)
    self.data = {
        id = params.id,
        name = params.name,
        photo = params.photo,
        photo_url = params.photo_url,
        score = params.score,
        rank = params.rank,
    }
end

function LeaderboardPlayerEntity:get_plain_data()
    return self.data
end

return LeaderboardPlayerEntity
