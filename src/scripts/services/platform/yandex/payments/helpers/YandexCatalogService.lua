local App = require('src.app')
local Models = require('src.scripts.services.platform.yandex.payments.models.models')

local PurchaseProductModel = Models.PurchaseProductModel

local PaymentsConfig = App.config.payments

--- @class YandexCatalogService
local YandexCatalogService = class('YandexCatalogService')

function YandexCatalogService:initialize(yandex_payments)
    --- @type YandexPayments
    self.yandex_payments = yandex_payments

    self.catalog = {}
end

function YandexCatalogService:get_catalog()
    return self.catalog
end

function YandexCatalogService:load_server_catalog()
    local catalog_list = self.yandex_payments:get_catalog_async()
    self:_make_catalog_from_data(catalog_list)
end

function YandexCatalogService:make_catalog_from_config()
    local catalog_list = PaymentsConfig.products
    self:_make_catalog_from_data(catalog_list)
end

function YandexCatalogService:find_product_in_catalog(product_id)
    for i = 1, #self.catalog do
        local product = self.catalog[i]
        local item_id = product:get_id()
        local item_offer_id = product:get_offer_id()

        if item_id == product_id or item_offer_id == product_id then
            return product
        end
    end
end

function YandexCatalogService:_make_catalog_from_data(catalog_list)
    for i = 1, #catalog_list do
        self:_check_catalog_item(i, catalog_list[i])
    end
end

function YandexCatalogService:_check_catalog_item(index, new_item_data)
    if Array.has(new_item_data.id, PaymentsConfig.offers_ids) then
        return
    end

    if not self:find_product_in_catalog(new_item_data.id) then
        self.catalog[#self.catalog + 1] = PurchaseProductModel(new_item_data)
    else
        self.catalog[index]:update(new_item_data)
    end
end

return YandexCatalogService
