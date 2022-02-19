local Layouts = require('gui.core.layouts.layouts')

local function get_id(id)
    if type(id) == 'table' then
        return id.container
    end

    return id
end

--- @class AbstractMenu
local AbstractMenu = class('AbstractMenu')

AbstractMenu.__cparams = {'ui_service'}

function AbstractMenu:initialize(ui_service, View, map)
    self.ui_service = ui_service

    self.View = View
    self.buttons = {}

    if map then
        self:init_with_id(map)
    end
end

function AbstractMenu:init_with_id(map)
    for ids, callback in pairs(map) do
        self:add(ids, callback)
    end
end

function AbstractMenu:init_with_nodes(map)
    for id, data in pairs(map) do
        self.buttons[id] = inject(self.View, data, data.callback)
    end
end

function AbstractMenu:add(ids, callback)
    self.buttons[ids.container] = inject(self.View, ids, callback)
end

function AbstractMenu:enable_by_id(id)
    self.buttons[get_id(id)]:enable()
end

function AbstractMenu:disable_by_id(id, disable_color)
    local colors = self.ui_service:get_common_pallettes()
    self.buttons[get_id(id)]:disable(disable_color, colors.disabled)
end

function AbstractMenu:set_disabled_color_by_id(id, options)
    local colors = self.ui_service:get_common_pallettes()
    self.buttons[get_id(id)]:set_disabled_color(colors.disabled, options)
end

function AbstractMenu:set_button_type_id(btn_id, type_id)
    self.buttons[get_id(btn_id)]:set_button_type_id(type_id)
end

function AbstractMenu:show(id)
    self.buttons[get_id(id)]:show()
end

function AbstractMenu:hide(id)
    self.buttons[get_id(id)]:hide()
end

function AbstractMenu:to_vertical_layout(order_arr, gaps)
    return Layouts.VerticalLayout(self:_get_layout_arr(order_arr), gaps)
end

function AbstractMenu:to_landscape_layout(order_arr, gaps)
    return Layouts.LandscapeLayout(self:_get_layout_arr(order_arr), gaps)
end

function AbstractMenu:_get_layout_arr(order_arr)
    local arr = {}

    for i = 1, #order_arr do
        arr[i] = self.buttons[order_arr[i].container]._target
    end

    return arr
end

function AbstractMenu:get_subscription(id)
    return self.buttons[get_id(id)]:get_subscription()
end

function AbstractMenu:unsubscribe()
    for _, button in pairs(self.buttons) do
        button:get_subscription():unsubscribe()
    end
end

return AbstractMenu
