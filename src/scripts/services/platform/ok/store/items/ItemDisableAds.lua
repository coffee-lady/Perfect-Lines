local App = require('src.app')

local ItemDisableAds = class('ItemDisableAds')

function ItemDisableAds:initialize(context_services, key)
    self.ads_service = context_services.ads_service
    self.is_consumable = false
    self.ui_key = key
end

function ItemDisableAds:get_ui_key()
    return self.ui_key
end

function ItemDisableAds:apply()
    self.ads_service:disable_ads()
end

return ItemDisableAds
