local App = require('src.app')

--- @class YandexPurchaseService
local YandexPurchaseService = class('YandexPurchaseService')

YandexPurchaseService.__cparams = {'auth_service'}

function YandexPurchaseService:initialize(yandex_payments)
    --- @type YandexPayments
    self.yandex_payments = yandex_payments

    self.user_purchases = {}
end

function YandexPurchaseService:update_purchases_list()
    self.user_purchases = self.yandex_payments:get_purchases_async()
end

function YandexPurchaseService:purchase_async(product_id)
    local token, err = self.yandex_payments:purchase_async(product_id)

    if token then
        self:update_purchases_list()
    end

    return token, err
end

function YandexPurchaseService:get_purchases()
    return self.user_purchases
end

function YandexPurchaseService:consume_purchase_async(purchase_token)
    self.yandex_payments:consume_purchase_async(purchase_token)
    self:update_purchases_list()
end

function YandexPurchaseService:has_in_purchase_list(product_id)
    for i = 1, #self.user_purchases do
        local purch_product_id = self.user_purchases[i].product_id

        if purch_product_id == product_id then
            return true
        end
    end

    return false
end

return YandexPurchaseService
