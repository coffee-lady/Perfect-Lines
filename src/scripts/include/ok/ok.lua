local App = require('src.app')
local OKGames = require('OKGames.okgames')
local nakama = require('nakama.nakama')
local engine_defold = require('nakama.engine.defold')
local Ads = require('src.scripts.include.ok.ads.ads')
local Auth = require('src.scripts.include.ok.auth.ok_auth_adapter')
local PlayerDataStorage = require('src.scripts.include.ok.player_data_storage.ok_player_data_storage_adapter')
local Payments = require('src.scripts.include.ok.payments.ok_payments_adapter')
local Mock = require('src.scripts.include.ok.mock.mock')
local NakamaAdapter = require('src.scripts.include.nakama.nakama')

local OKAPI = {}

local Async = App.libs.async

OKAPI.Ads = Ads
OKAPI.Auth = Auth
OKAPI.PlayerDataStorage = PlayerDataStorage
OKAPI.Payments = Payments

function OKAPI.init(event_bus, server_config)
    OKGames:setup_mock(Mock)
    OKGames:init_async()

    NakamaAdapter:init(nakama, engine_defold, server_config)

    OKAPI.on_resize()
end

function OKAPI.on_resize()
    Async.bootstrap(function()
        local result = OKGames:get_page_info_async()

        if not result.status then
            return
        end

        local page_info = result.data

        OKGames:set_window_size({width = page_info.clientWidth, height = page_info.clientHeight - page_info.offsetTop})
    end)
end

return OKAPI
