local yagames = require('yagames.yagames')
local App = require('src.app')

local Debug = App.libs.debug
local Async = App.libs.async

local DEBUG = App.config.debug_mode.PaymentsService
local DEBUG_CATALOG = App.config.debug_mode.PaymentsCatalog
local debug_logger = Debug('[Yandex] PaymentsService', DEBUG)

--- @class YandexPayments
local YandexPayments = class('YandexPayments')

function YandexPayments:init_async()
    Async(
        function(done)
            yagames.payments_init(
                nil,
                function(_, err)
                    debug_logger:log('payments are initialized')

                    if err then
                        debug_logger:log('ERROR:', err)
                    end

                    done()
                end
            )
        end
    )
end

-- return success, error
function YandexPayments:purchase_async(id)
    return Async(
        function(done)
            yagames.payments_purchase(
                {
                    id = id
                },
                function(_, err, purchase_data)
                    if err then
                        debug_logger:log('ERROR while purchase:', err)
                        done(nil, err)
                        return
                    end

                    local token = purchase_data.purchaseToken
                    debug_logger:log('purchased with token', debug_logger:inspect(token))
                    done(token, err)
                end
            )
        end
    )
end

function YandexPayments:get_purchases_async()
    return Async(
        function(done)
            yagames.payments_get_purchases(
                function(_, err, result)
                    local purchases = result.purchases

                    debug_logger:log('got purchases', debug_logger:inspect(purchases))

                    if err then
                        debug_logger:log('ERROR while get_purchases:', err)
                    end

                    done(self:_process_purchases(purchases))
                end
            )
        end
    )
end

function YandexPayments:_process_purchases(purchases)
    local result = {}

    for i = 1, #purchases do
        local data = purchases[i]

        result[i] = {
            product_id = data.productID,
            token = data.purchaseToken,
            payload = data.developerPayload,
            signature = data.signature
        }
    end

    return result
end

function YandexPayments:get_catalog_async()
    return Async(
        function(done)
            yagames.payments_get_catalog(
                function(_, err, result)
                    local catalog = self:_process_catalog(result)

                    debug_logger:log('got catalog', debug_logger:inspect(catalog))

                    if err then
                        debug_logger:log('ERROR while get_catalog:', err)
                    end

                    done(catalog)
                end
            )
        end
    )
end

function YandexPayments:_process_catalog(catalog)
    if DEBUG_CATALOG then
        return App.config.dummy_data.yandex_payments
    end

    local result = {}

    for i = 1, #catalog do
        local data = catalog[i]

        result[i] = {
            id = data.id,
            title = data.title,
            description = data.description,
            image_uri = data.imageURI,
            price = data.price
        }
    end

    return result
end

function YandexPayments:consume_purchase_async(purchase_token)
    Async(
        function(done)
            yagames.payments_consume_purchase(
                purchase_token,
                function(_, err)
                    debug_logger:log('consumed purchase', purchase_token)

                    if err then
                        debug_logger:log('ERROR while consume_purchase:', err)
                    end

                    done()
                end
            )
        end
    )
end

return YandexPayments
