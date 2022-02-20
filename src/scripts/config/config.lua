local Config = {
    dummy_data = require('src.scripts.config.dummy_data.dummy_data'),
    localization = require('src.scripts.config.core.LocalizationConfig'),
    game = require('src.scripts.config.game.GameConfig'),
    bundle = require('src.scripts.config.bundle.bundle_config'),
    data_storage = require('src.scripts.config.core.DataStorageConfig'),
    ads = require('src.scripts.config.business.AdsConfig'),
    leaderboards = require('src.scripts.config.game.LeaderboardsConfig'),

    debug_mode = {
        PlatformService = false,
        AuthService = false,
        StoreService = false,
        PlayerDataStorage = false,
        RewardedAdsService = true,
        RewardedAdsAlgorithm = true,
        InterstitialAdsService = true,
        BannerAdsService = false,
        SoundService = false,
        NakamaAdapter = false,
        LeaderboardsService = false,
        HintsService = false,
        FeedbackService = false,
        FeedbackLocalVersion = false,
        Feeds = false,
    },

    platforms = {yandex = 'yandex', ok = 'ok'},

    platform = 'yandex',

    ui = {
        default_theme = 'coffee',
        available_themes = {{key = 'coffee', color = 'FBFAFF'}},
        themes = require('src.scripts.config.core.themes.themes'),
    },

    resources = {localization = '/resources/localization/%s.json', levels = '/resources/levels/%s.json'},

    render_order = {game_scene = 1},
}

return Config
