local PopupTransitionConfig = {
    animation_in = {
        duration = 0.5,
        duration_bg = 0.8,
        delay_bg = 0,
        easing = gui.EASING_OUTEXPO,
        easing_bg = gui.EASING_OUTEXPO,
    },
    animation_out = {
        duration = 0.35,
        duration_bg = 0.6,
        easing = gui.EASING_INEXPO,
        easing_bg = gui.EASING_INEXPO,
    },
}

return PopupTransitionConfig
