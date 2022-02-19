local sitelock = require('yagames.sitelock')

--- @class YandexSiteLocker
local YandexSiteLocker = class('YandexSiteLocker')

function YandexSiteLocker:initialize()
    if html5 and sitelock.is_release_build() and not sitelock.verify_domain() then
        os.exit()
    end
end

return YandexSiteLocker
