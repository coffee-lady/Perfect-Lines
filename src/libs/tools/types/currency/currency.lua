local ResourcesStorage = require('src.libs.resources_storage.resources_storage')

local CURRENCY_CODE_TO_SYMBOLS

local Currency = {}

function Currency.set_localization_path(localization_path)
    CURRENCY_CODE_TO_SYMBOLS = ResourcesStorage:get_json_data(localization_path).currency
end

function Currency.get_symbol_from_code(code)
    return CURRENCY_CODE_TO_SYMBOLS[code]
end

function Currency.format_price(price, currency_code)
    return price .. ' ' .. (CURRENCY_CODE_TO_SYMBOLS[currency_code] or '')
end

return Currency
