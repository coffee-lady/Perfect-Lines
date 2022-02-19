local ResourcesStorage = {
    cache = {},
}

ResourcesStorage.types = {
    json = 'json',
    lua = 'lua',
}

function ResourcesStorage:get(filename, type)
    if self.cache[filename] then
        return self.cache[filename]
    end

    if type == self.types.json then
        return self:get_json_data(filename)
    end

    if type == self.types.lua then
        return self:get_lua_data(filename)
    end
end

function ResourcesStorage:get_json_data(filename)
    if self.cache[filename] then
        return self.cache[filename]
    end

    local data = sys.load_resource(filename)

    if not data then
        return nil
    end

    local decoded = json.decode(data)
    self.cache[filename] = decoded

    return decoded
end

function ResourcesStorage:get_lua_data(filename)
    if self.cache[filename] then
        return self.cache[filename]
    end

    local data = loadfile(filename)
    self.cache[filename] = data

    return data
end

return ResourcesStorage
