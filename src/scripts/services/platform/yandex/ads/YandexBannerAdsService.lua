local App = require('src.app')
local YandexAdapter = require('src.scripts.include.yandex.yandex')

local YandexBannerAds = YandexAdapter.YandexBannerAds
local Debug = App.libs.debug

local BannerConfig = App.config.ads.banner
local DEBUG = App.config.debug_mode.BannerAdsService

--- @class YandexBannerAdsService
local YandexBannerAdsService = class('YandexBannerAdsService')

YandexBannerAdsService.__cparams = {'data_storage_use_cases'}

function YandexBannerAdsService:initialize(data_storage_use_cases)
    self.debug = Debug('[Yandex] BannerAdsService', DEBUG)
    self.data_storage_use_cases = data_storage_use_cases

    self.yandex_banner_ads = YandexBannerAds
end

function YandexBannerAdsService:show()
    if not self.yandex_banner_ads.initted then
        self:_load_banner()
    end

    self.yandex_banner_ads:show(BannerConfig.block_id)
end

function YandexBannerAdsService:hide()
    if not self.yandex_banner_ads.initted then
        self:_load_banner()
    end

    self.yandex_banner_ads:hide(BannerConfig.block_id)
end

function YandexBannerAdsService:_load_banner()
    self.yandex_banner_ads:init_async(BannerConfig.height)
    self.yandex_banner_ads:load_async(BannerConfig)

    if BannerConfig.visible then
        self:_init_timer()
    end
end

function YandexBannerAdsService:_init_timer()
    self.timer =
        timer.delay(
        BannerConfig.reload_time,
        true,
        function()
            self.yandex_banner_ads:refresh(BannerConfig.block_id)
        end
    )
end

return YandexBannerAdsService
