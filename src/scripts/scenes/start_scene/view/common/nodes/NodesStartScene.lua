local App = require('src.app')
local GUI = require('gui.gui')

local ID = App.constants.gui.screens.start_scene

local TextNode = GUI.TextNode
local BoxNode = GUI.BoxNode
local NodesList = GUI.NodesList

local NodesMap = class('NodesMap')

function NodesMap:initialize()
    self.nodes = {
        root = BoxNode(ID.root),
        background = BoxNode(ID.background),

        button_settings = {
            container = BoxNode(ID.button_settings.container),
            icon = BoxNode(ID.button_settings.icon),
            text = BoxNode(ID.button_settings.text),
        },

        button_store = {
            container = BoxNode(ID.button_store.container),
            icon = BoxNode(ID.button_store.icon),
            text = BoxNode(ID.button_store.text),
        },

        button_play = {
            inner = BoxNode(ID.button_play.inner),
            text = BoxNode(ID.button_play.text),
        },
    }
end

function NodesMap:get_table()
    return self.nodes
end

return NodesMap
