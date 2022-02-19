local monarch = require('monarch.monarch')
local Libs = require('src.libs.libs')
local Observable = Libs.event_observation.observable
local Event = Libs.Event
local Async = Libs.async

--- @class ScenesService
local ScenesService = class('ScenesService')

local INIT_MONARCH = 'init_monarch'

ScenesService.SCREEN_TRANSITION_IN_STARTED = monarch.SCREEN_TRANSITION_IN_STARTED
ScenesService.SCREEN_TRANSITION_IN_FINISHED = monarch.SCREEN_TRANSITION_IN_FINISHED
ScenesService.SCREEN_TRANSITION_OUT_STARTED = monarch.SCREEN_TRANSITION_OUT_STARTED
ScenesService.SCREEN_TRANSITION_OUT_FINISHED = monarch.SCREEN_TRANSITION_OUT_FINISHED

local function get_full_gui_url(scene_id)
    return scene_id ~= '.' and scene_id .. ':/scene#gui' or scene_id
end

local function get_full_go_url(scene_id)
    return scene_id ~= '.' and scene_id .. ':/scene#go' or scene_id
end

function ScenesService:initialize()
    msg.post('#', INIT_MONARCH)

    self.event_scene_change = Event()
    self.event_before_scene_change = Event()
    self.init_observer = Observable()
end

function ScenesService:on_message(message_id)
    print(message_id)
    if message_id == hash(INIT_MONARCH) then
        self.init_observer:next()
        self.init_observer:complete()
    end
end

function ScenesService:post_to_gui(screen_id, message_id, message)
    msg.post(get_full_gui_url(screen_id), message_id, message)
end

function ScenesService:post_to_go(screen_id, message_id, message)
    msg.post(get_full_go_url(screen_id), message_id, message)
end

function ScenesService:_notify()
    local current_scene = self:get_current_scene()
    local prev_scene = self:get_previous_scene()

    self.event_scene_change:emit(
        {
            current_scene = current_scene,
            prev_scene = prev_scene,
            is_current_scene_popup = current_scene and monarch.is_popup(current_scene) or false,
            is_prev_scene_popup = prev_scene and monarch.is_popup(prev_scene) or false
        }
    )
end

function ScenesService:_notify_before(current_scene, scene_data)
    local prev_scene = self:get_current_scene()

    self.event_before_scene_change:emit(
        {
            current_scene = current_scene,
            prev_scene = prev_scene,
            scene_data = scene_data,
            is_current_scene_popup = monarch.is_popup(current_scene),
            is_prev_scene_popup = prev_scene and monarch.is_popup(prev_scene) or false
        }
    )
end

function ScenesService:show(scene_id, scene_data, options, callback)
    scene_data = scene_data or {}
    options = options or {}

    if options.clear == nil then
        options.clear = true
    end

    self:_notify_before(hash(scene_id), scene_data)

    monarch.show(
        scene_id,
        options,
        scene_data,
        function()
            self:_notify()

            if callback then
                callback()
            end
        end
    )
end

function ScenesService:show_delayed(delay, scene_id, scene_data, options, callback)
    timer.delay(
        delay,
        false,
        function()
            self:show(scene_id, scene_data, options, callback)
        end
    )
end

function ScenesService:show_with_middleware(scene_id, scene_data, options, callback)
    scene_data = scene_data or {}
    options = options or {}

    if options.clear == nil then
        options.clear = true
    end

    Async.bootstrap(
        function()
            self:_exec_middlewares(scene_id, 'before')
            self:_notify_before(hash(scene_id), scene_data)

            monarch.show(
                scene_id,
                options,
                scene_data,
                function()
                    self:_notify()

                    Async.bootstrap(
                        function()
                            self:_exec_middlewares(scene_id, 'after')
                        end
                    )

                    if callback then
                        callback()
                    end
                end
            )
        end
    )
end

function ScenesService:_exec_middlewares(scene_id, key)
    if not self.middleware or not self.middleware[scene_id] or not self.middleware[scene_id][key] then
        return
    end

    local middleware = self.middleware[scene_id][key]
    for i = 1, #middleware do
        middleware[i]()
    end
end

function ScenesService:show_with_middleware_delayed(delay, scene_id, scene_data, options, callback)
    timer.delay(
        delay,
        false,
        function()
            self:show_with_middleware(scene_id, scene_data, options, callback)
        end
    )
end

function ScenesService:get_current_scene()
    return monarch.top()
end

function ScenesService:get_previous_scene()
    return monarch.top(-1)
end

function ScenesService:back(scene_data, callback)
    scene_data = scene_data or {}

    self:_notify_before(monarch.top(-1), scene_data)

    monarch.back(
        scene_data,
        function()
            self:_notify()

            if callback then
                callback()
            end
        end
    )
end

function ScenesService:is_visible(screen_id)
    return monarch.is_visible(screen_id)
end

function ScenesService:is_popup(screen_id)
    return monarch.is_popup(screen_id)
end

function ScenesService:get_scene_data(screen_id)
    return monarch.data(screen_id)
end

function ScenesService:add_listener(screen_id)
    monarch.add_listener(screen_id)
end

function ScenesService:prepend_middleware(screen_id, fn)
    self:_check_middlewares(screen_id)
    local middleware = self.middleware[screen_id].before
    middleware[#middleware + 1] = fn
end

function ScenesService:append_middleware(screen_id, fn)
    self:_check_middlewares(screen_id)
    local middleware = self.middleware[screen_id].after
    middleware[#middleware + 1] = fn
end

function ScenesService:_check_middlewares(screen_id)
    if not self.middleware then
        self.middleware = {}
    end

    if not self.middleware[screen_id] then
        self.middleware[screen_id] = {
            before = {},
            after = {}
        }
    end
end

return ScenesService
