local Array = require('src.libs.tools.types.array.array')
local BundleConfig = require('src.scripts.config.common.bundle.bundle_config')
local CommandRaiseVersion = require('src.editor.commands.command_raise_version')
local PlatformChanger = require('src.editor.platform_changer.platform_changer')

local Platforms = BundleConfig.platforms

local Bundler = {}

function Bundler.get_commands()
    local all_platforms = Bundler._get_all_platforms()
    local commands = {}

    for i = 1, #all_platforms do
        local platform_key = all_platforms[i]

        commands[i] = {
            label = BundleConfig.command_name .. BundleConfig.commands_titles[platform_key],
            locations = BundleConfig.commands_locations,
            active = function()
                return true
            end,
            run = function()
                return {PlatformChanger:get_command_change_platform(platform_key), Bundler.get_command_bundle(platform_key)}
            end,
        }
    end

    return commands
end

function Bundler.get_command_bundle(platform)
    CommandRaiseVersion:execute()

    local platform_config = BundleConfig.platforms_config[platform]
    local command = {'java'}

    Bundler._add_param('-jar', BundleConfig.bob_path, command)
    Bundler._add_param('--archive', platform_config.archive, command)
    Bundler._add_param('--variant', platform_config.debug and 'debug' or 'release', command)
    Bundler._add_param('--platform', platform_config.platform, command)
    Bundler._add_param('-bo', platform_config.bundle_output, command)
    Bundler._add_param('--settings', platform_config.settings, command)
    Bundler._add_param('--exclude-build-folder', Bundler._get_platforms_to_exclude_str(platform), command)

    command[#command + 1] = 'resolve'
    command[#command + 1] = 'clean'
    command[#command + 1] = 'build'
    command[#command + 1] = 'bundle'

    return {
        action = 'shell',
        command = command,
    }
end

function Bundler._add_param(key, value, command)
    command[#command + 1] = key

    if value == true then
        return
    end

    if value ~= nil then
        command[#command + 1] = value
    end
end

function Bundler._get_platforms_to_exclude_str(platform)
    local platform_config = BundleConfig.platforms_config[platform]
    local all_platforms = {}

    for _, value in pairs(Platforms) do
        all_platforms[#all_platforms + 1] = value
    end

    local folders_to_exclude = Array.filter(all_platforms, function(item)
        return item ~= platform
    end)

    for i = 1, #folders_to_exclude do
        folders_to_exclude[i] = BundleConfig.platforms_scripts .. folders_to_exclude[i]
    end

    for _, folder in pairs(platform_config.folders_to_exclude) do
        folders_to_exclude[#folders_to_exclude + 1] = folder

    end

    return table.concat(folders_to_exclude, ',')
end

function Bundler._get_all_platforms()
    local all_platforms = {}

    for _, value in pairs(Platforms) do
        all_platforms[#all_platforms + 1] = value
    end

    return all_platforms
end

return Bundler
