local App = require('src.app')

local ItemUnlockThemes = class('ItemUnlockThemes')

function ItemUnlockThemes:initialize(context_services, key)
    self.ui_service = context_services.ui_service
    self.is_consumable = false
    self.ui_key = key
end

function ItemUnlockThemes:get_ui_key()
    return self.ui_key
end

function ItemUnlockThemes:apply()
    self.ui_service:unlock_all_themes()
end

return ItemUnlockThemes
