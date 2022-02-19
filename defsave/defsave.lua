-- DefSave helps with loading and saving config and player data between sesssions
local json = require("defsave.json") -- used for HTML5

local M = {}

M.autosave = false -- set to true to autosave all loaded files that are changed on a timer
M.autosave_timer = 10 -- amount of seconds between autosaves if changes have been made
M.timer = 0 -- current timer value only increases if autosave is enabled
M.changed = false -- locally used but can be useful to have exposed
M.verbose = true -- if true then more information will be printed such as autosaves
M.block_reloading = false -- if true then files already loaded will never be overwritten with a reload
M.appname = "defsave" -- determines part of the path for saving files to
M.loaded = {} -- list of files currently loaded
M.sysinfo = sys.get_sys_info()
M.use_default_data = true -- if true will attempt to load default data from the default_data table when loading empty file
M.enable_encryption = false -- if true then all data saved and loaded will be encrypted with AES - SLOWER
M.encryption_key = "defsave" -- pick an encryption key to use if you're using encryption
M.enable_obfuscation = false -- if true then all data saved and loaded will be XOR obfuscated - FASTER
M.obfuscation_key = "defsave" -- pick an obfuscation key it use if you're using encryption, the longer the key for obfuscation the better

-- You don't have to save your keys directly in one file as a single string... you can get creative with how you store your keys
-- Don't expect your save files to not be unlocked by someone eventually, don't store sensetive data in your files!
-- This is only a deterent for casual users to not mess with save data files
-- And your users can still use memory editing tools which you must defend against with other ways if you even wish to

local log = print

M.default_data = {} -- default data to set files to if any cannnot be loaded

function M.set_appname(appname)
    assert(type(appname) == "string", "DefSave: set_appname must pass a string")
    M.appname = appname
end

function M.obfuscate(input, key)
    key = key or M.obfuscation_key
    local output = ""
    local key_iterator = 1

    local input_length = #input
    local key_length = #key

    for i = 1, input_length do
        local character = string.byte(input:sub(i, i))
        if key_iterator >= key_length + 1 then
            key_iterator = 1
        end -- cycle
        local key_byte = string.byte(key:sub(key_iterator, key_iterator))
        output = output .. string.char(bit.bxor(character, key_byte))

        key_iterator = key_iterator + 1

    end
    return output
end

local function clone(t) -- deep-copy a table
    if type(t) ~= "table" then
        return t
    end
    local meta = getmetatable(t)
    local target = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            target[k] = clone(v)
        else
            target[k] = v
        end
    end
    setmetatable(target, meta)
    return target
end

function M.get_file_path(file)
    if M.appname == "defsave" then
        log("DefSave: You need to set a non-default appname to defsave.appname")
    end
    if file == nil then
        log("DefSave: Warning attempting to get a path for a nil file")
        return nil
    end
    if M.sysinfo.system_name == "Linux" then
        -- For Linux we must modify the default path to make Linux users happy
        local appname = "config/" .. tostring(M.appname)
        return sys.get_save_file(appname, file)
    end
    if html5 then
        -- For HTML5 there's no need to get the full path
        return M.appname .. "_" .. file
    end
    return sys.get_save_file(M.appname, file)
end

