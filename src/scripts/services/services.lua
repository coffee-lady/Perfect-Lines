local Services = {
    LocalizationService = require('src.scripts.services.core.LocalizationService.LocalizationService'),
    ScenesService = require('src.scripts.services.core.ScenesService.ScenesService'),
    ScreenService = require('src.scripts.services.core.ScreenService.ScreenService'),
    PlatformService = require('src.scripts.services.core.PlatformService.PlatformService'),
    LocalStorage = require('src.scripts.services.core.LocalStorage.LocalStorage'),
    SoundService = require('src.scripts.services.core.SoundService.SoundService'),
    UIService = require('src.scripts.services.core.UIService.UIService'),
    LevelsLoaderService = require('src.scripts.services.game.LevelsLoaderService.LevelsLoaderService'),
    GraphicsService = require('src.scripts.services.game.GraphicsService.GraphicsService'),
    ScenesStrategiesService = require('src.scripts.services.core.ScenesStrategiesService.ScenesStrategiesService')
}

return Services
