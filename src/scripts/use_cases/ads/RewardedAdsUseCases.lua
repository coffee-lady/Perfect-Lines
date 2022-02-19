local App = require('src.app')

local RewardedConfig = App.config.ads.rewarded

--- @class RewardedAdsUseCases
local RewardedAdsUseCases = class('RewardedAdsUseCases')

RewardedAdsUseCases.__cparams = {'data_storage_use_cases', 'ads_service'}

function RewardedAdsUseCases:initialize(data_storage_use_cases, ads_service)
    --- @type DataStorageUseCases
    self.data_storage_use_cases = data_storage_use_cases
    --- @type AdsService
    self.ads_service = ads_service
end

return RewardedAdsUseCases
