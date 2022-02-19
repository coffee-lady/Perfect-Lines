local App = require('src.app')
local OkAdapter = require('src.scripts.include.ok.ok')

local RewardedAdsAdapter = OkAdapter.Ads.RewardedAds
local Debug = App.libs.debug

local RewardedConfig = App.config.ads.rewarded

local DEBUG = App.config.debug_mode.RewardedAdsService

--- @class OKRewardedAdsService
local OKRewardedAdsService = class('OKRewardedAdsService')

OKRewardedAdsService.__cparams = {'data_storage_use_cases'}

function OKRewardedAdsService:initialize(data_storage_use_cases)
    self.debug = Debug('[OK] RewardedAdsService', DEBUG)

    RewardedAdsAdapter:init_timer(RewardedConfig.delay, data_storage_use_cases)
end

function OKRewardedAdsService:show(callbacks)
    return RewardedAdsAdapter:show_on_reward(callbacks)
end

return OKRewardedAdsService
