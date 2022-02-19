local App = require('src.app')

--- @class PaymentsUseCases
local PaymentsUseCases = class('PaymentsUseCases')

PaymentsUseCases.__cparams = {'auth_service', 'payments_service', 'platform_service'}

function PaymentsUseCases:initialize(auth_service, payments_service, platform_service)
    --- @type AuthService
    self.auth_service = auth_service
    --- @type PaymentsService
    self.payments_service = payments_service
    --- @type PlatformService
    self.platform_service = platform_service

    if self.auth_service:is_authorized() then
        self:init_server_payments()
    else
        self.payments_service:init_local_payments()
    end

    self.auth_service.event_auth_success:add(self.on_authorized, self)
    self.auth_service.event_auth_success:add(self.on_authorized, self)
    self.platform_service.event_online:add(self.on_online, self)
end

function PaymentsUseCases:on_authorized()
    self:init_server_payments()
end

function PaymentsUseCases:on_online()
    self:init_server_payments()
end

function PaymentsUseCases:init_server_payments()
    self.payments_service:init_server_payments()
end

function PaymentsUseCases:purchase_async(product_id)
    if not self.auth_service:is_authorized() then
        return nil, 'Error: not authorized'
    end

    return self.payments_service:purchase_async(product_id)
end

function PaymentsUseCases:get_purchases()
    return self.payments_service:get_purchases()
end

function PaymentsUseCases:get_catalog()
    return self.payments_service:get_catalog()
end

function PaymentsUseCases:consume_purchase_async(purchase_token)
    if not self.auth_service:is_authorized() then
        return
    end

    self.payments_service:consume_purchase_async(purchase_token)
end

function PaymentsUseCases:has_in_purchase_list(product_id)
    if not self.auth_service:is_authorized() then
        return false
    end

    return self.payments_service:has_in_purchase_list(product_id)
end

return PaymentsUseCases
