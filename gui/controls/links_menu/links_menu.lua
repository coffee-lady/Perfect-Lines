local SubscribedLink = require('gui.controls.subscribed_link.subscribed_link')
local AbstractMenu = require('gui.controls.abstract_menu.abstract_menu')

--- @class LinksMenu: AbstractMenu
local LinksMenu = class('LinksMenu', AbstractMenu)

LinksMenu.__cparams = {'ui_service'}

function LinksMenu:initialize(ui_service, map)
    AbstractMenu.initialize(self, ui_service, SubscribedLink, map)
end

return LinksMenu
