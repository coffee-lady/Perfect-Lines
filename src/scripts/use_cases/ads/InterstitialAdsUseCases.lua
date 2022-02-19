local App = require('src.app')

local InterstitialsConfig = App.config.ads.interstitial

--- @class InterstitialAdsUseCases
local InterstitialAdsUseCases = class('InterstitialAdsUseCases')

InterstitialAdsUseCases.__cparams = {'data_storage_use_cases', 'ads_service'}

function InterstitialAdsUseCases:initialize(data_storage_use_cases, ads_service)
    --- @type DataStorageUseCases
    self.data_storage_use_cases = data_storage_use_cases
    --- @type AdsService
    self.ads_service = ads_service
end

function InterstitialAdsUseCases:show_on_game_start(callbacks)
    self:show_with_probability(InterstitialsConfig.prob_start_game, callbacks)
end

function InterstitialAdsUseCases:show_on_game_end(callbacks)
    self:show_with_probability(InterstitialsConfig.prob_end_game, callbacks)
end

return InterstitialAdsUseCases
