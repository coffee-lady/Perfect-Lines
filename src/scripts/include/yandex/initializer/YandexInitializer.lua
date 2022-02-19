local yagames = require('yagames.yagames')

--- @class YandexInitializer
local YandexInitializer = class('YandexInitializer')

local function init_handler(_, err)
end

function YandexInitializer:initialize()
    yagames.init(init_handler)
end

return YandexInitializer
