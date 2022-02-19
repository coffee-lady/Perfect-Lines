local App = require('src.app')
local YandexAPI = require('src.scripts.include.yandex.yandex')

local YandexRewardedAds = YandexAPI.YandexRewardedAds
local YandexRewardedAdsAlgorithm = YandexAPI.YandexRewardedAdsAlgorithm

local Debug = App.libs.debug

local RewardedConfig = App.config.ads.rewarded
local DataStorageConfig = App.config.data_storage
local FILE = DataStorageConfig.file
local KEY_TIMER = DataStorageConfig.keys.rewarded_timer
local MSG = App.constants.msg
local DEBUG = App.config.debug_mode.RewardedAdsService

--- @class YandexBannerAdsService
local YandexRewardedAdsService = class('YandexBannerAdsService')

YandexRewardedAdsService.__cparams = {'data_storage_use_cases'}

function YandexRewardedAdsService:initialize(data_storage_use_cases)
    self.debug = Debug('[Yandex] RewardedAdsService', DEBUG)

    self.yandex_rewarded_ads = YandexRewardedAds(RewardedConfig.delay, FILE, KEY_TIMER, data_storage_use_cases)
    self.yandex_rewarded_algorithm = YandexRewardedAdsAlgorithm(RewardedConfig.min_time, data_storage_use_cases)
end

function YandexRewardedAdsService:show_video(callbacks)
    return self.yandex_rewarded_ads:show(callbacks)
end

function YandexRewardedAdsService:show_for_reward(callbacks)
    return self.yandex_rewarded_algorithm:show(callbacks)
end

return YandexRewardedAdsService
