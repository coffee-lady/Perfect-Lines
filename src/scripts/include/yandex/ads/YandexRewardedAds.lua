local yagames = require('yagames.yagames')
local App = require('src.app')

local Debug = App.libs.debug
local Async = App.libs.async
local AutosaveTimeoutTimer = App.libs.AutosaveTimeoutTimer

local DEBUG = App.config.debug_mode.RewardedAdsService
local debug_logger = Debug('[Yandex] RewardedAdsAdapter', DEBUG)

local function exec(func, ...)
    if func then
        func(...)
    end
end

--- @class YandexRewardedAds
local YandexRewardedAds = class('YandexRewardedAds')

function YandexRewardedAds:initialize(delay, file, key_timer, storage)
    self.timer = AutosaveTimeoutTimer(delay)
    self.timer:enable_saving(file, key_timer, storage)
    self.timer:restore_unfinished()
end

function YandexRewardedAds:show(callbacks)
    callbacks = callbacks or {}

    Async(
        function(done)
            yagames.adv_show_rewarded_video(
                {
                    open = function()
                        exec(callbacks.open)
                        debug_logger:log('on open')
                    end,
                    rewarded = function()
                        exec(callbacks.rewarded)
                        debug_logger:log('on rewarded')
                    end,
                    close = function()
                        exec(callbacks.close)
                        self.timer:resume()
                        debug_logger:log('on close')
                        done()
                    end,
                    error = function(_, err)
                        exec(callbacks.error, err)
                        debug_logger:log('on error', 'err: ' .. err)
                        done()
                    end
                }
            )
        end
    )
end

function YandexRewardedAds:show_on_reward(callbacks)
    if not self.timer:is_expired() then
        return
    end

    self:show(callbacks)
end

return YandexRewardedAds
