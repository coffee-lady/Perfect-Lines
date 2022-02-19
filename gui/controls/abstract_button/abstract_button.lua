local BoxNode = require('gui.core.nodes.box_node.box_node')
local TextNode = require('gui.core.nodes.text_node.text_node')

local BOOTSTRAP_URL = 'bootstrap'
local ACTION_CLICK = hash('click')

local function get_text_object(id)
    return type(id) == 'string' and TextNode(id) or id
end

local function get_box_object(id)
    return type(id) == 'string' and BoxNode(id) or id
end

--- @class AbstractButton
local AbstractButton = class('AbstractButton')

AbstractButton.__cparams = {'scenes_service'}

AbstractButton.BUTTON_DEFAULT = 'btn_default'
AbstractButton.BUTTON_LINK = 'btn_link'
AbstractButton.BUTTON_SLIDER = 'btn_slider'
AbstractButton.BUTTON_CLOSE = 'btn_close'

AbstractButton.BUTTON_CLICKED = hash('btn_clicked')

function AbstractButton:initialize(scenes_service, ids, on_click)
    --- @type ScenesService
    self.scenes_service = scenes_service

    local container_id = ids.container
    local inner_id = ids.inner
    local text_id = ids.text
    local icon_wrapper_id = ids.icon_wrapper

    self.nodes = {
        container = get_box_object(container_id)
    }

    if inner_id then
        self.nodes.inner = get_box_object(inner_id)
    else
        self.nodes.inner = self.nodes.container
    end

    if icon_wrapper_id then
        self.nodes.icon_wrapper = get_box_object(icon_wrapper_id)
    end

    if text_id then
        self._text_node = get_text_object(text_id)
    end

    self._scale = self.nodes.inner:get_scale()
    self._scale.x = math.abs(self._scale.x)
    self._scale.y = math.abs(self._scale.y)
    self._is_pressed = false
    self._on_click = on_click or function()
        end

    self.disabled = false
    self.type_id = AbstractButton.BUTTON_DEFAULT
end

function AbstractButton:set_button_type_id(type_id)
    self.type_id = type_id
end

function AbstractButton:click(action)
    local is_picked = self.nodes.container:is_picked(action)
    self:_post_click_msg(action, is_picked)

    if self.disabled then
        return
    end

    if is_picked then
        if action.pressed and not self._is_pressed then
            self:press()
            return
        end

        if action.released and self._is_pressed then
            self:release()
            self:do_action()
            return
        end

        if not self._is_pressed then
            self:press()
            return
        end

        return
    end

    if self._is_pressed then
        self:release()
    end
end

function AbstractButton:press()
    self._is_pressed = true
end

function AbstractButton:release()
    self._is_pressed = false
end

function AbstractButton:_post_click_msg(action, is_picked)
    if action.pressed and is_picked then
        self.scenes_service:post_to_go(
            BOOTSTRAP_URL,
            AbstractButton.BUTTON_CLICKED,
            {
                type_id = self.type_id
            }
        )
    end
end

function AbstractButton:do_action()
    self._on_click()
end

function AbstractButton:enable()
    self.disabled = false

    if self._native_color then
        self.nodes.inner:set_color(self._native_color)
    end
end

function AbstractButton:disable(disable_color, color_map)
    self.disabled = true

    if not disable_color then
        return
    end

    self:set_disabled_color(color_map)
end

function AbstractButton:set_disabled_color(color_map, options)
    self._native_color = self.nodes.inner:get_color()

    options = options or {}

    if options.inner then
        self.nodes.inner:set_color(color_map.graphics)
    end

    if options.icon_wrapper and self.nodes.icon_wrapper then
        self.nodes.icon_wrapper:set_color(color_map.graphics)
    end

    if options.text and self._text_node and color_map.text then
        self._text_node:set_color(color_map.text)
    end
end

function AbstractButton:show()
    self.disabled = false
    self.hidden = false

    self.nodes.container:set_enabled(true)
    self.nodes.inner:set_enabled(true)
end

function AbstractButton:hide()
    self.disabled = true
    self.hidden = true

    self.nodes.container:set_enabled(false)
    self.nodes.inner:set_enabled(false)
end

function AbstractButton:delete()
end

return AbstractButton
