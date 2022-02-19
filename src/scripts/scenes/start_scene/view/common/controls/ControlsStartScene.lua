local App = require('src.app')
local GUI = require('gui.gui')

local ButtonsMenu = GUI.ButtonsMenu
local SubscriptionsMap = App.libs.SubscriptionsMap
local Async = App.libs.async
local Luject = App.libs.luject

local ID = App.constants.gui.screens.start_scene
local URL = App.constants.urls
local MSG = App.constants.msg

local ControlsMap = class('ControlsMap')

ControlsMap.__cparams = {'scenes_service'}

function ControlsMap:initialize(scenes_service)
    --- @type ScenesService
    self.scenes_service = scenes_service

    self.main_buttons = Luject:resolve_class(ButtonsMenu, {
        [ID.button_play] = function()
            self.scenes_service:show(URL.game_scene)
        end,
    })
end

function ControlsMap:final()
    self.main_buttons:unsubscribe()
end

return ControlsMap
