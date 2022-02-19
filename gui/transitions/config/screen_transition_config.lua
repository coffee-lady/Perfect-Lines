local Transition = require('gui.transitions.Transition.Transition')

local Settings = {
    duration = 0.5,
    easing = gui.EASING_OUTCIRC,
}

local ScreenTransitionConfig = {
    show_in = {
        type = Transition.TYPE.FADE_IN,
        duration = Settings.duration,
        easing = Settings.easing,
    },
    show_out = {
        type = Transition.TYPE.FADE_OUT,
        duration = Settings.duration,
        easing = Settings.easing,
    },
    back_in = {
        type = Transition.TYPE.FADE_IN,
        duration = Settings.duration,
        easing = Settings.easing,
    },
    back_out = {
        type = Transition.TYPE.FADE_OUT,
        duration = Settings.duration,
        easing = Settings.easing,
    },
}

return ScreenTransitionConfig
