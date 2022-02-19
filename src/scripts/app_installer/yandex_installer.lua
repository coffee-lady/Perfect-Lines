local App = require('src.app')
local YandexAPI = require('src.scripts.include.yandex.yandex')
local CommonServicesInstaller = require('src.scripts.app_installer.common_services_installer')
local UseCasesInstaller = require('src.scripts.app_installer.use_cases_installer')
local Services = require('src.scripts.services.services')
local ServerDataStorage = require('src.scripts.services.platform.yandex.server_data_storage.YandexServerDataStorage')
local AuthService = require('src.scripts.services.platform.yandex.auth.YandexAuthService')
local AdsService = require('src.scripts.services.platform.yandex.ads.YandexAdsService')
local PaymentsService = require('src.scripts.services.platform.yandex.payments.YandexPaymentsService')
local LeaderboardsService = require('src.scripts.services.platform.yandex.leaderboards.YandexLeaderboardsService')
local FeedbackService = require('src.scripts.services.platform.yandex.feedback.YandexFeedbackService')
local YandexPlatformService = require('src.scripts.services.platform.yandex.YandexPlatformService')

local Luject = App.libs.luject

local YandexInstaller = {}

function YandexInstaller:install()
    YandexAPI.YandexInitializer()

    self:_install_services()
    UseCasesInstaller:install_use_cases()
end

function YandexInstaller:_install_services()
    Services.PlatformService:set_target_platform_service(YandexPlatformService)

    CommonServicesInstaller:install_services()

    Luject:bind('auth_service'):to(AuthService):as_single()
    Luject:bind('server_data_storage'):to(ServerDataStorage):as_single()
    Luject:bind('payments_service'):to(PaymentsService):as_single()
    Luject:bind('ads_service'):to(AdsService):as_single()
    Luject:bind('leaderboards_service'):to(LeaderboardsService):as_single()
    Luject:bind('feedback_service'):to(FeedbackService):as_single()
end

return YandexInstaller
