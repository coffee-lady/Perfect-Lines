local App = require('src.app')
local JSAPI = require('src.scripts.include.js.js')
local JSEventsBootstrap = require('src.scripts.scenes.bootstrap.common.js_events_bootstrap')

local MSG = App.constants.msg

local ColorLib = App.libs.color
local Luject = App.libs.luject

local BootstrapGUI = class('BootstrapGUI')

BootstrapGUI.__cparams = {'event_bus', 'scenes_service', 'screen_service', 'local_storage', 'show_first_scene_use_case'}

function BootstrapGUI:initialize(event_bus, scenes_service, screen_service, local_storage, show_first_scene_use_case)
    self.event_bus = event_bus
    self.scenes_service = scenes_service
    self.screen_service = screen_service
    self.local_storage = local_storage
    self.show_first_scene_use_case = show_first_scene_use_case

    msg.post('.', MSG.acquire_input_focus)

    math.randomseed(os.time())
    ColorLib.convert_v4_theme(App.config.ui.themes)

    JSAPI.init(self.event_bus)

    Luject:resolve_class(JSEventsBootstrap)

    if self.scenes_service.init_observer.completed then
        self:initialize_game()
    else
        self.scenes_service.init_observer:subscribe(self, self.initialize_game)
    end
end

function BootstrapGUI:initialize_game()
    if html5 then
        html5.run('loadGame();')
    end

    self.show_first_scene_use_case:show_first_scene()
end

function BootstrapGUI:update(dt)
    self.local_storage:update(dt)
end

function BootstrapGUI:on_message(message_id, message)
    self.scenes_service:on_message(message_id)
    self.screen_service:on_message(message_id)
    self.event_bus:emit(message_id, message)
end

function BootstrapGUI:final()
    self.local_storage:final()
end

return BootstrapGUI
