local yagames = require('yagames.yagames')
local App = require('src.app')

local Debug = App.libs.debug
local Async = App.libs.async

local DEBUG = App.config.debug_mode.FeedbackService
local debug_logger = Debug('[Yandex] YandexFeedbackAdapter', DEBUG)

local function exec(func)
    if func then
        func()
    end
end

--- @class YandexFeedback
local YandexFeedback = class('YandexFeedback')

function YandexFeedback:is_reviewable()
    return Async(
        function(done)
            yagames.feedback_can_review(
                function(_, err, res)
                    debug_logger:log('feedback_can_review', debug_logger:inspect(res))

                    if err then
                        debug_logger:log('ERROR on feedback_can_review', err)
                        done(false)
                        return
                    end

                    done(res.value)
                end
            )
        end
    )
end

function YandexFeedback:request_review_async()
    return Async(
        function(done)
            yagames.feedback_request_review(
                function(_, err, result)
                    debug_logger:log('feedback_request_review', debug_logger:inspect(result))

                    if err then
                        debug_logger:log('ERROR on feedback_request_review', err)
                        done(false)
                        return
                    end

                    done(result.feedbackSent)
                end
            )
        end
    )
end

return YandexFeedback
