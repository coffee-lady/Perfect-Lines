local App = require('src.app')
local Controllers = require('src.scripts.scenes.game_scene.controllers.controllers')
local Presenters = require('src.scripts.scenes.game_scene.presenters.presenters')
local View = require('src.scripts.scenes.game_scene.view.ViewGameScene')
local Includes = require('src.scripts.scenes.game_scene.include.include')
local UIMaps = require('src.scripts.scenes.game_scene.common.common')

local SubscriptionsMap = App.libs.SubscriptionsMap
local SceneStrategy = App.libs.scenes.SceneStrategy

local StandardGameStrategy = class('StandardGameStrategy', SceneStrategy)

StandardGameStrategy.__cparams = {}

function StandardGameStrategy:initialize()
    SceneStrategy.initialize(self, Controllers, Presenters, View, UIMaps)

    self:_set_subscriptions()

    self:init_scene()

    self.extensions = {}

    for i = 1, #Includes do
        self.extensions[i] = inject(Includes[i])
    end

    self:set_screen_transition({disable_back_in = true, disable_back_out = true})
end

function StandardGameStrategy:init_scene()
    self.controllers.animations:animate_start():run()
end

function StandardGameStrategy:_set_subscriptions()
    self.subs_map = inject(SubscriptionsMap, self, {})
end

function StandardGameStrategy:on_continue()
    self.controllers.game_process:on_continue()
end

function StandardGameStrategy:on_victory()
    self.controllers.animations:animate_victory():add_callback(function()
        self.controllers.game_process:on_victory()

        self:call_collection(self.extensions, 'on_victory')
    end):run()
end

function StandardGameStrategy:final()
    SceneStrategy.final(self)
    self.subs_map:unsubscribe()
    self:call_collection(self.extensions, 'final')
end

return StandardGameStrategy
