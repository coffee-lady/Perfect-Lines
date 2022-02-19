local class = require('src.libs.tools.middleclass.middleclass')
local Tools = require('src.libs.tools.tools')

local inspect = Tools.inspect

local Debug = class('Debug')

function Debug:initialize(prefix, is_debug, is_html_logged)
    self.is_debug = is_debug
    self.is_html_logged = is_html_logged
    self.prefix = prefix or ''
end

function Debug:log(...)
    if not self.is_debug then
        return
    end

    print(self.prefix, ...)

    if self.is_html_logged then
        self:log_html(self.prefix, ...)
    end
end

function Debug:log_platform(...)
    self:log_html(...)
end

function Debug:log_html(...)
    if not html5 then
        return
    end

    local params = table.concat({...}, ' ')
    local execute_line = string.format('console.log(`%s  %s`)', self.prefix, params)
    local status, error = pcall(html5.run, execute_line)

    if not status then
        print(error)
    end
end

function Debug:inspect(...)
    return inspect(...)
end

function Debug:log_dump(...)
    if self.is_debug then
        print(self.prefix, inspect(...))
    end
end

function Debug:log_html_dump(...)
    self:log_html(inspect(...))
end

function Debug:traceback(thread, message, level)
    if self.is_debug then
        print(debug.traceback(thread, message, level))
    end
end

return Debug
