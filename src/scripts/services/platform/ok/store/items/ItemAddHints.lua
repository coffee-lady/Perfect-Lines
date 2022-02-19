local App = require('src.app')

local ItemAddHints = class('ItemAddHints')

function ItemAddHints:initialize(context_services, key, count)
    self.data_storage_use_cases = context_services.data_storage_use_cases
    self.count = count
    self.is_consumable = true
    self.ui_key = key
end

function ItemAddHints:get_count()
    return self.count
end

function ItemAddHints:get_ui_key()
    return self.ui_key
end

function ItemAddHints:apply()
end

return ItemAddHints
