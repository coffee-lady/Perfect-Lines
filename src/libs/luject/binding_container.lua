local Const = require('src.libs.luject.const')
local Binding = require('src.libs.luject.binding')

local BindingContainer = class('BindingContainer')

local log = function(...)

end

local function to_hash(val)
    if type(val == 'string') then
        return hash(val)
    end
    return val
end

function BindingContainer:initialize()
    self.bindings = {}
    self.class_instances = {}
end

function BindingContainer:debug()
    log = pprint
end

function BindingContainer:clear_container()
    self.bindings = {}
    self.class_instances = {}
end

function BindingContainer:resolve_class_params(class, context, binding, out_params)
    out_params = out_params or {}

    local param_keys = class.__cparams

    local inject_key = nil

    if context and context.parent_context then
        inject_key = context.parent_context.param_key
    end

    if param_keys then
        for i, ckey in ipairs(param_keys) do
            log('resolving key ' .. ckey)
            local resolve_context = {
                parent_context = context,
                inject_class = class,
                param_key = ckey,
                inject_key = inject_key,
                binding_id = binding and binding:get_id(),
            }
            local c_param = self:resolve(ckey, resolve_context)
            assert(c_param, 'cant resolve for key ' .. tostring(ckey))
            table.insert(out_params, c_param)
        end
    end

    return out_params
end

function BindingContainer:resolve_params(binding, context)
    local params = self:resolve_class_params(binding.bind_class, context, binding)

    -- append params from binding data
    local bind_param = binding.params
    if bind_param then
        for i, c_param in ipairs(bind_param) do
            table.insert(params, c_param)
        end
    end

    return params
end

function BindingContainer:resolve_transient(binding, context)
    local params = self:resolve_params(binding, context)
    local inst = binding:create_instance(params)
    assert(inst, 'cant resolve for binding ' .. tostring(binding))
    return inst
end

function BindingContainer:resolve_single(binding, context)
    -- local inst = self.class_instances[binding.bind_class]
    local inst = binding.instance
    if not inst then
        inst = self:resolve_transient(binding, context)
        -- self.class_instances[binding.bind_class] = inst
        binding.instance = inst
    end

    return inst
end

function BindingContainer:bind(...)
    local binding = Binding(...)
    local keys = {...}

    assert(#keys > 0)

    for i, key in ipairs(keys) do
        key = to_hash(key)
        local key_bindings = self.bindings[key]
        if not key_bindings then
            key_bindings = {}
            self.bindings[key] = key_bindings
        end

        table.insert(key_bindings, binding)
    end

    return binding
end

function BindingContainer:parse_key_data(key)
    local key_str = key
    local key_data_str = nil

    if string.find(key, Const.param_separator) then
        key_str, key_data_str = string.match(key, Const.patern_params)
        if key_data_str then
            key_data_str = to_hash(key_data_str)
        end
    end

    local key_data = {
        key = to_hash(key_str),
        key_type = key_data_str,
    }
    log('key_data', key_data)
    return key_data
end

function BindingContainer:resolve(key, context)
    log('resolve ', key)

    local key_data = self:parse_key_data(key)
    key = key_data.key

    local key_bindings = self.bindings[key]

    local binding_not_found = not key_bindings or #key_bindings == 0

    if key_data.key_type == Const.types.list and binding_not_found then
        return {}
    end

    if binding_not_found then
        pprint(context)
        error('cant resolve key ' .. key)
    end

    -- select binding data
    local resolve_values = self:_resolve_params(key_bindings, context)
    log('Find binding for key = ', key, ' count = ', #resolve_values)

    if key_data.key_type == Const.types.list then
        return resolve_values
    end

    -- assert(#resolve_values == 1, "Find multiple bindings for key " .. tostring(key) )
    return resolve_values[1]

end

function BindingContainer:_resolve_params(key_bindings, context)
    local resolve_values = {}

    log('resolve conditional bindig')
    for i = 1, #key_bindings do
        local cbind = key_bindings[i]
        if (cbind.inject_condition ~= nil and cbind.inject_condition(context)) then
            log('resolve value ' .. tostring(cbind) .. ' num ' .. tostring(i))
            local resolve_value = self:resolve_from_binding(cbind, context)
            table.insert(resolve_values, resolve_value)
        end
    end

    log('resolve no condition bindig')
    for i = 1, #key_bindings do
        local cbind = key_bindings[i]
        if (cbind.inject_condition == nil) then
            log('resolve value ' .. tostring(cbind) .. ' num ' .. tostring(i))
            local resolve_value = self:resolve_from_binding(cbind, context)
            table.insert(resolve_values, resolve_value)
        end
    end

    return resolve_values
end

function BindingContainer:resolve_from_binding(binding, context)
    assert(binding, 'cant bind')

    if binding.is_from_instance then
        return assert(binding.instance)
    end

    if binding.type == Binding.BindTypes.SINGLE then
        log('resolve single')
        return self:resolve_single(binding, context)
    elseif binding.type == Binding.BindTypes.TRANSIENT then
        log('resolve transient')
        return self:resolve_transient(binding, context)
    end

    return nil
end

function BindingContainer:resolve_class(class, ...)
    local cparams = self:resolve_class_params(class)
    local custom_param = {...}

    for _, param in ipairs(custom_param) do
        table.insert(cparams, param)
    end

    return class(unpack(cparams))
end

function BindingContainer:instant_all_single()
    for key, bindings in pairs(self.bindings) do
        for i = 1, #bindings do
            local binding = bindings[i]
            if binding.type == Binding.BindTypes.SINGLE then
                self:resolve_single(binding)
            end
        end
    end
end

return BindingContainer
