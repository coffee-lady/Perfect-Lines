local Constants = require('src.scripts.constants.constants')

local CommonConfig = {
    dummy_data = require('src.scripts.config.common.dummy_data.dummy_data'),
    localization = require('src.scripts.config.common.localization.localization_config'),
    game = require('src.scripts.config.common.game.game_config'),
    bundle = require('src.scripts.config.common.bundle.bundle_config'),
    data_storage = require('src.scripts.config.common.data_storage.data_storage_config'),
    graphics = require('src.scripts.config.common.graphics.GraphicsConfig'),
    ui_sets_configs = require('src.scripts.config.common.ui.ui_config'),

    debug_mode = {
        PlatformService = false,
        AuthService = false,
        PaymentsService = false,
        StoreService = false,
        PlayerDataStorage = false,
        RewardedAdsService = true,
        RewardedAdsAlgorithm = true,
        InterstitialAdsService = true,
        BannerAdsService = false,
        PaymentsCatalog = false,
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
        default_theme = 'winter',
        default_ui = 'winter',
        available_themes = {{key = 'winter', color = 'FBFAFF'}},
        themes = require('src.scripts.config.common.themes.themes'),
    },

    resources = {localization = '/resources/localization/%s.json', levels = '/resources/levels/%s.json'},

    render_order = {start_scene = 1, game_scene = 2},
}

return CommonConfig
