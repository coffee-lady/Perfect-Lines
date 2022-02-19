local Core = require('gui.core.core')
local Widget = require('gui.widget.widget')
local Controls = require('gui.controls.controls')
local AbstractButton = require('gui.controls.abstract_button.abstract_button')

local BoxNode = Core.BoxNode

--- @class SliderArrowsView : Widget
local SliderArrowsView = class('SliderArrowsView', Widget)

SliderArrowsView.__cparams = {'event_bus', 'ui_service', 'scenes_service'}

local function get_container_view(id)
    if type(id) == 'table' then
        return type(id.container) == 'string' and BoxNode(id.container) or id.container
    end

    return id
end

function SliderArrowsView:initialize(event_bus, ui_service, scenes_service, params)
    Widget.initialize(self, event_bus, ui_service, scenes_service)

    self.scenes_service = scenes_service

    self.items_count = params.items_count
    self.arrow_next_id = params.arrow_next_id
    self.arrow_prev_id = params.arrow_prev_id
    self.scroll_prev = params.scroll_prev
    self.scroll_next = params.scroll_next

    self.nodes = {arrow_next = get_container_view(self.arrow_next_id), arrow_prev = get_container_view(self.arrow_prev_id)}

    self:set_flow_buttons_menu({[self.arrow_prev_id] = self.scroll_prev, [self.arrow_next_id] = self.scroll_next})

    self.scene_id = self.scenes_service:get_current_scene()

    self.boundary_buttons = inject(Controls.FlowButtonsMenu, {})

    self:set_button_type_id(self.arrow_prev_id, AbstractButton.BUTTON_SLIDER)
    self:set_button_type_id(self.arrow_next_id, AbstractButton.BUTTON_SLIDER)
end

function SliderArrowsView:on_click(action)
    self.boundary_buttons:on_click(action)
    self:flow_buttons_on_click(action)
end

function SliderArrowsView:add_boundary_arrows(ids, callbacks)
    self.use_end_arrows = true
    self.arrow_next_boundary_id = ids.arrow_next_boundary
    self.arrow_prev_boundary_id = ids.arrow_prev_boundary

    self.nodes.arrow_next_boundary = get_container_view(self.arrow_next_boundary_id)
    self.nodes.arrow_prev_boundary = get_container_view(self.arrow_prev_boundary_id)

    self.boundary_buttons:add(ids.arrow_next_boundary, callbacks.arrow_next_boundary)
    self.boundary_buttons:add(ids.arrow_prev_boundary, callbacks.arrow_prev_boundary)

    self.boundary_buttons:set_button_type_id(ids.arrow_next_boundary, AbstractButton.BUTTON_SLIDER)
    self.boundary_buttons:set_button_type_id(ids.arrow_prev_boundary, AbstractButton.BUTTON_SLIDER)
end

function SliderArrowsView:are_arrows_picked(action)
    for _, arrow in pairs(self.nodes) do
        if arrow:is_enabled() and arrow:is_picked(action) then
            return true
        end
    end

    return false
end

function SliderArrowsView:check_showing_arrows(current_scroll_index)
    self.buttons:show(self.arrow_next_id)
    self.buttons:show(self.arrow_prev_id)

    if self.use_end_arrows then
        self.boundary_buttons:hide(self.arrow_prev_boundary_id)
        self.boundary_buttons:hide(self.arrow_next_boundary_id)
    end

    if current_scroll_index == 0 then
        self.buttons:hide(self.arrow_prev_id)
        if self.use_end_arrows then
            self.boundary_buttons:show(self.arrow_prev_boundary_id)
        end
        return
    end

    if current_scroll_index == self.items_count - 1 then
        self.buttons:hide(self.arrow_next_id)

        if self.use_end_arrows then
            self.boundary_buttons:show(self.arrow_next_boundary_id)
        end
    end
end

return SliderArrowsView
