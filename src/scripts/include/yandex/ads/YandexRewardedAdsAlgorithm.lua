local App = require('src.app')
local InterstitialAdsAdapter = require('src.scripts.include.yandex.ads.YandexInterstitialAds')
local RewardedAdsAdapter = require('src.scripts.include.yandex.ads.YandexRewardedAds')

local TimeoutTimer = App.libs.TimeoutTimer
local Debug = App.libs.debug

local DEBUG = App.config.debug_mode.RewardedAdsAlgorithm
local debug_logger = Debug('[Yandex] RewardedAdsAlgorithm', DEBUG)

--- @class YandexRewardedAdsAlgorithm
local YandexRewardedAdsAlgorithm = class('YandexRewardedAdsAlgorithm')

function YandexRewardedAdsAlgorithm:initialize(saving_delay, file, key_is_first_short_ad, storage)
    self.storage = storage
    self.timer = TimeoutTimer(saving_delay)

    self.file = file
    self.key_is_first_short_ad = key_is_first_short_ad
end

-- returns is_rewarded, is_short_ad_view
function YandexRewardedAdsAlgorithm:show(on_short_ad)
    local was_rewarded = false
    local is_short_ad_view = false

    InterstitialAdsAdapter.show(
        {
            open = function()
                self.timer:resume()
            end,
            close = function(was_inter_shown)
                if not was_inter_shown then
                    return
                end

                local is_first_short_ad = self._check_for_first_short_ad()

                if not self.timer:is_expired() then
                    self._on_short_ad(is_first_short_ad, on_short_ad)
                    is_short_ad_view = true

                    if is_first_short_ad then
                        was_rewarded = true
                    end

                    return
                end

                was_rewarded = true
            end,
            error = function(err)
                self._on_error(err)
            end
        }
    )

    if was_rewarded then
        return true, is_short_ad_view
    end

    if is_short_ad_view then
        return false, is_short_ad_view
    end

    RewardedAdsAdapter:show(
        {
            rewarded = function()
                was_rewarded = true
            end,
            error = function(err)
                self._on_error(err)
            end
        }
    )

    return was_rewarded, false
end

function YandexRewardedAdsAlgorithm:_check_for_first_short_ad()
    local is_first = self.storage:get(self.file, self.key_is_first_short_ad)

    if is_first == nil then
        is_first = true
    end

    if is_first then
        self.storage:set(self.file, self.key_is_first_short_ad, false)
    end

    return is_first
end

function YandexRewardedAdsAlgorithm._on_short_ad(is_first_short_ad, callback)
    debug_logger:log('short view of ad. is_first_short_ad =', is_first_short_ad)
    callback(is_first_short_ad)
end

function YandexRewardedAdsAlgorithm._on_error(err)
    debug_logger:log('ERROR:', err)
end

return YandexRewardedAdsAlgorithm
