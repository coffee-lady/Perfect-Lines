local json = require('src.libs.tools.data.json.json')

local PlatformChanger = {}

local Settings = {
    path_script_change_platform = './src/editor/platform_changer/helpers/setup_build_platform.py',
    path_platform_config = './src/editor/platform_changer/config/config_change_platform.json',

    format_command_name = 'Setup build %s',
    default_command_key = 'UNKNOWN',
    command_locations = {'Edit'},
}

function PlatformChanger:init()
    self.config_platform = self:_load_platform_config()
end

function PlatformChanger.get_commands()
    return PlatformChanger:_build_commands()
end

function PlatformChanger:_build_commands()
    local config = self.config_platform.platforms

    local commands = {}

    for key, value in pairs(config) do
        local command_name = string.format(Settings.format_command_name, key or Settings.default_command_key)

        local command = {
            label = command_name,
            locations = Settings.command_locations,
            active = function()
                return true
            end,
            run = function()
                return {self:get_command_change_platform(key)}
            end,
        }

        table.insert(commands, command)
    end

    return commands
end

function PlatformChanger:_load_platform_config()
    local config_path = Settings.path_platform_config
    local config_file, error = io.open(config_path, 'r')

    if not config_file then
        return {}
    end

    local config_str = config_file:read('*a')
    config_file:close()
    return json.decode(config_str)
end

function PlatformChanger:get_command_change_platform(platform_key)
    return {
        action = 'shell',
        command = {'python', Settings.path_script_change_platform, platform_key},
    }
end

return PlatformChanger
