local App = require('src.app')
local yagames = require('yagames.yagames')

local Debug = App.libs.debug
local Async = App.libs.async

local DEBUG = App.config.debug_mode.PlayerDataStorage

local debug_logger = Debug('[Yandex] PlayerDataStorageAdapter', DEBUG)

--- @class YandexStorage
local YandexStorage = class('YandexStorage')

function YandexStorage:get_all_async()
    return Async(
        function(done)
            yagames.player_get_data(
                nil,
                function(_, err, result)
                    if err then
                        debug_logger:log('ERROR while getting player data:', err)
                        return
                    end

                    debug_logger:log('load all data from server =', debug_logger:inspect(result))

                    done(result)
                end
            )
        end
    )
end

function YandexStorage:set(data_object, filename, key, value)
    yagames.player_set_data(
        data_object,
        true,
        function(_, err)
            if err then
                debug_logger:log('ERROR on set data', err)
                return
            end

            debug_logger:log('set', filename, key, debug_logger:inspect(value), 'to yandex server')
        end
    )
end

function YandexStorage:get_key(filename, key)
    return filename .. key
end

return YandexStorage
