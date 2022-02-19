local LongPressDetector = require('gui.drag_and_drop.long_press_detector.long_press_detector')

--- @class DropReceiver
--- @field private node AnimatableNode
--- @field public on_drag fun(element: Draggable)
--- @field public on_drag_start fun(element: Draggable)
--- @field public on_drag_enter fun(element: Draggable)
--- @field public on_drag_over fun(element: Draggable)
--- @field public on_drag_leave fun(element: Draggable)
--- @field public on_drag_end fun(element: Draggable)
--- @field public on_drop fun(element: Draggable)
local DropReceiver = class('DropReceiver')

function DropReceiver:initialize(node)
    self.node = node
    self.long_press_detector = LongPressDetector(node)
end

function DropReceiver:is_picked(action)
    return self.node:is_picked(action)
end

--- @param element Draggable
function DropReceiver:on_drag(element)
end

--- @param element Draggable
function DropReceiver:on_drag_start(element)
end

--- @param element Draggable
function DropReceiver:on_drag_enter(element)
end

--- @param element Draggable
function DropReceiver:on_drag_over(element)
end

--- @param element Draggable
function DropReceiver:on_drag_leave(element)
end

--- @param element Draggable
function DropReceiver:on_drag_end(element)
end

--- @param element Draggable
function DropReceiver:on_drop(element)
end

return DropReceiver
