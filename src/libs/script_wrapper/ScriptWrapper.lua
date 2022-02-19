local Tools = require('src.libs.tools.tools')
local class = Tools.middleclass

local ScriptWrapper = class('Wrapper')

local INIT_METHOD = 'init'
local defold_methods = {INIT_METHOD, 'final', 'update', 'on_input', 'on_reload', 'on_message'}

function ScriptWrapper:initialize()

end

local function register_method(self, method_name)
    local method = self[method_name]
    if not method then
        return
    end

    if method_name == INIT_METHOD then
        _G[method_name] = function(go_self, ...)
            self.__script_instance__ = go_self
            method(self, go_self, ...)
        end
    else
        _G[method_name] = function(_, ...)
            method(self, ...)
        end
    end
end

function ScriptWrapper:register()
    for _, method_name in ipairs(defold_methods) do
        register_method(self, method_name)
    end
end

return ScriptWrapper
