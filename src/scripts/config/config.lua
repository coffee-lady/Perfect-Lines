local TestConfigs = require('src.scripts.config.test.config')
local ReleaseConfigs = require('src.scripts.config.release.config')
local CommonConfig = require('src.scripts.config.common.common_config')
local ConfigSettings = require('src.scripts.config.common.config_settings')

if ConfigSettings.IS_RELEASE_BUILD then
    ConfigSettings.CONNECT_STATIC_CONFIG = true
    ConfigSettings.CONNECT_STATIC_TEST_CONFIG = false
    ConfigSettings.CONNECT_LOCAL_TEST_CONFIG = false
end

CommonConfig.connect_static_config = ConfigSettings.CONNECT_STATIC_CONFIG
CommonConfig.connect_static_test_config = ConfigSettings.CONNECT_STATIC_TEST_CONFIG
CommonConfig.connect_local_test_config = ConfigSettings.CONNECT_LOCAL_TEST_CONFIG
CommonConfig.is_release_version = ConfigSettings.IS_RELEASE_BUILD

local ReleaseConfig = ReleaseConfigs[CommonConfig.platform]
local TestConfig = TestConfigs[CommonConfig.platform]

for key, value in pairs(CommonConfig) do
    TestConfig[key] = value
    ReleaseConfig[key] = value
end

if ConfigSettings.IS_RELEASE_BUILD then
    for key, _ in pairs(ReleaseConfig.debug_mode) do
        ReleaseConfig.debug_mode[key] = false
    end

    for _, bundle_config in pairs(ReleaseConfig.bundle.platforms_config) do
        bundle_config.debug = false
    end

    return ReleaseConfig
end

if ConfigSettings.CONNECT_LOCAL_TEST_CONFIG then
    return TestConfig
end

return ReleaseConfig
