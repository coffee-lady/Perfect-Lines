local EasingFunc = require('src.libs.tools.easings.functions.functions')

return {
    [gui.EASING_INBACK] = EasingFunc.in_back,
    [gui.EASING_INCUBIC] = EasingFunc.in_cubic,
    [gui.EASING_INSINE] = EasingFunc.in_sine,
    [gui.EASING_OUTSINE] = EasingFunc.out_sine,
    [gui.EASING_OUTCIRC] = EasingFunc.out_circ,
    [gui.EASING_OUTQUINT] = EasingFunc.out_quint,
    [gui.EASING_OUTCUBIC] = EasingFunc.out_cubic,
    [gui.EASING_OUTQUAD] = EasingFunc.out_quad,
}

