local Binding = class('Binding')

local BindTypes = {
    SINGLE = 0,
    TRANSIENT = 1,
    CACHED = 2,
}

Binding.BindTypes = BindTypes

function Binding:initialize(...)
    self.keys = {...}
    self.instance = nil
    self.bind_class = nil
    self.params = nil
    self.type = BindTypes.TRANSIENT
    self.is_from_instance = false
    self.instantiate_callback = nil
end

function Binding:create_instance(cparams)
    local inst = self.bind_class(unpack(cparams))
    if self.instantiate_callback then
        self.instantiate_callback(inst)
    end
    return inst
end

function Binding:to(class)
    assert(class, debug.traceback())
    self.bind_class = class
    return self
end

function Binding:to_instance(instance)
    assert(instance)
    self.instance = instance
    self.is_from_instance = true
    return self
end

function Binding:as_single()
    self.type = BindTypes.SINGLE
    return self
end

function Binding:as_transient()
    self.type = BindTypes.TRANSIENT
    return self
end

function Binding:as_cached()
    self.type = BindTypes.CACHED
    return self
end

function Binding:with_params(...)
    self.params = {...}
    return self
end

function Binding:on_instantiate(callback)
    assert(type(callback) == 'function')
    self.instantiate_callback = callback
    return self
end

function Binding:when_injected_into(class)
    self.inject_condition = function(context)
        return context and context.inject_class == class
    end
    return self
end

function Binding:when(condition_fn)
    assert(type(condition_fn) == 'function')
    self.inject_condition = condition_fn
    return self
end

function Binding:when_injected_id(id_object)
    self.inject_condition = function(context)
        pprint('Binding:when_injected_id ', context.binding_id)
        return context and context.binding_id == id_object
    end

    return self
end

function Binding:with_id(id_object)
    assert(id_object)
    self.binding_identifier = id_object
    return self
end

function Binding:get_id()
    return self.binding_identifier
end

function Binding.__tostring(self, ...)
    local out = 'Binding'
    if self.keys then
        out = table.concat(self.keys, ', ')
    end

    out = string.format('keys=%s, condition=%s', out, tostring(self.inject_condition))

    return out
end

return Binding
