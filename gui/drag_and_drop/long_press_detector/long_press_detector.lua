local MIN_LONG_PRESS_DURATION = 0.2

--- @class LongPressDetector
--- @field private node Node
--- @field private started_timer number
--- @field private long_press_detector LongPressDetector
--- @field private is_dragging boolean
--- @field public on_click fun(action_id:string, action:table)
--- @field public is_last_input_long_press fun(): boolean
local LongPressDetector = class('LongPressDetector')

function LongPressDetector:initialize(node)
    self.node = node
end

--- @param action table
function LongPressDetector:on_click(action)
    if not self.node:is_picked(action) or action.released then
        self.started_timer = nil
        return
    end

    if action.pressed then
        self.started_timer = socket.gettime()
    end
end

function LongPressDetector:is_last_input_long_press()
    if not self.started_timer then
        return false
    end

    return socket.gettime() - self.started_timer >= MIN_LONG_PRESS_DURATION
end

return LongPressDetector
