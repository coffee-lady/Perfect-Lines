local Array = {}

function Array.remove(elem, arr)
    for i = #arr, 1, -1 do
        if arr[i] == elem then
            table.remove(arr, i)
        end
    end
end

function Array.deepcopy(orig)
    local orig_type = type(orig)
    local copy

    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[Array.deepcopy(orig_key)] = Array.deepcopy(orig_value)
        end
        setmetatable(copy, Array.deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end

    return copy
end

function Array.length(arr)
    local len = 0
    for _ in pairs(arr) do
        len = len + 1
    end

    return len
end

function Array.sum(arr)
    local sum = 0

    for _, value in pairs(arr) do
        sum = sum + value
    end

    return sum
end

function Array.concat(...)
    local arrays = {...}
    local result = {}

    for i = 1, #arrays do
        local arr = arrays[i]

        for j = 1, #arr do
            result[#result + 1] = arr[j]
        end
    end

    return result
end

function Array.reduce(arr, func)
    local val

    for key, value in pairs(arr) do
        val = func(val, key, value)
    end

    return val
end

function Array.filter(arr, func)
    local result = {}

    for _, value in pairs(arr) do
        if func(value) then
            result[#result + 1] = value
        end
    end

    return result
end

function Array.filter_hash(arr, func)
    local result = {}

    for key, value in pairs(arr) do
        if func(key, value) then
            result[key] = value
        end
    end

    return result
end

function Array.has(elem, arr)
    for _, value in pairs(arr) do
        if elem == value then
            return true
        end
    end

    return false
end

function Array.first_index_of(value, arr, start_pos, end_pos)
    for i = start_pos or 1, end_pos or #arr do
        if arr[i] == value then
            return i
        end
    end

    return nil
end

function Array.last_index_of(value, arr, start_pos, end_pos)
    for i = start_pos or #arr, end_pos or 1, -1 do
        if arr[i] == value then
            return i
        end
    end

    return nil
end

function Array.pop(arr)
    local val = arr[#arr]

    table.remove(arr)

    return val
end

function Array.clear(arr)
    for key, _ in pairs(arr) do
        arr[key] = nil
    end
end

function Array.print_1d(arr)
    print(table.concat(arr, ' '))
end

function Array.print_2d_briefly(arr)
    local str = ''

    for _, value in pairs(arr) do
        str = str .. '{ ' .. table.concat(value, ' ') .. ' }, '
    end

    print(str)
end

function Array.print_2d(arr, print_keys)
    for key, value in pairs(arr) do
        if print_keys then
            print(key .. ': ' .. table.concat(value, ' '))
        else
            print(table.concat(value, ' '))
        end
    end
end

function Array.copy_1d(arr)
    local new_arr = {}

    for key, value in pairs(arr) do
        new_arr[key] = value
    end

    return new_arr
end

function Array.copy_2d(arr)
    local new_arr = {}

    for key_row, row in pairs(arr) do
        new_arr[key_row] = {}

        for key_col, value in pairs(row) do
            new_arr[key_row][key_col] = value
        end
    end

    return new_arr
end

function Array.equals(arr1, arr2)
    if #arr1 ~= #arr2 then
        return false
    end

    arr1 = Array.copy_1d(arr1)
    arr2 = Array.copy_1d(arr2)

    table.sort(arr1)
    table.sort(arr2)

    for i = 1, #arr1 do
        if arr1[i] ~= arr2[i] then
            return false
        end
    end

    return true
end

function Array.shuffle(arr)
    local current_i = #arr
    local tmp, random_i

    while (current_i ~= 1) do
        random_i = math.floor(math.random() * current_i);
        random_i = random_i ~= 0 and random_i or random_i + 1
        current_i = current_i - 1;

        tmp = arr[current_i]
        arr[current_i] = arr[random_i]
        arr[random_i] = tmp
    end

    return arr
end

return Array
