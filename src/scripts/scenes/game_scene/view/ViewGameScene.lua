local App = require('src.app')

local SceneView = App.libs.scenes.SceneView

--- @class ViewGameScreen : SceneView
local ViewGameScreen = class('ViewGameScreen', SceneView)

function ViewGameScreen:initialize(UIMaps)
    SceneView.initialize(self, UIMaps)
end

return ViewGameScreen
