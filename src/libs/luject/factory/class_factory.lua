local Luject = require('src.libs.luject.luject')
local ClassFactory = class('ClassFactory')

function ClassFactory:initialize(luject_class_key, ...)
    self.class_key = luject_class_key

    self.params = {...}
end

function ClassFactory:create()
    return Luject:resolve(self.class_key, unpack(self.params))
end

return ClassFactory
