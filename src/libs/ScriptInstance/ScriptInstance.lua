local ScriptInstance = {}

function ScriptInstance:get_instance()
    return lua_script_instance.Get()
end

function ScriptInstance:set_instance(value)
    return lua_script_instance.Set(value)
end

return ScriptInstance
