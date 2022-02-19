local App = require('src.app')

local DataStorageConfig = App.config.data_storage
local FILE = DataStorageConfig.file
local KEY_PAID_CANCELING_ERRORS = DataStorageConfig.keys.paid_canceling_errors_count

local ItemAddCancelingErrors = class('ItemAddCancelingErrors')

function ItemAddCancelingErrors:initialize(context_services, key, count)
    self.data_storage_use_cases = context_services.data_storage_use_cases
    self.count = count
    self.is_consumable = true
    self.ui_key = key
end

function ItemAddCancelingErrors:get_count()
    return self.count
end

function ItemAddCancelingErrors:get_ui_key()
    return self.ui_key
end

function ItemAddCancelingErrors:apply()
end

return ItemAddCancelingErrors
