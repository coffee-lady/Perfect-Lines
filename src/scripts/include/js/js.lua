local JSAPI = {}

local call_web = function(fun)
    if html5 then
        return html5.run(fun)
    end
end

function JSAPI.init(event_bus)
    if not html5 or not jstodef then
        return
    end

    jstodef.add_listener(
        function(_, message_id, message)
            event_bus:emit(hash(message_id), message)
        end
    )
end

function JSAPI.set_banner()
    call_web('setBanner();')
end

function JSAPI.get_canvas_width()
    if not html5 then
        return 0
    end

    return string.match(call_web('getCanvasWidth();'), '%d+')
end

function JSAPI.get_canvas_height()
    if not html5 then
        return 0
    end

    return string.match(call_web('getCanvasHeight();'), '%d+')
end

function JSAPI.show_banner()
    call_web('showBanner();')
end

function JSAPI.hide_banner()
    call_web('hideBanner();')
end

function JSAPI.set_banner_scale()
    call_web('setBannerScale();')
end

return JSAPI
