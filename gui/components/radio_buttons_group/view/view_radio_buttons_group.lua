local Core = require('gui.core.core')
local Widget = require('gui.widget.widget')
local Constants = require('gui.constants.gui_constants')
local ButtonView = require('gui.components.radio_buttons_group.view.view_radio_button')

local NodeFactory = Core.NodeFactory

--- @class RadioButtonsGroupView : Widget
local RadioButtonsGroupView = class('RadioButtonsGroupView', Widget)

RadioButtonsGroupView.__cparams = {'event_bus', 'ui_service'}

function RadioButtonsGroupView:initialize(event_bus, ui_service, params)
    Widget.initialize(self, event_bus, ui_service, true)

    local ids = params.ID
    self.button_factory = NodeFactory(ids.container)
    self.params = params
    self.buttons = {}

    self:init()
end

function RadioButtonsGroupView:init()
    local items_nodes = {}

    for _, item_id in pairs(self.params.items) do
        items_nodes[#items_nodes + 1] = self:_create_item(item_id)
    end

    if self.params.align == Constants.ALIGN_VERTICALLY then
        self:align_nodes_vertically(items_nodes, self.params.gaps)
    end

    if self.params.align == Constants.ALIGN_HORIZONTALLY then
        self:align_nodes_horizontally(items_nodes, self.params.gaps)
    end
end

function RadioButtonsGroupView:_create_item(item_id)
    local gui_nodes = self.button_factory:create_tree(item_id)
    local btn_view = inject(ButtonView, item_id, gui_nodes, self.params)
    self.buttons[#self.buttons + 1] = btn_view
    return btn_view:get_container()
end

function RadioButtonsGroupView:get_pressed_btn_id(action)
    for i = 1, #self.buttons do
        if self.buttons[i]:is_pressed(action) then
            return self.buttons[i].id
        end
    end

    return false
end

function RadioButtonsGroupView:select(id)
    for i = 1, #self.buttons do
        if self.buttons[i].id == id then
            self.buttons[i]:select()
        else
            self.buttons[i]:deselect()
        end
    end
end

return RadioButtonsGroupView
