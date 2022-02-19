--[[
  bind context = param for function when
    context.inject_class - class in wich injected param
    context.parent_context - parent context in resolving tree
    context.param_key - key of binding
    context.inject_key - key of parent injecting class
    context.binding_id - binding identificator
]] local BindingContainer = require('src.libs.luject.binding_container')
-- lua singletone container

local Luject = {}

local binding_container = BindingContainer()

function Luject:debug()
    binding_container:debug()
end

function Luject:bind(...)
    return binding_container:bind(...)
end

function Luject:resolve(key)
    return binding_container:resolve(key)
end

function Luject:resolve_class(class, ...)
    return binding_container:resolve_class(class, ...)
end

function Luject:instant_all_single()
    binding_container:instant_all_single()
end

function Luject:clear_container()
    binding_container:clear_container()
end

return Luject
