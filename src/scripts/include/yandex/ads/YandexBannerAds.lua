local App = require('src.app')
local yagames = require('yagames.yagames')
local JSAPI = require('src.scripts.include.js.js')

local Debug = App.libs.debug
local Async = App.libs.async
local String = App.libs.string

local PROP = {
    DISPLAY = 'display',
    DISPLAY_NONE = 'none',
    DISPLAY_BLOCK = 'block'
}

local DEBUG = App.config.debug_mode.BannerAdsService
local debug_logger = Debug('[Yandex] BannerAdsAdapter', DEBUG)

--- @class YandexBannerAds
local YandexBannerAds = class('YandexBannerAds')

function YandexBannerAds:init_async(banner_height)
    self.banner_height = banner_height

    Async(
        function(done)
            yagames.banner_init(
                function(_, err)
                    debug_logger:log('banner initialized')

                    if err then
                        debug_logger:log('ERROR on banner_init:', err)
                    end

                    done()
                end
            )
        end
    )
end

function YandexBannerAds:load_async(params)
    local id, css_string, is_visible = params.block_id, params.css, params.visible

    if not is_visible then
        return
    end

    Async(
        function(done)
            yagames.banner_create(
                id,
                {
                    css_class = css_string,
                    css_styles = String.replace_vars('height: {height}px; width: {width}px; transform-origin: bottom; display: none;', YandexBannerAds._get_banner_params())
                },
                function(_, err, _)
                    self.initted = true

                    debug_logger:log('banner created')

                    if err then
                        debug_logger:log('ERROR on banner_create:', err)
                    end

                    JSAPI.set_banner()

                    self:hide(id)

                    done()
                end
            )
        end
    )
end

function YandexBannerAds:show(id)
    if not self.initted then
        debug_logger:log('ERROR: trying show banner: banner is not initted')
    end

    debug_logger:log('show banner')
    yagames.banner_set(id, PROP.DISPLAY, PROP.DISPLAY_BLOCK)

    self.is_banner_visible = true

    JSAPI.show_banner()
end

function YandexBannerAds:hide(id)
    if not self.initted then
        debug_logger:log('ERROR: trying show banner: banner is not initted')
        return
    end

    debug_logger:log('hide banner')
    yagames.banner_set(id, PROP.DISPLAY, PROP.DISPLAY_NONE)

    self.is_banner_visible = false

    JSAPI.hide_banner()
end

function YandexBannerAds:refresh(id)
    if not self.initted then
        debug_logger:log('ERROR: trying to refresh: banner is not initialized')
        return
    end

    yagames.banner_refresh(
        id,
        function(_, err)
            debug_logger:log('refreshing banner')

            if err then
                debug_logger:log('refreshing banner ERROR:', err)
            end

            JSAPI.set_banner_scale()

            if not self.is_banner_visible then
                self:hide(id)
            end
        end
    )
end

function YandexBannerAds:_get_banner_params()
    if not html5 then
        return {
            height = 0,
            width = 0
        }
    end

    local canvas_width = JSAPI.get_canvas_width()
    local canvas_height = JSAPI.get_canvas_height()
    local display_height = sys.get_config('display.height')

    local height_ratio = canvas_height / display_height

    local height = height_ratio * self.banner_height

    return {
        height = height,
        width = canvas_width
    }
end

return YandexBannerAds
