local App = require('src.app')
--- @type OKGamesSDK
local OKGames = require('OKGames.okgames')
local NakamaAdapter = require('src.scripts.include.nakama.nakama')

local Debug = App.libs.debug

local DEBUG = App.config.debug_mode.PaymentsService
local debug_logger = Debug('[OK] PaymentsService', DEBUG)

local OKPaymentsAdapter = {}

function OKPaymentsAdapter:init()
    debug_logger:log_dump(NakamaAdapter:get_catalog_async())
    debug_logger:log_dump(NakamaAdapter:get_user_wallet_async())
end

-- return success, error
function OKPaymentsAdapter:purchase_async(id, title, price)
    local result = OKGames:show_payments_async({
        name = title,
        description = '',
        code = id,
        price = price,
    })

    debug_logger:log('purchased', id, debug_logger:inspect(result))

    return result.status
end

function OKPaymentsAdapter:sync_wallet_events_async(wallet)
    return NakamaAdapter:sync_wallet_events({
        wallet_items = wallet,
    })
end

function OKPaymentsAdapter:get_wallet_async()
    local wallet = NakamaAdapter:get_user_wallet_async()
    return wallet
end

function OKPaymentsAdapter:_process_purchases(purchases)
    local result = {}

    for i = 1, #purchases do
        local data = purchases[i]

        result[i] = {
            product_id = data.productID,
            token = data.purchaseToken,
            payload = data.developerPayload,
            signature = data.signature,
        }
    end

    return result
end

function OKPaymentsAdapter:get_catalog_async()
    local data = NakamaAdapter:get_catalog_async()

    if not data then
        return {}
    end

    local catalog = self:_process_catalog(data.bundles)
    return catalog
end

function OKPaymentsAdapter:_process_catalog(catalog)
    local result = {}

    for i = 1, #catalog do
        local data = catalog[i]
        local items = {}

        for _, item in pairs(data.items) do
            items[item.key] = item.amount
        end

        result[i] = {
            id = data.id,
            type = data.sales_type,
            price = tonumber(data.price),
            items = items,
        }
    end

    return result
end

return OKPaymentsAdapter
