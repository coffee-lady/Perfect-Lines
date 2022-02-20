local App = require('src.app')
local Luject = require('src.libs.luject.luject')
local SubscriptionsMap = require('src.libs.event_bus.subscriptions_map')
local GamesStrategies = require('src.scripts.scenes.game_scene.strategies.strategies')

local URL = App.constants.urls

--- @class ScenesStrategiesService
local ScenesStrategiesService = class('ScenesStrategiesService')

ScenesStrategiesService.__cparams = {'event_bus'}

function ScenesStrategiesService:initialize(event_bus)
    self.event_bus = event_bus
    self.strategies = {}

    self.event_game_strategy_changed = Event()
end

function ScenesStrategiesService:select_standard_game()
    if self:get_strategy_gui(URL.game_scene) == GamesStrategies.StandardStrategy then
        return
    end

    self:set_gui_strategy(URL.game_scene, GamesStrategies.StandardStrategy)

    self.event_game_strategy_changed:emit()
end

function ScenesStrategiesService:set_gui_strategy(scene, Strategy)
    if not self.strategies[scene] then
        self.strategies[scene] = {}
    end

    self.strategies[scene].gui = Strategy
end

function ScenesStrategiesService:set_go_strategy(scene, Strategy)
    if not self.strategies[scene] then
        self.strategies[scene] = {}
    end

    self.strategies[scene].go = Strategy
end

--- @return SceneStrategy
function ScenesStrategiesService:get_strategy_gui(scene)
    if self.strategies[scene] then
        return self.strategies[scene].gui
    end
end

--- @return SceneStrategy
function ScenesStrategiesService:get_strategy_go(scene)
    if self.strategies[scene] then
        return self.strategies[scene].go
    end
end

--- @return SceneStrategy
function ScenesStrategiesService:get_strategy_instance_gui(scene)
    return inject(self.strategies[scene].gui)
end

--- @return SceneStrategy
function ScenesStrategiesService:get_strategy_instance_go(scene)
    return inject(self.strategies[scene].go)
end

return ScenesStrategiesService
