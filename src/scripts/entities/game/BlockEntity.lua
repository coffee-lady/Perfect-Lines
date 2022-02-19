--- @class BlockEntity
local BlockEntity = class('BlockEntity')

function BlockEntity:initialize(params)
    --- @class EnergyEntityPlain
    self.data = {
        is_destroyable = params.is_destroyable,
        max_lives_count = params.max_lives_count,
        lives_count = params.lives_count,
    }
end

function BlockEntity:decrease_lives(delta_lives)
    self.data.lives_count = self.data.lives_count - delta_lives
end

function BlockEntity:get_plain_data()
    return self.data
end

return BlockEntity
