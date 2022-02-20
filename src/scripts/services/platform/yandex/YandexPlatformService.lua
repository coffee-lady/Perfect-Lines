local YandexAdapter = require('src.scripts.include.yandex.yandex')

--- @class PlatformService
local YandexPlatformService = class('YandexPlatformService')

YandexPlatformService.__cparams = {'event_bus'}

function YandexPlatformService:initialize(event_bus)
    YandexAdapter.init(event_bus)
end

function YandexPlatformService:on_resize()

end

return YandexPlatformService
