local ObfuscateSimple = {}

ObfuscateSimple.DEFAULT_OBFUSCATE = 'f8g64dfg132cv8df65'

function ObfuscateSimple.obfuscate(input, key)
    key = key or ObfuscateSimple.DEFAULT_OBFUSCATE

    local output = ''
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

function ObfuscateSimple.to_bytes(input)
    local bytes = {}

    for i = 1, #input do
        local byte = string.byte(string.sub(input, i, i))
        table.insert(bytes, byte)
    end

    return bytes
end

return ObfuscateSimple
