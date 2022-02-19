local App = require('src.app')

local PaymentsConfig = App.config.payments
local Products = PaymentsConfig.products

--- @type PurchaseProductModel
local YaPurchaseProductModel = class('PurchaseProductModel')

function YaPurchaseProductModel:initialize(purchase_data)
    self.id = purchase_data.id
    self.price = purchase_data.price

    self:_set_config()
end

function YaPurchaseProductModel:_set_config()
    for i = 1, #Products do
        if Products[i].id == self.id then
            self.config = Products[i]
        end
    end
end

function YaPurchaseProductModel:update(purchase_data)
    self.id = purchase_data.id
    self.title = purchase_data.title
    self.description = purchase_data.description
    self.price = purchase_data.price
end

function YaPurchaseProductModel:get_id()
    return self.id
end

function YaPurchaseProductModel:get_ui_id()
    return self.config.ui_id
end

function YaPurchaseProductModel:get_offer_id()
    return self.config.offer_id
end

function YaPurchaseProductModel:get_price()
    return self.price
end

function YaPurchaseProductModel:get_offer_price()
    return self.config.offer_price
end

function YaPurchaseProductModel:get_special_offer_duration()
    return self.config.offer_duration
end

function YaPurchaseProductModel:get_config()
    return self.config
end

return YaPurchaseProductModel
