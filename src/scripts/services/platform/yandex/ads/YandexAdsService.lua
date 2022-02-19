local App = require('src.app')
local BannerAds = require('src.scripts.services.platform.yandex.ads.YandexBannerAdsService')
local InterstitialAds = require('src.scripts.services.platform.yandex.ads.YandexInterstitialAdsService')
local RewardedAds = require('src.scripts.services.platform.yandex.ads.YandexRewardedAdsService')

local MSG = App.constants.msg

local Luject = App.libs.luject
local Event = App.libs.Event

--- @class AdsService
local YandexAdsService = class('YandexAdsService')

YandexAdsService.__cparams = {'data_storage_use_cases'}

function YandexAdsService:initialize(data_storage_use_cases)
    self.interstitial = Luject:resolve_class(InterstitialAds)
    self.rewarded = Luject:resolve_class(RewardedAds)
    self.banner = Luject:resolve_class(BannerAds)
end

function YandexAdsService:show_banner()
    return self.banner:show()
end

function YandexAdsService:hide_banner()
    return self.banner:hide()
end

function YandexAdsService:show_interstitial_ad(callbacks)
    return self.interstitial:show(callbacks)
end

function YandexAdsService:show_interstitial_ad_with_probability(probability, callbacks)
    return self.interstitial:show_on_game_end(callbacks)
end

function YandexAdsService:show_rewarded_ad_video(callbacks)
    return self.rewarded:show_video(callbacks)
end

function YandexAdsService:show_rewarded_ad_for_reward(callbacks)
    return self.rewarded:show_for_reward(callbacks)
end

return YandexAdsService
