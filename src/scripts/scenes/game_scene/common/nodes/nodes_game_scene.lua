local App = require('src.app')
local GUI = require('gui.gui')

local ID = App.constants.gui.screens.game_scene

local TextNode = GUI.TextNode
local BoxNode = GUI.BoxNode

local Nodes = class('Nodes')

function Nodes:initialize()
    self.nodes = {root = BoxNode(ID.root)}
end

function Nodes:get_table()
    return self.nodes
end

return Nodes
