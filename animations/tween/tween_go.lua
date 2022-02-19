local Tween = require('animations.tween.tween')

--- @class TweenGO : Tween
local TweenGO = class('AnimationTweenGO', Tween)

function TweenGO:initialize(object, to, duration, anim_property)
    self.object = object
    self.to = to
    self.anim_property = anim_property
    self.anim_playback = go.PLAYBACK_ONCE_FORWARD
    self.anim_delay = 0
    self.anim_easing = go.EASING_LINEAR
    self.anim_duration = duration
    self.callbacks = {}

    self.is_running = false
end

function TweenGO:on_run(callback)
    go.animate(
        self.object.id,
        self.anim_property,
        self.anim_playback,
        self.to,
        self.anim_easing,
        self.anim_duration,
        self.anim_delay,
        function()
            callback(self)
        end
    )
end

function TweenGO:on_cancel()
    go.cancel_animations(self.object.id, self.anim_property)
end

return TweenGO
