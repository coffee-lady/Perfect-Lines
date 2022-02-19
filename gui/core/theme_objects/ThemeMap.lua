local ThemeNode = require('gui.core.theme_objects.ThemeNode')
local StaticThemeNode = require('gui.core.theme_objects.StaticThemeNode')
local NodesList = require('gui.core.nodes.nodes_list.nodes_list')

local ThemeMap = class('ThemeMap')

ThemeMap.__cparams = {'ui_service', 'scenes_service'}

function ThemeMap:initialize(ui_service, scenes_service, settings, scheme)
    --- @type UIService
    self.ui_service = ui_service
    --- @type ScenesService
    self.scenes_service = scenes_service

    self.is_common = settings.is_common
    self.extra_key = settings.extra_key
    self.scene_id = settings.scene_id or self.scenes_service:get_current_scene()
    self.theme = self.is_common and self.ui_service:get_common_colors() or self.ui_service:get_scene_colors(self.scene_id)

    assert(self.theme, 'no theme for ' .. self.scene_id)

    if self.extra_key then
        self.theme = self.theme[self.extra_key]
    end

    self.scheme = scheme
    self.map = {}

    -- print('initialize', self.scene_id)

    self:_fill_scheme()
    self.ui_service.event_theme_changed:add(self.on_event_theme_changed, self)
end

-- example of scheme:
-- (nodes is a table of GUINodes)
-- {
--     widget_icon = {
--         is_static = true,
--         disable_submode = true,
--         map = {
--             title = nodes.title,
--             bg = nodes.icon,
--         },
--     },
-- }
function ThemeMap:_fill_scheme()
    for theme_object_key, item in pairs(self.scheme) do
        self:add(theme_object_key, item)
    end
end

function ThemeMap:on_event_theme_changed()
    pcall(self.refresh, self)
end

function ThemeMap:add(theme_object_key, item)
    local ThemeNodeType = item.is_static and StaticThemeNode or ThemeNode
    local colors_key = item.colors_key and item.colors_key or theme_object_key

    assert(self.theme[colors_key], 'no colors for ' .. colors_key)

    local params = {
        primary_mode = item.primary_mode,
        disable_submode = item.disable_submode
    }
    self.map[theme_object_key] = ThemeNodeType(item.map, self.theme[colors_key], params)
end

function ThemeMap:add_to_list(list_key, theme_object_map, params)
    if not self.map[list_key] then
        local ThemeNodeType = params.is_static and StaticThemeNode or ThemeNode

        local map = {}
        for key, node in pairs(theme_object_map) do
            map[key] = NodesList(node)
        end

        local theme_params = {
            disable_submode = params.disable_submode
        }
        self.map[list_key] = ThemeNodeType(map, self.theme[list_key], theme_params)
        return
    end

    for key, node in pairs(theme_object_map) do
        self.map[list_key]:add_to_list(key, node)
    end

    self:refresh()
end

function ThemeMap:add_list(list_key, list_data)
    local ThemeNodeType = list_data.is_static and StaticThemeNode or ThemeNode

    local map = {}

    for i = 1, #list_data.list do
        local item = list_data.list[i]

        for key, object in pairs(item) do
            if not map[key] then
                map[key] = NodesList()
            end

            map[key]:add(object)
        end
    end

    local params = {
        disable_submode = list_data.disable_submode
    }
    self.map[list_key] = ThemeNodeType(map, self.theme[list_key], params)

    self:refresh()
end

function ThemeMap:refresh()
    self.theme = self.is_common and self.ui_service:get_common_colors() or self.ui_service:get_scene_colors(self.scene_id)

    if self.extra_key then
        self.theme = self.theme[self.extra_key]
    end

    for theme_object_key, theme_object in pairs(self.map) do
        local scheme_item = self.scheme[theme_object_key]
        local colors_key

        if scheme_item then
            colors_key = scheme_item.colors_key and scheme_item.colors_key or theme_object_key
        else
            colors_key = theme_object_key
        end

        theme_object:refresh(self.theme[colors_key])
    end
end

function ThemeMap:get_map()
    return self.map
end

function ThemeMap:final()
    -- print('final', self.scene_id)
    self.ui_service.event_theme_changed:remove(self.refresh, self)
end

return ThemeMap
