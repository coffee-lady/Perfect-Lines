local App = require('src.app')

local BannerConfig = App.config.ads.banner

--- @class BannerAdsUseCases
local BannerAdsUseCases = class('BannerAdsUseCases')

BannerAdsUseCases.__cparams = {'data_storage_use_cases', 'ads_service'}

function BannerAdsUseCases:initialize(data_storage_use_cases, ads_service)
    --- @type DataStorageUseCases
    self.data_storage_use_cases = data_storage_use_cases
    --- @type AdsService
    self.ads_service = ads_service
end

return BannerAdsUseCases