function M.load(file)
    if file == nil then
        log("DefSave: Warning no file specified when attempting to load")
        return nil
    end

    local path = M.get_file_path(file)

    if path == nil then
        log("DefSave: Warning path returned when attempting to load is nil")
        return nil
    end

    if M.loaded[file] ~= nil then
        if M.block_reloading == false then
            log("DefSave: Warning the file " .. file .. " was already loaded and will be reloaded possibly overwriting changes")
        else
            log("DefSave: Warning attempt to reload already file has been blocked")
            return true
        end
    end

    local loaded_file
    if html5 then
        -- sys.load can't be used for HTML5 apps running on iframe from a different origin (cross-origin iframe)
        -- use `localStorage` instead because of this limitation on default IndexedDB storage used by Defold
        loaded_file = json.decode(html5.run([[(function(){try{return window.localStorage.getItem(']] .. path ..
                                                [[')||'{}'}catch(e){return'{}'}})()]]))
    else
        loaded_file = sys.load(path)
    end

    local empty = false

    if next(loaded_file) == nil then
        if M.verbose then
            log("DefSave: Loaded file '" .. file .. "' is empty")
        end
        empty = true
    end

    if M.use_default_data and empty then
        if (M.reset_to_default(file)) then
            return true
        else
            return false
        end

    elseif empty then
        log("DefSave: The " .. file .. " is loaded but it was empty")
        M.loaded[file] = {}
        M.loaded[file].changed = true
        M.changed = true
        M.loaded[file].data = {}
        return true
    end

    M.loaded[file] = {}
    M.loaded[file].changed = false
    M.loaded[file].data = loaded_file

    if M.verbose then
        log("DefSave: The file '" .. file .. "' was successfully loaded")
    end

    return true

end

function M.save(file, force)
    force = force or false

    if M.loaded[file] == nil then
        log("DefSave: Warning attempt to save a file which could not be found in loaded list")
        return nil
    end

    if M.loaded[file].changed == false and force == false then
        if M.verbose then
            log("DefSave: File '" .. file .. "' is unchanged so not saving, set force flag to true to force saving if changed flag is false")
        end
        return true
    end

    local path = M.get_file_path(file)

    local is_save_successful;
    if html5 then
        -- sys.save can't be used for HTML5 apps running on iframe from a different origin (cross-origin iframe)
        -- use `localStorage` instead because of this limitation on default IndexedDB storage used by Defold
        local encoded_data = json.encode(M.loaded[file].data):gsub("'", "\'") -- escape ' characters
        html5.run([[try{window.localStorage.setItem(']] .. path .. [[', ']] .. encoded_data .. [[')}catch(e){}]])

        is_save_successful = true

    else
        is_save_successful = sys.save(path, M.loaded[file].data)
    end

    if is_save_successful then
        if M.verbose then
            log("DefSave: File '" .. tostring(file) .. "' has been saved to the path '" .. path .. "'")
        end
        M.loaded[file].changed = false
        return true
    else
        log("DefSave: Something went wrong when attempting to save the file '" .. tostring(file) .. "' to the path '" .. path .. "'")
        return nil
    end
end

function M.save_all(force)
    force = force or false
    for key, value in pairs(M.loaded) do
        M.save(key, force)
        M.changed = false
    end
end

function M.get(file, key)
    if M.loaded[file] ~= nil then
        if M.loaded[file].data[key] ~= nil then
            local value = clone(M.loaded[file].data[key])
            return value
        else
            return nil
        end
    else
        log("DefSave: Warning when attempting to get a key '" .. key .. "' the file '" .. tostring(file) ..
                "' could not be found in loaded list")
        return nil
    end
end

function M.set(file, key, value)
    if M.loaded[file] ~= nil then
        -- we could check here to see if values are the same or not to set the changed flags or not but would require deep table compare loop
        value = clone(value) -- decouple from original table if value is a table
        M.loaded[file].data[key] = value
        M.loaded[file].changed = true
        M.changed = true
        return true
    else
        log("DefSave: Warning when attempting to set a key '" .. key .. "' the file '" .. tostring(file) ..
                "' could not be found in loaded list")
        return nil
    end
end

function M.key_exists(file, key)
    if M.loaded[file] ~= nil then
        if M.loaded[file].data[key] ~= nil then
            return true
        end
    else
        return false
    end
end

function M.isset(file, key)
    return M.key_exists(file, key)
end

function M.reset_to_default(file)
    if M.default_data[file] ~= nil then
        M.loaded[file] = {}
        M.loaded[file].changed = true
        M.changed = true
        M.loaded[file].data = clone(M.default_data[file])
        if M.verbose then
            log("DefSave: Successfully set the file '" .. file .. "' to its default state")
        end
        return true
    else
        log("DefSave: There is no default file set for '" .. file .. "' so setting it to empty")
        M.loaded[file] = {}
        M.loaded[file].changed = true
        M.changed = true
        M.loaded[file].data = {}
        return true
    end
end

function M.is_loaded(file)
    if M.loaded[file] ~= nil then
        return true
    else
        return false
    end
end

function M.update(dt)
    if M.autosave == true then
        if dt == nil then
            log("DefSave: You must pass dt to defsave.update")
        end
        M.timer = M.timer + dt

        if M.timer >= M.autosave_timer then
            if M.changed == true then
                M.save_all()
                if M.verbose then
                    log("DefSave: Autosaved All Changed Files")
                end
            end
            M.timer = M.timer - M.autosave_timer
        end
    end
end

function M.final()
    M.save_all()
end

return M
