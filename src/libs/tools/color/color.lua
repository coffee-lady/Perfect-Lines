local ColorLib = {}

local MAX_COLOR_VALUE = 255

local function hex_to_perc(str)
    local color_value = tonumber(str, 16)

    if not color_value then
        return 1
    end

    return color_value / MAX_COLOR_VALUE
end

function ColorLib.to_vector3(str)
    local r = hex_to_perc(string.sub(str, 1, 2))
    local g = hex_to_perc(string.sub(str, 3, 4))
    local b = hex_to_perc(string.sub(str, 5, 6))

    return vmath.vector3(r, g, b)
end

function ColorLib.to_vector4(str)
    local r = hex_to_perc(string.sub(str, 1, 2))
    local g = hex_to_perc(string.sub(str, 3, 4))
    local b = hex_to_perc(string.sub(str, 5, 6))
    local a = hex_to_perc(string.sub(str, 7, 8))

    return vmath.vector4(r, g, b, a)
end

function ColorLib.channels_to_vector4(r, g, b, a)
    a = a or MAX_COLOR_VALUE

    r = r / MAX_COLOR_VALUE
    g = g / MAX_COLOR_VALUE
    b = b / MAX_COLOR_VALUE
    a = a / MAX_COLOR_VALUE

    return vmath.vector4(r, g, b, a)
end

function ColorLib.convert_v4_theme(theme)
    if type(theme) == 'string' then
        return ColorLib.to_vector4(theme)
    end

    for key, value in pairs(theme) do
        theme[key] = ColorLib.convert_v4_theme(value)
    end

    return theme
end

return ColorLib
