local ScreensConstants = {
    bootstrap = {
        container = 'container'
    }
}

ScreensConstants.start_scene = {
    root = 'root',
    background = 'background',

    button_settings = {
        container = 'appbar/button_settings/container',
        icon = 'appbar/button_settings/icon',
        text = 'appbar/button_settings/text'
    },

    button_store = {
        container = 'appbar/button_store/container',
        icon = 'appbar/button_store/icon',
        text = 'appbar/button_store/text'
    },

    button_play = {
        container = 'button_play/container',
        inner = 'button_play/inner',
        text = 'button_play/text'
    }
}

ScreensConstants.game_scene = {
    root = 'root',
    background = 'background',

    energy_widget = {
        container = 'appbar/energy/container',
        icon = 'appbar/energy/icon',
        text = 'appbar/energy/text'
    },

    button_pause = {
        container = 'appbar/pause/container',
        icon = 'appbar/pause/icon',
        text = 'appbar/pause/text'
    },

    lives_widget = {
        container = 'appbar/lives/container',
        template = 'appbar/lives/template'
    },

    balls_factory = '/go#balls_factory',
    blocks_factory = '/go#blocks_factory',
    boosts_factory = '/go#boosts_factory',

    platform = '/platform',
    losing_zone = '/losing_zone',

    walls = {
        wall_top = '/wall_top',
        wall_right = '/wall_right',
        wall_left = '/wall_left'
    },

    block = {
        co_kinematic = 'co_kinematic',
        co_trigger = 'co_trigger',
        cracks = 'cracks',
        breaking_pfx_granite = 'breaking_pfx_granite',
        breaking_pfx = 'breaking_pfx',
        decoration_sprite = 'decoration_sprite'
    }
}

return ScreensConstants
