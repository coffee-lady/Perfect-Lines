local App = require('src.app')
local GUI = require('gui.gui')

local ID = App.constants.gui.screens.game_screen
local URL = App.constants.urls

local ButtonsMenu = GUI.ButtonsMenu

local Controls = class('Controls')

Controls.__cparams = {'scenes_service'}

function Controls:initialize(scenes_service)
    --- @type ScenesService
    self.scenes_service = scenes_service

    self.buttons = inject(ButtonsMenu, {})
end

function Controls:final()
    self.buttons:unsubscribe()
end

return Controls
