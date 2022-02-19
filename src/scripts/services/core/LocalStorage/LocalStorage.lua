local defsave = require('defsave.defsave')

--- @class LocalStorage
local LocalStorage = class('LocalStorage')

function LocalStorage:initialize()
    defsave.appname = sys.get_config('project.title')
    defsave.autosave = true
    defsave.autosave_timer = 1
    defsave.verbose = false
end

function LocalStorage:update(dt)
    defsave.update(dt)
end

function LocalStorage:set(filename, key, value)
    if not defsave.is_loaded(filename) then
        defsave.load(filename)
    end

    defsave.set(filename, key, value)
    defsave.save_all()
end

function LocalStorage:get(filename, key)
    if not defsave.is_loaded(filename) then
        defsave.load(filename)
    end

    if not key then
        return defsave.loaded[filename].data
    end

    return defsave.get(filename, key)
end

function LocalStorage:final()
    defsave.save_all()
end

return LocalStorage
