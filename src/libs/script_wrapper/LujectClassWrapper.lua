local Luject = require('src.libs.luject.luject')
local ScriptClassRegistrator = require('src.libs.script_wrapper.ScriptClassRegistrator')

local LujectClassWrapper = class('LujectClassWrapper')

function LujectClassWrapper:register()
    return ScriptClassRegistrator(self, function(class_type)
        return Luject:resolve_class(class_type)
    end)
end

return LujectClassWrapper
