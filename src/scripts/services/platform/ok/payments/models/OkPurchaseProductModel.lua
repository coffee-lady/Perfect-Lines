local App = require('src.app')

local LKEY_STORE_GOODS = App.config.localization.keys.store_goods
local PaymentsConfig = App.config.payments
local Products = PaymentsConfig.products

local OK_CURRENCY_CODE = 'OK'

local OkPurchaseProductModel = class('OkPurchaseProductModel')

function OkPurchaseProductModel:initialize(services, purchase_data)
    self.localization_service = services.localization

    self.id = purchase_data.id
    self.price = purchase_data.price .. ' ' .. OK_CURRENCY_CODE
    self.items = purchase_data.items

    self:_set_config()

    self.config.items = self.items
    self.config.price = self.price
end

function OkPurchaseProductModel:_set_config()
    for i = 1, #Products do
        if Products[i].id == self.id then
            self.config = Products[i]
        end
    end
end

function OkPurchaseProductModel:set_offer_product(offer_product)
    self.offer_product = offer_product
end

function OkPurchaseProductModel:update(purchase_data)
    self.id = purchase_data.id
    self.price = purchase_data.price
end

function OkPurchaseProductModel:get_title()
    local goods_titles = self.localization_service:get_localized_text(LKEY_STORE_GOODS)
    return goods_titles[self.config.ui_id]
end

function OkPurchaseProductModel:get_id()
    return self.id
end

function OkPurchaseProductModel:get_ui_id()
    return self.config.ui_id
end

function OkPurchaseProductModel:get_offer_id()
    return self.config.offer_id
end

function OkPurchaseProductModel:get_price()
    return self.price
end

function OkPurchaseProductModel:get_offer_price()
    return self.offer_product.price
end

function OkPurchaseProductModel:get_special_offer_duration()
    return self.config.offer_duration
end

function OkPurchaseProductModel:get_config()
    return self.config
end

return OkPurchaseProductModel
