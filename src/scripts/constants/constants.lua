local Constants = {
    gui = require('src.scripts.constants.gui.gui_constants'),
    sounds = require('src.scripts.constants.sounds.sounds_constants'),
    localization = require('src.scripts.constants.localization.localization')
}

Constants.urls = {
    bootstrap = 'bootstrap',
    start_scene = 'start_scene',
    game_scene = 'game_scene'
}

Constants.fonts = {
    Dosis = {
        id = 'Dosis',
        Bold = 'Dosis30-Bold'
    }
}

Constants.msg = {
    acquire_input_focus = hash('acquire_input_focus'),
    collision_response = hash('collision_response'),
    screen = {
        resize = hash('_screen_resized')
    },
    game_loaded = hash('game_loaded'),
    localization_change = hash('localization_change'),
    sounds = {
        _play_sound = hash('_play_sound'),
        _stop_sound = hash('_stop_sound'),
        _pause_sound = hash('_pause_sound')
    },
    appbars = {
        appbar_button_click = hash('appbar_button_click')
    },
    popups = {
        popup_closed = hash('popup_closed')
    },
    add_action = hash('add_action'),
    themes_unlocked = hash('themes_unlocked'),
    undo_action = hash('undo_action'),
    redo_action = hash('redo_action'),
    localization = {
        _lang_changed = hash('_lang_changed'),
        language_changed = hash('language_changed')
    },
    ads = {
        _resume_interstitial_timer = hash('_ads_resume_int_timer'),
        short_ad_preview = hash('short_ad_preview'),
        close_banner = hash('close_banner'),
        error = hash('ads_error')
    },
    auth = {
        _success_emit_msg = hash('_auth_success_emit_msg'),
        _attempt_emit_msg = hash('_auth_attempt_emit_msg'),
        auth_attempt = hash('auth_attempt'),
        success_auth = hash('success_auth')
    },
    themes = {
        _unlocked_emit_msg = hash('_themes_unlocked_emit'),
        preview_end = hash('theme_preview_end')
    },
    js = {
        save_data = hash('save_data'),
        get_loading_time = hash('get_loading_time'),
        several_tabs_warning = hash('several_tabs_warning'),
        online = hash('online'),
        offline = hash('offline'),
        resize = hash('resize')
    },
    store = {
        _start_offer_timer = hash('_start_offer_timer'),
        _end_offer_timer = hash('_end_offer_timer'),
        offer_finished = hash('offer_finished'),
        _emit_starter_pack_bought = hash('_emit_starter_pack_bought'),
        starter_pack_bought = hash('starter_pack_bought'),
        promotion_started = hash('promotion_started')
    },
    leaderboards = {
        score_updated = hash('leaderboards_score_updated'),
        _emit_score_updated = hash('leaderboards_emit_score_updatedd')
    },
    feedback = {
        feedback_close = hash('feedback_close'),
        feedback_accept = hash('feedback_accept')
    },
    rating_popup = {
        leaderboard_loaded = hash('rating_popup_leaderboard_loaded')
    }
}

Constants.actions = {
    click = hash('click')
}

return Constants
