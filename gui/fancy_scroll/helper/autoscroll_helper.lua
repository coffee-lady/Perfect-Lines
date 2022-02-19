local AutoscrollHelper = class('AutoscrollHelper')

function AutoscrollHelper:initialize(default_easing)
    self.enable = false
    self.elastic = false
    self.duration = 0
    self.start_time = 0
    self.position_end = 0
    self.default_easing = default_easing
    self.easing_func = default_easing
end

function AutoscrollHelper:complete()
    if self.on_complete then
        self.on_complete()
    end

    self:reset()
end

function AutoscrollHelper:reset()
    self.enable = false
    self.elastic = false
    self.duration = 0
    self.start_time = 0
    self.easing_func = self.default_easing
    self.position_end = 0

    self.on_complete = nil
end

return AutoscrollHelper
