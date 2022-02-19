local yagames = require('yagames.yagames')
local App = require('src.app')

local Debug = App.libs.debug
local Async = App.libs.async
local UTF8 = App.libs.utf8

local DEFAULT_AVATAR = 'small'
local DEBUG = App.config.debug_mode.LeaderboardsService
local debug_logger = Debug('[Yandex] LeaderboardsAdapter', DEBUG)

local function exec(func)
    if func then
        func()
    end
end

--- @class YandexLeaderboards
local YandexLeaderboards = class('YandexLeaderboards')

YandexLeaderboards.IMAGE_SIZE = {
    small = 'small',
    medium = 'medium',
    large = 'large'
}

function YandexLeaderboards:init_async()
    Async(
        function(done)
            yagames.leaderboards_init(
                function(_, err)
                    debug_logger:log('leaderboards initialized')

                    if err then
                        debug_logger:log('ERROR on init_async', err)
                        done()
                        return
                    end

                    done()
                end
            )
        end
    )
end

function YandexLeaderboards:get_leaderboard_config_async(id)
    return Async(
        function(done)
            yagames.leaderboards_get_description(
                id,
                function(_, err, data)
                    debug_logger:log('got leaderboard', id, debug_logger:inspect(data))

                    if err then
                        debug_logger:log('ERROR on get_leaderboard_config_async', err)
                        done()
                        return
                    end

                    done(data)
                end
            )
        end
    )
end

function YandexLeaderboards:get_player_entry_async(leaderboard_id, options)
    return Async(
        function(done)
            yagames.leaderboards_get_player_entry(
                leaderboard_id,
                options and
                    {
                        getAvatarSrc = options.avatar_size or DEFAULT_AVATAR
                    } or
                    {},
                function(_, err, result)
                    debug_logger:log('got player entry', leaderboard_id, debug_logger:inspect(result))

                    if err then
                        debug_logger:log('ERROR on get_player_entry_async', err)
                        done()
                        return
                    end

                    done(result)
                end
            )
        end
    )
end

---  options =
-- {
--     include_user : boolean,
--     amount_around : int,
--     amount_top : int,
--     avatar_size : small | medium | large
-- }
function YandexLeaderboards:get_leaderboard_async(leaderboard_id, options)
    return Async(
        function(done)
            yagames.leaderboards_get_entries(
                leaderboard_id,
                options and
                    {
                        includeUser = options.include_user,
                        quantityAround = options.amount_around,
                        quantityTop = options.amount_top,
                        getAvatarSrc = options.avatar_size or DEFAULT_AVATAR
                    } or
                    {},
                function(_, err, result)
                    debug_logger:log(
                        'got leaderboard entries',
                        leaderboard_id,
                        debug_logger:inspect(
                            {
                                includeUser = options.include_user,
                                quantityAround = options.amount_around,
                                quantityTop = options.amount_top,
                                getAvatarSrc = options.avatar_size
                            }
                        ),
                        debug_logger:inspect(result)
                    )

                    if err then
                        debug_logger:log('ERROR on get_leaderboard_async', err)
                        done()
                        return
                    end

                    done(result)
                end
            )
        end
    )
end

function YandexLeaderboards:set_score_async(leaderboard_id, score)
    return Async(
        function(done)
            yagames.leaderboards_set_score(
                leaderboard_id,
                score,
                nil,
                function(_, err)
                    debug_logger:log('setted score', score, 'to', leaderboard_id)

                    if err then
                        debug_logger:log('ERROR on set_score_async', err)
                        done()
                        return
                    end

                    done()
                end
            )
        end
    )
end

return YandexLeaderboards
