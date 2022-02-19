local LongPressDetector = require('gui.drag_and_drop.long_press_detector.long_press_detector')

--- @class Draggable
--- @field private draggable_node AnimatableNode
--- @field private pickable_node AnimatableNode
--- @field private long_press_detector LongPressDetector
local Draggable = class('Draggable')

function Draggable:initialize(draggable_node, pickable_node)
    self.draggable_node = draggable_node
    self.pickable_node = pickable_node
    self.long_press_detector = LongPressDetector(pickable_node)
end

function Draggable:set_pos_xy(x, y)
    self.draggable_node:set_pos_xy(x, y)
end

function Draggable:on_click(action)
    self.long_press_detector:on_click(action)
end

function Draggable:is_under_long_press(action)
    return self.long_press_detector:is_last_input_long_press() and self:is_picked(action)
end

function Draggable:is_picked(action)
    return self.pickable_node:is_picked(action)
end

function Draggable:on_drag()
end

function Draggable:on_drag_start()
end

--- @param drop_receiver DropReceiver | nil
function Draggable:on_drag_enter(drop_receiver)
end

--- @param drop_receiver DropReceiver | nil
function Draggable:on_drag_over(drop_receiver)
end

--- @param drop_receiver DropReceiver | nil
function Draggable:on_drag_leave(drop_receiver)
end

function Draggable:on_drag_end()
end

--- @param drop_receiver DropReceiver | nil
function Draggable:on_drop(drop_receiver)
end

return Draggable
