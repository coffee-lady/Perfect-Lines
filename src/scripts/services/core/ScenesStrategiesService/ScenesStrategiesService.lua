local App = require('src.app')
local Luject = require('src.libs.luject.luject')
local SubscriptionsMap = require('src.libs.event_bus.subscriptions_map')

local URL = App.constants.urls

--- @class ScenesStrategiesService
local ScenesStrategiesService = class('ScenesStrategiesService')

ScenesStrategiesService.__cparams = {'event_bus_gui'}

function ScenesStrategiesService:initialize(event_bus)
    self.event_bus = event_bus
    self.strategies = {}
end

function ScenesStrategiesService:select_standard_game()
    -- self:set_gui_strategy(URL.game_scene, GamesStrategies.StandardStrategyGUI)
    -- self:set_go_strategy(URL.game_scene, GamesStrategies.StandardStrategyGO)
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
function ScenesStrategiesService:get_strategy_instance_gui(scene)
    return Luject:resolve_class(self.strategies[scene].gui)
end

--- @return SceneStrategy
function ScenesStrategiesService:get_strategy_instance_go(scene)
    return Luject:resolve_class(self.strategies[scene].go)
end

return ScenesStrategiesService
