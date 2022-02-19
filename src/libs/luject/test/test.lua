local Luject = require('src.libs.luject.luject')

local TestClassA = class('TestClassA')

function TestClassA:initialize(param)
    self.param = param
    print('initializing testclass A')
end

function TestClassA:execute()
    print('executing testclass A, param = ' .. tostring(self.param))
    return self.param
end

local TestClassB = class('TestClassB')

TestClassB.__cparams = {'TestClassA'}

function TestClassB:initialize(class_a)
    print('initializing testclass B')
    self.class_a = class_a
end

function TestClassB:execute()
    print('executing testclass B')
    self.class_a:execute()
end

local TestClassC = class('TestClassC')

TestClassC.__cparams = {'TestClassA', 'TestClassB'}

function TestClassC:initialize(class_a, class_b, name)
    print('initializing testclass C')
    self.class_a = class_a
    self.class_b = class_b
    self.name = name
end

function TestClassC:execute()
    self.class_a:execute()
    self.class_b:execute()
    print('executing testclass C name' .. self.name)
end

local TestClassD = class('TestClassD')

TestClassD.__cparams = {'TestClassA'}

function TestClassD:initialize(executer)
    print('initializing testclass D')
    self.executer = assert(executer)
end

function TestClassD:execute()
    self.executer:execute()
    print('executing testclass D ')
end

local MultipleExecutor = class('MultipleExecutor')

MultipleExecutor.__cparams = {'executor:list'}

function MultipleExecutor:initialize(executors)
    print('MultipleExecutor:initialize ', #executors)
    self.executors = executors
end

function MultipleExecutor:execute()
    print('MultipleExecutor execute')
    local val = 0

    for i, exec in ipairs(self.executors) do
        exec:execute()
        val = val + 1
    end

    return val
end

local m = {}

function m.run()
    m:test_simple_bindings()
    m:test_resolve_class()
    m:test_with_params()
    m:test_conditional_binding()
    m:test_list_bindings()
    m:test_binding_id()
end

function m:prebind()
    print('binding')
    self:clear()

    Luject:bind('TestClassA'):to(TestClassA):as_single()
    Luject:bind('TestClassB'):to(TestClassB):as_single()
    Luject:bind('TestClassC'):to(TestClassC):as_single():with_params('wet butt')
    Luject:bind('TestClassD'):to(TestClassD):as_single()
    Luject:bind('TestClassA'):to(TestClassB):as_single():when_injected_into(TestClassD)
end

function m:clear()
    Luject:clear_container()
end

function m:test_instant_all_single()
    self:prebind()
    Luject:instant_all_single()
end

function m:test_simple_bindings()
    self:prebind()

    print('--- test simple binding')
    local test_b = Luject:resolve('TestClassB')
    assert(test_b)
    test_b:execute()

    local test_a = Luject:resolve('TestClassA')
    test_a:execute()

end

function m:test_resolve_class()
    self:prebind()

    print('--- test resolve class')

    local build_class = Luject:resolve_class(TestClassB)
    assert(build_class)
    build_class:execute()
end

function m:test_with_params()
    self:prebind()

    print('--- test with params')
    local class_c = Luject:resolve('TestClassC')
    assert(class_c)
    class_c:execute()
end

function m:test_conditional_binding()
    self:clear()

    Luject:bind('TestClassA'):to(TestClassA):as_single():when_injected_into(TestClassD)
    Luject:bind('TestClassD'):to(TestClassD):as_single()
    Luject:bind('TestClassB'):to(TestClassB):as_single()

    print('-- test conditional binding')
    local d = Luject:resolve('TestClassD')
    assert(d)
    d:execute()
end

function m:test_list_bindings()
    print('-- test list binding')

    self:clear()

    Luject:bind('TestClassA'):to(TestClassA):as_single()
    Luject:bind('executor'):to(TestClassA):as_single()
    Luject:bind('executor'):to(TestClassB):as_single()
    Luject:bind('mult_executor'):to(MultipleExecutor):as_single()

    local mult_executor = Luject:resolve('mult_executor')
    assert(mult_executor)
    assert(mult_executor:execute() == 2)
end

function m:test_binding_id()
    print('-- test binding id')

    self:clear()

    Luject:bind('executor'):to(TestClassB):as_single():with_id('id_a')
    Luject:bind('executor'):to(TestClassB):as_single():with_id('id_b')

    Luject:bind('TestClassA'):to(TestClassA):as_single():when_injected_id('id_a'):with_params('anus')
    Luject:bind('TestClassA'):to(TestClassA):as_single():when_injected_id('id_b'):with_params('pussy')

    Luject:bind('mult_executor'):to(MultipleExecutor):as_single()

    local mult_executor = Luject:resolve('mult_executor')
    assert(mult_executor)
    assert(mult_executor:execute() == 2)
end

return m
