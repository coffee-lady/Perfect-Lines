local M = {}

M.DEFAULT_Z = 1
M.width = 10
M.density = 1

M.point_count = 10

local point_step = 10

local vmath_len = vmath.length
local floor = math.floor
local vmath_normalize = vmath.normalize

local function update_point_step()
    point_step = M.width / M.density
end

function M.set_width(width)
    M.width = width
    update_point_step()
end

function M.set_density(dens)
    M.density = dens
    update_point_step()
end

function M.draw_line(from, to, path)
    local points = path or {}

    local vec_len = to - from
    local len = vmath_len(vec_len)
    local point_count = floor(len / point_step)
    vec_len = vmath_normalize(vec_len)
    local delta = len / point_count
    local index = #points

    for _ = 1, point_count do
        index = index + 1
        points[index] = from
        from = from + vec_len * delta
    end

    points[index + 1] = to
end

local function line(from, to, step, points)
    local vec_len = to - from
    local len = vmath_len(vec_len)
    local point_count = floor(len / step) + 1
    vec_len = vmath.normalize(vec_len)
    local index = #points

    for i = 1, point_count do
        index = index + 1
        points[index] = vmath.vector3(from)
        from = from + vec_len * step
    end
    return points
end

function M.bezier(from, control, to, path)
    local point_count = M.point_count

    local points = path or {}
    local ins_pos = #points
    local x0 = from.x
    local y0 = from.y
    local xc = control.x
    local yc = control.y
    local x1 = to.x
    local y1 = to.y

    local step = 1 / (point_count - 1)
    local t = step
    local curr = from
    for i = 1, point_count - 1 do
        local oneMinusT = 1 - t
        local opt1 = oneMinusT * oneMinusT
        local opt2 = 2 * t * oneMinusT
        local opt3 = t * t
        local xt = (opt1 * x0) + (opt2 * xc) + (opt3 * x1)
        local yt = (opt1 * y0) + (opt2 * yc) + (opt3 * y1)

        local next = vmath.vector3(xt, yt, M.DEFAULT_Z)
        line(curr, next, point_step, points)
        curr = next
        t = t + step
    end

    ins_pos = ins_pos + 1
    points[ins_pos] = to
    return points
end

function M.bezier_qubic(from, control1, control2, to, path)
    local points = path or {}
    local point_count = M.point_count

    local ins_pos = #points
    local step = 1 / (point_count - 1)
    local t = step

    local x0 = from.x
    local y0 = from.y
    local x1 = control1.x
    local y1 = control1.y
    local x2 = control2.x
    local y2 = control2.y
    local x3 = to.x
    local y3 = to.y

    local curr = from

    for _ = 1, point_count - 1 do
        local oneMinusT = 1 - t
        local sqOneMinusT = oneMinusT * oneMinusT
        local firstParam = oneMinusT * sqOneMinusT
        local secondParam = sqOneMinusT * t * 3
        local thirdParam = t * t * oneMinusT * 3
        local fourthParam = t * t * t

        local xt = firstParam * x0 + secondParam * x1 + thirdParam * x2 + fourthParam * x3
        local yt = firstParam * y0 + secondParam * y1 + thirdParam * y2 + fourthParam * y3
        local next = vmath.vector3(xt, yt, M.DEFAULT_Z)
        line(curr, next, point_step, points)
        curr = next
        t = t + step
    end
    ins_pos = ins_pos + 1
    points[ins_pos] = to

    return points
end

return M
