local Services = {
    LocalizationService = require('src.scripts.services.core.LocalizationService.LocalizationService'),
    ScenesService = require('src.scripts.services.core.ScenesService.ScenesService'),
    ScreenService = require('src.scripts.services.core.ScreenService.ScreenService'),
    PlatformService = require('src.scripts.services.core.PlatformService.PlatformService'),
    LocalStorage = require('src.scripts.services.core.LocalStorage.LocalStorage'),
    SoundService = require('src.scripts.services.core.SoundService.SoundService'),
    ScenesStrategiesService = require('src.scripts.services.core.ScenesStrategiesService.ScenesStrategiesService')
}

return Services
