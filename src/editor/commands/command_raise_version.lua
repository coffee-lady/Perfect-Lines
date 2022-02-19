local ConfigProject = require('src.editor.utils.project.project_config')
local VersionData = require('src.editor.utils.project_version')
local CommandRaiseVersion = {}

local DEFAULT_PROJECT_PATH = 'game.project'
local PROPERTY_VERSION = 'project.version'

function CommandRaiseVersion:execute(options, project_path)
    project_path = project_path or DEFAULT_PROJECT_PATH
    local project_config = ConfigProject(project_path)
    local project_version = project_config:get_raw_property(PROPERTY_VERSION)
    print('current project version ', project_version)
    local version_data = VersionData(project_version)
    version_data:set_patch(version_data:get_patch() + 1)
    local next_project_version = version_data:to_string()
    project_config:set_raw_property(PROPERTY_VERSION, next_project_version)
    print('set project version ', next_project_version)
    project_config:save_to_file(project_path)
end

return CommandRaiseVersion
