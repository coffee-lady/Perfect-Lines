local App = require('src.app')
local YandexAdapter = require('src.scripts.include.yandex.yandex')

local YandexInterstitialAds = YandexAdapter.YandexInterstitialAds

local Event = App.libs.Event
local Debug = App.libs.debug

local DataStorageConfig = App.config.data_storage
local FILE = DataStorageConfig.file
local KEY_TIMER = DataStorageConfig.keys.interstitial_timer
local MSG = App.constants.msg
local IntConfig = App.config.ads.interstitial
local DEBUG = App.config.debug_mode.InterstitialAdsService

local function exec(func, ...)
    if func then
        func(...)
    end
end

--- @class InterstitialAdsService
local YandexInterstitialAdsService = class('YandexInterstitialAdsService')

YandexInterstitialAdsService.__cparams = {'data_storage_use_cases'}

function YandexInterstitialAdsService:initialize(data_storage_use_cases)
    self.debug = Debug('[Yandex] InterstitialAdsService', DEBUG)
    self.data_storage_use_cases = data_storage_use_cases

    self.yandex_interstitial = YandexInterstitialAds()

    self.yandex_interstitial:init_timer(IntConfig.delay, FILE, KEY_TIMER, self.data_storage_use_cases)

    self.event_resume_timer = Event()

    self.event_resume_timer:add(self.on_resume_timer, self)
end

function YandexInterstitialAdsService:on_resume_timer()
    self.yandex_interstitial:resume_timer()
end

function YandexInterstitialAdsService:show(callbacks)
    self.yandex_interstitial:show(self:_get_callbacks(callbacks))
end

function YandexInterstitialAdsService:show_with_probability(probability, callbacks)
    self.yandex_interstitial:show_with_probability(probability, self:_get_callbacks(callbacks))
end

function YandexInterstitialAdsService:_get_callbacks(callbacks)
    callbacks = callbacks or {}

    return {
        open = callbacks.open,
        offline = callbacks.offline,
        error = callbacks.error,
        close = function(was_shown)
            if was_shown then
                self:_on_was_shown()
            end

            exec(callbacks.close, was_shown)
        end
    }
end

function YandexInterstitialAdsService:_on_was_shown()
    self.event_resume_timer:emit()
end

return YandexInterstitialAdsService
