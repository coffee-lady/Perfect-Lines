local App = require('src.app')

local Observable = App.libs.event_observation.observable
local AutosaveIntervalTimer = App.libs.AutosaveIntervalTimer

local EnergyConfig = App.config.game.energy
local MSG = App.constants.messages
local DataStorageConfig = App.config.data_storage
local FILE = DataStorageConfig.file
local KEY_ENERGY_COUNT = DataStorageConfig.keys.energy_count
local KEY_ENERGY_TIMER = DataStorageConfig.keys.energy_timer

--- @class EnergyUseCases
local EnergyUseCases = class('EnergyUseCases')

EnergyUseCases.__cparams = {'data_storage_use_cases'}

function EnergyUseCases:initialize(data_storage_use_cases)
    --- @type ServerDataStorage
    self.data_storage_use_cases = data_storage_use_cases

    self.current_energy = self.data_storage_use_cases:get(FILE, KEY_ENERGY_COUNT) or EnergyConfig.max_count

    self:_set_timer()
    self:_update_bonus_for_expired_time()
end

function EnergyUseCases:is_enough_to_buy_life()
    return self:_can_change_count(-EnergyConfig.life_cost)
end

function EnergyUseCases:is_enough_to_restart()
    return self:_can_change_count(-EnergyConfig.restart_cost)
end

function EnergyUseCases:buy_life()
    self:change_energy_count(-EnergyConfig.life_cost)
end

function EnergyUseCases:restart_level()
    self:change_energy_count(-EnergyConfig.restart_cost)
end

function EnergyUseCases:win_level()
    self:change_energy_count(EnergyConfig.level_reward)
end

function EnergyUseCases:get_current_energy()
    return self.current_energy
end

function EnergyUseCases:get_max_energy()
    return EnergyConfig.max_count
end

function EnergyUseCases:get_life_cost()
    return EnergyConfig.life_cost
end

function EnergyUseCases:get_level_reward()
    return EnergyConfig.level_reward
end

function EnergyUseCases:get_time_left()
    return self.timer:get_seconds_left()
end

function EnergyUseCases:change_energy_count(delta_count)
    local energy_count = self.current_energy + delta_count

    self.current_energy = energy_count
    self.data_storage_use_cases:set(FILE, KEY_ENERGY_COUNT, self.current_energy)

    if self.current_energy >= EnergyConfig.max_count and self.current_timer then
        self.data_storage_use_cases:set(FILE, KEY_ENERGY_TIMER, nil)
        self.current_timer = nil
    else
        self:_check_timer()
    end
end

function EnergyUseCases:_can_change_count(delta_count)
    return self.current_energy + delta_count >= 0
end

function EnergyUseCases:_set_timer()
    self.timer =
        AutosaveIntervalTimer(
        EnergyConfig.recovery_time,
        function()
            self:change_energy_count(EnergyConfig.recovery_count)

            if self.current_energy >= EnergyConfig.max_count then
                self.timer:cancel()
                self.timer = nil
            end
        end
    )

    self.timer:enable_saving(FILE, KEY_ENERGY_TIMER)
end

function EnergyUseCases:_update_bonus_for_expired_time()
    local times_timer_expired = self.timer:get_times_expired()

    if times_timer_expired > 0 then
        local bonus = math.floor((EnergyConfig.max_count - self.current_energy) / times_timer_expired)

        if bonus > 0 then
            self:change_energy_count(bonus)
        end
    end
end

function EnergyUseCases:_check_timer()
    if not self.timer and self.current_energy < EnergyConfig.max_count then
        self:_set_timer()
    end
end

return EnergyUseCases
