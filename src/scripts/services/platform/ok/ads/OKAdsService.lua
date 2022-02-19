local App = require('src.app')
local InterstitialAds = require('src.scripts.services.platform.ok.ads.OKInterstitialAdsService')
local RewardedAds = require('src.scripts.services.platform.ok.ads.OKRewardedAdsService')

local MSG = App.constants.msg
local Event = App.libs.Event

--- @class OKAdsService
local OKAdsService = class('OKAdsService')

OKAdsService.__cparams = {'data_storage_use_cases'}

function OKAdsService:initialize(data_storage_use_cases)
    InterstitialAds:init(data_storage_use_cases)
    RewardedAds:init(data_storage_use_cases)

    self.enabled = true
    self.is_online = false
    self.event_error = Event()
end

function OKAdsService:enable_ads()
    self.enabled = true
end

function OKAdsService:disable_ads()
    self.enabled = false
    self:hide_banner()
end

function OKAdsService:show_banner()
end

function OKAdsService:hide_banner()
end

function OKAdsService:show_interstitial_on_game_start(callbacks)
    if not self.enabled then
        return false
    end

    if not self.is_online then
        return false
    end

    return InterstitialAds:show_on_game_start(callbacks)
end

function OKAdsService:show_interstitial_on_game_end(callbacks)
    if not self.enabled then
        return false
    end

    if not self.is_online then
        return false
    end

    return InterstitialAds:show_on_game_end(callbacks)
end

function OKAdsService:get_interstitial_views_count()
    return InterstitialAds:get_views_count()
end

function OKAdsService:show_rewarded()
    if not self.is_online then
        self.event_error:emit()
        return false, false
    end

    return RewardedAds:show()
end

function OKAdsService:on_online()
    self.is_online = true
end

function OKAdsService:on_offline()
    self.is_online = false
end

return OKAdsService
