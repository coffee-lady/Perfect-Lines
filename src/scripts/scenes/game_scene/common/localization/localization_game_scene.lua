local App = require('src.app')
local GUI = require('gui.gui')

local TextKeys = App.config.localization.keys
local MSG = App.constants.msg

local SceneLocalization = GUI.SceneLocalization

local Localization = class('Localization', SceneLocalization)

Localization.__cparams = {'localization_service'}

function Localization:initialize(localization_service, nodes_map)
    SceneLocalization.initialize(self, localization_service, TextKeys.game_scene)

    self.nodes = nodes_map:get_table()
end

return Localization
