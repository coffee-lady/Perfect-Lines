local AdsConfig = {}

AdsConfig.interstitial = {
    start_level = 1,
    prob_start_game = 1,
    prob_end_game = 1,
    delay = 180,
}

AdsConfig.rewarded = {
    start_level = 1,
    delay = 120,
    min_time = 3,
}

AdsConfig.banner = {
    start_level = 1,
    block_id = 'R-A-734570-3',
    reload_time = 60,
    visible = true,
    css = 'banner',
    height = 120,
}

return AdsConfig
