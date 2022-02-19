local String = {}

String.SPACE = ' '
String.NEWLINE = '\n'
String.POINT = '.'
String.ELLIPSIS = '...'

function String.replace_vars(str, vars)
    if not vars then
        vars = str
    end

    return (string.gsub(str, '({([^}]+)})', function(whole, key)
        return vars[key] or whole
    end))
end

function String.split(str, separator)
    local t = {} -- NOTE: use {n = 0} in Lua-5.0
    local fpat = '(.-)' .. separator
    local last_end = 1
    local s, e, cap = str:find(fpat, 1)
    while s do
        if s ~= 1 or cap ~= '' then
            table.insert(t, cap)
        end
        last_end = e + 1
        s, e, cap = str:find(fpat, last_end)
    end
    if last_end <= #str then
        cap = str:sub(last_end)
        table.insert(t, cap)
    end
    return t
end

function String.join(arr, separator)
    return table.concat(arr, separator)
end

return String
