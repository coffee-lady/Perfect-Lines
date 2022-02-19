--- @class EnergyEntity
local EnergyEntity = class('EnergyEntity')

function EnergyEntity:initialize(params)
    --- @class EnergyEntityPlain
    self.data = {
        recovery_time = params.recovery_time,
        max_count = params.max_count,
        game_cost = params.game_cost,
    }
end

function EnergyEntity:get_plain_data()
    return self.data
end

return EnergyEntity
