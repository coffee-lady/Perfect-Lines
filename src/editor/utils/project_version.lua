---@class VersionData
local VersionData = class('VersionData')

local VERSION_SEPARATOR = '.'

function VersionData:initialize(version_str)
    self.version_str = version_str
    self.major = 0
    self.minor = 0
    self.patch = 0
    self:init_from_str(version_str)
end

function VersionData:init_from_str(version_str)
    local parts = self:split_config_str(version_str, VERSION_SEPARATOR)
    if not parts then
        return
    end

    self.major = self:parse_value(parts[1], 0)
    self.minor = self:parse_value(parts[2], 0)
    self.patch = self:parse_value(parts[3], 0)
end

function VersionData:split_config_str(str, separator)
    if separator == nil or str == nil then
        return str
    end

    local parts = {}
    for str in string.gmatch(str, '([^' .. separator .. ']+)') do
        table.insert(parts, str)
    end

    return parts
end

function VersionData:parse_value(value, default_value)
    if value == nil then
        return default_value
    end

    value = tonumber(value) or default_value
    return value
end

function VersionData:equal(version_data)
    if version_data == nil or type(version_data) ~= 'table' then
        return false
    end

    return version_data.major == self.major and version_data.minor == self.minor and version_data.patch == self.patch
end

function VersionData:compare(version_data)
    if version_data == nil then
        return false
    end

    local diff = self.major - version_data.major
    if diff ~= 0 then
        return diff
    end

    diff = self.minor - version_data.minor
    if diff ~= 0 then
        return diff
    end

    return self.patch - version_data.patch
end

function VersionData:get_major()
    return self.major
end

function VersionData:get_minor()
    return self.minor
end

function VersionData:get_patch()
    return self.patch
end

function VersionData:set_major(value)
    self.major = value
end

function VersionData:set_minor(value)
    self.minor = value
end

function VersionData:set_patch(value)
    self.patch = value
end

function VersionData:__tostring()
    return self:to_string()
end

function VersionData:to_string()
    return string.format('%d.%d.%d', self.major, self.minor, self.patch)
end

-- Test()

return VersionData
