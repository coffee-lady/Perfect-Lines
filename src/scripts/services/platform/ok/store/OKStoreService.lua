local App = require('src.app')
local Items = require('src.scripts.services.platform.ok.store.items.items')

local Debug = App.libs.debug
local Async = App.libs.async

local MSG = App.constants.msg
local PaymentsConfig = App.config.payments
local NOT_CONSUMABLE_ITEMS = App.config.payments_not_consumable_items_keys
local STARTER_PACK_ID = PaymentsConfig.starter_pack_id
local STARTER_PACK_REPLACER_ID = PaymentsConfig.starter_pack_replacer_id
local DEBUG = App.config.debug_mode.StoreService

local KEY_TO_ITEM = {
    hints = Items.ItemAddHints,
    canceling_errors = Items.ItemAddCancelingErrors,
    all_themes = Items.ItemUnlockThemes,
    no_ads = Items.ItemDisableAds,
}

--- @class OKStoreService
local OKStoreService = class('OKStoreService')

OKStoreService.__cparams = {
    'payments_service', 'event_bus', 'use_case_get_shown_products', 'use_case_finish_special_offer',
    'use_case_find_product',
}

function OKStoreService:initialize(payments_service, event_bus, use_case_get_shown_products,
                                   use_case_finish_special_offer, use_case_find_product)
    --- @type PaymentsService
    self.payments_service = payments_service
    self.event_bus = event_bus
    self.use_case_get_shown_products = use_case_get_shown_products
    self.use_case_finish_special_offer = use_case_finish_special_offer
    self.use_case_find_product = use_case_find_product

    self.debug = Debug('[OK] StoreService', DEBUG)

    self.shop_catalog = {}
    self.payments_catalog = self.payments_service:get_catalog()

    self:_process_payments_catalog()
    self:apply_purchased_not_consumable_items()
end

function OKStoreService:apply_purchased_not_consumable_items()
    local wallet = self.payments_service:get_wallet()

    for key, value in pairs(NOT_CONSUMABLE_ITEMS) do
        if wallet[key] then
            KEY_TO_ITEM[key](self.services, key):apply()
        end
    end
end

function OKStoreService:_process_payments_catalog()
    for i = 1, #self.payments_catalog do
        local purchase_product = self.payments_catalog[i]
    end
end

function OKStoreService:get_products_to_show()
    return self.use_case_get_shown_products:get_products_to_show(self.shop_catalog)
end

function OKStoreService:get_catalog()
    return self.shop_catalog
end

function OKStoreService:purchase_async(product)
    if not self.auth_service:is_authorized() then
        return nil, 'Error: not authorized'
    end

    local is_on_special_offer = product:is_on_special_offer()
    local id = is_on_special_offer and product:get_offer_id() or product:get_id()
    local token, err = self.payments_service:purchase_async(id)

    if not token then
        return token, err
    end

    if is_on_special_offer then
        self.use_case_finish_special_offer:finish_special_offer(product)
    end

    if product:is_consumable() then
        self.payments_service:consume_purchase_async(token)
    end

    return token, err
end

function OKStoreService:_find_product(product_id)
    return self.use_case_find_product:find_product(product_id, self.shop_catalog)
end

return OKStoreService
