local OKGames = require('OKGames.okgames')
local App = require('src.app')

local Debug = App.libs.debug
local AutosaveTimeoutTimer = App.libs.AutosaveTimeoutTimer

local DEBUG = App.config.debug_mode.InterstitialAdsService
local debug_logger = Debug('[OK] InterstitialAdsAdapter', DEBUG)

local function exec(func, ...)
    if func then
        func(...)
    end
end

local InterstitialAdsAdapter = {}

function InterstitialAdsAdapter:init_timer(delay, file, key_timer, data_storage_use_cases)
    self.timer = AutosaveTimeoutTimer(delay)
    self.timer:enable_saving(file, key_timer, data_storage_use_cases)
    self.timer:restore_unfinished()
end

function InterstitialAdsAdapter:show(callbacks)
    if not self.timer:is_expired() then
        debug_logger:log('timer is not expired. seconds_left:', self.timer.seconds_left)
        return
    end

    callbacks = callbacks or {}

    exec(callbacks.open)

    local result = OKGames:show_interstitial_ad_async()

    if result.status then
        exec(callbacks.close, true)
    else
        exec(callbacks.error)
    end
end

function InterstitialAdsAdapter:show_with_probability(probability, callbacks)
    callbacks = callbacks or {}

    if probability == 0 then
        return
    end

    local show_ad = math.random() <= probability

    if not show_ad then
        debug_logger:log('ad will not be shown because of probability')
        exec(callbacks.close, false)
        return
    end

    self:show(callbacks)
end

function InterstitialAdsAdapter:resume_timer()
    self.timer:resume()
end

return InterstitialAdsAdapter
