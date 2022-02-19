local INIT_FUNCTION = 'init'
local DEFOLD_FUNCTIONS = {INIT_FUNCTION, 'final', 'update', 'on_input', 'on_reload', 'on_message'}
local DEFOLD_FUNCS_NO_INIT = {'final', 'update', 'on_input', 'on_reload', 'on_message'}

local ScriptClassRegistrator = class('ScriptClassRegistrator')

function ScriptClassRegistrator:initialize(script_class, fn_instantiator, owner_name)
    assert(script_class)

    self.owner_name = owner_name
    self.script_instances = {}
    self.script_class = script_class

    self:bind_instantiator(fn_instantiator)
    self:bind_defold_methods()
end

function ScriptClassRegistrator:bind_instantiator(fn_instantiator)
    if fn_instantiator ~= nil then
        assert(type(fn_instantiator) == 'function')
    end

    self.fn_instantiator = fn_instantiator or function(class_param)
        print('Instantiating thoug default func')
        return class_param()
    end
end

function ScriptClassRegistrator:bind_defold_methods()
    _G[INIT_FUNCTION] = function(script_self, ...)
        local instance = self.fn_instantiator(self.script_class)
        self.script_instances[script_self] = instance
        local instance_init_method = instance[INIT_FUNCTION]
        if instance_init_method then
            instance_init_method(instance, script_self, ...)
        end
        instance.__script_instance = script_self
    end

    for _, method_name in ipairs(DEFOLD_FUNCS_NO_INIT) do
        local instance_method = self.script_class[method_name]
        if instance_method and type(instance_method) == 'function' then
            self:register_method(method_name, instance_method)
        end
    end
end

function ScriptClassRegistrator:register_method(method_key, instance_method)
    _G[method_key] = function(script_self, ...)
        local instance = self.script_instances[script_self]
        -- print('calling ', method_key, 'for ', script_self)
        if not instance then
            -- print('Method key ', method_key)
            -- print('Instance ', script_self)
            -- print('Script Class Wrap: error find instance for script self')
            return
        end

        instance_method(instance, ...)
    end
end

return ScriptClassRegistrator
