local Button = require('gui.controls.button.button')
local AbstractMenu = require('gui.controls.abstract_menu.abstract_menu')

--- @class FlowButtonsMenu : AbstractMenu
local FlowButtonsMenu = class('FlowButtonsMenu', AbstractMenu)

FlowButtonsMenu.__cparams = {'ui_service'}

function FlowButtonsMenu:initialize(ui_service, map)
    AbstractMenu.initialize(self, ui_service, Button, map)
end

function FlowButtonsMenu:on_click(action)
    for _, button in pairs(self.buttons) do
        button:click(action)
    end
end

return FlowButtonsMenu
