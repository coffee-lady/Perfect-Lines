local SubscribedButton = require('gui.controls.subscribed_button.subscribed_button')
local AbstractMenu = require('gui.controls.abstract_menu.abstract_menu')

--- @class ButtonsMenu : AbstractMenu
local ButtonsMenu = class('ButtonsMenu', AbstractMenu)

ButtonsMenu.__cparams = {'ui_service'}

function ButtonsMenu:initialize(ui_service, map)
    AbstractMenu.initialize(self, ui_service, SubscribedButton, map)
end

return ButtonsMenu
