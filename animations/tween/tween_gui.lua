local Tween = require('animations.tween.tween')

--- @class TweenGUI : Tween
local TweenGUI = class('AnimationTweenGUI', Tween)

function TweenGUI:initialize(object, to, duration, anim_property)
    self.object = object
    self.to = to
    self.anim_property = anim_property
    self.anim_playback = gui.PLAYBACK_ONCE_FORWARD
    self.anim_delay = 0
    self.anim_easing = gui.EASING_LINEAR
    self.anim_duration = duration
    self.callbacks = {}

    assert(self.to, 'TweenGUI: no property TO ' .. inspect({self.anim_property, self.anim_playback}))

    self.is_running = false
end

function TweenGUI:on_run(callback)
    gui.animate(self.object.target, self.anim_property, self.to, self.anim_easing, self.anim_duration, self.anim_delay, function()
        callback(self)
    end, self.anim_playback)
end

function TweenGUI:on_cancel()
    gui.cancel_animation(self.object.target, self.anim_property)
end

return TweenGUI
