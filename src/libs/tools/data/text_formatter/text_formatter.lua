local String = require('src.libs.tools.types.string.string')
local UTF8 = require('src.libs.tools.data.utf8.utf8')

local ELLIPSIS_LENGTH = 3
local POINT_LENGTH = 1

local TextFormatter = {}

function TextFormatter.split_text_lines(text, max_line_width, max_line_count)
    local lines = {}
    local words = String.split(text, String.SPACE)

    local text_data = {
        lines = {},
        current_line = nil,
        current_line_length = 0,
        max_line_width = max_line_width,
        max_line_count = max_line_count,
    }

    for i, word in ipairs(words) do
        if word and word ~= '' then
            TextFormatter._add_word_to_text_data(text_data, word)
        end
    end

    return text_data.lines
end

function TextFormatter.format_text_lines(text, max_line_width, max_line_count)
    local lines = TextFormatter.split_text_lines(text, max_line_width, max_line_count)

    local buff = {}
    local line_count = math.min(#lines, max_line_count)
    for i = 1, line_count do
        local line = table.concat(lines[i], String.SPACE)
        local line_length = UTF8.len(line)

        if line_length > max_line_width then
            line = UTF8.sub(line, 1, max_line_width)
        end

        table.insert(buff, line)
    end

    if #buff == 0 then
        return ''
    end

    local last_line = buff[line_count]
    local last_line_length = UTF8.len(last_line)

    if last_line_length > max_line_width then
        last_line = UTF8.sub(last_line, 1, max_line_width - ELLIPSIS_LENGTH)
        last_line = last_line .. String.ELLIPSIS
        buff[line_count] = last_line
    end

    return table.concat(buff, String.NEWLINE)
end

function TextFormatter.format_user_name(text, max_width)
    local words = String.split(text, String.SPACE)
    local name = words[1]

    if not name then
        print(text, inspect(words), name)
        return
    end

    local length = UTF8.len(name)

    if length > max_width then
        return UTF8.sub(name, 1, max_width - ELLIPSIS_LENGTH) .. String.ELLIPSIS
    end

    if words[2] then
        return words[1] .. ' ' .. UTF8.sub(words[2], 1, 1) .. String.POINT
    end

    return words[1]
end

function TextFormatter._check_add_line(text_data, word)
    if not text_data.current_line then
        text_data.current_line = {}
        table.insert(text_data.lines, text_data.current_line)
    end

    table.insert(text_data.current_line, word)
end

function TextFormatter._try_add_word_without_split(text_data, word, word_len)
    local count_separator = text_data.current_line_length > 0 and 1 or 0

    if text_data.max_line_count and text_data.max_line_count <= #text_data.lines then
        TextFormatter._check_add_line(text_data, word)
        return true
    end

    if text_data.current_line_length + count_separator + word_len <= text_data.max_line_width then
        text_data.current_line_length = text_data.current_line_length + count_separator + word_len
        TextFormatter._check_add_line(text_data, word)
        return true
    end

    if word_len <= text_data.max_line_width then
        text_data.current_line = nil
        TextFormatter._check_add_line(text_data, word)
        text_data.current_line_length = word_len
        return true
    end

    return false
end

function TextFormatter._add_long_word_to_text_data(text_data, word, word_len)
    local start_index = 1
    while start_index <= word_len do
        local separator_count = text_data.current_line_length > 0 and 1 or 0
        local line_count_left = text_data.max_line_width - text_data.current_line_length - separator_count

        if line_count_left <= 0 then
            line_count_left = text_data.max_line_width
        end

        local sub_count = math.min(line_count_left, word_len - start_index)

        local end_index = start_index + sub_count
        local sub_word = UTF8.sub(word, start_index, end_index)
        TextFormatter._try_add_word_without_split(text_data, sub_word, sub_count)

        start_index = end_index + 1
    end
end

function TextFormatter._add_word_to_text_data(text_data, word)
    local word_len = UTF8.len(word)

    if TextFormatter._try_add_word_without_split(text_data, word, word_len) then
        return
    end

    TextFormatter._add_long_word_to_text_data(text_data, word, word_len)
end

return TextFormatter

