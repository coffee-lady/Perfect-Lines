local App = require('src.app')
local YandexAPI = require('src.scripts.include.yandex.yandex')

local YandexFeedback = YandexAPI.YandexFeedback

local Debug = App.libs.debug

local URL = App.constants.urls
local DataStorageConfig = App.config.data_storage
local FILE = DataStorageConfig.file
local KEY_WAS_FEEDBACK_REQUESTED = DataStorageConfig.keys.was_feedback_requested
local DEBUG = App.config.debug_mode.FeedbackService
local DEBUG_LOCAL = App.config.debug_mode.FeedbackLocalVersion

--- @class FeedbackService
local YandexFeedbackService = class('YandexFeedbackService')

YandexFeedbackService.__cparams = {'data_storage_use_cases'}

function YandexFeedbackService:initialize(data_storage_use_cases)
    self.data_storage_use_cases = data_storage_use_cases

    self.yandex_feedback = YandexFeedback()

    self.debug = Debug('[Yandex] YandexFeedbackService', DEBUG)
end

function YandexFeedbackService:request_feedback_async()
    local is_feedback_sent = self.yandex_feedback:request_review_async()

    if DEBUG_LOCAL then
        is_feedback_sent = true
    end

    return is_feedback_sent
end

function YandexFeedbackService:can_review()
    if DEBUG_LOCAL then
        return true
    end

    return self.yandex_feedback:is_reviewable()
end

return YandexFeedbackService
