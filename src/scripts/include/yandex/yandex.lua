local YandexAPI = {
    YandexInitializer = require('src.scripts.include.yandex.initializer.YandexInitializer'),
    YandexBannerAds = require('src.scripts.include.yandex.ads.YandexBannerAds'),
    YandexInterstitialAds = require('src.scripts.include.yandex.ads.YandexInterstitialAds'),
    YandexRewardedAds = require('src.scripts.include.yandex.ads.YandexRewardedAds'),
    YandexRewardedAdsAlgorithm = require('src.scripts.include.yandex.ads.YandexRewardedAdsAlgorithm'),
    YandexAuth = require('src.scripts.include.yandex.auth.YandexAuth'),
    YandexStorage = require('src.scripts.include.yandex.storage.YandexStorage'),
    YandexPayments = require('src.scripts.include.yandex.payments.YandexPayments'),
    YandexLeaderboards = require('src.scripts.include.yandex.leaderboards.YandexLeaderboards'),
    YandexFeedback = require('src.scripts.include.yandex.feedback.YandexFeedback')
}

return YandexAPI
