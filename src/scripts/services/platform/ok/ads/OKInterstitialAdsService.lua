local App = require('src.app')
local OkAdapter = require('src.scripts.include.ok.ok')

local InterstitialAdsAdapter = OkAdapter.Ads.InterstitialAds
local Debug = App.libs.debug
local Event = App.libs.Event

local AppConfig = App.config.app
local FILE = AppConfig.file
local KEY_INTERSTITIAL_VIEW_COUNT = AppConfig.keys.interstitial_view_count
local MSG = App.constants.msg
local IntConfig = App.config.ads.interstitial
local DEBUG = App.config.debug_mode.InterstitialAdsService

local function exec(func, ...)
    if func then
        func(...)
    end
end

--- @class OKInterstitialAdsService
local OKInterstitialAdsService = class('OKInterstitialAdsService')

OKInterstitialAdsService.__cparams = {'data_storage_use_cases'}

function OKInterstitialAdsService:initialize(data_storage_use_cases)
    self.debug = Debug('[OK] InterstitialAdsService', DEBUG)
    self.data_storage_use_cases = data_storage_use_cases

    InterstitialAdsAdapter:init_timer(IntConfig.delay, self.data_storage_use_cases)

    self.event_resume_interstitial_timer = Event()

    self.event_resume_interstitial_timer:add(self.on_resume_interstitial_timer, self)
end

function OKInterstitialAdsService:on_resume_interstitial_timer()
    InterstitialAdsAdapter:resume_timer()
end

function OKInterstitialAdsService:show(callbacks)
    InterstitialAdsAdapter:show(self:_get_callbacks(callbacks))
end

function OKInterstitialAdsService:show_on_game_start(callbacks)
    self.debug:log('show_on_game_start')
    self:show_with_probability(IntConfig.prob_start_game, callbacks)
end

function OKInterstitialAdsService:show_on_game_end(callbacks)
    self.debug:log('show_on_game_end')
    self:show_with_probability(IntConfig.prob_end_game, callbacks)
end

function OKInterstitialAdsService:show_with_probability(probability, callbacks)
    InterstitialAdsAdapter:show_with_probability(probability, self:_get_callbacks(callbacks))
end

function OKInterstitialAdsService:_get_callbacks(callbacks)
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

function OKInterstitialAdsService:_on_was_shown()
    self.event_resume_interstitial_timer:emit()
end

return OKInterstitialAdsService
