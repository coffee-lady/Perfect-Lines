local App = require('src.app')
local GUI = require('gui.gui')

local URL = App.constants.urls

local ThemeMap = GUI.ThemeMap
local NodesList = GUI.NodesList

local Theme = class('ThemeMap', ThemeMap)

Theme.__cparams = {'ui_service', 'scenes_service'}

function Theme:initialize(ui_service, scenes_service, nodes_map)
    local nodes = nodes_map:get_table()

    local settings = {}
    local scheme = {
        root = {
            is_static = true,
            map = {
                bg = nodes.root,
                points = NodesList(nodes.points.icon, nodes.points.text),
                tools = NodesList(nodes.tool_hint.icon, nodes.tool_hint.text, nodes.tool_clear.icon,
                                  nodes.tool_clear.text),
            },
        },
        user = {
            disable_submode = true,
            map = {bg = nodes.user.icon_bg, stroke = nodes.user.stroke, icon = nodes.user.icon, text = nodes.user.text},
        },
        game_point = {disable_submode = true, map = {icon = nodes.game_point.icon, stroke = nodes.game_point.stroke}},
    }

    ThemeMap.initialize(self, ui_service, scenes_service, settings, scheme)
end

return Theme
