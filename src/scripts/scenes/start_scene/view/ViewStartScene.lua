local App = require('src.app')
local GUI = require('gui.gui')

local SceneView = App.libs.scenes.SceneView
local LandscapeLayout = GUI.layouts.LandscapeLayout
local TextNode = GUI.TextNode

--- @class ViewStartScene : SceneView
local ViewStartScene = class('ViewStartScene', SceneView)

function ViewStartScene:initialize(UIMaps)
    SceneView.initialize(self, UIMaps)
end

return ViewStartScene
