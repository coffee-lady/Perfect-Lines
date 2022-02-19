local App = require('src.app')

local Obfuscate = App.libs.obfuscate
local JSON = App.libs.json
local Base64 = App.libs.base64

--- @class ServerContentEncoder
local ContentEncoder = class('ContentEncoder')

ContentEncoder.__cparams = {}

function ContentEncoder:initialize(secure_key)
    self.secure_key = secure_key
end

function ContentEncoder:encode_content(content, secure_key)
    secure_key = secure_key or self.secure_key
    local status, content_json = pcall(JSON.encode, content)

    if not status then
        return nil
    end

    local secure_container = {}
    secure_container.content = Base64.encode(Obfuscate.obfuscate(content_json, secure_key))

    return secure_container
end

function ContentEncoder:encode_content_json(content, secure_key)
    local result = self:encode_content(content, secure_key)
    if not result then
        return nil
    end

    return JSON.encode(result)
end

function ContentEncoder:decode_container(container, secure_key)
    if not container or not container.content then
        return nil
    end

    secure_key = secure_key or self.secure_key

    local decodedConentent = Base64.decode(container.content)

    local obfuscate_status, content_json = pcall(Obfuscate.obfuscate, decodedConentent, secure_key)

    if not obfuscate_status then
        return nil
    end

    local decode_status, content = pcall(JSON.decode, content_json)

    if not decode_status then
        return nil
    end

    return content
end

function ContentEncoder:decode_container_json(container_json, secure_key)
    local status, container = pcall(JSON.decode, container_json or '{}')
    if not status then
        return nil
    end

    return self:decode_container(container, secure_key)
end

function ContentEncoder:generate_sign(format_sign, key)
    local timestamp = os.time()

    local sign_text = string.format(format_sign, timestamp)
    local sign_obfuscate = Obfuscate.obfuscate(sign_text, key)
    local sign = Base64.encode(sign_obfuscate)

    return sign
end

return ContentEncoder
