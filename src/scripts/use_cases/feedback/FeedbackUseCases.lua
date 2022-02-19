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

--- @class FeedbackUseCases
local FeedbackUseCases = class('FeedbackUseCases')

FeedbackUseCases.__cparams = {'data_storage_use_cases', 'platform_service', 'feedback_service'}

function FeedbackUseCases:initialize(data_storage_use_cases, platform_service, feedback_service)
    --- @type DataStorageUseCases
    self.data_storage_use_cases = data_storage_use_cases
    --- @type PlatformService
    self.platform_service = platform_service
    --- @type FeedbackService
    self.feedback_service = feedback_service
end

function FeedbackUseCases:request_review_async()
    if not self:is_available() then
        return false
    end

    local is_feedback_sent = self.feedback_service:request_feedback_async()

    if is_feedback_sent then
        self.data_storage_use_cases:set(FILE, KEY_WAS_FEEDBACK_REQUESTED, true)
    end

    return is_feedback_sent
end

function FeedbackUseCases:is_available()
    local was_feedback_requested = self.data_storage_use_cases:get(FILE, KEY_WAS_FEEDBACK_REQUESTED)

    return self.platform_service.is_online and not was_feedback_requested and self.feedback_service:can_review()
end

return FeedbackUseCases
