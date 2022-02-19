local monarch = require('monarch.monarch')
local transitions = require('monarch.transitions.gui')
local easings = require('monarch.transitions.easings')

local Transition = class('Transition')

Transition.EASINGS = {
    BACK = easings.BACK(),
    BOUNCE = easings.BOUNCE(),
    CIRC = easings.CIRC(),
    CUBIC = easings.CUBIC(),
    ELASTIC = easings.ELASTIC(),
    EXPO = easings.EXPO(),
    QUAD = easings.QUAD(),
    QUART = easings.QUART(),
    QUINT = easings.QUINT(),
    SINE = easings.SINE(),
}

Transition.TYPE = {
    SLIDE_IN_RIGHT = transitions.slide_in_right,
    SLIDE_IN_LEFT = transitions.slide_in_left,
    SLIDE_IN_TOP = transitions.slide_in_top,
    SLIDE_IN_BOTTOM = transitions.slide_in_bottom,
    SLIDE_OUT_RIGHT = transitions.slide_out_right,
    SLIDE_OUT_LEFT = transitions.slide_out_left,
    SLIDE_OUT_TOP = transitions.slide_out_top,
    SLIDE_OUT_BOTTOM = transitions.slide_out_bottom,
    SCALE_IN = transitions.scale_in,
    SCALE_OUT = transitions.scale_out,
    FADE_IN = transitions.fade_in,
    FADE_OUT = transitions.fade_out,
}

local COMMON_TYPE = {
    IN_RIGHT_OUT_LEFT = 'in_right_out_left',
    IN_LEFT_OUT_RIGHT = 'in_left_out_right',
    LEFT_IN_OUT = 'in_left_out_left',
    RIGHT_IN_OUT = 'in_right_out_right',
    FADE_IN_OUT = 'fade_in_out',
}

local SHOW_IN = 'show_in'
local SHOW_OUT = 'show_out'
local BACK_IN = 'back_in'
local BACK_OUT = 'back_out'

local DEFAULT_CONFIG = {
    show_in = {
        type = Transition.TYPE.FADE_IN,
        easing = gui.EASING_OUTQUAD,
        delay = 0,
    },
    show_out = {
        type = Transition.TYPE.FADE_OUT,
        easing = gui.EASING_INQUAD,
        delay = 0,
    },
    back_in = {
        type = Transition.TYPE.FADE_IN,
        easing = gui.EASING_OUTQUAD,
        delay = 0,
    },
    back_out = {
        type = Transition.TYPE.FADE_OUT,
        easing = gui.EASING_INQUAD,
        delay = 0,
    },
}

--- @param object Node
function Transition:initialize(object)
    self.object = object

    self.transition = transitions.create(object and object.target or nil)

    monarch.add_listener(msg.url())
end

function Transition:show_in(options)
    local default = DEFAULT_CONFIG.show_in
    self:_set(SHOW_IN, options, default)

    return self
end

function Transition:show_out(options)
    local default = DEFAULT_CONFIG.show_out
    self:_set(SHOW_OUT, options, default)

    return self
end

function Transition:back_in(options)
    local default = DEFAULT_CONFIG.back_in
    self:_set(BACK_IN, options, default)

    return self
end

function Transition:back_out(options)
    local default = DEFAULT_CONFIG.back_out
    self:_set(BACK_OUT, options, default)

    return self
end

function Transition:_set(navigation, options, default)
    local type = options.type or default.type
    local duration = options.duration
    local delay = options.delay or default.delay
    local easing = options.easing or default.easing

    if options.object then
        self.transition[navigation](options.object.target, type, easing, duration, delay)
    else
        self.transition[navigation](type, easing, duration, delay)
    end
end

function Transition:in_right_out_left(options)
    return self:_set_common(COMMON_TYPE.IN_RIGHT_OUT_LEFT, options)
end

function Transition:in_left_out_right(options)
    return self:_set_common(COMMON_TYPE.IN_LEFT_OUT_RIGHT, options)
end

function Transition:left_in_out(options)
    return self:_set_common(COMMON_TYPE.LEFT_IN_OUT, options)
end

function Transition:right_in_out(options)
    return self:_set_common(COMMON_TYPE.RIGHT_IN_OUT, options)
end

function Transition:fade_in_out(options)
    return self:_set_common(COMMON_TYPE.FADE_IN_OUT, options)
end

function Transition:_set_common(type, options)
    local object = options.object or self.object
    local duration = options.duration
    local delay = options.delay
    local easing = options.easing

    self.transition = transitions[type](object.target, duration, delay, easing)

    return self
end

function Transition:on_message(message_id, message, sender)
    self.transition.handle(message_id, message, sender)
end

function Transition:final()
    monarch.remove_listener(msg.url())
end

return Transition
