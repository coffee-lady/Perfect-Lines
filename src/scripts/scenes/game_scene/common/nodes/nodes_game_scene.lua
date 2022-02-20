local App = require('src.app')
local GUI = require('gui.gui')

local ID = App.constants.gui.screens.game_scene

local TextNode = GUI.TextNode
local BoxNode = GUI.BoxNode

local Nodes = class('Nodes')

function Nodes:initialize()
    self.nodes = {
        root = BoxNode(ID.root),
        user = {
            container = BoxNode(ID.user.container),
            icon_bg = BoxNode(ID.user.icon_bg),
            icon = BoxNode(ID.user.icon),
            stroke = BoxNode(ID.user.stroke),
            text = TextNode(ID.user.text),
        },
        points = {
            container = BoxNode(ID.points.container),
            icon = BoxNode(ID.points.icon),
            text = TextNode(ID.points.text),
        },
        game_point = {
            container = BoxNode(ID.game_point.container),
            icon = BoxNode(ID.game_point.icon),
            highlight = BoxNode(ID.game_point.highlight),
        },
        tool_hint = {
            container = BoxNode(ID.tool_hint.container),
            icon = BoxNode(ID.tool_hint.icon),
            text = TextNode(ID.tool_hint.text),
        },
        tool_clear = {
            container = BoxNode(ID.tool_clear.container),
            icon = BoxNode(ID.tool_clear.icon),
            text = TextNode(ID.tool_clear.text),
        },
    }
end

function Nodes:get_table()
    return self.nodes
end

return Nodes
