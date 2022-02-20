local OKGames = require('OKGames.okgames')
local App = require('src.app')

local Debug = App.libs.debug
local AutosaveTimeoutTimer = App.libs.AutosaveTimeoutTimer

local DEBUG = App.config.debug_mode.RewardedAdsService
local debug_logger = Debug('[OK] RewardedAdsAdapter', DEBUG)

local function exec(func, ...)
    if func then
        func(...)
    end
end

local RewardedAdsAdapter = {}

function RewardedAdsAdapter:init_timer(delay, file, key_timer, data_storage_use_cases)
    self.timer = AutosaveTimeoutTimer(delay)
    self.timer:enable_saving(file, key_timer, data_storage_use_cases)
    self.timer:restore_unfinished()
end

function RewardedAdsAdapter:show(callbacks)
    callbacks = callbacks or {}
    debug_logger:log('RewardedAdsAdapter.show')

    local loaded_result = OKGames:load_rewarded_ad_async()

    if not loaded_result.status then
        exec(callbacks.error)
        debug_logger:log('error on load ad')
        return false
    end

    exec(callbacks.open)

    local show_result = OKGames:show_rewarded_ad_async()

    if not show_result.status then
        exec(callbacks.error)
        debug_logger:log('error on show ad')
        return false
    end

    exec(callbacks.rewarded)
    exec(callbacks.close)
    debug_logger:log('success on show ad')
    return true
end

function RewardedAdsAdapter:show_on_reward(callbacks)
    if not self.timer:is_expired() then
        debug_logger:log('timer is not expired. seconds left:', self.timer:get_seconds_left())
        return false
    end

    return self:show(callbacks)
end

return RewardedAdsAdapter
