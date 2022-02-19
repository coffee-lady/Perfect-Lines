local App = require('src.app')
local CommonServicesInstaller = require('src.scripts.app_installer.common_services_installer')
local UseCasesInstaller = require('src.scripts.app_installer.use_cases_installer')
local Services = require('src.scripts.services.services')
local ServerDataStorage = require('src.scripts.services.platform.ok.server_data_storage.OKServerDataStorage')
local AuthService = require('src.scripts.services.platform.ok.auth.OKAuthService')
local AdsService = require('src.scripts.services.platform.ok.ads.OKAdsService')
local PaymentsService = require('src.scripts.services.platform.ok.payments.OKPaymentsService')
local StoreService = require('src.scripts.services.platform.ok.store.OKStoreService')
local OkPlatform = require('src.scripts.services.platform.ok.OkPlatformService')

local Luject = App.libs.luject

local OkInstaller = {}

function OkInstaller:install()
    self:_install_services()
    UseCasesInstaller:install_use_cases()
end

function OkInstaller:_install_services()
    Services.PlatformService:set_target_platform_service(OkPlatform)

    CommonServicesInstaller:install_services()

    Luject:bind('server_data_storage'):to(ServerDataStorage):as_single()
    Luject:bind('payments_service'):to(PaymentsService):as_single()
    Luject:bind('auth_service'):to(AuthService):as_single()
    Luject:bind('ads_service'):to(AdsService):as_single()
end

return OkInstaller
