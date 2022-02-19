local class = require('src.libs.tools.middleclass.middleclass')

--- @class ConfigProject
local ConfigProject = class('ConfigProject')

local PATERN_SECTION = '^%s*%[([%w_]+)%]%s*$'
local PATTERN_KEYVALUE = '^%s*([%w_#]+)%s*=%s*(.*)%s*$'
local PATTERN_PROPERTY_PATH = '([%w_]+)%.([%w_]+)'
local NEW_LINE = '\n'

local FORMAT_SECTION = '[%s]'
local FORMAT_KEYVALUE = '%s = %s'

local log = print

function ConfigProject:initialize(project_file)
    self.config_data = {}

    if project_file then
        self:load_from_file(project_file)
    end
end

function ConfigProject:load_from_file(file_path)
    local project_file_lines = self:_load_file_lines(file_path)
    self:_parse_project_config_lines(project_file_lines)
end

function ConfigProject:_load_file_lines(file_path)
    local lines = {}
    local project_file = io.open(file_path, 'r')

    for line in project_file:lines() do
        table.insert(lines, line)
    end

    project_file:close()
    return lines
end

function ConfigProject:_parse_project_config_lines(lines)
    self.config_data = {}
    self.section_order = {}

    local section = nil
    local section_key = nil

    for _, line in ipairs(lines) do
        local section_match = string.match(line, PATERN_SECTION)
        if section_match then
            section = {}
            self.config_data[section_match] = section
            table.insert(self.section_order, section_match)
        else
            local key, value = string.match(line, PATTERN_KEYVALUE)
            -- log("key", key, "value", value)

            if key and value and section then
                local value_container = {}
                value_container.key = key
                value_container.value = value
                table.insert(section, value_container)
            end
        end
    end
end

function ConfigProject:save_to_file(file_path)
    local config_lines = self:config_to_lines()
    self:save_line_to_file(file_path, config_lines)
end

function ConfigProject:config_to_lines()
    local lines = {}

    for _, section_key in ipairs(self.section_order or {}) do
        local section_line = string.format(FORMAT_SECTION, section_key)
        table.insert(lines, section_line)
        for key, container in pairs(self.config_data[section_key]) do
            local save_key = tostring(container.key)
            local save_value = tostring(container.value)
            local line_key_value = string.format(FORMAT_KEYVALUE, save_key, save_value)
            table.insert(lines, line_key_value)
        end

        table.insert(lines, '')
    end

    return lines
end

function ConfigProject:save_line_to_file(file_path, lines)
    local file_save = io.open(file_path, 'w+')
    for i, line in ipairs(lines) do
        file_save:write(line)
        file_save:write(NEW_LINE)
    end

    file_save:close()
end

function ConfigProject:get_raw_property(property_path)
    local section_key, key = self:_parse_property_path(property_path)
    if not section_key or not key then
        log('cant parse property path ', property_path)
        return nil
    end

    return self:get_raw_value(section_key, key)
end

function ConfigProject:get_raw_value(section_key, key)
    local value_container = self:get_value_container(section_key, key)

    if not value_container then
        log('cant get value for ', section_key, key)
        return nil
    end

    return value_container.value
end

function ConfigProject:set_raw_property(property_path, value)
    local section_key, key = self:_parse_property_path(property_path)
    self:set_raw_value(section_key, key, value)
end

function ConfigProject:set_raw_value(section_key, key, value)
    local value_container = self:get_value_container(section_key, key)

    if not value_container then
        log('cant set value for ', section_key, key)
        return nil
    end

    value_container.value = value
end

function ConfigProject:_parse_property_path(property_path)
    log('parse property', property_path)
    return string.match(property_path, PATTERN_PROPERTY_PATH)
end

function ConfigProject:get_value_container(section_key, key)
    if not section_key or not key then
        log('cant get value for ', section_key, key)
        return nil
    end

    local section = self.config_data[section_key]
    if not section then
        log('cant find section ', section_key)
        return nil
    end

    for i = 1, #section do
        local value_container = section[i]
        if value_container.key == key then
            return value_container
        end
    end

    return nil
end

return ConfigProject
