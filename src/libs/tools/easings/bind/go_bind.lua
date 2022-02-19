local EasingFunc = require('src.libs.tools.easings.functions.functions')

return {
    [go.EASING_INBACK] = EasingFunc.in_back,
    [go.EASING_INCUBIC] = EasingFunc.in_cubic,
    [go.EASING_INSINE] = EasingFunc.in_sine,
    [go.EASING_OUTSINE] = EasingFunc.out_sine,
    [go.EASING_OUTCIRC] = EasingFunc.out_circ,
    [go.EASING_OUTQUINT] = EasingFunc.out_quint,
    [go.EASING_OUTCUBIC] = EasingFunc.out_cubic,
    [go.EASING_OUTQUAD] = EasingFunc.out_quad,
}
