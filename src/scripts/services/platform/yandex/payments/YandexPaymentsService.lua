local App = require('src.app')
local YandexAPI = require('src.scripts.include.yandex.yandex')
local YandexCatalogService = require('src.scripts.services.platform.yandex.payments.helpers.YandexCatalogService')
local YandexPurchaseService = require('src.scripts.services.platform.yandex.payments.helpers.YandexPurchaseService')

local YandexPayments = YandexAPI.YandexPayments

--- @class PaymentsService
local YandexPaymentsService = class('YandexPaymentsService')

function YandexPaymentsService:initialize()
    self.yandex_payments = YandexPayments()
    self.catalog_service = YandexCatalogService(self.yandex_payments)
    self.purchase_service = YandexPurchaseService(self.yandex_payments)
end

function YandexPaymentsService:init_server_payments()
    self.yandex_payments:init_async()
    self.catalog_service:load_server_catalog()
    self.purchase_service:update_purchases_list()
end

function YandexPaymentsService:init_local_payments()
    self.catalog_service:make_catalog_from_config()
end

function YandexPaymentsService:get_purchases()
    return self.purchase_service:get_purchases()
end

function YandexPaymentsService:get_catalog()
    return self.catalog_service:get_catalog()
end

function YandexPaymentsService:purchase_async(product_id)
    return self.purchase_service:purchase_async(product_id)
end

function YandexPaymentsService:consume_purchase_async(purchase_token)
    self.purchase_service:consume_purchase_async(purchase_token)
end

function YandexPaymentsService:has_in_purchase_list(product_id)
    return self.purchase_service:has_in_purchase_list(product_id)
end

function YandexPaymentsService:find_product_in_catalog(product_id)
    return self.catalog_service:find_product_in_catalog(product_id)
end

return YandexPaymentsService
