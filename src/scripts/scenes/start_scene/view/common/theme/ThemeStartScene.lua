local App = require('src.app')
local GUI = require('gui.gui')

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
                bg = nodes.background
            }
        },
        appbar = {
            is_static = true,
            map = {
                simple_button = NodesList(nodes.button_settings.icon, nodes.button_store.icon),
                simple_button_text = NodesList(nodes.button_settings.text, nodes.button_store.text)
            }
        },
        button_play = {
            is_static = true,
            map = {
                inner = nodes.button_play.inner
            }
        }
    }

    ThemeMap.initialize(self, ui_service, scenes_service, settings, scheme)
end

return Theme
