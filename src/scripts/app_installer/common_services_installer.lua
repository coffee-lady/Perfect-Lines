local App = require('src.app')
local EventBus = require('src.libs.event_bus.event_bus')
local Services = require('src.scripts.services.services')
local AuthService = require('src.scripts.services.platform.yandex.auth.YandexAuthService')
local AdsService = require('src.scripts.services.platform.yandex.ads.YandexAdsService')
local PaymentsService = require('src.scripts.services.platform.yandex.payments.YandexPaymentsService')
local LeaderboardsService = require('src.scripts.services.platform.yandex.leaderboards.YandexLeaderboardsService')
local FeedbackService = require('src.scripts.services.platform.yandex.feedback.YandexFeedbackService')
local YandexPlatformService = require('src.scripts.services.platform.yandex.YandexPlatformService')

local Luject = App.libs.luject

local CommonServicesInstaller = {}

function CommonServicesInstaller:install_services()
    Luject:bind('event_bus_gui'):to(EventBus):as_single()
    Luject:bind('event_bus_go'):to(EventBus):as_single()
    Luject:bind('ui_service'):to(Services.UIService):as_single()
    Luject:bind('scenes_service'):to(Services.ScenesService):as_single()
    Luject:bind('screen_service'):to(Services.ScreenService):as_single()
    Luject:bind('localization_service'):to(Services.LocalizationService):as_single()
    Luject:bind('local_storage'):to(Services.LocalStorage):as_single()
    Luject:bind('platform_service'):to(Services.PlatformService):as_single()
    Luject:bind('sound_service'):to(Services.SoundService):as_single()
    Luject:bind('levels_loader_service'):to(Services.LevelsLoaderService):as_single()
    Luject:bind('graphics_service'):to(Services.GraphicsService):as_single()
    Luject:bind('scenes_strategies_service'):to(Services.ScenesStrategiesService):as_single()
end

return CommonServicesInstaller
