local yagames = require('yagames.yagames')
local App = require('src.app')

local Debug = App.libs.debug
local Async = App.libs.async
local AutosaveTimeoutTimer = App.libs.AutosaveTimeoutTimer

local DEBUG = App.config.debug_mode.InterstitialAdsService
local debug_logger = Debug('[Yandex] InterstitialAdsAdapter', DEBUG)

local function exec(func, ...)
    if func then
        func(...)
    end
end

--- @class YandexInterstitialAds
local YandexInterstitialAds = class('YandexInterstitialAds')

function YandexInterstitialAds:init_timer(delay, file, key_timer, data_storage_use_cases)
    self.timer = AutosaveTimeoutTimer(delay)
    self.timer:enable_saving(file, key_timer, data_storage_use_cases)
    self.timer:restore_unfinished()
end

function YandexInterstitialAds:show(callbacks)
    if not self.timer:is_expired() then
        debug_logger:log('timer is not expired. seconds_left:', YandexInterstitialAds.timer.seconds_left)
        return
    end

    callbacks = callbacks or {}
    Async(
        function(done)
            yagames.adv_show_fullscreen_adv(
                {
                    open = function()
                        exec(callbacks.open)
                        debug_logger:log('on open')
                    end,
                    close = function(_, was_shown)
                        exec(callbacks.close, was_shown)
                        debug_logger:log('on close', 'was_shown:', was_shown)
                        done()
                    end,
                    offline = function()
                        exec(callbacks.offline)
                        debug_logger:log('on offline')
                        done()
                    end,
                    error = function(_, err)
                        exec(callbacks.error, err)
                        debug_logger:log('on error', 'err: ' .. err)
                    end
                }
            )
        end
    )
end

function YandexInterstitialAds:show_with_probability(probability, callbacks)
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

function YandexInterstitialAds:resume_timer()
    self.timer:resume()
end

return YandexInterstitialAds
