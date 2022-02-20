local App = require('src.app')
local GUI = require('gui.gui')

local URL = App.constants.urls

local ThemeMap = GUI.ThemeMap
local NodesList = GUI.NodesList

local Theme = class('ThemeMap', ThemeMap)

Theme.__cparams = {'ui_service', 'scenes_service'}

function Theme:initialize(ui_service, scenes_service, nodes_map)
    local nodes = nodes_map:get_table()
    local buttons = nodes.buttons

    local settings = {}
    local scheme = {}

    ThemeMap.initialize(self, ui_service, scenes_service, settings, scheme)
end

return Theme
