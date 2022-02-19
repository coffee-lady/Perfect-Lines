--- @class DragAndDropController
--- @field private items_to_drag Draggable[]
--- @field private drop_receivers DropReceiver[]
--- @field private current_drag_item Draggable
--- @field private current_drop_receiver DropReceiver
--- @field private is_dragging boolean
--- @field public on_input fun(action_id:string, action:table)
local DragAndDropController = class('DragAndDropController')

--- @param items_to_drag Draggable[]
--- @param drop_receivers DropReceiver[]
function DragAndDropController:initialize(items_to_drag, drop_receivers)
    self.items_to_drag = items_to_drag
    self.drop_receivers = drop_receivers
    self.is_dragging = false
end

function DragAndDropController:on_click(action)
    if action.released then
        if self.is_dragging then
            self:_drag_end()
        end
        return
    end

    self:_emit_items_on_click(action)

    if not self.is_dragging then
        self:_check_draggables_for_starting_drag(action)
        return
    end

    self:_update_current_draggable(action)
    self:_emit_droppable_on_drag()
    self:_check_for_current_droppable(action)
end

--- @param drag_item Draggable
function DragAndDropController:_drag_start(drag_item)
    self.current_drag_item = drag_item
    self.current_drag_item:on_drag_start()
    self.is_dragging = true

    for i = 1, #self.drop_receivers do
        self.drop_receivers[i]:on_drag_start(drag_item)
    end
end

function DragAndDropController:_drag_end()
    local drag_item = self.current_drag_item
    local drop_receiver = self.current_drop_receiver

    for i = 1, #self.drop_receivers do
        if self.drop_receivers[i] ~= drop_receiver then
            self.drop_receivers[i]:on_drag_end(drag_item)
        end
    end

    if drop_receiver then
        drop_receiver:on_drop(drag_item)
        drag_item:on_drop(drop_receiver)
    else
        drag_item:on_drag_end()
    end

    self.current_drag_item = nil
    self.current_drop_receiver = nil
    self.is_dragging = false
end

function DragAndDropController:_check_draggables_for_starting_drag(action)
    for i = 1, #self.items_to_drag do
        local drag_item = self.items_to_drag[i]

        if drag_item:is_under_long_press(action) then
            self:_drag_start(drag_item)
            break
        end
    end
end

function DragAndDropController:_emit_items_on_click(action)
    for i = 1, #self.items_to_drag do
        self.items_to_drag[i]:on_click(action)
    end
end

function DragAndDropController:_update_current_draggable(action)
    self.current_drag_item:set_pos_xy(action.x, action.y)
    self.current_drag_item:on_drag()
end

function DragAndDropController:_emit_droppable_on_drag()
    for i = 1, #self.drop_receivers do
        self.drop_receivers[i]:on_drag(self.current_drag_item)
    end
end

function DragAndDropController:_check_for_current_droppable(action)
    local was_any_droppable_picked = false
    local prev_drop_receiver = self.current_drop_receiver

    for i = 1, #self.drop_receivers do
        local drop_receiver = self.drop_receivers[i]

        if drop_receiver:is_picked(action) then
            was_any_droppable_picked = true
            self:_check_picked_droppable(prev_drop_receiver, drop_receiver)
        end
    end

    if not was_any_droppable_picked then
        if self.current_drop_receiver then
            self.current_drop_receiver:on_drag_leave(self.current_drag_item)
        end

        self.current_drop_receiver = nil
    end
end

function DragAndDropController:_check_picked_droppable(prev_receiver, new_receiver)
    if not prev_receiver or prev_receiver ~= new_receiver then
        self:_change_current_drop_receiver(prev_receiver, new_receiver)
    else
        self:_drag_over_current_receiver()
    end
end

function DragAndDropController:_change_current_drop_receiver(prev_receiver, new_receiver)
    if prev_receiver then
        self:_leave_prev_drop_receiver(prev_receiver)
    end

    self:_enter_new_drop_receiver(new_receiver)
end

function DragAndDropController:_leave_prev_drop_receiver(prev_receiver)
    local drag_item = self.current_drag_item

    prev_receiver:on_drag_leave(drag_item)
    drag_item:on_drag_leave(prev_receiver)
end

function DragAndDropController:_enter_new_drop_receiver(new_receiver)
    local drag_item = self.current_drag_item

    self.current_drop_receiver = new_receiver
    new_receiver:on_drag_enter(drag_item)
    drag_item:on_drag_enter(new_receiver)
end

function DragAndDropController:_drag_over_current_receiver()
    local drag_item = self.current_drag_item
    local current_receiver = self.current_drop_receiver

    current_receiver:on_drag_over(drag_item)
    drag_item:on_drag_over(current_receiver)
end

return DragAndDropController
